//
//  FullShowViewController.swift
//  Hella Punk
//
//  Created by Justin Timko on 10/21/18.
//  Copyright © 2018 adapt2. All rights reserved.
//

import UIKit
import SQLite

class FullShowViewController: UIViewController {

    @IBOutlet weak var showFlyer: UIImageView!
    @IBOutlet weak var showDesc: UITextView!
    @IBOutlet weak var showSummary: UILabel!
    @IBOutlet weak var showVenue: UILabel!
    @IBOutlet weak var showDate: UILabel!
    @IBAction func btnDirections(_ sender: Any) {
        print("http://maps.apple.com/maps?daddr=" + (try! regionResults[myIndex2].get(Expression<String>("venue_address"))))
        if let url = URL(string: "http://maps.apple.com/maps?daddr=" + (try! regionResults[myIndex2].get(Expression<String>("venue_address")))) {
            UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print(show.get(Expression<String>("show_date")))
        let dateString = try! regionResults[myIndex2].get(Expression<String>("show_date")) as String
        let dateData: Array<Any>
        var dateArray: Array<Any>
        dateArray = (dateString.components(separatedBy: "T"))
        dateData = ((dateArray[0] as! String).components(separatedBy: "-"))
        
        adjustUITextViewHeight(arg: showDesc)
        showDesc.text = try! regionResults[myIndex2].get(Expression<String>("show_summary"))
        showDate.text = ((dateData[1] as? String)!) + "-" + ((dateData[2] as? String)!) + "-" + ((dateData[0] as? String)!)
        showVenue.text = try! regionResults[myIndex2].get(Expression<String>("venue_name"))
    }
    

    func adjustUITextViewHeight(arg : UITextView) {
        //arg.translatesAutoresizingMaskIntoConstraints = true
        arg.sizeToFit()
        arg.isScrollEnabled = false
    }

}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
