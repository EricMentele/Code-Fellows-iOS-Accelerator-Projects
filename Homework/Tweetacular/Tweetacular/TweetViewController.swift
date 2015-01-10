//
//  TweetViewController.swift
//  Tweetacular
//
//  Created by Eric Mentele on 1/7/15.
//  Copyright (c) 2015 Eric Mentele. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController {
  @IBOutlet weak var tweetLabel: UILabel!
  
  @IBOutlet weak var userImageButton: UIButton!

  @IBOutlet weak var favoritedLabel: UILabel!
  @IBOutlet weak var tweetTextLabel: UILabel!
  
  var selectedTweet : Tweet!
  var networkController : NetworkController!
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
    self.networkController.fetchTweetInfo(self.selectedTweet.tweetId, completionHandler: { (infoDictionary, errorString) -> () in
      if errorString == nil {
        
      self.selectedTweet.getTweetInfo(infoDictionary!)
//      self.selectedTweet.tweetFavoriteCount = infoDictionary!(
      }//if errorString nil
      println(self.selectedTweet.tweetFavoriteCount)
      self.favoritedLabel.text = self.selectedTweet.tweetFavoriteCount
    })//fetchTweetInfoCompletionHandler
    
      self.tweetLabel.text = self.selectedTweet!.userName
      self.tweetTextLabel.text = selectedTweet.text
      
      self.userImageButton.setBackgroundImage(selectedTweet.userImage, forState: UIControlState.Normal)
        // Do any additional setup after loading the view.
  
    }//viewdidload
  
  @IBAction func twitterUser(sender: AnyObject) {
    let tweetUserVC = self.storyboard?.instantiateViewControllerWithIdentifier("TweetUser") as TweetUserViewController
    var userTweetIDToPass = self.selectedTweet.tweetUserID
    var userTweetToPass = self.selectedTweet
    
    tweetUserVC.networkController = self.networkController
    tweetUserVC.userTweetID = userTweetIDToPass
    tweetUserVC.tweetUser = userTweetToPass
    
   
    self.navigationController?.pushViewController(tweetUserVC, animated: true)
    
  }//twitterUserButton
  

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }//override func
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
