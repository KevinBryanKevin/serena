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
import Eureka
import SVProgressHUD

class RegistrationViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        form +++ Section("Login Credentials")
            <<< NameRow(){ row in
                row.title = "Username"
                row.tag = "username"
                row.placeholder = "KittensMittens123"
                row.add(rule: RuleRequired())
                row.add(rule: RuleMinLength(minLength: 4))
                row.add(rule: RuleMaxLength(maxLength: 20))
                row.validationOptions = .validatesOnDemand
            }
            <<< PasswordRow(){ row in
                row.title = "Password"
                row.tag = "password"
                row.placeholder = "*******"
                row.add(rule: RuleRequired())
                row.add(rule: RuleMinLength(minLength: 8))
                row.add(rule: RuleMaxLength(maxLength: 20))
                row.validationOptions = .validatesOnDemand
            }
            +++ Section("Profile Information")
            <<< EmailRow(){ row in
                row.title = "Email Address"
                row.tag = "email"
                row.placeholder = "AppleFan@email.com"
                row.add(rule: RuleEmail())
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesOnDemand
                
            animateScroll = true
            // Leaves 20pt of space between the keyboard and the highlighted row after scrolling to an off screen row
            rowKeyboardSpacing = 20
        }

        // Do any additional setup after loading the view.
    }

    @IBAction func onCancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func register(_ sender: UIBarButtonItem) {
        let errors = form.validate()
        if (errors.count > 0) {
            SCLAlertView().showInfo("Errors in Registration Form", subTitle: errors[0].msg)
            return
        }
        let usernameRow: NameRow? = form.rowBy(tag: "username")
        guard let requestedUsername = usernameRow?.value else {
            SCLAlertView().showError("No Username", subTitle: "Cannot register without a username!")
            return
        }
        let passwordRow: PasswordRow? = form.rowBy(tag: "password")
        guard let requestedPassword = passwordRow?.value else {
            SCLAlertView().showError("No Password", subTitle: "Cannot register without a password!")
            return
        }
        let emailRow: EmailRow? = form.rowBy(tag: "email")
        let requestedEmail = emailRow?.value ?? ""
        
        let user = PFUser()
        user.username = requestedUsername
        user.password = requestedPassword
        user.email = requestedEmail
        user["score"] = 0
        
        SVProgressHUD.show()
        user.signUpInBackground { (success: Bool, error: Error?) in
            SVProgressHUD.dismiss()
            if (success) {
                let lc = self.storyboard!.instantiateViewController(withIdentifier: "LoginController")
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
