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
import SVProgressHUD

class LoginController: UIViewController {

    @IBOutlet weak var logologin: UIImageView!
    @IBOutlet weak var usernameLogin: UITextField!
    @IBOutlet weak var passwordLogin: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let currentUser = PFUser.current()
        if currentUser != nil {
            SVProgressHUD.show(withStatus: "Loading...")
            currentUser?.pinInBackground(block: { (success: Bool, error: Error?) in
                SVProgressHUD.dismiss()
                if (success) {
                    let nc = self.storyboard!.instantiateViewController(withIdentifier: "TabBarController")
                    return self.present(nc, animated: true, completion: nil)
                }
                if let errorMsg = error {
                    SCLAlertView().showInfo("Restoration Failed.", subTitle: errorMsg.localizedDescription)
                    return
                } else {
                    SCLAlertView().showWarning("Restoration Failed.", subTitle: "Unknown Error");
                }
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Listen for when the keyboard pops up.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        guard let keyboardSize: CGRect = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        guard let offset: CGRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        if keyboardSize.height == offset.height {
            if self.view.frame.origin.y == 0 {
                UIView.animate(withDuration: 0.1, animations: { () -> Void in
                    self.view.frame.origin.y -= keyboardSize.height
                })
            }
        } else {
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                self.view.frame.origin.y += keyboardSize.height - offset.height
            })
        }
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y += keyboardSize.height
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Remove listeners.
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: self.view.window)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: self.view.window)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        // Check the login?
        guard let username = usernameLogin.text else {
            SCLAlertView().showError("Missing Field", subTitle: "Username is required!")
            
            
            return
        }
        guard let password = passwordLogin.text else {
            // Alert the user that they need a password
            SCLAlertView().showError("Missing Field", subTitle: "Password is required!")
            return
        }
        SVProgressHUD.show(withStatus: "Logging in...")
        PFUser.logInWithUsername(inBackground: username, password: password) { (user: PFUser?, error: Error?) in
            SVProgressHUD.dismiss()
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
                return
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
