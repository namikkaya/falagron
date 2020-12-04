//
//  StretchyHeaderStickyFooterLayout.swift
//  falagron
//
//  Created by namik kaya on 19.10.2020.
//  Copyright © 2020 namik kaya. All rights reserved.
//

import UIKit


class StretchyHeaderStickyFooterLayout: UICollectionViewFlowLayout {
    var footerIsFound             : Bool = false
    var UICollectionAttributes    : [UICollectionViewLayoutAttributes]?
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttributes = super.layoutAttributesForElements(in: rect)
        
        layoutAttributes?.forEach({ (attributes) in
            if attributes.representedElementKind == UICollectionView.elementKindSectionHeader &&
                attributes.indexPath.section == 0 {
                
                guard let collectionView = collectionView else { return }

                let contentOffsetY = collectionView.contentOffset.y
                //print("contentOffSetY : \(contentOffsetY)")
                if (contentOffsetY > 0) {
                    return
                }
                
                let height = attributes.frame.height - contentOffsetY
                
                let width = collectionView.frame.width
                attributes.frame = CGRect(x: 0, y: contentOffsetY, width: width, height: height)
            }
            
            if attributes.representedElementKind == UICollectionView.elementKindSectionFooter{
                footerIsFound = true
                updateFooter(attributes: attributes)
            }
        })
        
        func updateFooter(attributes : UICollectionViewLayoutAttributes){
            let currentBounds = self.collectionView?.bounds
            attributes.zIndex = 1024
            attributes.isHidden = false
            let yOffset = currentBounds!.origin.y + currentBounds!.size.height - attributes.size.height/2.0
            attributes.center = CGPoint(x: currentBounds!.midX, y: yOffset)
        }
        /*
        if (!self.footerIsFound) {
            _ = self.layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, at : NSIndexPath(index: self.UICollectionAttributes!.count) as IndexPath)
        }*/
        
        return layoutAttributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
