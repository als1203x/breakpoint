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
        //Convert UID into emails
    func getUsername(forUID uid: String, handler: @escaping (_ username: String) -> ()) {
          // Looks through one time,
        REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for user in userSnapshot    {
                if user.key == uid {
                    handler(user.childSnapshot(forPath: "email").value as! String)
                }
            }
        }
    }
        //Convert email into UID
    func getIds(forUsername usernames: [String], handler: @escaping (_ uidArray: [String]) -> ())  {
        REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
           var idArray = [String]()
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for user in userSnapshot {
                let email = user.childSnapshot(forPath: "email").value as! String
                
                if usernames.contains(email)    {
                    idArray.append(user.key)
                }
            }
            handler(idArray)
        }
    }
    
    func getEmailsFor(group: Group, handler: @escaping (_ emailArray: [String]) -> ())  {
        var emailArray = [String]()
        REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for user in userSnapshot    {
                if group.members.contains(user.key) {
                    let email = user.childSnapshot(forPath: "email").value as! String
                    emailArray.append(email)
                }
            }
            handler(emailArray)
        }
    }
    
    //MARK: - Create Group
    
    func createGroup(withTitle title: String, andDescription description: String, forUserIds ids: [String], handler: @escaping (_ groupCreated: Bool) -> ())    {
        REF_GROUPS.childByAutoId().updateChildValues(["title":title, "description": description, "memebers":ids])
        handler(true)
    }
    
    //MARK: - Get All Groups
    func getAllGroups(handler: @escaping (_ groupsArray: [Group]) -> ()) {
        var groupsArray = [Group]()
        REF_GROUPS.observeSingleEvent(of: .value) { (groupSnapshot) in
            guard let groupSnapshot = groupSnapshot.children.allObjects as? [DataSnapshot]  else { return }
            for group in groupSnapshot  {
                let memberArray = group.childSnapshot(forPath: "members").value as! [String]
                    //check to see current user is in group
                if memberArray.contains((Auth.auth().currentUser?.uid)!)    {
                    let title = group.childSnapshot(forPath: "title").value as! String
                    let description = group.childSnapshot(forPath: "description").value as! String
                    
                    let group = Group(title: title, description: description, key: group.key, members: memberArray, memberCount: memberArray.count)
                groupsArray.append(group)
                }
            }
            handler(groupsArray)
        }
    }
    
    func uploadPost(withMessage message: String, forUID uid: String, withGroupKey groupKey: String?, sendComplete: @escaping (_ status: Bool) -> ())   {
        if groupKey != nil  {
            //send to group refs
        }else   {
                //generates a uid for every message created
            REF_FEED.childByAutoId().updateChildValues(["content": message, "senderId": uid])
            sendComplete(true)
        }
    }
    
    func getAllFeedMessages(handler: @escaping (_ messages: [Message]) -> ())   {
        var messages = [Message]()
        REF_FEED.observeSingleEvent(of: .value) { (feedMessageSnapshot) in
            guard let feedMessageSnapshot = feedMessageSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for message in feedMessageSnapshot {
                let content = message.childSnapshot(forPath: "content").value as! String
                let senderId = message.childSnapshot(forPath: "senderId").value as! String
                let message = Message(content: content, senderId: senderId)
                messages.append(message)
            }
            handler(messages)
        }
    }
    
    //MARK: - Search through email, in realtime
    
    func getEmail(forSearchQuery query: String, handler: @escaping (_ emailArray: [String]) -> ())    {
        var emailArray = [String]()
        // value - any data changes at a location, or at any child node
        REF_USERS.observe(.value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for user in userSnapshot {
                let email = user.childSnapshot(forPath: "email").value as! String
                if email.contains(query) == true && email != Auth.auth().currentUser?.email {
                    emailArray.append(email)
                }
            }
            handler(emailArray)
        }
    }
}
