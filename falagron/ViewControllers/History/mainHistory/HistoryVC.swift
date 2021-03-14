//
//  HistoryVC.swift
//  falagron
//
//  Created by namik kaya on 20.12.2020.
//  Copyright © 2020 namik kaya. All rights reserved.
//

import UIKit

class HistoryVC: BaseViewController {
    
    // Views
    @IBOutlet weak var tableView: UITableView!
    var menuButton:UIButton?
    
    var viewManager:HistoryControlManager!
    var serviceManager:HistoryServiceManager!
    
    var selectedFalId:String?
    
    var isPushDetail:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkComeFromController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
        menuButton = addGetMenuButton()
        menuButton?.addTarget(self, action: #selector(menuButtonEvent(_:)), for: .touchUpInside)
        self.setNavigationBarTitle(titleText: "Fallarım")
        self.tableView.isUserInteractionEnabled = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @objc private func menuButtonEvent(_ sender:UIButton) {
        self.revealViewController()?.revealToggle(animated: true)
    }
    
    override func menuDisplayChange(status: MenuDisplayStatus) {
        super.menuDisplayChange(status: status)
        switch status {
        case .ON:
            self.tableView.isUserInteractionEnabled = false
            break
        case .OFF:
            self.tableView.isUserInteractionEnabled = true
            break
        }
    }
}

// MARK: - Service kontrolleri
extension HistoryVC {
    /// Detaydan geriye geldiğinde service çıkmaması için
    private func checkComeFromController() {
        if !isPushDetail {
            viewManager.loadingUI()
            serviceManager.getHistoryData() // Geçmiş fallar çekilir.
        }else {
            isPushDetail = false
        }
    }
}

// MARK: - NavigationController Button
extension HistoryVC {
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

// MARK: - Setups
extension HistoryVC {
    private func setup() {
        viewManager = HistoryControlManager(tableView: self.tableView, delegate: self)
        serviceManager = HistoryServiceManager(delegate: self)
    }
}

// MARK: - Delegates
extension HistoryVC: HistoryControlManagerDelegate {
    func historyCommonTypeTrigger(type: HistoryNC.CommonHistoryType) {
        switch type {
        case .historyListToDetail(let data):
            if let historyDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "HistoryDetailVC") as? HistoryDetailVC {
                historyDetailVC.setfalData = data
                isPushDetail = true
                self.navigationController?.pushViewController(historyDetailVC, animated: true)
            }
            break
        }
    }
}

extension HistoryVC: HistoryServiceManagerDelegate {
    func historyServiceEvent(type: HistoryServiceManager.HistoryServiceType) {
        switch type {
        case .getHistory(let data):
            viewManager?.setData(falData: data, selectedFalId: self.selectedFalId)
            self.selectedFalId = nil
            break
        case .historyError(let error):
            infoMessage(message: (error.userInfo["message"] ?? "Bir hata oluştu!") as! String, buttonTitle: "Tamam") { }
            break
        }
    }
}
