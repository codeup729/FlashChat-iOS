//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase
class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true

    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
    }
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        
        do {
          try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            let alert = UIAlertController(title: "Error", message: String(format: "Error signing out: %@", signOutError), preferredStyle: .alert)
            
            let okayAction = UIAlertAction(title: "Okay", style: .default) { (action) in
                print(action)
            }
            alert.addAction(okayAction)
            self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
