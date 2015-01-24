//
//  GitComController.swift
//  Git It!
//
//  Created by Eric Mentele on 1/19/15.
//  Copyright (c) 2015 Eric Mentele. All rights reserved.
//

import UIKit

class GitCom {
  
  
  class var sharedGitCom : GitCom {
    struct Static {
      static let instance: GitCom = GitCom()
    }//struct
    return Static.instance
  }//singleton class
  
  var urlSession : NSURLSession
  let client_id = "d8b22940ac5a324187c4"
  let client_secret = "466fc36ccf89a7a06363bbb6321dcbb21fe72ff1"
  let accessToken : String?
  let userDefaultsTokenKey = "AccessToken"
  let imageQueue = NSOperationQueue()
  
  
  init() {
    
    let ephemeralConfig = NSURLSessionConfiguration.ephemeralSessionConfiguration()
    self.urlSession = NSURLSession(configuration: ephemeralConfig)
    
    if let accessToken = NSUserDefaults.standardUserDefaults().objectForKey(self.userDefaultsTokenKey) as? String {
      
      self.accessToken = accessToken
      //println(accessToken)
    }
  }//init
  
  
  //called in app delegate to use UIapplication to get access token code"temp access token"
  func fetchAccessTokenCode () {
    
    let url = "https://github.com/login/oauth/authorize?client_id=\(self.client_id)&scope=user,repo"
    UIApplication.sharedApplication().openURL(NSURL(string: url)!)
    
    
  }//FetchAccessTokenCode
  
  
  func handleAccessTokenCode (url: NSURL) {
    
    let code = url.query
    let requestURL = NSURL(string: "https://github.com/login/oauth/access_token?\(code!)&client_id=\(self.client_id)&client_secret=\(self.client_secret)")
    let postRequest = NSMutableURLRequest(URL: requestURL!)
    postRequest.HTTPMethod = "POST"
    
    ///////Second Method/////////
    //    let bodyString = "\(code!)&client_id\(self.client_id)&client_secret\(self.client_secret)"
    //    let bodyData = bodyString.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)
    //    let length = bodyData!.length
    //    let postRequest = NSMutableURLRequest(URL: NSURL(string: "https://github.com/login/oauth/access_token")!)
    //    postRequest.HTTPMethod = "POST"
    //    postRequest.setValue("\(length)", forHTTPHeaderField: "Content-Length")
    //    postRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    //    postRequest.HTTPBody = bodyData
    //////////////////////////////
    let dataTask = self.urlSession.dataTaskWithRequest(postRequest, completionHandler: { (data, response, error) -> Void in
      
      if error == nil {
        
        if let gitResponse = response as? NSHTTPURLResponse {
          
          switch gitResponse.statusCode {
            
          case 200...299:
            println("Token 200s response")
            let tokenResponse = NSString(data: data, encoding: NSASCIIStringEncoding)
            //println(tokenResponse)
            let accessTokenComponent = tokenResponse?.componentsSeparatedByString("&").first as String
            let accessToken = accessTokenComponent.componentsSeparatedByString("=").last
            
            NSUserDefaults.standardUserDefaults().setObject(accessToken!, forKey: self.userDefaultsTokenKey)
            NSUserDefaults.standardUserDefaults().synchronize()
            
          case 300...599:
            println("300 to 599 response")
          default: "what, what?"
          }//switch
        }//gitResponse
      }//if error
    })//dataTask
    dataTask.resume()
  }//handleAccessTokenCode
  
  
  func fetchReposForSearchTerm(searchTerm: String, callback: ([Repo]?, String?) -> ()) {
    
    let url = NSURL(string: "https://api.github.com/search/repositories?q=\(searchTerm)")
    let request = NSMutableURLRequest(URL: url!)
    request.setValue("token \(self.accessToken!)", forHTTPHeaderField: "Authorization")
    
    let dataTask = self.urlSession.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
      
      if error == nil {
        
        let response = response as NSHTTPURLResponse
        switch response.statusCode {
          
        case 200...299:
          println("Go for launch!!!")
        
        if let jsonDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? [String : AnyObject] {
          
          //println(jsonDictionary)
          if let itemsArray = jsonDictionary["items"] as? [[String : AnyObject]] {
            
            var repos = [Repo]()
            
            for item in itemsArray {
              
              let repo = Repo(item)
              repos.append(repo)
            }//for item
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
              
              callback(repos,nil)
            })//main queue
          }//items array
          
          //println(jsonDictionary)
          }//jsonDictionary
        case 300...599:
          
          println("FAIL")
          callback(nil,"FAIL")
        default: "what what?"
        }//switch
      }//if error
    })//dataTask
    dataTask.resume()
  }//fetchRepos
  
  
  func fetchUsersForSearchTerm(searchTerm: String, callback: ([User]?, String?) -> (Void)) {
    
    let url = NSURL(string: "https://api.github.com/search/users?q=\(searchTerm)")
    let request = NSMutableURLRequest(URL: url!)
    request.setValue("token \(self.accessToken!)", forHTTPHeaderField: "Authorization")
    
    let dataTask = self.urlSession.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
      
      if error == nil {
        
        let response = response as NSHTTPURLResponse
        
        switch response.statusCode {
          
        case 200...299: println("We are the users!")
        
          if let jsonDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? [String : AnyObject] {
            println(jsonDictionary.count)
            let results = jsonDictionary["total_count"] as? Int
            //println(Int(results!))
    
            
            
            if let itemsArray = jsonDictionary["items"] as? [[String : AnyObject]] {
              
              var users = [User]()
              
              for item in itemsArray {
                
                let user = User(item, Int(results!))
                users.append(user)
              }
              
              NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                
                callback(users, nil)
              })
            }
          }
          
        default: println("LAME SAUCE!")
        }
      }//if error
    })//data task
    dataTask.resume()
  }//fetchUsers
  
  func fetchUserImage(url: String, completionHandler: (UIImage) -> ()) {
    
    let url = NSURL(string: url)
    
    self.imageQueue.addOperationWithBlock { () -> Void in
      
      let imageData = NSData(contentsOfURL: url!)
      let image = UIImage(data: imageData!)
    
    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
      completionHandler(image!)
    })
    }//imageQueue
  }//fetchUserImage
} //GitCom



