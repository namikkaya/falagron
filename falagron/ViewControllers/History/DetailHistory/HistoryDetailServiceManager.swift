//
//  HistoryDetailServiceManager.swift
//  falagron
//
//  Created by namik kaya on 15.03.2021.
//  Copyright © 2021 namik kaya. All rights reserved.
//

import UIKit
import Firebase

protocol HistoryDetailServiceManagerDelegate:AnyObject{
    func callServiceResponse(stringData: String?)
}

extension HistoryDetailServiceManagerDelegate {
    func callServiceResponse(stringData: String?) {}
}

class HistoryDetailServiceManager: NSObject {
    weak var delegate: HistoryDetailServiceManagerDelegate?
    // service
    private var groupQuery: DispatchGroup?
    private var queueBackground: DispatchQueue?
    
    private var falList: [String:FalDataModel] = [:]
    
    override init() {
        super.init()
    }
    
    convenience init(delegate: HistoryDetailServiceManagerDelegate) {
        self.init()
        self.delegate = delegate
    }
    
    func callServices(data: FalHistoryDataModel) {
        falList.removeAll()
        fetchData(data: data)
    }
    
    deinit {
        groupQuery = nil
        queueBackground = nil
    }
}

extension HistoryDetailServiceManager {
    private func fetchData(data:FalHistoryDataModel) {
        groupQuery = DispatchGroup()
        queueBackground = DispatchQueue.global(qos: .background)
        
        guard let forData = data.falData else { return }
        
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
            self?.delegate?.callServiceResponse(stringData: falAllText)
        }
    }
}

extension HistoryDetailServiceManager {
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

