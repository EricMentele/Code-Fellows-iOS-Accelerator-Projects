//
//  GitComController.swift
//  Git It!
//
//  Created by Eric Mentele on 1/19/15.
//  Copyright (c) 2015 Eric Mentele. All rights reserved.
//

import Foundation

class GitCom {
  
  var urlSession : NSURLSession
  
  
  init() {
    
    let ephemeralConfig = NSURLSessionConfiguration.ephemeralSessionConfiguration()
    
    self.urlSession = NSURLSession(configuration: ephemeralConfig)
  }//init
  
  
  func fetchReposForSearchTerm(searchTerm: String, callback: ([Repo]?, String?) -> ()) {
    
    let url = NSURL(string: "http://127.0.0.1:3000")
    
    let dataTask = self.urlSession.dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
      
      if error == nil {
        
        let response = response as NSHTTPURLResponse
        switch response.statusCode {
          
        case 200...299: println("Go for launch!!!")
        if let jsonDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? [String : AnyObject] {
          //println(jsonDictionary)
          if let items = jsonDictionary["items"] as? [AnyObject] {
            var repos = [Repo]()
            for object in items {
              if let repoItem = object as? [String : AnyObject] {
                let repo = Repo(repoItem)
                repos.append(repo)
                //println(repos)
                NSOperationQueue.mainQueue().addOperationWithBlock( { () -> Void in
                  
                  callback(repos, nil)
                })//NSOperationQueue
              }//repoItem
            }//for
          }//items
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
} //GitCom