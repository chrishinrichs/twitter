//
//  User.swift
//  twitter
//
//  Created by CHRISTOPHER HINRICHS on 9/25/14.
//  Copyright (c) 2014 CHRISTOPHER HINRICHS. All rights reserved.
//

import UIKit

var _currentUser: User?
let currentUserKey = "user_key"
let userDidLoginNotification = "UserLoggedIn"
let userDidLogoutNotification = "UserLoggedOut"

class User: NSObject {
    var name: String!
    var screenName: String!
    var profileImageURL: String!
    var tagline: String!
    var dictionary: NSDictionary!
    
    init(dictionary: NSDictionary) {
        name = dictionary["name"] as? String
        screenName = "@" + (dictionary["screen_name"] as? String)!
        profileImageURL = dictionary["profile_image_url"] as? String
        tagline = dictionary["description"] as? String
        self.dictionary = dictionary
    }
    
    func logout() {
        User.currentUser = nil
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
    }
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                var data = NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey) as? NSData
                if data != nil {
                    var dictionary = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil) as NSDictionary
                    _currentUser = User(dictionary: dictionary)
                }
            }
            return _currentUser
        }
        set(user) {
            _currentUser = user
            
            if _currentUser != nil {
                var data = NSJSONSerialization.dataWithJSONObject(user!.dictionary, options: nil, error: nil)
                NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentUserKey)
            } else {
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey)
            }
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
}
