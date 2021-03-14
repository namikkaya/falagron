//
//  NotificationsVC.swift
//  falagron
//
//  Created by namik kaya on 10.01.2021.
//  Copyright © 2021 namik kaya. All rights reserved.
//

import UIKit

extension NotificationsVC {
    enum SectionType {
        case historySection(rowTypeList: [RowType])
    }
    
    enum RowType {
        case historyCell(data: NotificationModel)
    }
}


class NotificationsVC: BaseViewController {

    var menuButton:UIButton?
     
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
        menuButton = addGetMenuButton()
        menuButton?.addTarget(self, action: #selector(menuButtonEvent(_:)), for: .touchUpInside)
        self.setNavigationBarTitle(titleText: "Fallarım")
        print("HistoryVC: viewWillAppear")
        //self.tableView.isUserInteractionEnabled = true
    }
    
    @objc private func menuButtonEvent(_ sender:UIButton) {
        self.revealViewController()?.revealToggle(animated: true)
    }
}

extension NotificationsVC {
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

extension NotificationsVC {
    private func createData() {
        var rowType: [RowType] = []
        for i in 0..<15 {
            //let model = FalHistoryDataModel(date: Date(), falId: "123456", isPurchase: ((i%1) != 0) ? true : false)
            let model = NotificationModel(date: Date(), type: "FAL", message: "Falınız geldi hanım", title: "Falagron", navigationBody: "history/1234")
            rowType.append(.historyCell(data: model))
        }
        //historyList.append(.historySection(rowTypeList: rowType))
        //tableView.reloadData()
    }
}
