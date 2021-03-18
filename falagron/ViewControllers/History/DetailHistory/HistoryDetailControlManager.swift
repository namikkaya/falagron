//
//  HistoryDetailControlManager.swift
//  falagron
//
//  Created by namik kaya on 15.03.2021.
//  Copyright © 2021 namik kaya. All rights reserved.
//

import UIKit

class HistoryDetailControlManager: NSObject {
    
    var viewModel: HistoryDetailViewModel?
    
    // outlet object
    private var textView: UITextView?
    
    private var data: FalHistoryDataModel?
    
    convenience init(textView:UITextView?, data: FalHistoryDataModel?) {
        self.init()
        self.data = data
        self.textView = textView
        if let data = data {
            viewModel = HistoryDetailViewModel(falData: data)
            setupClosure()
        }
    }
    
    deinit {
        viewModel = nil
        textView = nil
        print("XYZ: HistoryDetailControlManager: deinit")
    }
}
extension HistoryDetailControlManager {
    func setupClosure() {
        viewModel?.reloadViewClosure = { [weak self] data in
            self?.setFalDisplayText(str: data)
        }
    }
}
extension HistoryDetailControlManager {
    func setFalDisplayText(str: String?) {
        guard let str = str else { return }
        DispatchQueue.main.async { [weak self] in
            self?.textView?.text = str
        }
    }
}
