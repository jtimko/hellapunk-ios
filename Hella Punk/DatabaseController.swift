//
//  DatabaseController.swift
//  Hella Punk
//
//  Created by Justin Timko on 11/2/18.
//  Copyright © 2018 adapt2. All rights reserved.
//

import UIKit
import SQLite

let databaseFileName = "shows.db"
let databaseFilePath = "\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])/\(databaseFileName)"

class DatabaseController: UIViewController {
    
    let db              = try! Connection(databaseFilePath)
    let shows           = Table("shows")
    let id              = Expression<Int64>("id")
    let show_summary    = Expression<String?>("show_summary")
    let venue_name      = Expression<String>("venue_name")
    let show_date       = Expression<String>("show_date")
    let shows_img       = Expression<String?>("shows_img")
    let venue_address   = Expression<String>("venue_address")
    let city_name       = Expression<String>("city_name")
    var region_id       = Expression<Int>("region_id")
    let save_show       = Expression<Bool>("save_show")

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func createTable() -> Void {
        do {
            try self.db.run(shows.create(ifNotExists: true) { t in
                t.column(self.id, primaryKey: true)
                t.column(self.show_summary, unique: true)
                t.column(self.venue_name)
                t.column(self.venue_address)
                t.column(self.show_date)
                t.column(self.shows_img)
                t.column(self.city_name)
                t.column(self.region_id)
                t.column(self.save_show)
                
            })
        } catch {
            print("Error occured creating table: \(error)")
        }
    }
    
    func listAllShows(id: Int) -> [Row] {
        var results: Array<Row>? = nil
        if (id == 5) {
            results = Array(try! db.prepare(shows.filter(save_show == true)
                                                  .order(show_date.asc)))
        } else {
            results = Array(try! db.prepare(shows.filter(region_id == id)
                                                  .order(show_date.asc)))
        }
        return results!
    }
    
    func deleteOldShows() -> Void {
         _ = try! self.db.run("DELETE FROM shows WHERE show_date < (strftime('%Y-%m-%dT%H:%M:%S-7:00', 'NOW', 'localtime', '-6 hours'))")
        //print(result)
    }
    
    func addShowsToDatabase(arrRes: [[String:AnyObject]]) {
        for show in arrRes {
            let insert = self.shows.insert(self.show_summary <- show["show_summary"] as? String,
                                           self.venue_name <- (show["venue_name"] as? String)!,
                                           self.venue_address <- (show["venue_address"] as? String)!,
                                           self.show_date <- (show["show_date"] as? String)!,
                                           self.shows_img <- (show["shows_img"] as? String)!,
                                           self.city_name <- (show["city_name"] as? String)!,
                                           self.region_id <- ((show["city_region"]! as? NSString)?.integerValue)!,
                                           self.save_show <- false)
            do {
                try self.db.run(insert)
            } catch{
                //print("error \(error)")
            }
        }

    }
    
    func toogleSaveShows(summary: String, date: String, saved: Bool) -> Void {
        if (saved == false) {
           _ = try! self.db.run("UPDATE shows SET save_show = true WHERE show_summary LIKE \"%\(summary)%\" AND show_date LIKE \"%\(date)%\"")
        } else {
           _ = try! self.db.run("UPDATE shows SET save_show = false WHERE show_summary LIKE \"%\(summary)%\" AND show_date LIKE \"%\(date)%\"")
        }
    }

}
