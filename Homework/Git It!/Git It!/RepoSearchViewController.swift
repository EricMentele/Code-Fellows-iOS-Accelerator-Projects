//
//  RepoSearchViewController.swift
//  Git It!
//
//  Created by Eric Mentele on 1/19/15.
//  Copyright (c) 2015 Eric Mentele. All rights reserved.
//

import UIKit

class RepoSearchViewController: UIViewController, UITableViewDataSource, UISearchBarDelegate {

  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var searchBar: UISearchBar!
  
  var repos = [Repo]()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.dataSource = self
        self.searchBar.delegate = self
      
    }
  
  
  //MARK: TABLE VIEW DATA SOURCE
  //MARK: Number of rows in section
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return self.repos.count
  }//tableView
  
  
  //MARK: Cell for row at index path
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCellWithIdentifier("repoCell") as UITableViewCell
    let cellRepo = self.repos[indexPath.row]
    cell.textLabel!.text = cellRepo.name
    assert(self.repos.count != 0)
    return cell
  }//cellForRow
  
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
    if segue.identifier == "gitWeb" {
      
      let destinationVC = segue.destinationViewController as GitWebViewController
      let selectedCell = self.tableView.indexPathForSelectedRow()
      let repo = self.repos[selectedCell!.row]
      destinationVC.url = repo.url
    }
  }

  
  
  //MARK: SEARCH BAR
  func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    
    GitCom.sharedGitCom.fetchReposForSearchTerm(searchBar.text, callback: {
      (items, errorDescription) -> () in

      if errorDescription == nil {
        
      self.repos = items!
      assert(!self.repos.isEmpty)
      }
      self.tableView.reloadData()
    })//fetch repos
   
    searchBar.resignFirstResponder()
    
  }//search bar clicked
  
  
  //MARK: Search bar text restriction
  func searchBar(searchBar: UISearchBar, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
    
    return text.validate()
  }//sear bar text restriction
  
  
}//RepoSearchVC
