//
//  HistoryServiceManager.swift
//  falagron
//
//  Created by namik kaya on 10.03.2021.
//  Copyright © 2021 namik kaya. All rights reserved.
//

import UIKit

class HistoryServiceManager: NSObject {

    override init() { super.init() }
}

extension HistoryServiceManager {
    enum HistoryServiceType {
        case getHistory(data: [FalHistoryDataModel]),
             historyError(error:NSError)
    }
}

extension HistoryServiceManager {
    /// Kullanıcı için geçmiş data bilgileri gelir.
    func getHistoryData(completion: @escaping  (_ status:Bool, _ data:[FalHistoryDataModel]?, _ errorMessage:NSError?) -> () = {_, _, _ in}) {
        FirebaseManager.shared.getHistory { (status: Bool, data: [FalHistoryDataModel], errorMessage: String?) in
            if status {
                completion(true, data, nil)
            }else {
                let errorType = NSError(domain: "com.kaya.falagron", code: 1001, userInfo: ["message": errorMessage ?? "Geçmiş fallar çekilirken bir hata oluştu. Lütfen tekrar deneyin."])
                completion(false, nil, errorType)
            }
        }
    }
}
