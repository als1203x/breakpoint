//
//  UserFeedCell.swift
//  breakpoint
//
//  Created by Hope on 2/15/18.
//  Copyright © 2018 ARC. All rights reserved.
//

import UIKit

class UserFeedCell: UITableViewCell {
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var contentLbl: UILabel!
    
    
    func configureCell(profileImage: UIImage, email: String, content: String)   {
        self.profileImg.image = profileImage
        self.emailLbl.text = email
        self.contentLbl.text = content
    }
}
