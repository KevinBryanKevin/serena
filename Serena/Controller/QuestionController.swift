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
import Parse

class QuestionController: UIViewController {
    
    @IBOutlet weak var option1: UIButton!
    @IBOutlet weak var option2: UIButton!
    @IBOutlet weak var option3: UIButton!
    @IBOutlet weak var option4: UIButton!
    
    // This is the tag of the "correct" button.
    var correctTag: Int?
    var correctItem: NewsItem?
    
    var options: [NewsItem]?
    var buttons: [UIButton]?
    
    @IBOutlet var buttonViews: [UIView]!
    
    // If this is true, we're coming back from an information
    // only screen.
    var shouldUpdate: Bool = true
    
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
                var subTitle = "Great job! You're a genious :)"
                if let currentScore = PFUser.current()?["score"] as? Int {
                    subTitle = "\(subTitle) Your score is now \(currentScore + 1)."
                }
                SCLAlertView().showSuccess("Correct!", subTitle: subTitle)
            
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "CorrectViewController") as! CorrectViewController
                
                self.shouldUpdate = true
                nextViewController.item = self.correctItem
                nextViewController.informationOnly = false
                 self.navigationController?.pushViewController(nextViewController, animated: true)
            } else {
                var subTitle = "Oops! That's not the trending answer."
                if let currentScore = PFUser.current()?["score"] as? Int {
                    subTitle = "\(subTitle) Your score is now \(currentScore - 1)."
                }
                SCLAlertView().showError("Incorrect", subTitle: subTitle)
                guard let user = PFUser.current() else { return }
                guard let currentScore = user["score"] as? Int else { return }
                user["score"] = currentScore - 1
                user.saveEventually()
            }
            
        }
    }
    @IBAction func infoButtonTapped(_ sender: UIButton) {
        if options == nil {
            return
        }
        let item = options![sender.tag]
        
        let storyBoard = self.storyboard!
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "CorrectViewController") as! CorrectViewController
        
        nextViewController.item = item
        nextViewController.informationOnly = true
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if (!shouldUpdate) {
            return
        }
        shouldUpdate = false
        
        buttons = [option1, option2, option3, option4]
        
        SVProgressHUD.show(withStatus: "Fetching...")
        NewsItem.fetchTrendingNews(callback: {(news: [NewsItem], errorMsg: String?) in
            let (item1, item2, item3, item4) = self.getChoices(originals: news)
            self.options = [item1, item2, item3, item4]
            
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
                
                for i in 0..<self.buttons!.count {
                    self.buttons![i].titleLabel?.numberOfLines = 1;
                   self.buttons![i].titleLabel?.adjustsFontSizeToFitWidth = true;
                    self.buttons![i].titleLabel?.lineBreakMode = .byClipping
                    self.buttons![i].setTitle(self.options![i].title, for: UIControlState.normal)
                }
            }
        })
        
        
        
        
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for view in buttonViews {
            view.layer.cornerRadius = 10
            view.layer.masksToBounds = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
