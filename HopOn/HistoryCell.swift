//
//  HistoryCell.swift
//  HopOn
//
//  Created by Intern on 10/8/16.
//  Copyright © 2016 Intern. All rights reserved.
//

import UIKit

class HistoryCell: UITableViewCell {

    @IBOutlet weak var txtBooked_at: UILabel!
    @IBOutlet weak var txtBooked_add: UILabel!
    @IBOutlet weak var txtReturn_add: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        //super.setSelected(selected, animated: animated)
    }

}
