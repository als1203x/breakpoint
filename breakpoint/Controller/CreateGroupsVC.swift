//
//  CreateGroupsVC.swift
//  breakpoint
//
//  Created by Hope on 2/13/18.
//  Copyright © 2018 ARC. All rights reserved.
//

import UIKit

class CreateGroupsVC: UIViewController {

    @IBOutlet weak var titleTextField: InsetTextField!
    @IBOutlet weak var descriptionTextField: InsetTextField!
    @IBOutlet weak var emailSearchTextField: InsetTextField!
    @IBOutlet weak var groupMemberLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var doneBtn: UIButton!
    
    var emailArray = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailSearchTextField.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
            // add target -- allows to add target, slector action, for a event
        emailSearchTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
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
        cell.configureCell(profileImage: profileImg!, email: emailArray[indexPath.row], isSelected: true)
        
        return cell
    
    }
}


extension CreateGroupsVC: UITextFieldDelegate      {
    
    
}

