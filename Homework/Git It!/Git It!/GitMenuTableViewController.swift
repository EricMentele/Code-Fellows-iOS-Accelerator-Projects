//
//  GitMenuTableViewController.swift
//  Git It!
//
//  Created by Eric Mentele on 1/19/15.
//  Copyright (c) 2015 Eric Mentele. All rights reserved.
//

import UIKit

class GitMenuTableViewController: UITableViewController {
  
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
  }//view did load
  
  
  override func viewDidAppear(animated: Bool) {
    
    super.viewDidAppear(animated)
    
    if GitCom.sharedGitCom.accessToken == nil {
      
        GitCom.sharedGitCom.fetchAccessTokenCode()
       }//ifGitCom
      //set up object to be animated including starting point
      let gitAlert = NSBundle.mainBundle().loadNibNamed("GitAlert", owner: self, options: nil).first as UIView
      gitAlert.center = self.view.center
      gitAlert.alpha = 0
      gitAlert.transform = CGAffineTransformMakeScale(0.4, 0.4)
      self.view.addSubview(gitAlert)
      
      UIView.animateWithDuration(0.4, delay: 0.5, options: nil, animations: { () -> Void in
        gitAlert.alpha = 1
        gitAlert.transform =  CGAffineTransformMakeScale(1.0, 1.0)
        }) { (finished) -> Void in
          
      }//animate
  }//viewDidAppear
  
  
  @IBAction func gitAlertOk(sender: AnyObject) {
    
    let gitAlert = NSBundle.mainBundle().loadNibNamed("GitAlert", owner: self, options: nil).first as UIView
    gitAlert.transform = CGAffineTransformMakeScale(0.0, 0.0)
  }
  
}//GitMenu
