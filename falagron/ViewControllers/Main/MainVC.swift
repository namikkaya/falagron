//
//  MainVC.swift
//  falagron
//
//  Created by namik kaya on 18.09.2020.
//  Copyright © 2020 namik kaya. All rights reserved.
//

import UIKit
import Firebase

class MainVC: BaseViewController {
    private var selfNC: MainNC?
    
    var menuButton:UIButton?
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    
    private var viewModel: MainViewManager!
    
    // Helper
    var producer:FalDataProducer?

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = MainViewManager(collectionView: self.collectionView, delegate: self)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selfNC = self.navigationController as? MainNC {
            self.selfNC = selfNC
        }
        setNeedsStatusBarAppearanceUpdate()
        menuButton = addGetMenuButton()
        menuButton?.addTarget(self, action: #selector(menuButtonEvent(_:)), for: .touchUpInside)
        self.collectionView.isUserInteractionEnabled = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.updateUI()
        
        //FirebaseManager.shared.checkTime()
        
        
        //setViewedFalIds(setIds: ["3"])
        /*
        LocalNotificationCenter.shared.checkLocalNotificationAuthorization { (granted:Bool, status: UNAuthorizationStatus?) in
            if granted {
                print("XYZ: MainVC: izin verilmiş")
                LocalNotificationCenter.shared.addScheduleNotification(at: 10, uniqId: "123", title: "Başlık", body: "Oley be", userInfo: ["root":"fallarim", "inPage":"", "falId":"123"]) // 
            }else {
                print("XYZ: MainVC: izin yok \(status?.rawValue)")
                LocalNotificationCenter.shared.requestNotificationAuthorization()
            }
        }
         */
        /*
        FirebaseManager.shared.fetchFilterFal(giris: true,
                                              evli: true,
                                              iliskisiVar: true,
                                              nisanli: true,
                                              ogrenci: true,
                                              olumlu: true,
                                              purchase: false,
                                              purchaseLove: false) { (status: Bool, snapshot: QuerySnapshot?, errorMessage: String?) in
            
            if let snapshot = snapshot, snapshot.documents.count > 0 {
                var count = 0
                for document in snapshot.documents {
                    if let falData = try? JSONDecoder().decode(FalDataModel.self, fromJSONObject: document.data()) {
                        if falData.paragrafTipi?.paragrafTipi_Giris == true &&
                            falData.iliskiDurumu?.iliskiDurumu_Evli == true &&
                            falData.iliskiDurumu?.iliskiDurumu_Nisanli == true &&
                            falData.iliskiDurumu?.iliskiDurumu_IliskisiVar == true &&
                            falData.kariyer?.kariyer_Ogrenci == true {
                            print("XYZ: falData: falID: \(falData.id) paragrafTipi: \(falData.paragrafTipi?.paragrafTipi_Giris) - iliski durumu evli: \(falData.iliskiDurumu?.iliskiDurumu_Evli) - iliskidurumu nisanli: \(falData.iliskiDurumu?.iliskiDurumu_Nisanli) - iliskisiVar: \(falData.iliskiDurumu?.iliskiDurumu_IliskisiVar) - ogrenci \(falData.kariyer?.kariyer_Ogrenci)")
                            count += 1
                        }
                    }
                }
                print("XYZ: falData count: \(snapshot.documents.count) aranan toplam: \(count)")
            }else {
                print("XYZ: Hata oluştu")
            }
        }
        */
        
    }
    
    
    // user login and logout
    override func userAuthStatusChange(status: FirebaseManager.FBAuthStatus) {
        super.userAuthStatusChange(status: status)
        switch status {
        case .singIn:
            
            break
        case .singOut:
            
            break
        }
    }
    
    override func menuDisplayChange(status: MenuDisplayStatus) {
        super.menuDisplayChange(status: status)
        switch status {
        case .ON:
            self.collectionView.isUserInteractionEnabled = false
            break
        case .OFF:
            self.collectionView.isUserInteractionEnabled = true
            break
        }
    }
    
    @objc private func menuButtonEvent(_ sender:UIButton) {
        switch FirebaseManager.shared.authStatus {
        case .singIn:
            self.revealViewController()?.revealToggle(animated: true)
            break
        case .singOut:
            selfNC?.gotoLogin()
            break
        }
    }
}



extension MainVC {
    private func addGetMenuButton() -> UIButton  {
        let leftMenuButton = UIButton(frame: CGRect(x: 0, y: 0, width: 18, height: 18))
        leftMenuButton.setImage(UIImage(named: "menuIcon"), for: .normal)
        let barButton = UIBarButtonItem(customView: leftMenuButton)
        let width = barButton.customView?.widthAnchor.constraint(equalToConstant: 18)
        width?.isActive = true
        let height = barButton.customView?.heightAnchor.constraint(equalToConstant: 18)
        height?.isActive = true
        self.navigationItem.setLeftBarButton(barButton, animated: true)
        return leftMenuButton
    }
}

extension MainVC {
    func getViewedFalIDs(){
        FirebaseManager.shared.getUserViewedFal { [weak self] (status: Bool, viewedFal: [String]?, errorMessage:String?) in
            guard status else {
                self?.infoMessage(message: errorMessage ?? "Bir hata oluştu.", buttonTitle: "TAMAM")
                return
            }
            
            if let viewedFal = viewedFal, viewedFal.count > 0 {
                print("Görüntülenen fallar: \(viewedFal.count)")
            }else {
                print("Görüntülenen falı yok.")
            }
        }
    }
    
    func setViewedFalIds(setIds:[String]){
        FirebaseManager.shared.setUserViewedFal(falDocumentId: setIds) { [weak self] (status:Bool, viewedFals:[String]?, errorMessage:String?) in
            guard errorMessage == nil else {
                self?.infoMessage(message: errorMessage ?? "Bir hata oluştu.", buttonTitle: "TAMAM")
                return
            }
            
            if let viewedFals = viewedFals, viewedFals.count > 0 {
                print("Görüntülenen fallar: \(viewedFals.count)")
            }else {
                print("Görüntülenen falı yok.")
            }
        }
    }
}


extension MainVC: MainViewManagerDelegate {
    func didEventTypeTrigger(type: MainViewManager.EventType) {
        switch type {
        case .didPurchaseEventTrigger(let purchaseType):
            purchaseEvent(type: purchaseType)
            break
        }
    }
}

extension MainVC {
    private func purchaseEvent(type: PurchaseType) {
        switch type {
        case .daily:
            
            break
        case .shared:
            
            break
        case .buyyer:
            
            break
        case .watcher:
            
            break
        }
        
        selfNC?.purchaseNavigation(type: type)
    }
}
