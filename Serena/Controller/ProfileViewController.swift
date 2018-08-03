//
//  ProfileViewController.swift
//  Serena
//
//  Created by Luis Perez on 8/2/18.
//  Copyright © 2018 Luis Perez. All rights reserved.
//

import UIKit
import Eureka
import Parse
import SVProgressHUD
import SCLAlertView

class ProfileViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        form +++ Section("Account")
            <<< ButtonRow(){ row in
                row.title = "Log Out"
                row.onCellSelection({ (cell: ButtonCellOf<String>, button: ButtonRow) in
                    // Erase everything!
                    SVProgressHUD.show(withStatus: "Logging out...")
                    PFUser.logOutInBackground(block: { (error: Error?) in
                        if let errorMsg = error {
                            SVProgressHUD.dismiss();
                            SCLAlertView().showWait("Logout Failure", subTitle: errorMsg.localizedDescription)
                            return
                        }
                        // Try to delete local storage.
                        PFObject.unpinAllObjectsInBackground(block:
                            { (success: Bool, error: Error?) in
                                if (success) {
                                    let lc = self.storyboard!.instantiateViewController(withIdentifier: "LoginController")
                                    return self.present(lc, animated: true, completion: nil)
                                }
                                if let errorMsg = error {
                                    SCLAlertView().showWait("Logout Failure", subTitle: errorMsg.localizedDescription)
                                    return
                                } else {
                                    SCLAlertView().showError("Logout Failure", subTitle: "Unable to clear local cache.")
                                    return
                                }
                        })
                    })
                })
                
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
