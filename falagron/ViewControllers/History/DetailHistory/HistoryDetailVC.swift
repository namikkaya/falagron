//
//  HistoryDetailVC.swift
//  falagron
//
//  Created by namik kaya on 17.01.2021.
//  Copyright © 2021 namik kaya. All rights reserved.
//

import UIKit
import Firebase

class HistoryDetailVC: UIViewController {
    
    // Outlet object
    @IBOutlet private weak var textView: UITextView! {
        didSet{
            textView.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        }
    }
    
    
    var setfalData:FalHistoryDataModel?
    
    var falId: String?
    
    var menuButton:UIButton?
    
    var viewManager: HistoryDetailControlManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let data = setfalData else { return }
        viewManager = HistoryDetailControlManager(textView: textView, data: data)
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
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func destroy() {
        print("XYZ: HistoryDetail destory")
    }
    
    deinit {
        destroy()
        print("XYZ: HistoryDetail deinit")
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
