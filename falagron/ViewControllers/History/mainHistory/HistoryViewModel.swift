//
//  HistoryViewModel.swift
//  falagron
//
//  Created by namik kaya on 12.03.2021.
//  Copyright © 2021 namik kaya. All rights reserved.
//

import UIKit

protocol HistoryViewModelDelegate:class {
    func historyErrorMessage(errorMessage: String?)
}

extension HistoryViewModelDelegate {
    func historyErrorMessage(errorMessage: String?) {}
}

class HistoryViewModel: NSObject {
    weak var delegate: HistoryViewModelDelegate?
    var serviceManager:HistoryServiceManager!
    
    // MARK: - Variables
    var falData:[FalHistoryDataModel] = []
    var selectedFalId:String?
    var historyData:[SectionType] = []
    
    private var historyList: [SectionType] = [SectionType]() {
        didSet {
            self.historyData = historyList
            self.reloadTableViewClosure?(historyList)
        }
    }

    private var loading: [SectionType] = [SectionType]() {
        didSet {
            self.historyData = loading
            self.loadingTableViewClosure?(loading)
        }
    }
    
    
    var reloadTableViewClosure: ((_ falData:[SectionType])->())?
    var loadingTableViewClosure: ((_ loadingData:[SectionType])-> ())?
    
    override init() {
        super.init()
        serviceManager = HistoryServiceManager()
    }
    
    deinit {
        falData.removeAll()
        selectedFalId = nil
        historyData.removeAll()
        reloadTableViewClosure = nil
        loadingTableViewClosure = nil
    }
    
    func callFuncToGetEmpData() {
        serviceManager.getHistoryData { [weak self] (status: Bool, data: [FalHistoryDataModel]?, error: NSError?) in
            if status {
                guard let data = data else { return }
                self?.setData(falData: data, selectedFalId: self?.selectedFalId)
            }else {
                // hata mesajı
                guard let error = error, let message = error.userInfo["message"] as? String else {
                    self?.delegate?.historyErrorMessage(errorMessage: "Bir hata oluştu!")
                    return
                }
                self?.delegate?.historyErrorMessage(errorMessage: message)
            }
        }
    }
}

extension HistoryViewModel {
    // data set
    private func setData(falData:[FalHistoryDataModel], selectedFalId: String? = nil) {
        self.falData.removeAll()
        self.falData = falData
        self.updateUI()
    }
    
    func setLoading() {
        self.falData.removeAll()
        self.falData = []
        loadingUI()
    }
}

// MARK: - Update DATA
extension HistoryViewModel {
    /// Fal da görüldü atmak için
    /// - Parameter selectedId: falId
    func updateData(selectedId:String) {
        for (index, element) in falData.enumerated() {
            if element.falId == selectedId {
                falData[index].userViewedStatus = true
            }
        }
        updateUI()
    }
    
    private func updateUI() {
        var rowType: [RowType] = []
        var tempHistoryData: [SectionType] = []
        for item in falData { rowType.append(.historyCell(data: item)) }
        tempHistoryData.append(.historySection(rowTypeList: rowType))
        historyList = tempHistoryData
    }
    
    private func loadingUI() {
        historyList.removeAll()
        var tempHistoryData: [SectionType] = []
        tempHistoryData.append(.historySection(rowTypeList: [.loading]))
        historyData = tempHistoryData
    }
}

extension HistoryViewModel {
    enum SectionType {
        case historySection(rowTypeList: [RowType])
    }
    
    enum RowType {
        case historyCell(data: FalHistoryDataModel), loading
    }
}
