//
//  AuthModels.swift
//  falagron
//
//  Created by namik kaya on 22.10.2020.
//  Copyright © 2020 namik kaya. All rights reserved.
//

import Foundation
import FirebaseFirestore

let fallar:String = "fallar"
let usersInfo:String = "usersInfo"
let userViewedFal:String = "falViewedByUser"
let userFalList:String = "falList"
let falInfo:String = "falInfo"
let timeCheckInfo:String = "timeCheckInfo"

let falText:String = "falText"

let paragrafTipi:String = "paragrafTipi"
let paragrafTipi_Giris:String = "paragrafTipi_Giris"
let paragrafTipi_Gelisme:String = "paragrafTipi_Gelisme"
let paragrafTipi_Sonuc:String = "paragrafTipi_Sonuc"

let iliskiDurumu:String = "iliskiDurumu"
let iliskiDurumu_IliskisiVar:String = "iliskiDurumu_IliskisiVar"
let iliskiDurumu_IliskisiYok:String = "iliskiDurumu_IliskisiYok"
let iliskiDurumu_YeniAyrilmis:String = "iliskiDurumu_YeniAyrilmis"
let iliskiDurumu_Evli:String = "iliskiDurumu_Evli"
let iliskiDurumu_Nisanli:String = "iliskiDurumu_Nisanli"
let iliskiDurumu_YeniBosanmis:String = "iliskiDurumu_YeniBosanmis"

let kariyer:String = "kariyer"
let kariyer_Calisiyor:String = "kariyer_Calisiyor"
let kariyer_Calismiyor:String = "kariyer_Calismiyor"
let kariyer_Ogrenci:String = "kariyer_Ogrenci"
let kariyer_EvHanimi:String = "kariyer_EvHanimi"

let userGender:String = "cinsiyet"
let userGenderMale:String = "Erkek"
let userGenderFemale:String = "Kadin"
let userGenderLGBT:String = "LGBT"

let yargi:String = "yargi"
let yargi_Olumlu:String = "yargi_Olumlu"
let yargi_Olumsuz:String = "yargi_Olumsuz"

let textAppealString:String = "@%hitap%@"
let previewTextAppealWomenString:String = "Hanım"
let previewTextAppealMenString:String = "Bey"

let textGenderString:String = "@%gender%@" // karşı cins
let previewTextGenderMenString:String = "erkek"
let previewTextGenderWomenString:String = "kadın"

let textSameGenderString:String = "@%sameGender%@" // hem cins
let previewTextSameGenderMenString:String = "erkek"
let previewTextSameGenderWomenString:String = "kadın"

let purchaseString: String = "purchase"
let purchaseStatusString: String = "purchaseStatus"

let purchaseLoveString = "purchaseLove"
let purchaseLoveStatusString = "purchaseStatus"


let userNameKey:String               = "name"
let emailKey:String                  = "email"
let passwordKey:String               = "password"
let lastNameKey:String               = "lastName"
let birthDayKey:String               = "birthDay"
let loveKey:String                   = "iliskiDurumu"
let sexKey:String                    = "sex"
let workKey:String                   = "kariyer"

enum RegisterTableViewCellType {
    case text
    case swicth
    case list
}

//USER MODELS
struct UserModel {
    var userName:String?
    var email:String?
    var lastName:String?
    var birthDay:Timestamp?
    
    var cinsiyet:GenderModel?
    var kariyer:WorkStatus?
    var iliskiDurumu:LoveStatus?
    
    var documentId:String?
    
    init(json: [String: Any], documentId:String? = nil) {
        if let name = json[userNameKey] as? String {
            self.userName = name
        }
        if let mail = json[emailKey] as? String {
            self.email = mail
        }
        if let lastName = json[lastNameKey] as? String {
            self.lastName = lastName
        }
        if let date = json[birthDayKey] as? Timestamp {
            self.birthDay = date
        }
        if let gender = json[userGender] as? [String:Any]{
            self.cinsiyet = GenderModel(json: gender)
        }
        if let love = json[loveKey] as? [String:Any] {
            self.iliskiDurumu = LoveStatus(json: love)
        }
        if let work = json[workKey] as? [String:Any] {
            self.kariyer = WorkStatus(json: work)
        }
        if let documentId = documentId {
            self.documentId = documentId
        }
    }
}

struct GenderModel {
    var Erkek:Bool?
    var Kadin:Bool?
    var LGBT:Bool?
    init(json: [String: Any]) {
        for (key, value) in json {
            switch key {
            case userGenderMale:
                Erkek = value as? Bool
                break
            case userGenderFemale:
                Kadin = value as? Bool
                break
            case userGenderLGBT:
                LGBT = value as? Bool
                break
            default: break
            }
        }
    }
}

struct LoveStatus {
    var iliskiDurumu_IliskisiVar:Bool?
    var iliskiDurumu_IliskisiYok:Bool?
    var iliskiDurumu_YeniAyrilmis:Bool?
    var iliskiDurumu_Evli:Bool?
    var iliskiDurumu_Nisanli:Bool?
    var iliskiDurumu_YeniBosanmis:Bool?
    
    init(json: [String: Any]) {
        for (key, value) in json {
            switch key {
            case "iliskiDurumu_Evli":
                iliskiDurumu_Evli = value as? Bool
                break
            case "iliskiDurumu_YeniAyrilmis":
                iliskiDurumu_YeniAyrilmis = value as? Bool
                break
            case "iliskiDurumu_IliskisiYok":
                iliskiDurumu_IliskisiYok = value as? Bool
                break
            case "iliskiDurumu_IliskisiVar":
                iliskiDurumu_IliskisiVar = value as? Bool
                break
            case "iliskiDurumu_YeniBosanmis":
                iliskiDurumu_YeniBosanmis = value as? Bool
                break
            case "iliskiDurumu_Nisanli":
                iliskiDurumu_Nisanli = value as? Bool
                break
            default: break
            }
        }
    }
}

struct WorkStatus {
    var kariyer_Calisiyor:Bool?
    var kariyer_Calismiyor:Bool?
    var kariyer_Ogrenci:Bool?
    var kariyer_EvHanimi:Bool?
    
    init(json: [String: Any]) {
        for (key, value) in json {
            switch key {
            case "kariyer_Calisiyor":
                kariyer_Calisiyor = value as? Bool
                break
            case "kariyer_Calismiyor":
                kariyer_Calismiyor = value as? Bool
                break
            case "kariyer_Ogrenci":
                kariyer_Ogrenci = value as? Bool
                break
            case "kariyer_EvHanimi":
                kariyer_EvHanimi = value as? Bool
                break
            default: break
            }
        }
    }
}

struct AuthCurrentToTarget {
    var currentController:UIViewController
    var targetController:UIViewController
    
    init(currentController:UIViewController, targetController:UIViewController) {
        self.currentController = currentController
        self.targetController = targetController
    }
}

struct RegisterCellModel {
    var title:String?
    var placeHolder:String?
    var type: RegisterTableViewCellType?
}

struct NotificationModel {
    var date:Date?
    var type: String?
    var message: String?
    var title: String?
    var navigationBody: String?
}
