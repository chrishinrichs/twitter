//
//  ViewController.swift
//  twitter
//
//  Created by CHRISTOPHER HINRICHS on 9/25/14.
//  Copyright (c) 2014 CHRISTOPHER HINRICHS. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func launchTwitterLogin(sender: UIButton) {
        TwitterClient.sharedInstance.loginWithBlock() {
            (user: User?, error: NSError?) -> Void in
            if (user != nil) {
                // Segue to home feed
                User.currentUser = user
                self.performSegueWithIdentifier("login", sender: self)
            } else {
                println("Login error")
            }
        }
        
    }

}

