//
//  InsetTextField.swift
//  breakpoint
//
//  Created by Hope on 2/10/18.
//  Copyright © 2018 ARC. All rights reserved.
//

import UIKit

class InsetTextField: UITextField {

    
    override func awakeFromNib() {
        let placeholder = NSAttributedString(string: self.placeholder!, attributes: [NSAttributedStringKey.foregroundColor:#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)])
        self.attributedPlaceholder = placeholder
        super.awakeFromNib()
    }
    
    
    private var padding = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
    
       //Where text is held
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
       //Where editing text is held
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
           return UIEdgeInsetsInsetRect(bounds, padding)
    }
       //Where placeholder text is held
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
           return UIEdgeInsetsInsetRect(bounds, padding)
    }
}
