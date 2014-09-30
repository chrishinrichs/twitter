//
//  NewTweetViewController.swift
//  twitter
//
//  Created by CHRISTOPHER HINRICHS on 9/25/14.
//  Copyright (c) 2014 CHRISTOPHER HINRICHS. All rights reserved.
//

import UIKit

class NewTweetViewController: UIViewController {

    @IBOutlet weak var inputText: UITextView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    var originalTweet: Tweet!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        var user = User.currentUser!
        profileImage.setImageWithURL(NSURL(string: user.profileImageURL))
        nameLabel.text = user.name
        nicknameLabel.text = user.screenName
        inputText.becomeFirstResponder()
    }

    @IBAction func onSubmit(sender: UIBarButtonItem) {
        if inputText.hasText() {
            var tweet = Tweet(dictionary: nil)
            tweet.text = inputText.text
            TwitterClient.sharedInstance.tweetWithCompletion(tweet, originalTweet: originalTweet, completion: { (error) -> () in
                if error != nil {
                    println("Failed to save tweet")
                } else {
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancel(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
