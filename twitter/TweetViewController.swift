//
//  TweetViewController.swift
//  twitter
//
//  Created by CHRISTOPHER HINRICHS on 9/25/14.
//  Copyright (c) 2014 CHRISTOPHER HINRICHS. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController {

    var tweet: Tweet!
    
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var numFavorites: UILabel!
    @IBOutlet weak var numRetweets: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateView()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateView", name: tweetUpdatedNotification, object: tweet)

    }
    
    func updateView() {
        tweetText.text = tweet.text
        nameLabel.text = tweet.user.name
        nicknameLabel.text = tweet.user.screenName
        if tweet.numFavorites == 1 {
            numFavorites.text = "1 Favorite"
        } else {
            numFavorites.text = "\(tweet.numFavorites) Favorites"
        }
        if tweet.numRetweets == 1 {
            numRetweets.text = "1 Retweet"
        } else {
            numRetweets.text = "\(tweet.numRetweets) Retweets"
        }
        profileImage.setImageWithURL(NSURL(string: tweet.user.profileImageURL))
        dateLabel.text = tweet.relativeDate
        var img: UIImage!
        if tweet.retweeted == true {
            img = UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("retweeted", ofType: "png")!)
        } else {
            img = UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("retweet", ofType: "png")!)
        }
        retweetButton.setImage(img, forState: nil)
        
        var img2: UIImage!
        if tweet.favorited == true {
            img2 = UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("starred", ofType: "png")!)
        } else {
            img2 = UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("unstarred", ofType: "png")!)
        }
        favoriteButton.setImage(img2, forState: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func toggleRetweet(sender: UIButton) {
        tweet.toggleRetweet()
    }

    @IBAction func toggleFavorite(sender: UIButton) {
        tweet.toggleFavorite()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ReplySegue" {
            var destNavController = segue.destinationViewController as UINavigationController
            var destination = destNavController.viewControllers[0] as NewTweetViewController
            destination.originalTweet = tweet
        }
    }

}
