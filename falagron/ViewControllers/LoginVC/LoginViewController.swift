//
//  LoginViewController.swift
//  falagron
//
//  Created by namik kaya on 19.09.2020.
//  Copyright © 2020 namik kaya. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController {
    @IBOutlet private weak var collectionView: UICollectionView!
    private var selfNC: AuthenticationNC?
    
    var rows:[SectionType] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let selfNC = self.navigationController as? AuthenticationNC {
            self.selfNC = selfNC
        }
        setupCollectionView()
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
    
}

extension LoginViewController {
    enum RowType{
        case loading,
        logoCell(image:UIImage),
        loginWriteCell(emailPlaceHolder:String, passwordPlaceHolder:String)
    }
    
    enum SectionType {
        case cellType(type:RowType)
    }
}

extension LoginViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return rows.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionType = rows[section]
        switch sectionType {
        case .cellType(let type):
            switch type {
            case .logoCell, .loginWriteCell:
                return 1
            default: return 0
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let type = rows[indexPath.section]
        switch type {
        case .cellType(let type):
            switch type {
            case .logoCell(let image):
                let cell = collectionView.dequeueReusableCell(with: LoginLogoCell.self, for: indexPath)
                return cell
            case .loginWriteCell(let emailPlaceHolder, let passwordPlaceHolder):
                let cell = collectionView.dequeueReusableCell(with: LoginWriteEmailPasswordCell.self, for: indexPath)
                cell.setup(mailPlaceHolder: emailPlaceHolder, passwordPlaceHolder: passwordPlaceHolder, rePasswordPlaceHolder: passwordPlaceHolder)
                return cell
            default: return UICollectionViewCell()
            }
        }
    }
}

extension LoginViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sectionType = rows[indexPath.section]
        switch sectionType {
        case .cellType(let type):
            switch type {
            case .logoCell:
                return CGSize(width: collectionView.frame.size.width, height: 120)
            case .loginWriteCell:
                return CGSize(width: collectionView.frame.size.width, height: 170)
            default: return .zero
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat { return 1.0 }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat { return 1.0 }
}

extension LoginViewController {
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        let cells = [UICollectionViewCell.self, LoginLogoCell.self, LoginWriteEmailPasswordCell.self]
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
}

extension LoginViewController {
    private func updateUI() {
        rows.removeAll()
        rows.append(.cellType(type: .logoCell(image: UIImage(named: "coffee") ?? UIImage())))
        rows.append(.cellType(type: .loginWriteCell(emailPlaceHolder: "E-posta", passwordPlaceHolder: "Şifre")))
        self.collectionView.reloadData()
    }
}
