//
//  loginVC.swift
//  breakpoint
//
//  Created by Hope on 2/10/18.
//  Copyright © 2018 ARC. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    @IBOutlet weak var emailField: InsetTextField!
    @IBOutlet weak var passwordField: InsetTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.delegate = self
        passwordField.delegate = self
    }

    @IBAction func signInBtnPressed(_ sender: Any)  {
        if emailField.text != nil && passwordField.text != nil  {
            AuthService.instance.loginUser(withEmail: emailField.text!, andPassword: passwordField.text!, loginComplete: { (success, loginEror) in
                if success  {
                    self.dismiss(animated: true, completion: nil)
                }else   {
                    print(String(describing: loginEror?.localizedDescription))
                }
                
                AuthService.instance.registerUser(withEmail: self.emailField.text!, andPassword: self.passwordField.text!, userCreationComplete: { (success, registrationError) in
                    if success  {
                        AuthService.instance.loginUser(withEmail: self.emailField.text!, andPassword: self.passwordField.text!, loginComplete: { (success, nil) in
                            self.dismiss(animated: true, completion: nil)
                        })
                        print(String(describing: registrationError?.localizedDescription))
                    }
                })

            })
        }
        
    }
    
    @IBAction func closeBtnPressed(_ sender: Any)   {
        dismiss(animated: true, completion: nil)
    }
}

extension LoginVC: UITextFieldDelegate  {
    
    
}
