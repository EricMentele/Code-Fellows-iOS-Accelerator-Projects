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
    //println(self.repos.count)
    //println(cellRepo.name)
    return cell
  }//cellForRow
  
  
  func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    GitCom.sharedGitCom.fetchReposForSearchTerm(searchBar.text, callback: { (items, errorDescription) -> () in

      if errorDescription == nil {
      self.repos = items!
      //println(self.repos)
        
      } else {
        println("NOPE")
      }
      self.tableView.reloadData()
    })
   
    searchBar.resignFirstResponder()
    
  }
  
  
}//RepoSearchVC
