//
//  ViewController.swift
//  CF iOS DevEx Day 1
//
//  Created by Eric Mentele on 1/5/15.
//  Copyright (c) 2015 Eric Mentele. All rights reserved.
//


/*
Monday Homework

Create your MVC groups X
Create your Tweet class with an initializer that takes a Dictionary in as a parameterX
In addition to the text property, add a property to hold the username of the person who tweeted the tweetX
Drag the tweet.json file into your Xcode projectX
Parse the json file into tweet objectsX
In addition to text, pull out the username from the json for each tweet and use that property you added to hold it
Display those tweet objects in the table view
Create a custom table view cell class with your own custom label and image view

*/
import UIKit

class ViewController: UIViewController, UITableViewDataSource {
  
  //tableView Outlet
  @IBOutlet weak var tableView: UITableView!
  
  
  var tweets = [Tweet]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  self.tableView.dataSource = self

  //store the location of the json data to be used.
    if let jsonPath = NSBundle.mainBundle().pathForResource("tweet", ofType: "json") {
      
      //store the json data from the location.
      if let jsonData = NSData(contentsOfFile: jsonPath) {
        
      //create an error to handle the data failing to return.
        var error: NSError?
        
        //parse the json data into an array of objects.
        if let jsonArray = NSJSONSerialization.JSONObjectWithData(jsonData, options: nil, error: &error) as? [AnyObject] {
        
          //loop through json array and create an object with the data at each index.
          for object in jsonArray {
            
            //store json array objects in a dictionary.
            if let jsonDictionary = object as? [String : AnyObject] {
              
              //define dictionary to store json data in
              let tweet = Tweet(jsonDictionary)
              
              //add json dictionary to tweet dictionary of json dictionaries
              self.tweets.append(tweet)
            }
          }
        }
      }
    }
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return self.tweets.count
    
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCellWithIdentifier("tweetCell", forIndexPath: indexPath) as TweetCell
    
    let tweet = self.tweets[indexPath.row]
    
    cell.tweetText.text = tweet.text
    
    cell.nameLabel.text = tweet.userName
    
    return cell
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

