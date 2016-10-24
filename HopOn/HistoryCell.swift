//
//  HistoryCell.swift
//  HopOn
//
//  Created by Intern on 10/8/16.
//  Copyright © 2016 Intern. All rights reserved.
//

import UIKit

class HistoryCell: UITableViewCell {

    
    @IBOutlet weak var txtBooking_id: UILabel!
    @IBOutlet weak var txtBrand_model: UILabel!
    @IBOutlet weak var txtBooked_at: UILabel!
    @IBOutlet weak var txtBooked_add: UILabel!
    @IBOutlet weak var txtReturn_add: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        txtBrand_model.layer.cornerRadius = 3
        txtBrand_model.layer.borderWidth = 1
        txtBrand_model.layer.borderColor = UIColor.white.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
