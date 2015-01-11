//
//  NetworkController.swift
//  Tweetacular
//
//  Created by Eric Mentele on 1/7/15.
//  Copyright (c) 2015 Eric Mentele. All rights reserved.
//
import Foundation
import Accounts
import Social

class NetworkController {
  //twitter account property to be used by methods
  var myTwitterAccount : ACAccount?
  //NS OperationQueue for loading images
  var imageQueue = NSOperationQueue()
    init() {
      //empty init to comply with optional property.
  }
////////////////////////////////////////////HOME TIMELINE///////////////////////////////////////////////////////
   func fetchHomeTimeline ( completionHandler : ([Tweet]?, String?) -> ()) {
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
          self.myTwitterAccount = twitterAccounts.first as? ACAccount
          //store URL to twitter api.
          let twitterURL = NSURL(string: "https://api.twitter.com/1.1/statuses/home_timeline.json")
          //set up request to twitter url.
          let twitterRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: twitterURL, parameters: nil)
          //designate account to send in request.
          twitterRequest.account = self.myTwitterAccount
          //perform asynchronous request with handler
          twitterRequest.performRequestWithHandler(){ (data, response, error) -> Void in
            //use switch for returned status codes
            switch response.statusCode {
            //status codes for success
            case 200...299: println("Go for launch!")
            //store json data returned from Twitter in array with NSJSONSerialization
            if let jsonArray = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? [AnyObject] {
              //println("HomeTimeline jsonArray \(jsonArray)")
              //create an empty Array of tweet objects
              var tweets = [Tweet]()
              //loop through array indeces to create an object for each
              for object in jsonArray {
                //cast object as dictionary
                if let jsonDictionary = object as? [String : AnyObject] {
                  //println("TweetHomeTimeline jsonDictionary \(jsonDictionary)")
                  //store jsonDictionary values in a tweet object
                  let tweet = Tweet(jsonDictionary)
                  //store tweet objects in tweets array
                  tweets.append(tweet)
                  //switch back to main thread
                  NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        //call completion handler for end of operation.
                        completionHandler(tweets,nil)
                  })//NSOperationQueue
                }//jsonDictionary
              }//for object
            }//jsonArray
            //return codes designating a problem.
            case 300...599:
              println("We got a problem!")
              completionHandler(nil, "We got a problem")
            default: println("response defaulted")
            }//switch
          }//Twitter request with handler
        }//if twitter .isEmpty
      }//if granted
    }//accountStoreRequestWithType
  }//fetchHomeTimeline
////////////////////////////////////////////////TWEET INFO///////////////////////////////////////////////////////
  //This function is used to get more information about a single tweet from the Home Timeline tweets. It does this by interpolating the tweet's id into the relatied Twitter api url.
  func fetchTweetInfo (tweetID: String? ,completionHandler : ([String: AnyObject]?, String?) -> ()) {
          let twitterInfoURL = NSURL(string: "https://api.twitter.com/1.1/statuses/show.json?id=\(tweetID!)")
          let twitterRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: twitterInfoURL, parameters: nil)
          twitterRequest.account = self.myTwitterAccount
          twitterRequest.performRequestWithHandler(){ (data, response, error) -> Void in
            if error == nil {
              switch response.statusCode {
              case 200...299: println("Go for launch again!")
              if let jsonDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? [String:AnyObject] {
                    //println("TweetInfo jsonDictionary \(jsonDictionary)")
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                      completionHandler(jsonDictionary,nil)
                    })//NSOperationQueue
                }//jsonDictionary
              case 300...599:
                println("We got a problem!: ")
                completionHandler(nil, "We got a problem")
              default: println("response defaulted")
              }//switch
            }//if error
          }//Twitter request with handler
        }//fetchTweetInfo
////////////////////////////////////////////////USER IMAGE///////////////////////////////////////////////////////
  func fetchUserTweetImage (tweet: Tweet, completionHandler: (UIImage?) -> ()) {
    if let imageURL = NSURL(string: tweet.userImageURL) {
      self.imageQueue.addOperationWithBlock({ () -> Void in
        if let imageData = NSData(contentsOfURL: imageURL) {
          tweet.userImage = UIImage(data: imageData)
          NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
            completionHandler(tweet.userImage)
          })
          //return tweet.image!
          //        cell.tweetImageView.image = tweet.image
        }//optional chained imageData
        
      })//imageQueue.addOperationWithBlock
    }//optional imageURL

  }//fetchUserTweetImage
///////////////////////////////////////FETCH BANNER IMAGE/////////////////////////////////////////////////
  func fetchUserBannerImage (tweet: Tweet, completionHandler: (bannerImage: UIImage?, String?) -> ()) {
    //design a new network request to the twitter api for the banner image .
    let RequestURL = NSURL(string: "https://api.twitter.com/1.1/users/profile_banner.json?user_id=\(tweet.tweetUserID)")
    let twitterRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: RequestURL, parameters: nil)
    twitterRequest.account = myTwitterAccount
    //execute the request.
    twitterRequest.performRequestWithHandler() { (data, response, error) -> Void in
      //make sure it worked
      if error == nil {
        //decide what to do based on the response status code
        switch response.statusCode {
        case 200...299: println("Banner is go for launch")
          //serialize returned json data for use
        if let jsonDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? [String: AnyObject] {
          if let bannerSize = jsonDictionary["sizes"] as? [String: AnyObject] {
            println("banner size!")
            if let bannerResolution = bannerSize["mobile_retina"] as? [String: AnyObject] {
              println("banner resolution")
              if let selectedBannerURL = bannerResolution["url"] as? String {
                println("selected banner url \(selectedBannerURL)")
                if let bannerNSURL = NSURL(string: selectedBannerURL) {
                  println("bannerNSURL\(bannerNSURL)")
                  if let bannerData = NSData(contentsOfURL: bannerNSURL) {
                    println("banner data \(bannerData)")
                    tweet.userBannerImage = UIImage(data: bannerData)
                    println("banner image set!")
                  }
                }
              }
            }
          }
          
          NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
            completionHandler(bannerImage: tweet.userBannerImage, nil)
          })//NSOperationQueue
          //println("User Banner json\(jsonDictionary)")
          }// optional jsonDictionary
        case 300...599: println("Problem getting the banner")
          //completionHandler (nil, "Problem getting the banner")
        default: println("defaulted")
        }//switch
      }//if error
    }//twitter request
  }//fetchUserBannerImage
  
///////////////////////////////////////////////////////////////////////////////////////////////////////
  
  func fetchUserTweetTL (userid: String, completionHandler: ([Tweet]?, String?) -> ()) {
    
    let userRequestURL = NSURL(string: "https://api.twitter.com/1.1/statuses/user_timeline.json?user_id=\(userid)")
    let twitterRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: userRequestURL!, parameters: nil)
    twitterRequest.account = self.myTwitterAccount
    twitterRequest.performRequestWithHandler(){ (data, response, error) -> Void in
      if error == nil {
        switch response.statusCode {
        case 200...299: println("Go for launch again!")
        if let jsonArray = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? [AnyObject] {
          //println("TweetUserTimeline jsonArray\(jsonArray)")
          var tweets = [Tweet]()
          for object in jsonArray {
            if let jsonDictionary = object as? [String : AnyObject] {
              //println("TweetUserTimeline  jsonDictionary \(jsonDictionary)")
              let tweet = Tweet(jsonDictionary)
              tweets.append(tweet)
            }//optionalJsonDicionary
          }//forinjsonArray
          NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
            completionHandler(tweets,nil)
          })//NSOperationQueue
          }//jsonArray
          //return codes designating a problem.
        case 300...599:
          println("We got a problem!!!!!!!: ")
          completionHandler(nil, "We got a problem")
        default: println("response defaulted")
        }//switch
      }//if error nil
    }//Twitter Request
  }//fetchUserTweetTL

}//Network Controller





