//
//  QuestionController.swift
//  Serena
//
//  Created by Luis Perez on 7/21/18.
//  Copyright © 2018 Luis Perez. All rights reserved.
//

import UIKit
import SCLAlertView

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
        // let's do this randomly
        // let's look at the rank of the orignal and do something fancy
        // let's just return the first 4
        // let's add a joke one and return that sometimes
//<<<<<<< HEAD
        
        var mySet: Set = [0];
        mySet.removeFirst()
        while(mySet.count < 4){
            mySet.insert(Int(arc4random_uniform(20)))
        }
        
        print(mySet)
        var numbers = [0,0,0,0]
        var i = 0;
        for item in mySet{
            numbers[i] = item;
            i = i + 1;
        }
        print(numbers)
        return (originals[numbers[0]], originals[numbers[1]], originals[numbers[2]], originals[numbers[3]])
//=======
        /* write some code.
        return (originals[0], originals[1], originals[2], originals[3])
>>>>>>> a5f9d4676bfa83d8ce270aaedbef1cc812991d2d*/
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.title = "News Question"
        
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
            
            // We now know the max item.
            
            DispatchQueue.main.async {
                self.option1.setTitle(item1.title, for: UIControlState.normal)
                self.option2.setTitle(item2.title, for: UIControlState.normal)
                self.option3.setTitle(item3.title, for: UIControlState.normal)
                self.option4.setTitle(item4.title, for: UIControlState.normal)
            }
        })
        

        // Do any additional setup after loading the view.
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
