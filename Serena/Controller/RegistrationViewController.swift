//
//  RegistrationViewController.swift
//  Serena
//
//  Created by Luis Perez on 7/29/18.
//  Copyright © 2018 Luis Perez. All rights reserved.
//

import UIKit
import SCLAlertView
import Parse

class RegistrationViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func register(_ sender: UIButton) {
        guard let requestedUsername = username.text else {
            SCLAlertView().showError("No Username", subTitle: "Cannot register without a username!")
            return
        }
        guard let requestedPassword = password.text else {
            SCLAlertView().showError("No Password", subTitle: "Cannot register without a password!")
            return
        }
        guard let requestedEmail = email.text else {
            SCLAlertView().showError("No Email", subTitle: "Cannot register without an email!")
            return
        }
        
        let user = PFUser()
        user.username = requestedUsername
        user.password = requestedPassword
        user.email = requestedEmail
        user["score"] = 0
        
        user.signUpInBackground { (success: Bool, error: Error?) in
            if (success) {
                guard let lc = self.storyboard?.instantiateViewController(withIdentifier: "LoginController") else {
                    SCLAlertView().showError("Internal", subTitle: "Unable to obtain login controller!")
                    return
                }
                self.present(lc, animated: true, completion: nil)
                
            } else {
                if let errorMsg = error {
                    SCLAlertView().showError("Error signing up!", subTitle: errorMsg.localizedDescription)
                } else {
                    SCLAlertView().showError("Error signing up!", subTitle: "Unknown error.")
                }
                
            }
        }
    }
}
