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
        logoCell(image:String),
        nameCell(name:String),
        lastNameCell(lastName:String),
        birthDayCell(date:String),
        relationshipStatusCell(type:String),
        genderCell(type:String),
        workingStatusCell(type:String)
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
            case .logoCell(let image):
                
                break
            default: break
            }
        default: break
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let type = rows[indexPath.section]
        
        return UICollectionViewCell()
    }
    
    
}

extension LoginViewController {
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
}
