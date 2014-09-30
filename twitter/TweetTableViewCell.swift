//
//  TweetTableViewCell.swift
//  twitter
//
//  Created by CHRISTOPHER HINRICHS on 9/25/14.
//  Copyright (c) 2014 CHRISTOPHER HINRICHS. All rights reserved.
//

import UIKit

@objc protocol TweetReplyDelegate {
    func reply(tweet: Tweet) -> Void
}


class TweetTableViewCell: UITableViewCell {

    var cellTweet: Tweet!
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userTwitterHandle: UILabel!
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var delegate: TweetReplyDelegate!
    
    func loadFromTweet(tweet: Tweet) {
        cellTweet = tweet
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateContent", name: tweetUpdatedNotification, object: cellTweet)
        updateContent()
    }
    
    func updateContent() {
        let tweet = cellTweet
        userImage.setImageWithURL(NSURL(string: tweet.user.profileImageURL))
        userName.text = tweet.user.name
        userTwitterHandle.text = tweet.user.screenName
        tweetText.text = tweet.text
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
    
    @IBAction func reply(sender: UIButton) {
        if delegate != nil {
            delegate.reply(cellTweet)
        }
    }
    
    @IBAction func retweet(sender: UIButton) {
        cellTweet.toggleRetweet()
    }
    
    @IBAction func favorite(sender: UIButton) {
        cellTweet.toggleFavorite()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
