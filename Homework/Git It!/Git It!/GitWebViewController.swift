//
//  GitWebViewController.swift
//  Git It!
//
//  Created by Eric Mentele on 1/23/15.
//  Copyright (c) 2015 Eric Mentele. All rights reserved.
//

import UIKit
import WebKit

class GitWebViewController: UIViewController {
  
  let webView = WKWebView()
  var url: String!
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    self.webView.frame = self.view.frame
    self.view.addSubview(webView)
    let request = NSURLRequest(URL: NSURL(string: self.url!)!)
    self.webView.loadRequest(request)
    
  }
  
  
}//GitWeb
