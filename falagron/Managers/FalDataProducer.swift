//
//  falDataProducer.swift
//  falagron
//
//  Created by namik kaya on 23.01.2021.
//  Copyright © 2021 namik kaya. All rights reserved.
//

import UIKit
import Firebase

class FalDataProducer:NSObject {
    
    var falList:[Int:FalDataModel] = [:]
    
    var userData:UserModel?
    
    var group:DispatchGroup?
    var queue:DispatchQueue?

    
    override init() {
        super.init()
    }
    
    convenience init(userData:UserModel?) {
        self.init()
        guard let userData = userData else {
            print("XYZ: createFalData userData hatası")
            return
        }
        self.userData = userData
        
        createFalData()
    }
    
    private func createFalData(purchase: Bool = false, purchaseLove: Bool = false) {
        group = DispatchGroup()
        queue = DispatchQueue.global(qos: .background)
        
        var statusOfPurchase:Bool = false
        if purchase || purchaseLove{
            // ücretli fal
            statusOfPurchase = true
        }else {
            // ücretsiz fal
            statusOfPurchase = false
            for i in 0...2 {
                group?.enter()
                queue?.async { [weak self] in
                    guard let self = self else { return }
                    
                    self.getFal(giris: i == 0 ? true : false,
                                gelisme: i == 1 ? true : false,
                                sonuc: i == 2 ? true : false,
                                evli: (self.userData?.iliskiDurumu?.iliskiDurumu_Evli ?? false),
                                iliskisiVar: (self.userData?.iliskiDurumu?.iliskiDurumu_IliskisiVar ?? false),
                                yeniAyrilmis: (self.userData?.iliskiDurumu?.iliskiDurumu_YeniAyrilmis ?? false),
                                yeniBosanmis: (self.userData?.iliskiDurumu?.iliskiDurumu_YeniBosanmis ?? false),
                                iliskisiYok: (self.userData?.iliskiDurumu?.iliskiDurumu_IliskisiYok ?? false),
                                nisanli: (self.userData?.iliskiDurumu?.iliskiDurumu_Nisanli ?? false),
                                ogrenci: (self.userData?.kariyer?.kariyer_Ogrenci ?? false),
                                evHanimi: (self.userData?.kariyer?.kariyer_EvHanimi ?? false),
                                calisiyor: (self.userData?.kariyer?.kariyer_Calisiyor ?? false),
                                calismiyor: (self.userData?.kariyer?.kariyer_Calismiyor ?? false),
                                olumlu: true,
                                olumsuz: false,
                                purchase: false,
                                purchaseLove: false,
                                sorting: i) { (status: Bool, snapShot: QuerySnapshot?, errorMessage: String?, _sorting: Int)  in
                        
                        if let snapShot = snapShot, status {
                            for document in snapShot.documents {
                                if var falData = try? JSONDecoder().decode(FalDataModel.self, fromJSONObject: document.data()) {
                                    falData.documentReference = document.reference
                                    self.falList[_sorting] = falData
                                    print("XYZ: atama: success \(_sorting)")
                                }
                            }
                            
                        }else {
                            print("XYZ: filtre 1 response HATA")
                        }
                        self.group?.leave()
                    }
                }
            }
        }
        
        serviceNotify(purchaseStatus: statusOfPurchase)
    }
    
    
    private func serviceNotify(purchaseStatus: Bool = false) {
        group?.notify(queue: DispatchQueue.global()) { [weak self] in
            guard let self = self else { return }
            var count:Int = 0
            var merged = FalMergedModel(userId: FirebaseManager.shared.user?.uid)
            var dict: [String:DocumentReference] = [:]
            var falIdList: [String] = []
            print("XYZ: merged: total count: \(self.falList.count)")
            self.falList.forEach { _ in
                dict[String(count)] = self.falList[count]?.documentReference
                if let falId = self.falList[count]?.documentReference?.documentID {
                    falIdList.append(falId)
                }
                count += 1
            }
            merged.falData = dict
            
            FirebaseManager.shared.setFalObjectInfo(data: merged, falIdList: falIdList)
        }
    }
}

extension FalDataProducer {
    private func getFal(giris:Bool? = nil,
                        gelisme:Bool? = nil,
                        sonuc:Bool? = nil,
                        evli:Bool? = nil,
                        iliskisiVar:Bool? = nil,
                        yeniAyrilmis:Bool? = nil,
                        yeniBosanmis:Bool? = nil,
                        iliskisiYok:Bool? = nil,
                        nisanli:Bool? = nil,
                        ogrenci:Bool? = nil,
                        evHanimi:Bool? = nil,
                        calisiyor:Bool? = nil,
                        calismiyor:Bool? = nil,
                        olumlu:Bool? = nil,
                        olumsuz:Bool? = nil,
                        purchase:Bool? = nil,
                        purchaseLove:Bool? = nil,
                        sorting:Int,
                        completion: @escaping  (_ status:Bool, _ snapShot:QuerySnapshot?, _ errorMessage:String?, _ sorting:Int) -> () = {_, _, _, _  in}) {
        
        FirebaseManager.shared.fetchFilterFal(giris: giris,
                                              gelisme: gelisme,
                                              sonuc: sonuc,
                                              evli: evli,
                                              iliskisiVar: iliskisiVar,
                                              yeniAyrilmis: yeniAyrilmis,
                                              yeniBosanmis: yeniBosanmis,
                                              iliskisiYok: iliskisiYok,
                                              nisanli: nisanli,
                                              ogrenci: ogrenci,
                                              evHanimi: evHanimi,
                                              calisiyor: calisiyor,
                                              calismiyor: calismiyor,
                                              olumlu: olumlu,
                                              olumsuz: olumsuz,
                                              purchase: purchase,
                                              purchaseLove: purchaseLove,
                                              sorting: sorting) { (status: Bool, snapShot:QuerySnapshot?, errorMessage: String?, _sorting : Int) in
            
            if errorMessage != nil {
                completion(false, nil, errorMessage, _sorting)
                return
            }
            
            completion(true, snapShot, nil, _sorting)
        }
        
    }
}


extension FalDataProducer {
    
}

