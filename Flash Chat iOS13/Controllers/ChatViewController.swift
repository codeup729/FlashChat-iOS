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
    
    var messages: [Message] = []
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        tableView.dataSource = self
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        loadMessages()
    }
    
    func loadMessages(){
        db.collection("messages")
            .order(by: K.FStore.dateField)
            .addSnapshotListener { (querySnapshot, error) in
            
            self.messages = []
            
            if let e = error{
                print("error receiving data")
            }
            else{
                if let snapshotDocuments = querySnapshot?.documents{
                    for doc in snapshotDocuments{
                        let data = doc.data() //dictionary
                        if let messageSender = data[K.FStore.senderField] as? String, let body = data[K.FStore.bodyField] as? String{
                            var newMessage = Message(sender: messageSender, body: body)
                            self.messages.append(newMessage)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData() //loadMessages() is not quick enough to update messages array before tableView loads up the cells hence we reload it.
                                let indexPath = IndexPath(row: self.messages.count-1, section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        if let messageBody = messageTextfield.text, let messageSender = Auth.auth().currentUser?.email{
            db.collection(K.FStore.collectionName).addDocument(data: [K.FStore.senderField: messageSender, K.FStore.bodyField: messageBody, K.FStore.dateField: Date().timeIntervalSince1970]){ //date added to sort the tableView cells in asc order of sending time.
                (error) in
                if let e = error{
                    let alert = UIAlertController(title: "Error", message: "Error updating", preferredStyle: .alert)
                    
                    let okayAction = UIAlertAction(title: "Okay", style: .default) { (action) in
                        print(action)
                    }
                    alert.addAction(okayAction)
                    self.present(alert, animated: true, completion: nil)
                }
                else{
                    print("Successfully updated")
                }
            }
        }
        messageTextfield.text = ""
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

extension ChatViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        
        
        if message.sender == Auth.auth().currentUser?.email{
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageBuble.backgroundColor = UIColor(named: K.BrandColors.purple)
            cell.label.textColor = UIColor(named: K.BrandColors.lightPurple)
        }
        else{
            cell.rightImageView.isHidden = true
            cell.leftImageView.isHidden = false
            cell.messageBuble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
            cell.label.textColor = UIColor(named: K.BrandColors.purple)
        }
        cell.label.text = message.body
        return cell
    }

}
    
