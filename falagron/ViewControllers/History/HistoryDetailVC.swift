//
//  HistoryDetailVC.swift
//  falagron
//
//  Created by namik kaya on 17.01.2021.
//  Copyright © 2021 namik kaya. All rights reserved.
//

import UIKit
import Firebase

class HistoryDetailVC: BaseViewController {
    
    // Outlet object
    @IBOutlet private weak var textView: UITextView! {
        didSet{
            textView.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        }
    }
    
    
    var setfalData:FalHistoryDataModel?
    
    var falId: String?
    
    private var falList: [String:FalDataModel] = [:]
    
    var menuButton:UIButton?
    
    var viewModel: HistoryDetailViewManager!
    
    // service
    private var groupQuery: DispatchGroup?
    private var queueBackground: DispatchQueue?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let data = setfalData else { return }
        viewModel = HistoryDetailViewManager(data: data, textView: textView, delegate: self)
        fetchData(data: data)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyy HH:mm"
        if let date = setfalData?.created?.dateValue() {
            let formatSTR = formatter.string(from: date)
            self.setNavigationBarTitle(titleText: formatSTR, fontSize: 12)
        }
        /*menuButton = addGetMenuButton()
        menuButton?.addTarget(self, action: #selector(menuButtonEvent(_:)), for: .touchUpInside)
        self.setNavigationBarTitle(titleText: "Fal Detayı")
        print("HistoryVC: viewWillAppear")*/
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        groupQuery = nil
        queueBackground = nil
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    /*
    @objc private func menuButtonEvent(_ sender:UIButton) {
        self.revealViewController()?.revealToggle(animated: true)
    }
 */
    
    override func menuDisplayChange(status: MenuDisplayStatus) {
        super.menuDisplayChange(status: status)
        switch status {
        case .ON:
            // userinteraction false
            
            break
        case .OFF:
            // userinteraction true
            
            break
        }
    }
}

extension HistoryDetailVC {
    private func addGetMenuButton() -> UIButton  {
        let leftMenuButton = UIButton(frame: CGRect(x: 0, y: 0, width: 18, height: 18))
        leftMenuButton.setImage(UIImage(named: "menuIcon"), for: .normal)
        let barButton = UIBarButtonItem(customView: leftMenuButton)
        let width = barButton.customView?.widthAnchor.constraint(equalToConstant: 18)
        width?.isActive = true
        let height = barButton.customView?.heightAnchor.constraint(equalToConstant: 18)
        height?.isActive = true
        self.navigationItem.setLeftBarButton(barButton, animated: true)
        return leftMenuButton
    }
}

extension HistoryDetailVC: HistoryDetailViewManagerDelegate {
    func didHistoryCommonTypeTrigger(type: HistoryNC.CommonHistoryType) {
        switch type {
        case .historyListToDetail(let data):
            didHistoryFalData(data: data)
            break
        default: break
        }
    }
}

extension HistoryDetailVC {
    private func didHistoryFalData(data: FalHistoryDataModel) {
        
    }
}

extension HistoryDetailVC {
    private func fetchData(data:FalHistoryDataModel) {
        groupQuery = DispatchGroup()
        queueBackground = DispatchQueue.global(qos: .background)
        
        guard let forData = data.falData else { return }
        
        loading?.start()
        
        for (key, value) in forData {
            groupQuery?.enter()
            getReferenceDocument(key: key, value: value)
        }
        serviceNotify()
    }
    
    private func getReferenceDocument(key:String, value: DocumentReference) {
        queueBackground?.async { [weak self] in
            FirebaseManager.shared.getReferanceDocument(key: key, documentRefs: value) { (status: Bool, data: FalDataModel?, errorMessage: String?) in
                if status {
                    if let data = data {
                        self?.falList[key] = data
                        self?.groupQuery?.leave()
                    }
                }else {
                    self?.getReferenceDocument(key: key, value: value)
                }
            }
        }
    }
    
    private func serviceNotify() {
        groupQuery?.notify(queue: DispatchQueue.global()) { [weak self] in
            let sortedDict = self?.falList.sorted(by: { $0.0 < $1.0 })
            var falAllText:String = ""
            sortedDict?.forEach({ (key: String, value: FalDataModel) in
                falAllText.append(self?.stringDecompile(description: "\(value.falText ?? "") \n \n") ?? "")
            })
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.viewModel.setFalDisplayText(str: falAllText)
                //self.loading?.stop()
            }
        }
    }
}

extension HistoryDetailVC {
    private func stringDecompile(description:String) -> String {
        // hitap
        let nameGenderAppeal = "\(FirebaseManager.shared.userInfoData?.userName ?? "") \(FirebaseManager.shared.userInfoData?.cinsiyet?.Erkek == true ? previewTextAppealMenString : previewTextAppealWomenString)"
        let replacedGenderAppealAppend = description.replacingOccurrences(of: textAppealString, with: nameGenderAppeal)
        
        // hem cins
        let sameGenderStr = FirebaseManager.shared.userInfoData?.cinsiyet?.Erkek == true ? previewTextSameGenderMenString : previewTextSameGenderWomenString
        let sameGenderAppend = replacedGenderAppealAppend.replacingOccurrences(of: textSameGenderString, with: sameGenderStr)
        
        // karşı cins
        let genderStr = FirebaseManager.shared.userInfoData?.cinsiyet?.Erkek == true ? previewTextSameGenderWomenString : previewTextSameGenderMenString
        let genderAppend = sameGenderAppend.replacingOccurrences(of: textGenderString, with: genderStr)
        
        return genderAppend
    }
}
