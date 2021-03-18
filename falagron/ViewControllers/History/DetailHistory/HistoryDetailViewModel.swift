//
//  HistoryDetailViewModel.swift
//  falagron
//
//  Created by namik kaya on 1.03.2021.
//  Copyright © 2021 namik kaya. All rights reserved.
//

import UIKit
import Firebase

class HistoryDetailViewModel: NSObject {
    
    private var falData:FalHistoryDataModel?
    private var service:HistoryDetailServiceManager?
    
    override init() {
        super.init()
        service = HistoryDetailServiceManager(delegate: self)
    }
    
    var reloadViewClosure: ((_ falData:String)->())?

    convenience init(falData:FalHistoryDataModel) {
        self.init()
        self.falData = falData
        requestService(falData: falData)
    }
    
    private func requestService(falData:FalHistoryDataModel) {
        service?.callServices(data: falData)
    }
    
    deinit {
        self.falData = nil
        self.service = nil
        print("XYZ: HistoryDetailViewModel: deinit")
    }
}

extension HistoryDetailViewModel: HistoryDetailServiceManagerDelegate {
    func callServiceResponse(stringData: String?) {
        guard let stringData = stringData else { return }
        reloadViewClosure?(stringData)
    }
}
