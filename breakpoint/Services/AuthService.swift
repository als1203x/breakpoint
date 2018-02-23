//
//  AuthService.swift
//  breakpoint
//
//  Created by Hope on 2/10/18.
//  Copyright © 2018 ARC. All rights reserved.
//

import Foundation
import Firebase
import GoogleSignIn
import FBSDKLoginKit

class AuthService {
    
    static let instance = AuthService()
    
    
    //need - email, password, and when registeation is done
    func registerUser(withEmail email: String, andPassword password: String, userCreationComplete: @escaping (_ status: Bool, _ error: Error?) -> ()) {
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            guard let user = user else  {
                userCreationComplete(false, error)
                return
            }
            
            //providers are fb,g+, email, etc]
            let userData = ["provider": user.providerID, "email":user.email]
            DataService.instance.createDBUser(uid: user.uid, userData: userData as Any as! Dictionary<String, Any>)
            userCreationComplete(true, nil)
        }
    }
   
    func loginUser(withEmail email: String, andPassword password: String, loginComplete: @escaping (_ status: Bool, _ error: Error?) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil  {
                loginComplete(false, error)
                return
            }
            loginComplete(true, nil)
        }
    }

    
    //Called after log in successful -- Google
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let err = error{
            print("Failed to log into Google", err)
            return
        }
        print("Successfully logged into Google", user)
        
        //For Auth in Firebase with Google User
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { (user, error) in
            if let err = error {
                //Failed to sign in
                print("Failed to create a Firebase User with Google account:", err)
                return
            }
                // User is signed in Firebase Auth
            print("Successful user creation in Friebase", user!.uid)
            
                //Input user in Database
            guard let user = user else  { return }
            
            let userData = ["provider": user.providerID, "email": user.email]
            DataService.instance.createDBUser(uid: user.uid, userData: userData as Any as! Dictionary<String, Any>)
        }
    }
    
    // Log into firebase and auth user using FB
    func fbAuth()  {
        //Log into Firebase with FB user
        guard let accessToken = FBSDKAccessToken.current().tokenString else { return }
        let credentials = FacebookAuthProvider.credential(withAccessToken: accessToken)
        
        Auth.auth().signIn(with: credentials) { (user, error) in
            if error != nil {
                print("Something went wrong with our FB user:", error ?? "")
                let loginManager = FBSDKLoginManager()
                loginManager.logOut()
                return
            }
            print("Successfully logged in with our user:", user ?? "" )
            
            //Input user in Database
            guard let user = user else  { return }
            
            let userData = ["provider": user.providerID, "email": user.email]
            DataService.instance.createDBUser(uid: user.uid, userData: userData as Any as! Dictionary<String, Any>)
        }
        
        showEmailAddress()
    }
    
    //// For retrieving user info of the Facebook User
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
    
}
