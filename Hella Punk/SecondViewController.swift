//
//  SecondViewController.swift
//  Hella Punk
//
//  Created by Justin Timko on 6/12/18.
//  Copyright © 2018 adapt2. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON
import SQLite

var myIndex2: Int = 0
var arrRes2 = [[String:AnyObject]]()
var regionResults: [Row] = []
var cheapFix: Int = 1

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let cities: Array   = ["Bay Area", "North", "East", "South", "Saved Shows"]
    let db = DatabaseController()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cityPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        cityPicker.delegate = self
        cityPicker.dataSource = self
        
        self.tableView.autoresizingMask = UIView.AutoresizingMask.flexibleHeight;
        self.db.createTable()
        
        //////////////////////////////////////////////////////////////////
        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
        longPressGesture.minimumPressDuration = 1.0 // 1 second press
        longPressGesture.delegate = self as? UIGestureRecognizerDelegate
        self.tableView.addGestureRecognizer(longPressGesture)
        ////////////////////////////////////////////////////////////////
        
        
        /////////////////Make splash screen for this///////////////////////
        Alamofire.request("http://hellapunk.com/listallshows.php?id=2018").responseJSON { response in
            if (response.result.value != nil) {
                let strOutput = JSON(response.result.value ?? "nil")
                
                if let resObj = strOutput.arrayObject {
                    arrRes2 = resObj as! [[String:AnyObject]]
                    self.db.addShowsToDatabase(arrRes: arrRes2)
                }
            }
            
            self.db.deleteOldShows()
            self.grabData(id: 1)
            self.tableView.reloadData()
        }
        ////////////////////////////////////////////////////////////////////
    }
    
    func grabData(id: Int) -> Void {
        regionResults = self.db.listAllShows(id: id)
        self.tableView.reloadData()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cities.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return cities[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        cheapFix = row + 1
        grabData(id: row + 1)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if regionResults.isEmpty {
            return 1
        } else {
            return regionResults.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bandCustomCell") as! BandTableViewCell
        if regionResults.isEmpty {
            cell.bandPic.image = UIImage(named: "flyer.jpg")
            cell.bandSummary?.text = "No Shows Announced!"
            cell.bandVenue?.text = "None"
            cell.bandDate?.text = "None"
        } else {
            let show = regionResults[indexPath.row]
            //print(try! show.get(Expression<String>("show_summary")))
            
            let strDateFull = try! show.get(Expression<String>("show_date"))
            var strDate: Array = ((strDateFull as AnyObject).components(separatedBy: "T"))

            // Setting up the date
            var dateArr: Array = strDate[0].components(separatedBy: "-")
            let dateStr: String = "\(dateArr[1])-\(dateArr[2])-\(dateArr[0])"

            // Setting up the time
            var timeArr: Array = strDate[1].components(separatedBy: ":")
            var timeStr: Int? = Int(timeArr[0])

            // Changing military time to standard
            if timeStr! > 12 {
                timeStr = timeStr! - 12
            }
            let saved = try! show.get(Expression<Bool>("save_show"))
            
            if (saved == true) {
                cell.bandSavedShow.isHidden = false
            } else if (saved == false) {
                cell.bandSavedShow.isHidden = true
            }
            
            cell.bandSummary?.text = "\(try! show.get(Expression<String>("show_summary"))), \(timeStr!):\(timeArr[1])PM"
            cell.bandVenue?.text = "\(try! show.get(Expression<String>("venue_name"))), \n \(try! show.get(Expression<String>("city_name")))"
            /*if (show["shows_img"] as? String != "null") {
                let url = URL(string: show["shows_img"] as! String)
                cell.bandPic.kf.setImage(with: url)
            } else {*/
            cell.bandPic.image = UIImage(named: "flyer.jpg")
            //}
            cell.bandDate?.text = dateStr

            tableView.isScrollEnabled = true
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        myIndex2 = indexPath.row
        //performSegue(withIdentifier: "segue2", sender: self)
    }
    
    @objc func longPress(_ longPressGestureRecognizer: UILongPressGestureRecognizer) {
        if longPressGestureRecognizer.state == UIGestureRecognizer.State.began {
            let touchPoint = longPressGestureRecognizer.location(in: self.tableView)
    
            if let indexPath = self.tableView.indexPathForRow(at: touchPoint) {
                let cell = tableView.cellForRow(at: indexPath) as? BandTableViewCell;
                let show = regionResults[indexPath.row]
                let summary = try! show.get(Expression<String>("show_summary"))
                let date = try! show.get(Expression<String>("show_date"))
                let saved = try! show.get(Expression<Bool>("save_show"))
                
                if (cell?.bandSavedShow.isHidden == true) {
                    cell?.bandSavedShow.isHidden = false
                } else if (cell?.bandSavedShow.isHidden == false) {
                    cell?.bandSavedShow.isHidden = true
                }
                
                self.db.toogleSaveShows(summary: summary, date: date, saved: saved)
            }
        }
    }
}

