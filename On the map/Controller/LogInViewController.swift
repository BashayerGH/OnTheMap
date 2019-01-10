//
//  LogInViewController.swift
//  On the map
//
//  Created by Bashayer AlGhamdi on 28/04/1440 AH.
//  Copyright © 1440 Bashayer. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController {

    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var inform: UILabel!
    
    
    @IBAction func login(_ sender: Any) {
        
        API.postSession(username: emailTextField.text!, password: passwordTextField.text!) { (errString1) in
            guard errString1 == nil else {
                self.inform.text = errString1!
                return
            }
            DispatchQueue.main.async {
                 self.passwordTextField.text = ""
                self.performSegue(withIdentifier: "Login", sender: nil)
            }
        }
        
    }
    
    @IBAction func register(sender: UIButton) {
        if let url = NSURL(string: "https://www.udacity.com/account/auth#!/signup") {
            UIApplication.shared.openURL(url as URL)
        }
    }
    
    
}
