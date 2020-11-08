//
//  MainVC.swift
//  falagron
//
//  Created by namik kaya on 18.09.2020.
//  Copyright © 2020 namik kaya. All rights reserved.
//

import UIKit

class MainVC: BaseViewController {
    private var rows: [RowType] = []
    private var selfNC: MainNC?
    private var pageData:[MainPageModel] = []
    
    var menuButton:UIButton?
    
    @IBOutlet private weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        createMainPageData()
        setupCollectionView()
        loadingUI()
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateUI()
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
        self.revealViewController()?.revealToggle(animated: true)
    }
    
    
}

//MARK: - Type
extension MainVC {
    enum RowType {
        case loading, banner(image:UIImage), button(type:PurchaseType, title:String, icon:UIImage)
    }
}

//MARK: - CollectionView
extension MainVC: UICollectionViewDelegate, UICollectionViewDataSource {
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
            selfNC?.purchaseNavigation(type: type)
        }
    }
}
extension MainVC: UICollectionViewDelegateFlowLayout {
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
extension MainVC {
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

extension MainVC {
    private func createMainPageData() {
        pageData.removeAll()
        let bannerItem = MainPageModel(type: .banner(image: UIImage(named: "coffee") ?? UIImage()))
        pageData.append(bannerItem)
        let daily = MainPageModel(type: .button(type: .daily, title: "Günlük Fal", icon: UIImage(named: "coffee") ?? UIImage()))
        pageData.append(daily)
        let watcher = MainPageModel(type: .button(type: .watcher, title: "İzle Kazan", icon: UIImage(named: "coffee") ?? UIImage()))
        pageData.append(watcher)
        let sharingFriend = MainPageModel(type: .button(type: .shared, title: "Tavsiye Et, Kazan", icon: UIImage(named: "coffee") ?? UIImage()))
        pageData.append(sharingFriend)
        let buyyer = MainPageModel(type: .button(type: .buyyer, title: "Kredi Al", icon: UIImage(named: "coffee") ?? UIImage()))
        pageData.append(buyyer)
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
