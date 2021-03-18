//
//  MenuVCViewController.swift
//  falagron
//
//  Created by namik kaya on 11.10.2020.
//  Copyright © 2020 namik kaya. All rights reserved.
//

import UIKit

enum MenuDisplayStatus {
    case ON
    case OFF
}

extension MenuVC {
    enum RowType {
        case loading
        case menuItem(data: MenuModel)
    }
}

class MenuVC: UIViewController {
    private var menuData:[MenuModel] = []
    
    private var rows: [RowType] = []
    private var selfNC: MenuNC?
    @IBOutlet private weak var collectionView: UICollectionView!
    
    var timer: Timer?
    
    var authStatus: FirebaseManager.FBAuthStatus?
    
//    UI
    private var isLoginUI:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        createMenuData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selfNC = self.navigationController as? MenuNC { self.selfNC = selfNC }
        userAuthStatusChange(status: FirebaseManager.shared.authStatus)
        addListener()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        clearTimer()
        removeListener()
    }
    
    func userAuthStatusChange(status:FirebaseManager.FBAuthStatus) {
        switch status {
        case .singIn:
            isLoginUI = true
            break
        case .singOut:
            isLoginUI = false
            break
        }
        updateUI()
        selectedMenuItem() // eğer seçili menu item gelecek ise çalıştırılır.
    }
}

extension MenuVC: UICollectionViewDelegate, UICollectionViewDataSource {
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        let cells = [UICollectionViewCell.self, menuCell.self, loadingColCell.self]
        collectionView.register(cellTypes: cells)
        if #available(iOS 11, *) {
            self.collectionView.contentInsetAdjustmentBehavior = .never
        }
        collectionView.keyboardDismissMode = .onDrag
        collectionView.register(MenuHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerId")
        collectionView.register(MenuFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "footerId")
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.alwaysBounceVertical = true
        layoutCells()
    }
    
    private func layoutCells() {
        let layout = StretchyHeaderStickyFooterLayout()
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        layout.scrollDirection = .vertical
        self.collectionView!.collectionViewLayout = layout
        if #available(iOS 11.0, *){ layout.sectionInsetReference = .fromSafeArea }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rows.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let type = rows[safe: indexPath.row] else { return UICollectionViewCell() }
        switch type {
        case .loading:
            let cell = collectionView.dequeueReusableCell(with: loadingColCell.self, for: indexPath)
            return cell
        case .menuItem(let data):
            let cell = collectionView.dequeueReusableCell(with: menuCell.self, for: indexPath)
            cell.setup(data: data)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        clearTimer()
        timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(timerTrigger(e:)), userInfo: ["row" : indexPath.row], repeats: false)
    }
    
    @objc func timerTrigger(e:Timer) {
        guard let row = e.userInfo as? [String: Int] else { return }
        let currentPage = menuData[row["row", default:0]]
        AppNavigationCoordinator.shared.currentPageType = currentPage.id
        self.revealViewController()?.revealToggle(animated: true)
        clearTimer()
    }
    
    private func clearTimer() {
        guard timer != nil else { return }
        timer?.invalidate()
        timer = nil
    }
}

extension MenuVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 44)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat { return 0.0 }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat { return 0.0 }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.collectionView!.frame.width, height: 205)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return isLoginUI ? CGSize(width: self.collectionView!.frame.width, height: 44) : .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier:"headerId", for: indexPath)
            
            header.tag = indexPath.section
            header.clipsToBounds = true
            header.isUserInteractionEnabled = true
            return header

        case UICollectionView.elementKindSectionFooter:
            if let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footerId", for: indexPath) as? MenuFooterView {
                footerView.tag = indexPath.section
                footerView.clipsToBounds = true
                footerView.isUserInteractionEnabled = true
                footerView.delegate = self
                return footerView
            }
            return UICollectionReusableView()
        default:
            assert(false, "Unexpected element kind")
        }
    }
}

extension MenuVC {
    private func createMenuData() {
        let falShow:MenuModel = .init(id: PageState.home, title: "Falına baktır", icon: UIImage(named: "coffeeIcon") ?? UIImage())
        let fallarim:MenuModel = .init(id: PageState.fallarim, title: "Fallarım", icon: UIImage(named: "history") ?? UIImage())
        let store:MenuModel = .init(id: PageState.purchase, title: "Kredilerim", icon: UIImage(named: "coffee-pot") ?? UIImage())
        /*let notification:MenuModel = .init(id: PageState.notification, title: "Bildirimler", icon: UIImage(named: "bell") ?? UIImage())*/
        let profile:MenuModel = .init(id: PageState.profile, title: "Profilim", icon: UIImage(named: "coffee-beans") ?? UIImage())
        /*let setting:MenuModel = .init(id: PageState.setting, title: "Ayarlar", icon: UIImage(named: "grinder") ?? UIImage())*/
        menuData = [falShow, fallarim, store, /*notification,*/ profile, /*setting*/]
    }
    func updateUI() {
        rows.removeAll()
        menuData.forEach { (item: MenuModel) in
            rows.append(.menuItem(data: item))
        }
        collectionView.reloadData()
    }
}

extension MenuVC: MenuFooterViewDelegate {
    func logoutButtonEvent() {
        FirebaseManager.shared.singOut { (status:Bool, errorMessage:String?) in
            guard !status else {
                print("Başarılı bir şekilde logout oldu.")
                self.revealViewController()?.revealToggle(animated: true)
                return
            }
            if !status {
                print("Bir hata oluştu.")
            }
        }
    }
}

extension MenuVC {
    // Seçili gelmesi gereken item seçili getirilir.
    private func selectedMenuItem() {
        var selectedItem: IndexPath?
        for (index,element) in rows.enumerated() {
            switch element {
            case .menuItem(let data):
                if data.id == AppNavigationCoordinator.shared.currentPageType {
                    selectedItem = IndexPath(row: index, section: 0)
                }
                break
            default: break
            }
        }
        selectedItem = selectedItem == nil ? IndexPath(row: 0, section: 0) : selectedItem
        collectionView.selectItem(at: selectedItem, animated: true, scrollPosition: .left)
    }
}

extension MenuVC {
    func addListener() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.authStatusChange(_:)) , name: NSNotification.Name.FALAGRON.AuthChangeStatus, object: nil)
    }
    
    func removeListener() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.FALAGRON.AuthChangeStatus, object: nil)
    }
}

extension MenuVC {
    @objc private func authStatusChange(_ notification: Notification) {
        if let userInfo = notification.userInfo, let authStatus = userInfo["status"] as? FirebaseManager.FBAuthStatus {
            userAuthStatusChange(status: authStatus)
        }
    }
}
