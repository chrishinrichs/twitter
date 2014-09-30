//
//  FeedViewController.swift
//  twitter
//
//  Created by CHRISTOPHER HINRICHS on 9/25/14.
//  Copyright (c) 2014 CHRISTOPHER HINRICHS. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TweetReplyDelegate {

    @IBOutlet weak var tableView: UITableView!
    var refreshControl: UIRefreshControl!
    
    var tweets: [Tweet] = [Tweet]()
    var originalTweet: Tweet!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // Add pull to refresh
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "loadTweets", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)

    }
    
    override func viewWillAppear(animated: Bool) {
        loadTweets()
    }
    
    func loadTweets() {
        // Load the user's twitter stream
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        TwitterClient.sharedInstance.homeTimelineWithCompletion(nil, completion: { (tweets, error) -> () in
            if error == nil {
                self.tweets = tweets!
            } else {
                self.tweets = [Tweet]()
            }
            self.tableView.reloadData()
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            self.refreshControl.endRefreshing()
        })
    }

    @IBAction func logout(sender: UIBarButtonItem) {
        User.currentUser?.logout()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as TweetTableViewCell
        var tweet = tweets[indexPath.row]
        cell.loadFromTweet(tweet)
        cell.delegate = self
        return cell
    }
    
    func reply(tweet: Tweet) {
        originalTweet = tweet
        performSegueWithIdentifier("NewTweetSegue", sender: self)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showTweet" {
            // Pass the tweet to the details page
            var destination = segue.destinationViewController as TweetViewController
            var indexPath = self.tableView.indexPathForSelectedRow()
            destination.tweet = self.tweets[indexPath!.row]
        } else if segue.identifier == "NewTweetSegue" {
            var destNavController = segue.destinationViewController as UINavigationController
            var destination2 = destNavController.viewControllers[0] as NewTweetViewController
            if originalTweet != nil {
                destination2.originalTweet = originalTweet
                originalTweet = nil
            }
        }
    }


}
