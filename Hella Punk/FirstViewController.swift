//
//  FirstViewController.swift
//  Hella Punk
//
//  Created by Justin Timko on 6/12/18.
//  Copyright © 2018 adapt2. All rights reserved.
//

import UIKit
import Alamofire
import Foundation
import SwiftyJSON
//import Kingfisher

var arrRes = [[String:AnyObject]]()
var myIndex: Int = 0

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBAction func unwindSegue(_ sender: UIStoryboardSegue) {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        Alamofire.request("http://dev.jtimko.com/apps/news.php").responseJSON { response in
            //print("Data \(response.result.value)")
            if response.result.value != nil {
                let strOutput = JSON(response.result.value ?? "nil")
                
                if let resObj = strOutput.arrayObject {
                    arrRes = resObj as! [[String:AnyObject]]
                }
                
                if arrRes.count > 0 {
                    self.tableView.reloadData()
                }
            }
        }

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrRes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainPage") as! MainTableViewCell
        var data = arrRes[indexPath.row]
        
        let url = URL(string: data["news_img"] as! String)
        
        cell.mainSummary?.delegate = self
        
        cell.mainImg.kf.setImage(with: url)
        cell.mainTitle?.text = data["news_title"] as? String
        cell.mainSummary?.text = data["news_summary"] as? String
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myIndex = indexPath.row
        performSegue(withIdentifier: "segue", sender: self)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n")
        {
            self.view.endEditing(true);
            return false;
        }
        return true
    }

}

