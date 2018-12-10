//
//  NewsFullViewController.swift
//  Hella Punk
//
//  Created by Justin Timko on 6/21/18.
//  Copyright © 2018 adapt2. All rights reserved.
//

import UIKit

class NewsFullViewController: UIViewController {
    
    
    
    
    @IBOutlet weak var newsImg: UIImageView!
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var newsStory: UITextView!
    @IBAction func btnBack(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let url = URL(string: arrRes[myIndex]["news_img"] as! String)
        //newsImg.kf.setImage(with: url)
        newsTitle.text = arrRes[myIndex]["news_title"] as? String
        newsStory.text = arrRes[myIndex]["news_article"] as? String
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
