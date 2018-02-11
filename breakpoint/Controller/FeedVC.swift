//
//  FirstViewController.swift
//  breakpoint
//
//  Created by Hope on 2/10/18.
//  Copyright © 2018 ARC. All rights reserved.
//

import UIKit

class FeedVC: UIViewController {

    var messages = [Message]()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    tableView.delegate = self
        tableView.dataSource = self
    
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DataService.instance.getAllFeedMessages { (returnMessages) in
            self.messages = returnMessages
            self.tableView.reloadData()
        }
    }
    
}



extension FeedVC: UITableViewDelegate, UITableViewDataSource    {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell") as? FeedCell else { return UITableViewCell()}
        
        let image = UIImage(named: "defaultProfileImage")
        let message = messages[indexPath.row]
    
        cell.configureCell(profileImage: image, email: message.senderId, content: message.content)
        return cell
    }
    
    
    
}
