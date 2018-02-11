//
//  CreatePostVC.swift
//  breakpoint
//
//  Created by Hope on 2/10/18.
//  Copyright © 2018 ARC. All rights reserved.
//

import UIKit
import Firebase

class CreatePostVC: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var emailLbl: UILabel!
    
    @IBOutlet weak var postView: UITextView!
    @IBOutlet weak var sendBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        postView.delegate = self
        // Do any additional setup after loading the view.
    }


    @IBAction func sendBtnPressed(_ sender: Any) {
        if postView.text != nil && postView.text != "Say something crazy" {
            sendBtn.isEnabled = false
            DataService.instance.uploadPost(withMessage: postView.text!, forUID: (Auth.auth().currentUser?.uid)!, withGroupKey: nil, sendComplete: { (isComplete) in
                if isComplete   {
                    self.sendBtn.isEnabled = true
                    self.dismiss(animated: true, completion: nil)
                }else   {
                    self.sendBtn.isEnabled = true
                    
                }
            })
        }
    }
    
    @IBAction func closeBtnPressed(_ sender: Any) {
    }
    
}

extension CreatePostVC: UITextViewDelegate  {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
    }
}

