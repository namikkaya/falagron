//
//  HistoryViewModel.swift
//  falagron
//
//  Created by namik kaya on 1.03.2021.
//  Copyright © 2021 namik kaya. All rights reserved.
//

import UIKit

protocol HistoryViewManagerDelegate:class {
    func historyCommonTypeTrigger(type: HistoryNC.CommonHistoryType)
}

extension HistoryViewManagerDelegate {
    func historyCommonTypeTrigger(type: HistoryNC.CommonHistoryType) {}
}

class HistoryViewManager: NSObject {
    weak var delegate: HistoryViewManagerDelegate?
    
// MARK: - outlet object
    var tableView:UITableView?
    
    var viewModel:HistoryViewModel?
    
    override init() { super.init() }
    
    convenience init(tableView: UITableView, delegate:HistoryViewManagerDelegate?) {
        self.init()
        self.tableView = tableView
        self.delegate = delegate
        
        setups()
        viewModel?.setLoading()
    }
    
    deinit {
        if tableView != nil { tableView = nil }
        if viewModel != nil { viewModel = nil }
    }
}

extension HistoryViewManager {
    private func setups() {
        setupViewModel()
        setupTableView()
    }
}

extension HistoryViewManager {
    private func setupViewModel() {
        viewModel = HistoryViewModel()
        
        viewModel?.reloadTableViewClosure = { [weak self] data in
            guard let self = self else{ return }
            DispatchQueue.main.async {
                self.tableView?.reloadData()
            }
        }
        
        viewModel?.loadingTableViewClosure = { [weak self] data in
            guard let self = self else{ return }
            DispatchQueue.main.async {
                self.tableView?.reloadData()
            }
        }
    }
    
    // Set data
    func setData(falData:[FalHistoryDataModel], selectedFalId: String? = nil) {
        viewModel?.setData(falData: falData, selectedFalId: selectedFalId)
    }
    
    // loading display
    func loadingUI() {
        viewModel?.setLoading()
    }
}



// MARK: - TableView
extension HistoryViewManager: UITableViewDelegate, UITableViewDataSource {
    private func setupTableView() {
        let cells = [HistoryInfoCell.self, loadingCell.self, UITableViewCell.self]
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.register(cellTypes: cells)
        self.tableView?.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 80, right: 0)
        self.tableView?.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let historyList = viewModel?.historyData, historyList.count > 0 else { return 0 }
        switch historyList[section] {
        case .historySection(let rowTypeList):
            return rowTypeList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let historyList = viewModel?.historyData, historyList.count > 0 else { return UITableViewCell() }
        let sectionType = historyList[indexPath.section]
        switch sectionType {
        case .historySection(let rowTypeList):
            switch rowTypeList[indexPath.row] {
            case .historyCell(let data):
                let cell = tableView.dequeueReusableCell(with: HistoryInfoCell.self, for: indexPath)
                cell.setup(falData: data)
                return cell
            case .loading:
                let cell = tableView.dequeueReusableCell(with: loadingCell.self, for: indexPath)
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let historyList = viewModel?.historyData, historyList.count > 0 else { return }
        let sectionType = historyList[indexPath.section]
        switch sectionType {
        case .historySection(let rowTypeList):
            switch rowTypeList[indexPath.row] {
            case .historyCell(let data):
                guard let dataId = data.falId else { return }
                self.viewModel?.updateData(selectedId: dataId)
                self.delegate?.historyCommonTypeTrigger(type: .historyListToDetail(data: data))
                break
            default: break
            }
        }
    }
}

// MARK: - Tableview scroll to point
extension HistoryViewManager {
    private func scrollToItemIndex(index:Int, animated: Bool = true) {
        guard let falData = viewModel?.falData else { return }
        if index < falData.count {
            let indexPath = IndexPath(row: index, section: 0)
            self.tableView?.scrollToRow(at: indexPath, at: .top, animated: animated)
        }
    }
}

extension HistoryViewManager {
    private func getFalIdRowIndex(falId:String?) -> Int? {
        guard let falData = viewModel?.falData, let falId = falId else { return nil }
        for (index, value) in falData.enumerated() {
            if value.falId == falId {
                return index
            }
        }
        return nil
    }
}
