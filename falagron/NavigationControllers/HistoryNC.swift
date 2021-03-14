//
//  HistoryNC.swift
//  falagron
//
//  Created by namik kaya on 20.12.2020.
//  Copyright © 2020 namik kaya. All rights reserved.
//

import UIKit

extension HistoryNC {
    enum CommonHistoryType {
        case historyListToDetail(data: FalHistoryDataModel)
    }
}

class HistoryNC: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBarSetup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async { [weak self] in
            self?.checkNotification()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
}

extension HistoryNC {
    private func checkNotification() {
        self.popToRootViewController(animated: false)
        print("XYZ: HistoryNC: \(AppNavigationCoordinator.shared.deeplinkParser?.falId)")
        if let detailFalId = AppNavigationCoordinator.shared.deeplinkParser?.falId {
            print("XYZ: HistoryNC falID: \(AppNavigationCoordinator.shared.deeplinkParser?.falId)")
            if let historyDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "HistoryDetailVC") as? HistoryDetailVC {
                historyDetailVC.falId = detailFalId
                self.pushViewController(historyDetailVC, animated: true)
                print("XYZ: Yönlendirme yapılması gerekiyor")
                AppNavigationCoordinator.shared.deeplinkParser = nil
            }
        }
    }
}
