//
//  CorrectViewController.swift
//  Serena
//
//  Created by Luis Perez on 7/27/18.
//  Copyright © 2018 Luis Perez. All rights reserved.
//

import UIKit
import AFNetworking
import Parse

class CorrectViewController: UIViewController {

    var item: NewsItem!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var keywordLabel: UILabel!
    @IBOutlet weak var learnMoreButton: UIButton!
    @IBOutlet weak var newsImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.keywordLabel.text = item.title
        self.descriptionLabel.text = item.description
        if let url = item.pictureURL {
            self.newsImage.setImageWith(url)
        } else {
            self.newsImage.isHidden = true
        }
        

        // Do any additional setup after loading the view.
        if let _ = item.url {
            // this is not empty
        } else {
            learnMoreButton.isHidden = true
        }
        
        updateCurrentUser()
        
    }
    
    func updateCurrentUser() {
        let user = PFUser.current()!
        let currentScore = user["score"] as! Int
        user["score"] = currentScore + 1
        user.saveInBackground()
    }

    @IBAction func learnMoreTapped(_ sender: Any) {
        if let url: String = item.url {
            if let urlClass: URL = URL(string: url) {
                UIApplication.shared.open(urlClass, options: [:], completionHandler: nil)
            }
        }
        
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
