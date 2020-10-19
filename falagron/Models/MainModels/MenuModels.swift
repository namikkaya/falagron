//
//  MenuModels.swift
//  falagron
//
//  Created by namik kaya on 11.10.2020.
//  Copyright © 2020 namik kaya. All rights reserved.
//

import Foundation

struct MenuModel {
    var id:PageState
    var title:String
    var icon:UIImage
    init(id:PageState, title: String, icon:UIImage) {
        self.id = id
        self.title = title
        self.icon = icon
    }
}
