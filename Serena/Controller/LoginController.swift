//
//  LoginController.swift
//  Serena
//
//  Created by Luis Perez on 7/21/18.
//  Copyright © 2018 Luis Perez. All rights reserved.
//

import UIKit
import Parse
import SCLAlertView

class LoginController: UIViewController {

    @IBOutlet weak var logologin: UIImageView!
    @IBOutlet weak var usernameLogin: UITextField!
    @IBOutlet weak var passwordLogin: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let currentUser = PFUser.current()
        if currentUser != nil {
            let nc = self.storyboard!.instantiateViewController(withIdentifier: "NavigationController")
            self.present(nc, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        // Check the login?
        guard let username = usernameLogin.text else {
            // What to do if they click button and type nothing
            // TODO(...): Alert the user that they need a username
            SCLAlertView().showError("", subTitle: "")
            
            
            return
        }
        guard let password = passwordLogin.text else {
            // Alert the user that they need a password
            SCLAlertView().showError("", subTitle: "")
            return
        }
        PFUser.logInWithUsername(inBackground: username, password: password) { (user: PFUser?, error: Error?) in
            if user != nil {
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "TabBarController")
                self.present(nextViewController, animated:true, completion:nil)
                return
            }
            if error != nil {
                SCLAlertView().showNotice("Unable to login", subTitle: error!.localizedDescription)
            }
            else {
                SCLAlertView().showNotice("Unable to login", subTitle: "Unknown Error")
            }
        }
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
