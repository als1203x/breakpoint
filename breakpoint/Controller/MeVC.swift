//
//  MeVC.swift
//  breakpoint
//
//  Created by Hope on 2/10/18.
//  Copyright © 2018 ARC. All rights reserved.
//

import UIKit
import Firebase

class MeVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileImgBtn: UIButton!
    @IBOutlet weak var postSegments: UISegmentedControl!
    
    let imagePicker = UIImagePickerController()
    
    var feedMessages = [Message]()
    var groupMessages = [Message]()
 
    @IBOutlet weak var tableCellProfileImg: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.emailLbl.text = Auth.auth().currentUser?.email
        
        
        DataService.instance.getAllFeedMessages(handler: {(returnMessages) in
            for message in returnMessages   {
                if message.senderId == Auth.auth().currentUser?.uid {
                    self.feedMessages.append(message)
                    self.tableView.reloadData()
                }
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
    }

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        profileImgBtn.isEnabled = false
        if let userImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profileImage.image = userImage
            profileImgBtn.isEnabled = true
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
   
 
    @IBAction func signOutBtnPressed(_ sender: Any) {
        let logoutPopup = UIAlertController(title: "Logout?", message: "Are you sure you want to logout?", preferredStyle: .actionSheet)
        let logoutAction = UIAlertAction(title: "Logout", style: .destructive) { (buttonTapped) in
            do {
                try Auth.auth().signOut()
                let authVC = self.storyboard?.instantiateViewController(withIdentifier: "AuthVC") as? AuthVC
                self.present(authVC!, animated: true, completion: nil)
            }catch  {
                print("Log out ERROR: \(error)")
            }
        }
        logoutPopup.addAction(logoutAction)
        present(logoutPopup, animated: true, completion: nil)
    }
    
    @IBAction func profileImgBtnPressed(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func toggleSegmentControl(_ sender: UISegmentedControl) {
        clearArrays()
        if postSegments.selectedSegmentIndex == 0 {
            DataService.instance.getAllFeedMessages(handler: {(returnMessages) in
                for message in returnMessages   {
                    if message.senderId == Auth.auth().currentUser?.uid {
                        self.feedMessages.append(message)
                        self.tableView.reloadData()
                    }
                }
            })
        }else   {
            DataService.instance.getAllGroupMessagesFor(handler: { (returnedGroupMessages) in
                for message in returnedGroupMessages    {
                    if message.senderId == Auth.auth().currentUser!.uid {
                        self.groupMessages.append(message)
                        self.tableView.reloadData()
                    }
                }
            })
        }
    }

    func clearArrays()  {
        groupMessages = []
        feedMessages = []
    }
    
}

extension MeVC: UITableViewDelegate, UITableViewDataSource  {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //depends on the segment
        if postSegments.selectedSegmentIndex == 0 {
            return feedMessages.count
        }else {
            return groupMessages.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //depends on segment
        let image = UIImage(named: "defaultProfileImage")
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "userFeedCell") as? UserFeedCell else { return UITableViewCell() }
        
        if postSegments.selectedSegmentIndex == 0   {
            cell.configureCell(profileImage: image!, email: Auth.auth().currentUser!.email!, content: feedMessages[indexPath.row].content)
            return cell
        }else   {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "userFeedCell") as? UserFeedCell else { return UITableViewCell()}
            cell.configureCell(profileImage: image!, email: Auth.auth().currentUser!.email!, content: groupMessages[indexPath.row].content)
            return cell
        }
    }
}
