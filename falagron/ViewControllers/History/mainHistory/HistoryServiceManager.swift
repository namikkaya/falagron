//
//  HistoryServiceManager.swift
//  falagron
//
//  Created by namik kaya on 10.03.2021.
//  Copyright © 2021 namik kaya. All rights reserved.
//

import UIKit

protocol HistoryServiceManagerDelegate:class {
    func historyServiceEvent(type: HistoryServiceManager.HistoryServiceType)
}

extension HistoryServiceManagerDelegate {
    func historyServiceEvent(type: HistoryServiceManager.HistoryServiceType) {}
}

class HistoryServiceManager: NSObject {
    weak var delegate: HistoryServiceManagerDelegate?

    override init() { super.init() }
    
    convenience init(delegate: HistoryServiceManagerDelegate) {
        self.init()
        self.delegate = delegate
    }
}

extension HistoryServiceManager {
    enum HistoryServiceType {
        case getHistory(data: [FalHistoryDataModel]),
             historyError(error:NSError)
    }
}

extension HistoryServiceManager {
    /// Kullanıcı için geçmiş data bilgileri gelir.
    func getHistoryData() {
        FirebaseManager.shared.getHistory { [weak self] (status: Bool, data: [FalHistoryDataModel], errorMessage: String?) in
            if status {
                self?.delegate?.historyServiceEvent(type: .getHistory(data: data))
            }else {
                let errorType = NSError(domain: "com.kaya.falagron", code: 1001, userInfo: ["message": "Geçmiş fallar çekilirken bir hata oluştu. Lütfen tekrar deneyin."])
                self?.delegate?.historyServiceEvent(type: .historyError(error: errorType))
            }
        }
    }
}
