//
//  FirebaseManager.swift
//  falagron
//
//  Created by namik kaya on 17.09.2020.
//  Copyright © 2020 namik kaya. All rights reserved.
//

import Foundation
import FirebaseAuth
import Firebase
import FirebaseFirestore
import FirebaseCore
import FirebaseFirestoreSwift

class FirebaseManager: NSObject{
    static let shared = FirebaseManager()
    
    private var handle: AuthStateDidChangeListenerHandle?
    var authStatus: FBAuthStatus = .singOut
    
    typealias ReferanceQueries = (ref1: Query, ref2: Query)
    
    var fbUserInformation:String = "usersInfo"
    
    var db: Firestore!
    
    var user:User?
    var userInfoData:UserModel?
    
    var userViewedFalList:[String] = []
    
    
    override init() {
        super.init()
        
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        Firestore.firestore().settings = settings
        
        db = Firestore.firestore()
        
        addFirebaseListener()
        checkUser()
    }
}

extension FirebaseManager {
    enum FBAuthStatus{
        case singIn
        case singOut
    }
}

// MARK: -  Auth
extension FirebaseManager {
    private func addFirebaseListener() {
        handle = Auth.auth().addStateDidChangeListener { (auth:Auth, user:User?) in
            let singStatus:FBAuthStatus = user != nil ? .singIn : .singOut
            let userInfo: [String : FBAuthStatus] = ["status":singStatus]
            if let user = user {
                self.user = user
                self.authStatus = .singIn
            }else {
                self.user = nil
                self.authStatus = .singOut
            }
            NotificationCenter.default.post(name: NSNotification.Name.FALAGRON.AuthChangeStatus, object: self, userInfo: userInfo)
        }
    }
    
    func removeFirebaseListener() {
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    func newUser(email:String, password:String, data:[String:Any], completion: @escaping  (_ status:Bool, _ message:String?) -> () = {_, _ in} ) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            guard error == nil else {
                completion(false, error?.localizedDescription)
                return
            }
            if let authResult = authResult {
                self.authStatus = .singIn
                self.userWriteData(userId: authResult.user.uid, data: data, completion: completion)
            }
        }
    }
    
    func singIn(email:String, password:String, completion: @escaping  (_ status:Bool, _ message:String?) -> () = {_, _ in}) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let strongSelf = self else { return }
            guard error == nil else {
                completion(false, error?.localizedDescription)
                return
            }
            if let user = authResult?.user {
                strongSelf.user = user
                strongSelf.authStatus = .singIn
                completion(true, nil)
            }
        }
    }
    
    func singOut(completion: @escaping  (_ status:Bool, _ message:String?) -> () = {_, _ in}) {
        do {
            try Auth.auth().signOut()
        }catch {
            completion(false,"Çıkış yaparken bir hata oluştu.")
        }
        self.authStatus = .singOut
        self.user = nil
        self.userInfoData = nil
        completion(true,nil)
    }
    
    func checkUser() {
        if Auth.auth().currentUser != nil {
            self.user = Auth.auth().currentUser
            self.authStatus = .singIn
            guard self.userInfoData == nil else { return }
            if let uid = self.user?.uid {
                getUserData(userId: uid)
            }
        } else {
            self.user = nil
            self.authStatus = .singOut
            self.user = nil
            self.userInfoData = nil
        }
    }
    
    func userWriteData(userId:String,data:[String : Any], completion: @escaping  (_ status:Bool, _ message:String?) -> () = {_, _ in}) {
        var newData = data
        newData["userId"] = userId
        db.collection(usersInfo).addDocument(data: newData) { error in
            if let err = error {
                completion(false, "Kullanıcı oluşturuldu ancak bilgileri eklenemedi. \n Hata: \(err.localizedDescription)")
            }else {
                completion(true, "Kullanıcı başarılı ile oluşturuldu.")
            }
        }
    }
    
    // firstRun: uygulama ilk başladığında user data sı alındıktan sonra kullanıcının görmüş olduğu falId lerini çekmek için kullanılır.
    func getUserData(userId:String, firstRun:Bool = false, completion: @escaping  (_ userInfo:UserModel?, _ error:Error?) -> () = {_, _ in}) {
        let refQuery = db.collection(fbUserInformation).whereField("userId",isEqualTo: userId)
        refQuery.getDocuments { [weak self] (snapShot: QuerySnapshot?, error: Error?) in
            guard let self = self else { return }
            guard let snap = snapShot else {
                completion(nil, error)
                return
            }
            
            if let jsonData = snap.documents.first?.data() {
                self.userInfoData = UserModel(json: jsonData)
                self.getUserViewedFal()
                completion(self.userInfoData, nil)
            }
        }
    }
}

//MARK: - User viewed fal
extension FirebaseManager {
    // Kullanıcının görüntülediği falId listesini çeker
    func getUserViewedFal(completion: @escaping  (_ status:Bool, _ userViewedFal:[String]?, _ errorMessage:String?) -> () = {_, _, _ in}) {
        guard let user = self.user else { return }
        let refQuery = db.collection(userViewedFal).document(user.uid)
        
        refQuery.getDocument { [weak self] (snap, error) in
            if let error = error {
                completion(false, nil, error.localizedDescription)
            }
            guard let snap = snap, let dict = snap.data() else { return }
            if let falItems = dict[userFalList] as? [String] {
                self?.userViewedFalList = falItems
                completion(true, self?.userViewedFalList, nil)
            }
        }
    }
    
    // Falı gören kullanıcının fal göründü alanına görünen falların id lerini ekleme
    func setUserViewedFal(falDocumentId:[String], completion: @escaping  (_ status:Bool, _ userViewedFal:[String]?, _ errorMessage:String?) -> () = {_, _, _ in}) {
        guard let user = self.user else { return }
        let refQuery = db.collection(userViewedFal).document(user.uid)
        refQuery.updateData([userFalList: FieldValue.arrayUnion(falDocumentId)]) { [weak self] (error:Error?) in
            guard error == nil else {
                refQuery.setData([userFalList: FieldValue.arrayUnion(falDocumentId)]) { (error:Error?) in
                    guard error == nil else {
                        completion(false, nil, error?.localizedDescription)
                        return
                    }
                    self?.userViewedFalList.append(contentsOf: falDocumentId)
                    completion(true, self?.userViewedFalList, nil)
                }
                return
            }
            self?.userViewedFalList.append(contentsOf: falDocumentId)
            completion(true, self?.userViewedFalList, nil)
        }
    }
}

//MARK: - Create Fal Viewer
extension FirebaseManager {
    func fetchFilterFal(giris:Bool? = nil,
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
                        completion: @escaping  (_ status:Bool, _ snapShot:QuerySnapshot?, _ errorMessage:String?, _ sorting:Int) -> () = {_, _, _, _ in}) {
        let query: ReferanceQueries = getCreateQuery(giris: giris,
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
                                                     purchaseLove: purchaseLove)
        
        
        refQuery(reference: query, sorting: sorting) { (snapShot: QuerySnapshot?, error: Error?, sorting:Int)  in
            if error != nil {
                completion(false, nil, "Bir hata oluştu.", sorting)
                return
            }
            completion(true, snapShot, nil, sorting)
        }
    }
    
    private func refQuery(reference: ReferanceQueries,
                          sorting:Int,
                          completion: @escaping  (_ snapShot:QuerySnapshot?, _ errorMessage:Error?, _ sorting:Int) -> () = {_, _, _ in}) {
        // referans 1 den hata geldiğinde referans 2 ile çıkar.
        getDocument(reference: reference.ref1, sorting: sorting) { [weak self] (snapShot:QuerySnapshot?, error:Error?, sorting: Int) in
            guard let self = self else { return }
            if let snapShot = snapShot, snapShot.documents.count > 0 {
                completion(snapShot,nil, sorting)
                //print("XYZ query: ilk qurey başarılı: \(sorting)")
                return
            }
            //print("XYZ query: ilk qurey başarısız oldu. : \(sorting)")
            self.getDocument(reference: reference.ref2, sorting: sorting) { (snapShot2: QuerySnapshot?, error:Error?, sorting2: Int) in
                if let snapShot2 = snapShot2, snapShot2.documents.count > 0 {
                    completion(snapShot2, nil, sorting2)
                    //print("XYZ query: ikinci qurey başarılı: : \(sorting)")
                    return
                }
                //print("XYZ query: ikinci query de başarısız oldu. : : \(sorting)")
                let errorType = NSError(domain: "com.kaya.falagron", code: 19292, userInfo: ["message": "Hata var!"])
                let returningError = error != nil ? error : errorType
                completion(nil, returningError, sorting2)
            }
         }
    }
    
    private func getDocument(reference: Query, sorting:Int, completion: @escaping  (_ snapShot:QuerySnapshot?, _ errorMessage:Error?, _ sorting:Int) -> () = {_, _, _ in}) {
        reference.getDocuments { (querySnapshot, error) in
            if error != nil {
                completion(nil, error, sorting)
                return
            }
            if let snapShot = querySnapshot {
                completion(snapShot, nil, sorting)
            }
        }
    }
}

//MARK: - Creates Fal Referance for the query
extension FirebaseManager {
    private func getCreateQuery(giris:Bool? = nil,
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
                                purchaseLove:Bool? = nil) -> ReferanceQueries {
        
        let query2 = Firestore.firestore().collection(fallar)
        let key = query2.document().documentID
        let db = Firestore.firestore()
        var reference = db.collection(fallar).limit(to: 1)
        var reference2 = db.collection(fallar).limit(to: 1)
        
        reference = reference.whereField(FieldPath.documentID(), isGreaterThanOrEqualTo: key)
        reference2 = reference.whereField(FieldPath.documentID(), isLessThan: key)
        
        if let giris = giris, giris {
            reference = reference.whereField("\(paragrafTipi).\(paragrafTipi_Giris)", isEqualTo: giris)
            reference2 = reference2.whereField("\(paragrafTipi).\(paragrafTipi_Giris)", isEqualTo: giris)
        }
        
        if let gelisme = gelisme, gelisme {
            reference = reference.whereField("\(paragrafTipi).\(paragrafTipi_Gelisme)", isEqualTo: gelisme)
            reference2 = reference2.whereField("\(paragrafTipi).\(paragrafTipi_Gelisme)", isEqualTo: gelisme)
        }
        
        if let sonuc = sonuc, sonuc {
            reference = reference.whereField("\(paragrafTipi).\(paragrafTipi_Sonuc)", isEqualTo: sonuc)
            reference2 = reference2.whereField("\(paragrafTipi).\(paragrafTipi_Sonuc)", isEqualTo: sonuc)
        }
        
        if let evli = evli, evli {
            reference = reference.whereField("\(iliskiDurumu).\(iliskiDurumu_Evli)", isEqualTo: evli)
            reference2 = reference2.whereField("\(iliskiDurumu).\(iliskiDurumu_Evli)", isEqualTo: evli)
        }
        
        if let iliskisiVar = iliskisiVar, iliskisiVar {
            reference = reference.whereField("\(iliskiDurumu).\(iliskiDurumu_IliskisiVar)", isEqualTo: iliskisiVar)
            reference2 = reference2.whereField("\(iliskiDurumu).\(iliskiDurumu_IliskisiVar)", isEqualTo: iliskisiVar)
        }
        
        if let iliskisiYok = iliskisiYok, iliskisiYok {
            reference = reference.whereField("\(iliskiDurumu).\(iliskiDurumu_IliskisiYok)", isEqualTo: iliskisiYok)
            reference2 = reference2.whereField("\(iliskiDurumu).\(iliskiDurumu_IliskisiYok)", isEqualTo: iliskisiYok)
        }
        
        if let nisanli = nisanli, nisanli {
            reference = reference.whereField("\(iliskiDurumu).\(iliskiDurumu_Nisanli)", isEqualTo: nisanli)
            reference2 = reference2.whereField("\(iliskiDurumu).\(iliskiDurumu_Nisanli)", isEqualTo: nisanli)
        }
        
        if let yeniAyrilmis = yeniAyrilmis, yeniAyrilmis {
            reference = reference.whereField("\(iliskiDurumu).\(iliskiDurumu_YeniAyrilmis)", isEqualTo: yeniAyrilmis)
            reference2 = reference2.whereField("\(iliskiDurumu).\(iliskiDurumu_YeniAyrilmis)", isEqualTo: yeniAyrilmis)
        }
        
        if let yeniBosanmis = yeniBosanmis, yeniBosanmis {
            reference = reference.whereField("\(iliskiDurumu).\(iliskiDurumu_YeniBosanmis)", isEqualTo: yeniBosanmis)
            reference2 = reference2.whereField("\(iliskiDurumu).\(iliskiDurumu_YeniBosanmis)", isEqualTo: yeniBosanmis)
        }
        
        if let ogrenci = ogrenci, ogrenci {
            reference = reference.whereField("\(kariyer).\(kariyer_Ogrenci)", isEqualTo: ogrenci)
            reference2 = reference2.whereField("\(kariyer).\(kariyer_Ogrenci)", isEqualTo: ogrenci)
        }
        
        if let evHanimi = evHanimi, evHanimi {
            reference = reference.whereField("\(kariyer).\(kariyer_EvHanimi)", isEqualTo: evHanimi)
            reference2 = reference2.whereField("\(kariyer).\(kariyer_EvHanimi)", isEqualTo: evHanimi)
        }
        
        if let calisiyor = calisiyor, calisiyor {
            reference = reference.whereField("\(kariyer).\(kariyer_Calisiyor)", isEqualTo: calisiyor)
            reference2 = reference2.whereField("\(kariyer).\(kariyer_Calisiyor)", isEqualTo: calisiyor)
        }
        
        if let calismiyor = calismiyor, calismiyor {
            reference = reference.whereField("\(kariyer).\(kariyer_Calismiyor)", isEqualTo: calismiyor)
            reference2 = reference2.whereField("\(kariyer).\(kariyer_Calismiyor)", isEqualTo: calismiyor)
        }
        
        if let olumlu = olumlu, olumlu {
            reference = reference.whereField("\(yargi).\(yargi_Olumlu)", isEqualTo: olumlu)
            reference2 = reference2.whereField("\(yargi).\(yargi_Olumlu)", isEqualTo: olumlu)
        }
        
        if let olumsuz = olumsuz, olumsuz {
            reference = reference.whereField("\(yargi).\(yargi_Olumsuz)", isEqualTo: olumsuz)
            reference2 = reference2.whereField("\(yargi).\(yargi_Olumsuz)", isEqualTo: olumsuz)
        }
        
        if let purchase = purchase {
            reference = reference.whereField("\(purchaseString).\(purchaseStatusString)", isEqualTo: purchase)
            reference2 = reference2.whereField("\(purchaseString).\(purchaseStatusString)", isEqualTo: purchase)
        }
        
        if let purchaseLove = purchaseLove {
            reference = reference.whereField("\(purchaseLoveString).\(purchaseLoveStatusString)", isEqualTo: purchaseLove)
            reference2 = reference2.whereField("\(purchaseLoveString).\(purchaseLoveStatusString)", isEqualTo: purchaseLove)
        }
        return (reference, reference2)
    }
}

extension FirebaseManager {
    func setFalObjectInfo(data:FalMergedModel, falIdList: [String], completion: @escaping  (_ status: Bool, _ errorMessage:Error?) -> () = {_, _ in}) {
        var newData:[String: Any?] = [:]
        newData["userId"] = data.userId
        newData["falData"] = data.falData
        newData["created"] = FieldValue.serverTimestamp()//Timestamp(date: Date())
        newData["userViewedStatus"] = false
        newData[purchaseString] = data.purchase
        
        db.collection(falInfo).addDocument(data: newData as [String : Any]) { [weak self] error in
            guard let self = self else { return }
            if let err = error {
                //completion(false, "Kullanıcı oluşturuldu ancak bilgileri eklenemedi. \n Hata: \(err.localizedDescription)")
            }else {
                //completion(true, "Kullanıcı başarılı ile oluşturuldu.")
                self.setViewedFal(falIdList: falIdList)
            }
        }
    }
    
    private func setViewedFal(falIdList:[String]) {
        self.setUserViewedFal(falDocumentId: falIdList) { [weak self] (status, allList:[String]?, message:String?) in
            guard let self = self else { return }
            if !status {
                self.setViewedFal(falIdList: falIdList)
            }else {
                
            }
        }
    }
    
}

extension FirebaseManager {
    func getHistory(completion: @escaping (_ status:Bool, _ falHistoryData: [FalHistoryDataModel], _ errorMessage:String?) -> () = {_, _, _ in}) {
        guard let user = self.user else { return }
        let refQuery = db.collection(falInfo).whereField("userId", isEqualTo: user.uid)
        refQuery.getDocuments { (snap, error) in
            if let error = error {
                completion(false, [], error.localizedDescription)
            }
            
            guard let snap = snap else {
                completion(false, [], nil)
                return
            }
            
            if snap.documents.count > 0 {
                var dataModelList:[FalHistoryDataModel] = []
                for item in snap.documents {
                    var falItem = FalHistoryDataModel(json: item.data())
                    falItem.falId = item.documentID
                    falItem.userId = user.uid
                    dataModelList.append(falItem)
                }
                let sorted = dataModelList.sorted { $0.created?.dateValue() ?? Date() >= $1.created?.dateValue() ?? Date() }
                completion(true, sorted, nil)
            }else {
                completion(false, [], "Bir hata oluştu")
            }
            
        }
    }
    
    func getReferanceDocument(key:String,
                              documentRefs: DocumentReference?,
                              completion: @escaping (_ status:Bool, _ falData: FalDataModel? , _ errorMessage:String?) -> () = {_, _, _ in}) {
        guard let documentRefs = documentRefs else { return }
        documentRefs.getDocument { (snapShot:DocumentSnapshot?, error:Error?) in
            guard let snapShot = snapShot, let document = snapShot.data() else {
                completion(false, nil, "Bir hata oluştu")
                return
            }
            if var falData = try? JSONDecoder().decode(FalDataModel.self, fromJSONObject: document) {
                falData.documentReference = documentRefs
                completion(true, falData, nil)
            }
        }
    }
    
}
