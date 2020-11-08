//
//  AuthModels.swift
//  falagron
//
//  Created by namik kaya on 22.10.2020.
//  Copyright © 2020 namik kaya. All rights reserved.
//

import Foundation

let fallar:String = "fallar"
let usersInfo:String = "usersInfo"

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
let userGenderFemale:String = "Kadın"
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


let userNameKey:String               = "name"
let emailKey:String                  = "email"
let passwordKey:String               = "password"
let lastNameKey:String               = "lastName"
let birthDayKey:String               = "birthDay"
let loveKey:String                   = "love"
let sexKey:String                    = "sex"
let workKey:String                   = "work"

enum RegisterTableViewCellType {
    case text
    case swicth
    case list
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
