//
//  GroupCell.swift
//  breakpoint
//
//  Created by Hope on 2/15/18.
//  Copyright © 2018 ARC. All rights reserved.
//

import UIKit

class GroupCell: UITableViewCell {

    @IBOutlet weak var groupTitleLbl: UILabel!
    @IBOutlet weak var groupDescriptionLbl: UILabel!
    @IBOutlet weak var memeberLbl: UILabel!
    
    func configureCell(title: String, description: String, memeberCount: Int)   {
        self.groupTitleLbl.text = title
        self.groupDescriptionLbl.text = description
            self.memeberLbl.text = "\(memeberCount) memebers"
    }
    
}
