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
        tableView.backgroundColor = UIColor(displayP3Red: 197.0/255.0, green: 246.0/255.0, blue: 243.0/255.0, alpha: 1.0)
        
        form +++ Section("Settings")
            <<< SegmentedRow<String>() { row in
                row.options = [Theme.Default.rawValue, Theme.Dark.rawValue, Theme.Graphical.rawValue]
                row.value = ThemeManager.currentTheme().rawValue
                }.onChange({ (row: SegmentedRow<String>) in
                    guard let value = row.value else { return }
                    if let selectedTheme = Theme(rawValue: value) {
                        ThemeManager.applyTheme(theme: selectedTheme)
                    }
                })
            +++ Section("Account")
            <<< LabelRow() { row in
                row.title = "Score"
                
                if let getScore = PFUser.current()?["score"] as? Int {
                    row.value = String(getScore)
                } else {
                    row.value = "Unknown"
                }
                row.tag = "score"
            }
            <<< LabelRow() { row in
                row.title = "Username"
                row.value = PFUser.current()!.username!
            }
            <<< LabelRow() { row in
                row.title = "Email"
                row.value = PFUser.current()!.email ?? ""
            }
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let labelRow: LabelRow = form.rowBy(tag: "score")!
        if let score = PFUser.current()?["score"] as? Int {
            labelRow.value = String(score)
        } else {
            labelRow.value = "Invalid"
        }
        labelRow.reload()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
