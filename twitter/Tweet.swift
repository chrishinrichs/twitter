//
//  Tweet.swift
//  twitter
//
//  Created by CHRISTOPHER HINRICHS on 9/25/14.
//  Copyright (c) 2014 CHRISTOPHER HINRICHS. All rights reserved.
//

import UIKit

let formatter: NSDateFormatter = NSDateFormatter()
let tweetUpdatedNotification = "tweetUpdated"

class Tweet: NSObject {
   
    var user: User!
    var text: String!
    var createdAtString: String!
    var createdAt: NSDate!
    var numFavorites: Int!
    var numRetweets: Int!
    var id: Int!
    var favorited: Bool!
    var retweeted: Bool!
    
    var relativeDate: String {
        get {
            var intervalSinceNow = Int(0 - createdAt.timeIntervalSinceNow)
            
            if intervalSinceNow < 60 {
                return "\(intervalSinceNow)s"
            } else if intervalSinceNow < 3600 {
                var minutes = intervalSinceNow/60
                return "\(minutes)m"
            } else if intervalSinceNow < 43200 {
                return "\(intervalSinceNow/3600)h"
            } else {
                var dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "MM/dd/YY"
                return dateFormatter.stringFromDate(createdAt)
            }
        }
    }
    
    init(dictionary: NSDictionary!) {
        if dictionary != nil {
            user = User(dictionary: dictionary["user"] as NSDictionary)
            text = dictionary["text"] as? String
            createdAtString = dictionary["created_at"] as? String
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            createdAt = formatter.dateFromString(createdAtString)
            numFavorites = dictionary["favorite_count"] as? Int
            numRetweets = dictionary["retweet_count"] as? Int
            id = dictionary["id"] as? Int
            favorited = (dictionary["favorited"] as? Int) != 0
            retweeted = (dictionary["retweeted"] as? Int) != 0
        }
    }
    
    func toggleFavorite() {
        if favorited == true {
            TwitterClient.sharedInstance.unfavoriteWithCompletion(self, completion: { (error) -> () in
                if error == nil {
                    self.favorited = false
                    self.numFavorites = self.numFavorites - 1
                    NSNotificationCenter.defaultCenter().postNotificationName(tweetUpdatedNotification, object: self)
                } else {
                    println("Failed to unfavorite")
                }
            })
        } else {
            TwitterClient.sharedInstance.favoriteWithCompletion(self) { (error) -> () in
                if error == nil {
                    self.favorited = true
                    self.numFavorites = self.numFavorites + 1
                    NSNotificationCenter.defaultCenter().postNotificationName(tweetUpdatedNotification, object: self)
                } else {
                    println("Failed to favorite")
                }
            }
        }
    }
    
    func toggleRetweet() {
        if retweeted == true {
            TwitterClient.sharedInstance.removeRetweetWithCompletion(self, completion: { (error) -> () in
                if error == nil {
                    self.retweeted = false
                    self.numRetweets = self.numRetweets - 1
                    NSNotificationCenter.defaultCenter().postNotificationName(tweetUpdatedNotification, object: self)
                } else {
                    println("Failed to remove retweet")
                }
            })
        } else {
            
            TwitterClient.sharedInstance.retweetWithCompletion(self) { (error) -> () in
                if error == nil {
                    self.retweeted = true
                    self.numRetweets = self.numRetweets + 1
                    NSNotificationCenter.defaultCenter().postNotificationName(tweetUpdatedNotification, object: self)
                } else {
                    println("Failed to retweet")
                }
            }
        }
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        
        return tweets
    }
    
}
