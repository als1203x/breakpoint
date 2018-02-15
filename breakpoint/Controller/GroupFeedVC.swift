//
//  GroupFeedVC.swift
//  breakpoint
//
//  Created by Hope on 2/15/18.
//  Copyright © 2018 ARC. All rights reserved.
//

import UIKit

class GroupFeedVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendMessageView: UIView!
    @IBOutlet weak var messageTxtField: InsetTextField!
    @IBOutlet weak var groupTitleLbl: UILabel!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var membersLbl: UILabel!
    
    var group: Group?
    
    func initData(forGroup group: Group)    {
        self.group = group
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sendMessageView.bindToKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        groupTitleLbl.text = group?.groupTitle
        DataService.instance.getEmailsFor(group: group!) { (returnedEmails) in
            self.membersLbl.text = returnedEmails.joined(separator: ", ")
        }
    }

   
    @IBAction func sendBtnPressed(_ sender: Any) {
    }
    

    
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

}
