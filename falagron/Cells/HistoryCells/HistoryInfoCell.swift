//
//  HistoryInfoCell.swift
//  falagron
//
//  Created by namik kaya on 27.12.2020.
//  Copyright © 2020 namik kaya. All rights reserved.
//

import UIKit

class HistoryInfoCell: UITableViewCell {
    @IBOutlet private weak var bgView: UIView! {
        didSet {
            bgView.addDropShadow(cornerRadius: 8,
                                 shadowRadius: 4,
                                 shadowOpacity: 0.2,
                                 shadowColor: UIColor.black,
                                 shadowOffset: .zero)
        }
    }
    
    @IBOutlet private weak var idLabel: UILabel!
    @IBOutlet private weak var createDateLabel: UILabel!
    
    @IBOutlet private weak var seenContainer: UIView!
    @IBOutlet private weak var rightIconContainer: UIView!
    @IBOutlet private weak var seenImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup(falData:FalHistoryDataModel) {
        if let date = falData.created {
            createDateLabel.text = getDateToString(date: date.dateValue())
        }
        idLabel.text = falData.falId
        if let seen = falData.userViewedStatus, !seen {
            seenImageView.image = UIImage(named: "notification")
        }else {
            seenImageView.image = UIImage(named: "visibility")
        }
    }
    
}

extension HistoryInfoCell {
    func getDateToString(date:Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM YY HH:mm"
        return formatter.string(from: date)
    }
}
