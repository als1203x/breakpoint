//
//  DataService.swift
//  breakpoint
//
//  Created by Hope on 2/10/18.
//  Copyright © 2018 ARC. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = Database.database().reference()

class DataService   {
    
    static let instance = DataService()
    
    //Private Var
        //ref for base database
    private var _REF_BASE = DB_BASE
        //child for users
    private var _REF_USERS = DB_BASE.child("users")
    
    private var _REF_GROUPS = DB_BASE.child("groups")
        //child for feed
    private var _REF_FEED = DB_BASE.child("feed")
    
    //Public Var - to access the private var
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    
    var REF_GROUPS: DatabaseReference   {
        return _REF_GROUPS
    }
    
    var REF_FEED:DatabaseReference  {
        return _REF_FEED
    }
    

    //MARK: - Push USERS
    func createDBUser(uid: String, userData: Dictionary<String, Any>)   {
        REF_USERS.child(uid).updateChildValues(userData)
    }
}