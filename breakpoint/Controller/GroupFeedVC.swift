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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sendMessageView.bindToKeyboard()
    }

   
    @IBAction func sendBtnPressed(_ sender: Any) {
    }
    

    
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

}
