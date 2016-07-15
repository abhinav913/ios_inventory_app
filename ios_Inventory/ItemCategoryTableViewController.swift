//
//  ItemCategoryTableViewController.swift
//  ios_Inventory
//
//  Created by Abhinav Shah on 7/8/16.
//  Copyright © 2016 Abhinav Shah. All rights reserved.
//

import UIKit

class ItemCategoryTableViewController: UIViewController, UITableViewDataSource {
    
    
    @IBOutlet var itemTableView: UITableView!
    var searchController: UISearchController!
    var categoryTitle: String!
    var categoryItems:[testItem] = []
    var filterItems:[testItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = categoryTitle
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchBar.sizeToFit()
        self.itemTableView.tableHeaderView = self.searchController.searchBar
        self.searchController.searchResultsUpdater = self
        definesPresentationContext = true
        self.searchController.dimsBackgroundDuringPresentation = false
        self.itemTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if (searchController.active && searchController.searchBar.text != "") {
            return self.filterItems.count
        } else {
            return self.categoryItems.count
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.itemTableView.dequeueReusableCellWithIdentifier("Item", forIndexPath: indexPath)
        var item:testItem
        if (searchController.active && searchController.searchBar.text != "") {
            item = self.filterItems[indexPath.row]
        } else {
            item = self.categoryItems[indexPath.row]
        }
        cell.textLabel?.text = item.name
        return cell
    }
    
    func showAlert(item: String) {
        let alert = UIAlertController(title: item, message: "Price: $\nQuantity: \nNotes: ", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (searchController.active && searchController.searchBar.text != "") {
            showAlert(self.filterItems[indexPath.row].name)
        } else {
            showAlert(self.categoryItems[indexPath.row].name)
        }
        self.itemTableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    //SEARCH -- in category doesnt work IDK WHY????
  /*  func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchText = self.searchController.searchBar.text
        filterContentForSearchText(searchText!)
        print("breh")
        self.itemTableView.reloadData()
    }*/
    
    func filterContentForSearchText(searchText:String, scope: String="Title") {
        self.filterItems = self.categoryItems.filter({(item: testItem) -> Bool in
            let categoryMatch = (scope == "Title")
            let stringMatch = item.name.lowercaseString.containsString(searchText.lowercaseString)
            return categoryMatch && stringMatch
        })
        self.itemTableView.reloadData()
    }
    
    func searchDisplayController(controller: UISearchController, shouldReloadTableForString searchString: String!) -> Bool {
        self.filterContentForSearchText(searchString, scope: "Title")
        return true
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */


    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ItemCategoryTableViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchText = self.searchController.searchBar.text
        filterContentForSearchText(searchText!)
        self.itemTableView.reloadData()
    }
}
