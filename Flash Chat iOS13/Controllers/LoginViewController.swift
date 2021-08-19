//
//  LoginViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase
class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    

    @IBAction func loginPressed(_ sender: UIButton) {
        
        if let email = emailTextfield.text, let password = passwordTextfield.text{
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                if let e = error{
                    let alert = UIAlertController(title: "Error", message: e.localizedDescription, preferredStyle: .alert)
                    
                    let okayAction = UIAlertAction(title: "Okay", style: .default) { (action) in
                        print(action)
                    }
                    alert.addAction(okayAction)
                    self?.present(alert, animated: true, completion: nil)
                    }
                else{
                    self?.performSegue(withIdentifier: "LoginToChat", sender: self)
                }
              
            }
        }
    }
    
}
