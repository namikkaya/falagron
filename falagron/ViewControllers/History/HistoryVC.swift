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
    
    // Variables
    private var historyList:[SectionType] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        createData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
        menuButton = addGetMenuButton()
        menuButton?.addTarget(self, action: #selector(menuButtonEvent(_:)), for: .touchUpInside)
        self.setNavigationBarTitle(titleText: "Fallarım")
        print("HistoryVC: viewWillAppear")
        self.tableView.isUserInteractionEnabled = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("HistoryVC: viewWillDisappear")
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

extension HistoryVC {
    enum SectionType {
        case historySection(rowTypeList: [RowType])
    }
    
    enum RowType {
        case historyCell(data: FalHistoryDataModel)
    }
}

extension HistoryVC {
    private func createData() {
        var rowType: [RowType] = []
        for i in 0..<15 {
            let model = FalHistoryDataModel(date: Date(), falId: "123456", isPurchase: ((i%1) != 0) ? true : false)
            rowType.append(.historyCell(data: model))
        }
        historyList.append(.historySection(rowTypeList: rowType))
        tableView.reloadData()
    }
}

extension HistoryVC: UITableViewDelegate, UITableViewDataSource{
    private func setupTableView() {
        let cells = [HistoryInfoCell.self, UITableViewCell.self]
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(cellTypes: cells)
        self.tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 80, right: 0)
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard historyList.count > 0 else { return 0 }
        switch historyList[section] {
        case .historySection(let rowTypeList):
            return rowTypeList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionType = historyList[indexPath.section]
        switch sectionType {
        case .historySection(let rowTypeList):
            switch rowTypeList[indexPath.row] {
            case .historyCell(let data):
                let cell = tableView.dequeueReusableCell(with: HistoryInfoCell.self, for: indexPath)
                
                return cell
            }
        }
    }
}
