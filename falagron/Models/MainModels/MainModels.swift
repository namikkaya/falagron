//
//  MainModels.swift
//  falagron
//
//  Created by namik kaya on 19.09.2020.
//  Copyright © 2020 namik kaya. All rights reserved.
//

import Foundation

struct MainPageModel {
    var type:MainVC.RowType?
    init(type:MainVC.RowType?) {
        self.type = type
    }
}

struct ArrayModel {
    var key:String
    var value:String
    
    init(key:String, value:String) {
        self.key = key
        self.value = value
    }
}

fileprivate var loveStatus:[ArrayModel] = [ ArrayModel(key: iliskiDurumu_IliskisiVar, value: "İlişkisi Var"),
                                                 ArrayModel(key: iliskiDurumu_IliskisiYok, value: "İlişkisi Yok"),
                                                 ArrayModel(key: iliskiDurumu_YeniAyrilmis, value: "Yeni Ayrılmış"),
                                                 ArrayModel(key: iliskiDurumu_Evli, value: "Evli"),
                                                 ArrayModel(key: iliskiDurumu_Nisanli, value: "Nişanlı"),
                                                 ArrayModel(key: iliskiDurumu_YeniBosanmis, value: "Yeni Boşanmış") ]

fileprivate var sexStatus:[ArrayModel] = [ArrayModel(key: userGenderFemale, value: "Kadın"),
                                          ArrayModel(key: userGenderMale, value: "Erkek"),
                                          ArrayModel(key: userGenderLGBT, value: "LGBT")]

fileprivate var workStatus:[ArrayModel] = [ArrayModel(key: kariyer_Calisiyor, value: "Çalışıyor"),
                                           ArrayModel(key: kariyer_Calismiyor, value: "Çalışmıyor"),
                                           ArrayModel(key: kariyer_Ogrenci, value: "Öğrenci"),
                                           ArrayModel(key: kariyer_EvHanimi, value: "Ev Hanımı")]

struct UserInformationDataModel {
    var id:String?
    var titleName:String? // iliski durumu
    var type:UserInfoDataType
    var items:[StatusItem] = []
    init(id:String, type: UserInfoDataType) {
        self.id = id
        self.type = type
        self.titleName = type.title
        items = getElements(type: type)
    }
    
    func getElements(type:UserInfoDataType) -> [StatusItem] {
        switch type {
        case .love:
            var items:[StatusItem] = []
            for (index, element) in loveStatus.enumerated() {
                let model = StatusItem(id: index, status: element, parentType: type)
                items.append(model)
            }
            return items
        case .sex:
            var items:[StatusItem] = []
            for (index, element) in sexStatus.enumerated() {
                let model = StatusItem(id: index, status: element, parentType: type)
                items.append(model)
            }
            return items
        case .work:
            var items:[StatusItem] = []
            for (index, element) in workStatus.enumerated() {
                let model = StatusItem(id: index, status: element, parentType: type)
                items.append(model)
            }
            return items
        }
    }
}

struct StatusItem {
    var id:Int
    var name:String
    var status:Bool = false
    var parentType:UserInfoDataType
    var model: ArrayModel
    init(id:Int, status: ArrayModel, parentType: UserInfoDataType) {
        self.id = id
        self.parentType = parentType
        self.name = status.value
        self.model = status
    }
}

// Register user bilgileri statik girilecek
enum UserInfoDataType {
    case love
    case sex
    case work
    
    var title:String? {
        switch self {
        case .love:
            return "İlişki Durumu"
        case .sex:
            return "Cinsiyetin"
        case .work:
            return "İş Durumu"
        }
    }
}
