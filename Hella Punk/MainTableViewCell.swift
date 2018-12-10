//
//  MainTableViewCell.swift
//  Alamofire
//
//  Created by Justin Timko on 6/19/18.
//

import UIKit

class MainTableViewCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var mainSummary: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
