//
//  UserCell.swift
//  breakpoint
//
//  Created by Hope on 2/13/18.
//  Copyright © 2018 ARC. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var checkImg: UIImageView!
    
    var showing = false
    
    func configureCell(profileImage: UIImage, email: String, isSelected: Bool) {
        self.profileImg.image = profileImage
        self.emailLbl.text = email
        if isSelected {
            checkImg.isHidden = false
        }else   {
            checkImg.isHidden = true
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            if showing == false {
                checkImg.isHidden = false
                showing = true
            }else {
                checkImg.isHidden = true
                showing = false
            }
        }
    }

}
