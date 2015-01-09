//
//  ViewController.swift
//  Tweetacular
//
//  Created by Eric Mentele on 1/6/15.
//  Copyright (c) 2015 Eric Mentele. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  //tableView Outlet
  @IBOutlet weak var tableView: UITableView!
  let networkController = NetworkController()
  var tweets = [Tweet]()
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    self.tableView.dataSource = self
    self.tableView.delegate = self
    //Use network controller to populate view controller tweets
    self.networkController.fetchHomeTimeline { (tweets, errorString) -> () in
     
      if errorString == nil {
        
        self.tweets = tweets!
        self.tableView.reloadData()
        
      } else {
        
        //stores UIAlert controller to be used in case of failure to return tweet data
        let networkIssueAlert = UIAlertController(title: "Error", message: "Unable to load data. Connectivity error!", preferredStyle: .Alert)
        //adds a cancell button to dismiss alert
        let cancelButton = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        networkIssueAlert.addAction(cancelButton)
        //presents alert controller
        self.presentViewController(networkIssueAlert, animated: true, completion: nil)
      }
    
  }//fetchHomeTImeline
  }//viewDidLoad
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return self.tweets.count
    
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCellWithIdentifier("tweetCell", forIndexPath: indexPath) as TweetCell
    
    let tweet = self.tweets[indexPath.row]
    
    cell.tweetText.text = tweet.text
    
    cell.nameLabel.text = tweet.userName
    
    if tweet.userImage == nil {
      
      self.networkController.fetchUserTweetImage(tweet, completionHandler: { (image) -> () in
        
        self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
      })//fetchUserTweetImage
    }//iftweetimage
    else {
      cell.tweetImage.image = tweet.userImage
    }//else
    return cell
    
  }
  //recognize that cell has been selected
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    //instantiate the view controller you want to go to
    let tweetVC = self.storyboard?.instantiateViewControllerWithIdentifier("tweetVC") as TweetViewController
    
    var tweetToPass = self.tweets[indexPath.row]
    
    tweetVC.selectedTweet = tweetToPass
    tweetVC.networkController = self.networkController
    println(tweetToPass.tweetFavoriteCount)
    //push the veiw controller you want to go to onto the nav stack to go to it.
    self.navigationController?.pushViewController(tweetVC, animated: true)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
}