//
//  QuestionController.swift
//  Serena
//
//  Created by Luis Perez on 7/21/18.
//  Copyright © 2018 Luis Perez. All rights reserved.
//

import UIKit

class QuestionController: UIViewController {
    
    @IBOutlet weak var option1: UIButton!
    @IBOutlet weak var option2: UIButton!
    @IBOutlet weak var option3: UIButton!
    @IBOutlet weak var option4: UIButton!
    
    // I will return only the four elements that were chosen.
    func getChoices(originals: [NewsItem]) -> (NewsItem, NewsItem, NewsItem, NewsItem) {
        // let's do this randomly
        // let's look at the rank of the orignal and do something fancy
        // let's just return the first 4
        // let's add a joke one and return that sometimes
        return (originals[0], originals[1], originals[2], originals[3])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NewsItem.fetchTrendingNews(callback: {(news: [NewsItem], errorMsg: String?) in
            let (item1, item2, item3, item4) = self.getChoices(originals: news)
            
            DispatchQueue.main.async {
                self.option1.titleLabel?.text = item1.title
                self.option2.titleLabel?.text = item2.title
                self.option3.titleLabel?.text = item3.title
                self.option4.titleLabel?.text = item4.title
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
