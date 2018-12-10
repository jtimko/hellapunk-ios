//
//  FeaturedViewController.swift
//  Hella Punk
//
//  Created by Justin Timko on 6/12/18.
//  Copyright © 2018 adapt2. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher


class FeaturedViewController: UIViewController {
    
    @IBOutlet weak var featPic: UIImageView!
    @IBOutlet weak var featName: UILabel!
    @IBOutlet weak var featLoc: UILabel!
    @IBOutlet weak var featSummary: UITextView!
    
    override func viewDidLoad() {
        var arrRes = [[String:AnyObject]]()
        
        super.viewDidLoad()
        Alamofire.request("http://dev.jtimko.com/apps/featured.php").responseJSON { response in
            if response.result.value != nil {
                let strOutput = JSON(response.result.value ?? "nil")
                
                if let resObj = strOutput.arrayObject {
                    arrRes = resObj as! [[String:AnyObject]]
                }
            }
            //print(arrRes)
            
            let url = URL(string: arrRes[0]["feat_img"] as! String)
            self.featPic.kf.setImage(with: url)
            self.featName.text = arrRes[0]["feat_artist"] as? String
            self.featLoc.text = arrRes[0]["feat_location"] as? String
            self.featSummary.text = arrRes[0]["feat_summary"] as? String
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

