//
//  HistoryDetailViewModel.swift
//  falagron
//
//  Created by namik kaya on 1.03.2021.
//  Copyright © 2021 namik kaya. All rights reserved.
//

import UIKit
import Firebase

protocol HistoryDetailViewManagerDelegate:class {
    func didHistoryCommonTypeTrigger(type: HistoryNC.CommonHistoryType)
}

extension HistoryDetailViewManagerDelegate {
    func didHistoryCommonTypeTrigger(type: HistoryNC.CommonHistoryType) {}
}

class HistoryDetailViewManager: NSObject {
    
    weak var delegate: HistoryDetailViewManagerDelegate?
    
    // outlet object
    private var textView:UITextView?
    
    override init() {
        super.init()
    }

    convenience init(data: FalHistoryDataModel, textView:UITextView!, delegate: HistoryDetailViewManagerDelegate) {
        self.init()
        self.delegate = delegate
        self.textView = textView
    }
    
    deinit {
        textView = nil
    }
}

extension HistoryDetailViewManager {
    func setFalDisplayText(str: String?) {
        guard let str = str else { return }
        textView?.text = str
    }
}
