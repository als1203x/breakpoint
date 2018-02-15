//
//  CreateGroupsVC.swift
//  breakpoint
//
//  Created by Hope on 2/13/18.
//  Copyright © 2018 ARC. All rights reserved.
//

import UIKit
import Firebase

class CreateGroupsVC: UIViewController {

    @IBOutlet weak var titleTextField: InsetTextField!
    @IBOutlet weak var descriptionTextField: InsetTextField!
    @IBOutlet weak var emailSearchTextField: InsetTextField!
    @IBOutlet weak var groupMemberLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var doneBtn: UIButton!
    
    var emailArray = [String]()
    var selectedUserArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailSearchTextField.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
            // add target -- allows to add target, slector action, for a event
        emailSearchTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        doneBtn.isHidden = true
    }
    
    
    @objc func textFieldDidChange() {
        if emailSearchTextField.text == "" {
            tableView.reloadData()
            emailArray = []
        }else   {
            DataService.instance.getEmail(forSearchQuery: emailSearchTextField.text!, handler: { (returnedEmailArray) in
                self.emailArray = returnedEmailArray
                self.tableView.reloadData()
            })
        }
    }

    @IBAction func doneBtnPressed(_ sender: Any) {
        if titleTextField.text != "" && descriptionTextField.text != "" {
            DataService.instance.getIds(forUsername: selectedUserArray, handler: { (idsArray ) in
                var userIds = idsArray
                userIds.append((Auth.auth().currentUser?.uid)!)
                
                DataService.instance.createGroup(withTitle: self.titleTextField.text!, andDescription: self.descriptionTextField.text!, forUserIds: userIds, handler: { (groupCreated) in
                    if groupCreated {
                        self.dismiss(animated: true, completion: nil)
                    }else   {
                        //UIAlert
                        print("Group could not be created. Please try again")
                    }
                })
            })
        }
    }
    
    
    @IBAction func closeBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}


extension CreateGroupsVC: UITableViewDelegate, UITableViewDataSource    {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emailArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "userCell") as? UserCell else { return UITableViewCell()}
        let profileImg = UIImage(named: "defaultProfileImage")
        
        if selectedUserArray.contains(emailArray[indexPath.row])    {
            cell.configureCell(profileImage: profileImg!, email: emailArray[indexPath.row], isSelected: true)
        }else   {
            cell.configureCell(profileImage: profileImg!, email: emailArray[indexPath.row], isSelected: false)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? UserCell else { return }
        if selectedUserArray.contains(cell.emailLbl.text!)  {
            // To remove from array, must filter to exclue removed element, returns
            selectedUserArray = selectedUserArray.filter({ $0 != cell.emailLbl.text!})
            if selectedUserArray.count >= 1     {
                groupMemberLbl.text = selectedUserArray.joined(separator: ", ")
                doneBtn.isHidden = false
            }else   {
                groupMemberLbl.text = "add people to your group"
                doneBtn.isHidden = true
            }
        }else   {
            selectedUserArray.append(cell.emailLbl.text!)
            groupMemberLbl.text = selectedUserArray.joined(separator: ", ")
            
        }
    }
    
}


extension CreateGroupsVC: UITextFieldDelegate      {
    
    
}

