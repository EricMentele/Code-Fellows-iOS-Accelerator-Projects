//
//  ViewController.swift
//  Tweetacular
//
//  Created by Eric Mentele on 1/6/15.
//  Copyright (c) 2015 Eric Mentele. All rights reserved.
//

import UIKit
import Accounts
import Social

class ViewController: UIViewController, UITableViewDataSource {
  
  //tableView Outlet
  @IBOutlet weak var tableView: UITableView!
  
  
  var tweets = [Tweet]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    self.tableView.dataSource = self
    
    
    //set up ACAccountStore object
    let accountStore = ACAccountStore()
    
    //configure account for Twitter
    let twitterAccountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)

    //open gate to account with .requestAccessToAccountsWithType
    accountStore.requestAccessToAccountsWithType(twitterAccountType, options: nil) {( granted: Bool, error: NSError!) -> Void in
    //check for access granted status and set up code to be run if granted
      if granted {
    //store twitter accounts from ACAccounts.
        let twitterAccounts = accountStore.accountsWithAccountType(twitterAccountType)
    //check to make sure accounts exist(!empty).
        if  !twitterAccounts.isEmpty{
    //store one(first) account.
          let myTwitterAccount = twitterAccounts.first as ACAccount
    //store URL to twitter api.
          let twitterURL = NSURL(string: "https://api.twitter.com/1.1/statuses/home_timeline.json")
    //set up request to twitter url.
          let twitterRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: twitterURL, parameters: nil)
    //designate account to send in request.
          twitterRequest.account = myTwitterAccount
    //perform asynchronous request with handler
          twitterRequest.performRequestWithHandler(){ (data, response, error) -> Void in
    //use switch for returned status codes
            switch response.statusCode {
            case 200...299: println("Go for launch!")
            
    //store json data returned from Twitter in array with NSJSONSerialization
            if let jsonArray = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? [AnyObject] {
    //loop through array indeces to create an object for each
              for object in jsonArray {
    //cast object as dictionary
                if let jsonDictionary = object as? [String : AnyObject] {
    //store jsonDictionary values in a tweet object
                  let tweet = Tweet(jsonDictionary)
    //store tweet objects in tweets array
                  self.tweets.append(tweet)
                  println("Tweets:\(self.tweets)")
    //switch back to main thread
                  NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
    //load data into table view
                    self.tableView.reloadData()
                  })//NSoperationQueue
                }//jsonDictionary
              }//for object
            }//jsonArray
            case 300...599: println("We got a problem!")
            default: println("response defaulted")
            }//switch
          }//Twitter request with handler
        }//if twitter .isEmpty
      }//if granted
    }//accountStoreRequestWithType
    
    
    
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return self.tweets.count
    
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCellWithIdentifier("tweetCell", forIndexPath: indexPath) as TweetCell
    
    let tweet = self.tweets[indexPath.row]
    
    cell.tweetText.text = tweet.text
    
    cell.nameLabel.text = tweet.userName
    
    cell.tweetImage.image = tweet.userImage
    
    return cell
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
}