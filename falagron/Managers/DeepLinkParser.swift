//
//  DeepLinkParser.swift
//  falagron
//
//  Created by namik kaya on 16.01.2021.
//  Copyright © 2021 namik kaya. All rights reserved.
//

import UIKit

class DeepLinkParser: NSObject {
    
    enum DeepLinkType: CaseIterable {
        case push
        case silent
        
        var name:String {
            switch self {
            case .push:
                return "push"
            case .silent:
                return "silent"
            }
        }
        
        static func stringToType(name: String?) -> DeepLinkType? {
            guard let name = name else { return nil }
            for item in DeepLinkType.allCases {
                if item.name == name {
                    return item
                }
            }
            return nil
        }
    }
    
    var uniqId:String?
    var selectedTab: PageState?
    var selectedController: String?
    var falId:String?
    var type: DeepLinkType?

    override init() {
        super.init()
    }
    
    init(data: [String:String]?) {
        super.init()
        guard let data = data else { return }
        parseData(data: data)
    }
    
    deinit {
        selectedTab = nil
        selectedController = nil
        falId = nil
    }
}

extension DeepLinkParser {
    private func parseData(data: [String:String]) {
        if data["root"] != nil {
            self.selectedTab = PageState.getStringToState(name: data["root"])
        }
        
        if data["inPage"] != nil { // navigasyon içinde yönlendirme olacak ise
            self.selectedController = data ["inPage"]
        }
        
        if data["falId"] != nil {
            self.falId = data["falId"]
        }
        
        if data["type"] != nil {
            self.type = DeepLinkType.stringToType(name: data["type"])
        }
    }
}
