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

class MenuVC: UIViewController, SWRevealViewControllerDelegate {
    private var menuData:[MenuModel] = []
    
    private var rows: [RowType] = []
    private var selfNC: MenuNC?
    @IBOutlet private weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        createMenuData()
        updateUI()
        
        for (index,element) in rows.enumerated() {
            switch element {
            case .menuItem(let data):
                if data.id == DataHolder.shared.currentPageType {
                    let indexPath = IndexPath(row: index, section: 0)
                    collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .left)
                }
            default: break
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selfNC = self.navigationController as? MenuNC {
            self.selfNC = selfNC
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
}

extension MenuVC {
    func revealController(_ revealController: SWRevealViewController!, didMoveTo position: FrontViewPosition) {
        switch position {
        case .left:
            NotificationCenter.default.post(name: NSNotification.Name.FALAGRON.MenuTakeOff, object: self, userInfo: nil)
            break
        case .right:
            NotificationCenter.default.post(name: NSNotification.Name.FALAGRON.MenuTakeOn, object: self, userInfo: nil)
            break
        default: break
        }
    }
}

extension MenuVC {
    func startListener() {
        
    }
    
    func stopListener() {
        
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
        
        let menuFooterNib:UINib = UINib(nibName: "MenuFooterView", bundle: nil)
        collectionView.register(menuFooterNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "footerId")
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
        //layout.estimatedItemSize = CGSize(width: 160, height: 150)
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
        let currentPage = menuData[indexPath.row]
        DataHolder.shared.currentPageType = currentPage.id
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
        return CGSize(width: self.collectionView!.frame.width, height: 44)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        print("Kind nedir: \(kind)")
        
        switch kind {

        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier:"headerId", for: indexPath)
            
            header.tag = indexPath.section
            header.clipsToBounds = true
            header.isUserInteractionEnabled = true
            return header

        case UICollectionView.elementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footerId", for: indexPath)
            return footerView
        default:
            assert(false, "Unexpected element kind")
        }
    }
}

extension MenuVC {
    private func createMenuData() {
        let falShow:MenuModel = .init(id: PageState.home, title: "Falına baktır", icon: UIImage(named: "coffee") ?? UIImage())
        let fallarim:MenuModel = .init(id: PageState.fallarim, title: "Fallarım", icon: UIImage(named: "coffee") ?? UIImage())
        let store:MenuModel = .init(id: PageState.purchase, title: "Kredilerim", icon: UIImage(named: "coffee") ?? UIImage())
        let notification:MenuModel = .init(id: PageState.notification, title: "Bildirimler", icon: UIImage(named: "coffee") ?? UIImage())
        let profile:MenuModel = .init(id: PageState.profile, title: "Profilim", icon: UIImage(named: "coffee") ?? UIImage())
        let setting:MenuModel = .init(id: PageState.setting, title: "Ayarlar", icon: UIImage(named: "coffee") ?? UIImage())
        menuData = [falShow, fallarim, store, notification, profile, setting]
    }
    func updateUI() {
        rows.removeAll()
        menuData.forEach { (item: MenuModel) in
            rows.append(.menuItem(data: item))
        }
        collectionView.reloadData()
    }
}
