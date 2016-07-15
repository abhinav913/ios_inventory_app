//
//  SecondViewController.swift
//  ios_Inventory
//
//  Created by Abhinav Shah on 7/7/16.
//  Copyright © 2016 Abhinav Shah. All rights reserved.
//

import UIKit

class RecentItemViewController: UIViewController {

    let searchController = UISearchController(searchResultsController: nil)
    var placement_data = [String]()
    var filteredData = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        placement_data = [
            "One",
            "Two",
            "Three",
            "Four",
            "Blue",
            "Green",
            "Macaroni",
        ]
        // Do any additional setup after loading the view, typically from a nib.
       /* searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar */
        
        
    }
 /*   func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredData = placement_data.filter { data in
            return data.lowercaseString.containsString(searchText.lowercaseString)
        }
        tableView.reloadData()
    } */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Table View
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active && searchController.searchBar.text != "" {
            return filteredData.count
        }
        return placement_data.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        let data: String
        if searchController.active && searchController.searchBar.text != "" {
            data = filteredData[indexPath.row]
        } else {
            data = ""
        }
        cell.textLabel!.text = data
        return cell
    }
}
/*
extension SecondViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
*/
