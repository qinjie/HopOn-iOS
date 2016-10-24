//
//  StationCell.swift
//  HopOn
//
//  Created by Intern on 15/8/16.
//  Copyright © 2016 Intern. All rights reserved.
//

import UIKit

class StationCell: UITableViewCell {

    @IBOutlet weak var txtName: UILabel!
    @IBOutlet weak var txtAvailable: UILabel!
    @IBOutlet weak var txtTotal: UILabel!
    @IBOutlet weak var txtAddress: UILabel!
    @IBOutlet weak var txtDistance: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        txtDistance.layer.cornerRadius = 3
        txtDistance.layer.borderWidth = 1
        txtDistance.layer.borderColor = UIColor.white.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
