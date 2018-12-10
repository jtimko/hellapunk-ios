//
//  BandTableViewCell.swift
//  Hella Punk
//
//  Created by Justin Timko on 6/16/18.
//  Copyright © 2018 adapt2. All rights reserved.
//

import UIKit

class BandTableViewCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var bandPic: UIImageView!
    @IBOutlet weak var bandSummary: UITextView!
    @IBOutlet weak var bandVenue: UILabel!
    @IBOutlet weak var bandDate: UILabel!
    @IBOutlet weak var bandSavedShow: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
