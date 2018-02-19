//
//  GroupFeedVC.swift
//  breakpoint
//
//  Created by Hope on 2/15/18.
//  Copyright © 2018 ARC. All rights reserved.
//

import UIKit
import Firebase

class GroupFeedVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendMessageView: UIView!
    @IBOutlet weak var messageTxtField: InsetTextField!
    @IBOutlet weak var groupTitleLbl: UILabel!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var membersLbl: UILabel!
    
    var group: Group?
    var groupMessages = [Message]()
    
    func initData(forGroup group: Group)    {
        self.group = group
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sendMessageView.bindToKeyboard()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        groupTitleLbl.text = group?.groupTitle
        DataService.instance.getEmailsFor(group: group!) { (returnedEmails) in
            self.membersLbl.text = returnedEmails.joined(separator: ", ")
        }
        
        DataService.instance.REF_GROUPS.observe(.value) { (snapshot) in
            DataService.instance.getAllMessagesFor(desiredGroup: self.group!, handler: { (returnedGroupMessages) in
                self.groupMessages = returnedGroupMessages
                self.tableView.reloadData()
                
                if self.groupMessages.count > 0 {
                    self.tableView.scrollToRow(at: IndexPath(row: self.groupMessages.count - 1, section: 0), at: .none , animated: true)
                }
            })
        }
    }

   
    @IBAction func sendBtnPressed(_ sender: Any) {
        if messageTxtField.text != "" {
            messageTxtField.isEnabled = false
            sendBtn.isEnabled = false
            DataService.instance.uploadPost(withMessage: messageTxtField.text!, forUID: Auth.auth().currentUser!.uid, withGroupKey: group?.key, sendComplete: { (complete) in
                if complete {
                    self.messageTxtField.text = ""
                    self.messageTxtField.isEnabled = true
                    self.sendBtn.isEnabled = true
                }
            })
            
            }
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismissDetail()
    }
    

}


extension GroupFeedVC: UITableViewDelegate, UITableViewDataSource   {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "groupFeedCell") as? GroupFeedCell   else    { return UITableViewCell()}
        let message = groupMessages[indexPath.row]
        DataService.instance.getUsername(forUID: message.senderId) { (email) in
            cell.configureCell(profileImage: UIImage(named: "defaultProfileImage")!, email: email, content: message.content)
        }
        return cell
    }
    
}
