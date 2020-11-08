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
    
    override init() {
        super.init()
        addFirebaseListener()
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
            NotificationCenter.default.post(name: NSNotification.Name.FALAGRON.AuthChangeStatus, object: self, userInfo: userInfo)
            /*if let user = user {
                // The user's ID, unique to the Firebase project.
                // Do NOT use this value to authenticate with your backend server,
                // if you have one. Use getTokenWithCompletion:completion: instead.
                let uid = user.uid
                let email = user.email
                let photoURL = user.photoURL
                var multiFactorString = "MultiFactor: "
                for info in user.multiFactor.enrolledFactors {
                    multiFactorString += info.displayName ?? "[DispayName]"
                    multiFactorString += " "
                }
                // ...
            }*/
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
                self.userWriteData(userId: authResult.user.uid, data: data, completion: completion)
            }
            
        }
    }
    
    func singIn(email:String, password:String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let strongSelf = self else { return }
            print(authResult?.user.isAnonymous)
        }
    }
    
    func checkUser() {
        if Auth.auth().currentUser != nil {
          // User is signed in.
          // ...
        } else {
          // No user is signed in.
          // ...
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
}
