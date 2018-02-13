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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }


    @IBAction func doneBtnPressed(_ sender: Any) {
    
    }
    
    
    @IBAction func closeBtnPressed(_ sender: Any) {
    
    }
}


extension CreateGroupsVC: UITableViewDelegate, UITableViewDataSource    {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "userCell") as? UserCell else { return UITableViewCell()}
   
        let profileImg = UIImage(named: "defaultProfileImage")
        cell.configureCell(profileImage: profileImg!, email: "gogo", isSelected: true)
        
        return cell
    
    }
}
