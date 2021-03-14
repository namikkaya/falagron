//
//  MainViewModel.swift
//  falagron
//
//  Created by namik kaya on 6.03.2021.
//  Copyright © 2021 namik kaya. All rights reserved.
//

import UIKit
protocol MainViewManagerDelegate: class {
    func didEventTypeTrigger(type: MainViewManager.EventType)
}

extension MainViewManagerDelegate {
    func didEventTypeTrigger(type: MainViewManager.EventType) {}
}

class MainViewManager: NSObject {
    var collectionView:UICollectionView!
    
    weak var delegate: MainViewManagerDelegate?
    
    private var pageData:[MainPageModel] = []
    private var rows: [MainPageModel.RowType] = []
    
    override init() {
        super.init()
    }
    
    convenience init(collectionView:UICollectionView, delegate: MainViewManagerDelegate) {
        self.init()
        self.collectionView = collectionView
        self.delegate = delegate
        
        createMainPageData()
        setupCollectionView()
        loadingUI()
    }
}

extension MainViewManager {
    enum EventType {
        case didPurchaseEventTrigger(purchaseType: PurchaseType)
    }
}

//MARK: - CollectionView
extension MainViewManager: UICollectionViewDelegate, UICollectionViewDataSource {
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        let cells = [UICollectionViewCell.self, MainBannerCell.self, MainButtonCell.self, loadingColCell.self]
        collectionView.register(cellTypes: cells)
        if #available(iOS 11, *) {
            self.collectionView.contentInsetAdjustmentBehavior = .never
        }
        collectionView.keyboardDismissMode = .onDrag
        layoutCells()
    }
    
    private func layoutCells() {
        let layout = LeftAlignedFlowLayout()
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
        case .banner(let image):
            let cell = collectionView.dequeueReusableCell(with: MainBannerCell.self, for: indexPath)
            cell.setup(image: image)
            return cell
        case .button(let type, let title, let icon):
            let cell = collectionView.dequeueReusableCell(with: MainButtonCell.self, for: indexPath)
            cell.setup(title: title, image: icon, type: type)
            return cell
        case .loading:
            let cell = collectionView.dequeueReusableCell(with: loadingColCell.self, for: indexPath)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? MainButtonCell {
            guard let type = cell.type else { return }
            delegate?.didEventTypeTrigger(type: .didPurchaseEventTrigger(purchaseType: type))
            //selfNC?.purchaseNavigation(type: type)
            
            //producer = FalDataProducer(userData: FirebaseManager.shared.userInfoData ?? nil)
        }
    }
}
extension MainViewManager: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let type = rows[indexPath.row]
        switch type {
        case .loading:
            return CGSize(width: collectionView.frame.size.width, height: 56)
        case .banner:
            return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height / 2)
        case .button:
            let buttonItemHeight = ((collectionView.frame.size.height / 2)) / 4
            return CGSize(width: collectionView.frame.size.width, height: buttonItemHeight)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat { return 1.0 }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat { return 1.0 }
}

//MARK: - UpdateUI
extension MainViewManager {
    func updateUI() {
        rows.removeAll()
        pageData.forEach { (item) in
            if let type = item.type {
                rows.append(type)
            }
        }
        self.collectionView.reloadData()
    }
    
    func loadingUI() {
        rows.removeAll()
        rows.append(.loading)
        self.collectionView.reloadData()
    }
}

extension MainViewManager {
    private func createMainPageData() {
        pageData.removeAll()
        let bannerItem = MainPageModel(type: .banner(image: UIImage(named: "whitelogo") ?? UIImage()))
        pageData.append(bannerItem)
        let daily = MainPageModel(type: .button(type: .daily, title: "Günlük Fal", icon: UIImage(named: "daily_icon") ?? UIImage()))
        pageData.append(daily)
        let watcher = MainPageModel(type: .button(type: .watcher, title: "İzle Kazan", icon: UIImage(named: "clapperboard") ?? UIImage()))
        pageData.append(watcher)
        let sharingFriend = MainPageModel(type: .button(type: .shared, title: "Tavsiye Et, Kazan", icon: UIImage(named: "recommended") ?? UIImage()))
        pageData.append(sharingFriend)
        let buyyer = MainPageModel(type: .button(type: .buyyer, title: "Kredi Al", icon: UIImage(named: "rent") ?? UIImage()))
        pageData.append(buyyer)
    }
}
