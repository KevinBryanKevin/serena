//
//  LoginController.swift
//  Serena
//
//  Created by Luis Perez on 7/21/18.
//  Copyright © 2018 Luis Perez. All rights reserved.
//

import UIKit

class LoginController: UIViewController {

    @IBOutlet weak var logologin: UIImageView!
    @IBOutlet weak var usernameLogin: UITextField!
    @IBOutlet weak var passwordLogin: UITextField!
    
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
            
            let alert = UIAlertController(title: "Invalid", message: "Did not type anything", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil)
            return
        }
        guard let password = passwordLogin.text else {
            // Alert the user that they need a password
            return
        }
        if let user = checkLogin(username: username, password: password) {
            // in here, we validated the user
            // moving to the next screen
            print(user)
        }
        // alert the user that something went wrong
        
    }
    
    // Given a username and a password, this function should validate the username/password and return  a corresponding User
    // TODO(somebody): finish implementing
    private func checkLogin(username: String, password: String) -> User? {
        if username == "" || password == "" {
            return nil
        }
        return User(username: username, password: password)
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
