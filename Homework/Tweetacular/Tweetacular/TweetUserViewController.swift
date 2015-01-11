//
//  TweetUserViewController.swift
//  Tweetacular
//
//  Created by Eric Mentele on 1/8/15.
//  Copyright (c) 2015 Eric Mentele. All rights reserved.
//

import UIKit

class TweetUserViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

  @IBOutlet weak var tUTableView: UITableView!
  @IBOutlet weak var UserLocation: UILabel!
  @IBOutlet weak var UserImage: UIImageView!
  @IBOutlet weak var UserName: UILabel!
  @IBOutlet weak var UserBanner: UIImageView!
  
 
  var networkController = NetworkController()
  var tweets = [Tweet]()
  var userTweetID: String!
  var tweetUser: Tweet!
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    self.tUTableView.dataSource = self
    self.tUTableView.delegate = self
    self.tUTableView.registerNib(UINib(nibName: "Tweet_Cell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "tweetCell")
    self.tUTableView.estimatedRowHeight = 144
    self.tUTableView.rowHeight = UITableViewAutomaticDimension
    
    self.UserImage.image = tweetUser?.userImage
    self.UserLocation.text = tweetUser?.tweetUserLocation
    self.UserName.text = tweetUser?.userName
    
    //self.UserBanner.image = tweetUser?.userBannerImage
    //Use network controller to populate TweetUser tweets
    
    self.networkController.fetchUserTweetTL(self.userTweetID, completionHandler: { (tweets, error) -> () in
      if error == nil {
        
        self.tweets = tweets!
        self.tUTableView.reloadData()
        
      }//if
        
      else {
        
        //stores UIAlert controller to be used in case of failure to return tweet data
        let networkIssueAlert = UIAlertController(title: "Error", message: "Unable to load data. Connectivity error!", preferredStyle: .Alert)
        //adds a cancell button to dismiss alert
        let cancelButton = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        networkIssueAlert.addAction(cancelButton)
        //presents alert controller
        self.presentViewController(networkIssueAlert, animated: true, completion: nil)
      } //else
    }) //fetchUserTweetTL
    
    self.networkController.fetchUserBannerImage(self.tweetUser, completionHandler: { (bannerImage, error) -> () in
      if error == nil {
        
        println("fetchUserBannerImage did something")
        self.UserBanner.image = self.tweetUser.userBannerImage //add
        
      }
      else {
        
        self.UserBanner.image = self.tweetUser.userImage

      }
    })//fetchUserBannerImage
    
  } //viewDidLoad
  
  
 


  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return self.tweets.count
    
  }//tableViewNumberOfRows
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCellWithIdentifier("tweetCell", forIndexPath: indexPath) as TweetCell
    
    let tweet = self.tweets[indexPath.row]
    
    cell.tweetText.text = tweet.text
    
    cell.nameLabel.text = tweet.userName
    
    if tweet.userImage == nil {
      
      self.networkController.fetchUserTweetImage(tweet, completionHandler: { (image) -> () in
        
        //self.tUTableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        self.tUTableView.reloadData()
      })//fetchUserTweetImage
    }//iftweetimage
    else {
      cell.tweetImage.image = tweet.userImage
    }//else
    return cell
    
  }//TableViewCellForRow
  //recognize that cell has been selected
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    //instantiate the view controller you want to go to
    let tweetVC = self.storyboard?.instantiateViewControllerWithIdentifier("tweetVC") as TweetViewController
    
    var tweetToPass = self.tweets[indexPath.row]
    
    tweetVC.selectedTweet = tweetToPass
    tweetVC.networkController = self.networkController
  
    //push the veiw controller you want to go to onto the nav stack to go to it.
    self.navigationController?.pushViewController(tweetVC, animated: true)
  }//tableViewDidSelect
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }//Memory Warning
  
  
}
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


