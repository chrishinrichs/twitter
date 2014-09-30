//
//  TwitterClient.swift
//  twitter
//
//  Created by CHRISTOPHER HINRICHS on 9/27/14.
//  Copyright (c) 2014 CHRISTOPHER HINRICHS. All rights reserved.
//

import UIKit

let consumerKey = "XR77t6VRGCt6Iq3skNaVCiVE2"
let consumerSecret = "VnztpejhSCF4GlReRNs84vTm1MOkuAVVRwAdkj5RRleAtrS2qZ"
let baseUrl = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1RequestOperationManager {
    
    var loginCallback: ((user: User?, error: NSError?) -> ())?
    
    class var sharedInstance: TwitterClient {
        
        struct Static {
            static let instance = TwitterClient(baseURL: baseUrl, consumerKey: consumerKey, consumerSecret: consumerSecret)
        }
        
        return Static.instance
    }
    
    func loginWithBlock(completion: (user: User?, error: NSError?) -> ()) {
        
        loginCallback = completion
        
        // Fetch request token and redirect to authorization page
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        
        fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuthToken!) -> Void in
            
                var authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
                UIApplication.sharedApplication().openURL(authURL)
            
            }, failure: { (error: NSError!) -> Void in
                self.loginCallback!(user: nil, error: error)
            })
        
    }
    
    func homeTimelineWithCompletion(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        GET("1.1/statuses/home_timeline.json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            println("Timeline loaded successfully: \(response)")
            var tweets = Tweet.tweetsWithArray(response as [NSDictionary])
            completion(tweets: tweets, error: nil)
        }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            println("Failed to load the user timeline")
            completion(tweets: nil, error: error)
        })

    }
    
    func tweetWithCompletion(tweet: Tweet, originalTweet: Tweet!, completion: (error: NSError?) -> ()) {
        
        var dictionary = [String: String]()
        dictionary["status"] = tweet.text
        
        if originalTweet != nil {
            dictionary["in_reply_to_status_id"] = "\(originalTweet.id)"
            println("Replying to tweet")
        }
        
        POST("1.1/statuses/update.json", parameters: dictionary, constructingBodyWithBlock: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            completion(error: nil)
        }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            completion(error: error)
        }
        
    }
    
    func favoriteWithCompletion(tweet: Tweet, completion: (error: NSError?) -> ()) {
        
        var dictionary = [String: String]()
        dictionary["id"] = "\(tweet.id)"
        
        POST("1.1/favorites/create.json", parameters: dictionary, constructingBodyWithBlock: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            completion(error: nil)
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                completion(error: error)
        }
        
    }
    
    
    func unfavoriteWithCompletion(tweet: Tweet, completion: (error: NSError?) -> ()) {
        
        var dictionary = [String: String]()
        dictionary["id"] = "\(tweet.id)"
        
        POST("1.1/favorites/destroy.json", parameters: dictionary, constructingBodyWithBlock: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            completion(error: nil)
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                completion(error: error)
        }
        
    }
    
    
    func retweetWithCompletion(tweet: Tweet, completion: (error: NSError?) -> ()) {
        
        POST("1.1/statuses/retweet/\(tweet.id).json", parameters: nil, constructingBodyWithBlock: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            completion(error: nil)
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                completion(error: error)
        }
        
    }
    
    func removeRetweetWithCompletion(tweet: Tweet, completion: (error: NSError?) -> ()) {
        POST("1.1/statuses/destroy/\(tweet.id).json", parameters: nil, constructingBodyWithBlock: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            completion(error: nil)
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                completion(error: error)
        }
    }

    
    func openURL(url: NSURL) {
        
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuthToken(queryString: url.query), success: { (accessToken: BDBOAuthToken!) -> Void in
            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
            TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                var user = User(dictionary: response as NSDictionary)
                self.loginCallback!(user: user, error: nil)
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                self.loginCallback!(user: nil, error: error)
            })
            }) { (error: NSError!) -> Void in
                self.loginCallback!(user: nil, error: error)
        }
    }
    
}
