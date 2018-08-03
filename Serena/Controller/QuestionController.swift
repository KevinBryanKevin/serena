//
//  QuestionController.swift
//  Serena
//
//  Created by Luis Perez on 7/21/18.
//  Copyright © 2018 Luis Perez. All rights reserved.
//

import UIKit
import SCLAlertView
import SVProgressHUD

class QuestionController: UIViewController {
    
    @IBOutlet weak var option1: UIButton!
    @IBOutlet weak var option2: UIButton!
    @IBOutlet weak var option3: UIButton!
    @IBOutlet weak var option4: UIButton!
    
    // This is the tag of the "correct" button.
    var correctTag: Int?
    var correctItem: NewsItem?
    
    // I will return only the four elements that were chosen.
    func getChoices(originals: [NewsItem]) -> (NewsItem, NewsItem, NewsItem, NewsItem) {
        
        var mySet: Set = [0];
        mySet.removeFirst()
        while(mySet.count < 4){
            mySet.insert(Int(arc4random_uniform(20)))
        }
        
        var numbers = [0,0,0,0]
        var i = 0;
        for item in mySet{
            numbers[i] = item;
            i = i + 1;
        }
        return (originals[numbers[0]], originals[numbers[1]], originals[numbers[2]], originals[numbers[3]])
    }
    
    @IBAction func sendCorrect(_ sender: Any) {
        let button = sender as! UIButton
        if let correct = self.correctTag {
            if button.tag == correct {
                SCLAlertView().showSuccess("Correct!", subTitle: "Great job! You're a genius :)")
            
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "CorrectViewController") as! CorrectViewController
                
                nextViewController.item = self.correctItem
                 self.navigationController?.pushViewController(nextViewController, animated: true)
            } else {
               SCLAlertView().showError("Incorrect", subTitle: "Oops! That's not the trending answer.")
            }
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        SVProgressHUD.show(withStatus: "Fetching...")
        NewsItem.fetchTrendingNews(callback: {(news: [NewsItem], errorMsg: String?) in
            let (item1, item2, item3, item4) = self.getChoices(originals: news)
            
            var maxItem: NewsItem = item1
            for (tag, item) in [item1, item2, item3, item4].enumerated() {
                if (item.rankint >= maxItem.rankint) {
                    maxItem = item
                    self.correctTag = tag
                    self.correctItem = item
                }
            }
    
            DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                self.option1.setTitle(item1.title, for: UIControlState.normal)
                self.option2.setTitle(item2.title, for: UIControlState.normal)
                self.option3.setTitle(item3.title, for: UIControlState.normal)
                self.option4.setTitle(item4.title, for: UIControlState.normal)
            }
        })
        
        
        
        
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
