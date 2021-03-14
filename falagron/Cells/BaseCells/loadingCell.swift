//
//  loadingCell.swift
//  falagron
//
//  Created by namik kaya on 6.03.2021.
//  Copyright © 2021 namik kaya. All rights reserved.
//

import UIKit

class loadingCell: UITableViewCell {

    @IBOutlet private weak var indicatorOB: UIActivityIndicatorView!
    override func awakeFromNib() {
        super.awakeFromNib()
        indicatorOB.startAnimating()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        indicatorOB.startAnimating()
    }
    
    deinit {
        indicatorOB.stopAnimating()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
