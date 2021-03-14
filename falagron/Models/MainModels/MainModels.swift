//
//  MainModels.swift
//  falagron
//
//  Created by namik kaya on 19.09.2020.
//  Copyright © 2020 namik kaya. All rights reserved.
//

import Foundation
import Firebase

struct MainPageModel {
    var type:RowType?
    init(type:RowType?) {
        self.type = type
    }
    
    enum RowType {
        case loading, banner(image:UIImage), button(type:PurchaseType, title:String, icon:UIImage)
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

struct FalMergedModel: Codable{
    var userId:String?
    var falData: [String:DocumentReference] = [:]
    var purchase:Bool = false
    init(userId: String? = nil) {
        if let userId = userId {
            self.userId = userId
        }
    }
}


struct FalDataModel: Codable {
    var id:String
    var falText:String?
    var iliskiDurumu:IliskiDurumu?
    var kariyer:Kariyer?
    var paragrafTipi:ParagrafTipi?
    var yargi:Yargi?
    var purchase:Purchase?
    var purchaseLove:PurchaseLove?
    var documentReference:DocumentReference?
}

struct IliskiDurumu: Codable {
    var iliskiDurumu_Evli:Bool?
    var iliskiDurumu_IliskisiVar:Bool?
    var iliskiDurumu_IliskisiYok:Bool?
    var iliskiDurumu_Nisanli:Bool?
    var iliskiDurumu_YeniAyrilmis:Bool?
    var iliskiDurumu_YeniBosanmis:Bool?
}

struct Kariyer: Codable {
    var kariyer_Calisiyor:Bool?
    var kariyer_Calismiyor:Bool?
    var kariyer_EvHanimi:Bool?
    var kariyer_Ogrenci:Bool?
}

struct ParagrafTipi: Codable {
    var paragrafTipi_Giris:Bool?
    var paragrafTipi_Gelisme:Bool?
    var paragrafTipi_Sonuc:Bool?
}

struct Yargi: Codable {
    var yargi_Olumlu:Bool?
    var yargi_Olumsuz:Bool?
}

struct Purchase: Codable {
    var purchaseStatus:Bool?
}

struct PurchaseLove: Codable {
    var purchaseStatus:Bool?
    var dictionary: [String: Any?] {
        return [purchaseLoveString: purchaseStatus]
    }
    var nsDictionary: NSDictionary {
        return dictionary as NSDictionary
    }
}

extension QueryDocumentSnapshot {
   func prepareForDecoding() -> [String: Any] {
       var data = self.data()
       data["documentId"] = self.documentID

       return data
   }
}

struct FalHistoryDataModel: Codable {
    var created:Timestamp?
    var userId:String?
    var falId:String?
    var isPurchase:Bool?
    var userViewedStatus:Bool?
    var falData:[String:DocumentReference]?
    
    init(json: [String: Any]) {
        if let userViewedStatus = json["userViewedStatus"] as? Bool {
            self.userViewedStatus = userViewedStatus
        }
        if let userId = json["userId"] as? String {
            self.userId = userId
        }
        if let falData = json["falData"] as? [String:DocumentReference] {
            self.falData = falData
        }
        if let isPurchase = json["isPurchase"] as? Bool {
            self.isPurchase = isPurchase
        }
        if let timeStamp = json["created"] as? Timestamp {
            self.created = timeStamp
        }
    }
}

extension JSONDecoder {
   func decode<T>(_ type: T.Type, fromJSONObject object: Any) throws -> T where T: Decodable {
       return try decode(T.self, from: try JSONSerialization.data(withJSONObject: object, options: []))
   }
}

struct JSON {
    static let encoder = JSONEncoder()
}
extension Encodable {
    subscript(key: String) -> Any? {
        return dictionary[key]
    }
    var dictionary: [String: Any] {
        return (try? JSONSerialization.jsonObject(with: JSON.encoder.encode(self))) as? [String: Any] ?? [:]
    }
}
