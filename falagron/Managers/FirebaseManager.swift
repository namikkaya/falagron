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

class FirebaseManager: NSObject{
    static let shared = FirebaseManager()
    
    private var handle: AuthStateDidChangeListenerHandle?
    var authStatus: FBAuthStatus = .singOut
    
    var fbUserInformation:String = "usersInfo"
    
    let db = Firestore.firestore()
    
    var user:User?
    var userInfoData:UserModel?
    
    var userViewedFalList:[String] = []
    
    override init() {
        super.init()
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
            print("kullanıcı login")
            self.authStatus = .singIn
            guard self.userInfoData == nil else { return }
            if let uid = self.user?.uid{
                getUserData(userId: uid)
            }
        } else {
            self.user = nil
            print("kullanıcı logOut")
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
    
    func getUserData(userId:String, completion: @escaping  (_ userInfo:UserModel?, _ error:Error?) -> () = {_, _ in}) {
        let refQuery = db.collection(fbUserInformation).whereField("userId",isEqualTo: userId)
        refQuery.getDocuments { (snapShot: QuerySnapshot?, error: Error?) in
            guard let snap = snapShot else {
                completion(nil, error)
                return
            }
            
            if let jsonData = snap.documents.first?.data() {
                self.userInfoData = UserModel(json: jsonData)
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
                refQuery.setData([userFalList: falDocumentId]) { (error:Error?) in
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
