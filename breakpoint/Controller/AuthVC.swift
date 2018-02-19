//
//  AuthVC.swift
//  breakpoint
//
//  Created by Hope on 2/10/18.
//  Copyright © 2018 ARC. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKLoginKit

class AuthVC: UIViewController, GIDSignInUIDelegate, FBSDKLoginButtonDelegate {
    

    override func viewDidLoad() {
        super.viewDidLoad()

        //Add Facebook Button
        let loginBtn = FBSDKLoginButton()
        view.addSubview(loginBtn)
        
        //modify frame or use contraints for button
        loginBtn.frame = CGRect(x: 16, y: 116, width: view.frame.width - 32, height: 75)
            //Button shows LogIn status
        loginBtn.delegate = self
            //
        loginBtn.readPermissions = ["email", "public_profile"]
/*
            //add custom fb login button
        let customFBButton = UIButton(type: .system)
        customFBButton.backgroundColor = .blue
        customFBButton.frame = CGRect(x: 16, y: 116, width: view.frame.width - 32, height: 75)
        customFBButton.setTitle("Custom FB Login here", for: .normal)
        customFBButton.setTitleColor(.white, for: .normal)
        customFBButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        customFBButton.addTarget(self, action: #selector(handleCustomFBLogin), for: .touchUpInside)
        view.addSubview(customFBButton)

 
        //Set up customButton
        let customButton = UIButton(type: .system)
        customButton.frame = CGRect(x: 16, y: 246, width: view.frame.width - 32, height: 50)
        customButton.backgroundColor = .orange
        customButton.setTitle("Custom Google Sign In", for: .normal)
        customButton.setTitleColor(.white, for: .normal)
        customButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        customButton.addTarget(self, action: #selector(handleCustomGoogleSign), for: .touchUpInside)
   */
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    
            //Protocol Methods For Facebook DEFAULT
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did log out of facebook")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print("Failed  here:", error)
            return
        } // else { print("Successful login with facebook.....")}
        
        showEmailAddress()
    }

    

    
    //Facebook Custom
    @objc func handleCustomFBLogin()  {
        //print(1234)
        
        FBSDKLoginManager().logIn(withPublishPermissions: ["email", "public_profile"], from: self) { (result, error) in
            if error != nil {
                print("Custom FB Login failed:", error!)
                return
            }
            self.showEmailAddress()
            //print(result!.token.tokenString)
        }
    }
    //// For retrieving user infor of the Facebook User
    
    func showEmailAddress() {
        //To retrieve information from the FacebookUser Name, Id, Email
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start(completionHandler: { (connection, result, err) in
            if err != nil  {
                print("Failed to start graph request:", err!)
                    return
            }
            print(result!)
        })
    }
    
    @objc func handleCustomGoogleSign() {
        GIDSignIn.sharedInstance().signIn()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil   {
            dismiss(animated: true, completion: nil)
        }
    }

    
    fileprivate func setUpGoogleButton(){
        
        
        //add Google SignIn Button
        let googleBtn = GIDSignInButton()
        googleBtn.frame = CGRect(x: 16, y: 246, width: view.frame.width - 32, height: 50)
        view.addSubview(googleBtn)
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
    }
    
    fileprivate func setupFacebookButton(){}
    
    
    @IBAction func signInWithEmailBtnPressed(_ sender: Any) {
        let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginVC")
        present(loginVC!, animated: true, completion: nil)
    }
    
    @IBAction func facebookSignInBtnPressed(_ sender: Any) {
    }
    
    @IBAction func googleSignInBtnPressed(_ sender: Any) {
        
    }


}
