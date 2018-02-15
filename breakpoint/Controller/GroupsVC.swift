//
//  SecondViewController.swift
//  breakpoint
//
//  Created by Hope on 2/10/18.
//  Copyright © 2018 ARC. All rights reserved.
//

import UIKit

class GroupsVC: UIViewController {

    @IBOutlet weak var groupsTableView: UITableView!
    
    var groupsArray = [Group]()
    
    override func viewDidLoad() {
        groupsTableView.delegate = self
        groupsTableView.dataSource = self
        groupsTableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DataService.instance.REF_GROUPS.observe(.value) { (snapshot) in
            DataService.instance.getAllGroups   { (returnGroupsArray) in
                self.groupsArray = returnGroupsArray
                self.groupsTableView.reloadData()
            }
        }
    }
}


extension GroupsVC: UITableViewDelegate, UITableViewDataSource  {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = groupsTableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath) as? GroupCell   else { return UITableViewCell()}
        let group = groupsArray[indexPath.row]
        cell.configureCell(title: group.groupTitle, description: group.groupDesc, memeberCount: group.memberCount)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let groupFeedVC = storyboard?.instantiateViewController(withIdentifier: "GroupFeedVC") as? GroupFeedVC else { return }
        groupFeedVC.initData(forGroup: groupsArray[indexPath.row])
        present(groupFeedVC, animated: true, completion: nil)
    }
    
}



