//
//  SecondViewController.swift
//  ios_Inventory
//
//  Created by Abhinav Shah on 7/7/16.
//  Copyright © 2016 Abhinav Shah. All rights reserved.
//

import UIKit
import FirebaseDatabase

class RecentItemViewController: UITableViewController {

    @IBOutlet var recentItemView: UITableView!
    
    var allItems = [Item]()
    var dbRef:FIRDatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        dbRef = FIRDatabase.database().reference().child("inventory-items")
        self.allItems = []
        definesPresentationContext = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        startObservingDB()
    }
    
    func startObservingDB() {
        dbRef.observeEventType(.Value, withBlock: {(snapshot:FIRDataSnapshot) in
            self.allItems = []
            var newItems = [Item]()
            for item in snapshot.children {
                let itemObject = Item(snapshot:item as! FIRDataSnapshot)
                newItems.append(itemObject)
            }
            newItems.sortInPlace({$0.time > $1.time})
            if newItems.count > 10 {
                for i in 0...9 {
                    self.allItems.append(newItems[i])
                }
            } else {
                self.allItems = newItems
            }
            self.recentItemView.reloadData()
            }) {(error:NSError) in
                print(error.description)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.allItems.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = recentItemView.dequeueReusableCellWithIdentifier("Recent", forIndexPath: indexPath)
        var item:Item
        item = self.allItems[indexPath.row]
        cell.textLabel?.text = item.name
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.recentItemView.deselectRowAtIndexPath(indexPath, animated: true)
        showAlert(self.allItems[indexPath.row])
    }
    
    func showAlert(var item: Item) {
        let alert = UIAlertController(title: item.name, message: "Price: $\(item.price)\nQuantity: \(item.quantity)\nNotes: \(item.notes)", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        alert.addAction(UIAlertAction(title: "Sell Unit", style: UIAlertActionStyle.Destructive, handler: {
            (action) -> Void in
            item.itemRef?.updateChildValues(["quantity": (item.quantity - 1)])
            item.quantity = item.quantity - 1
            if item.quantity <= 0 {
                item.itemRef?.removeValue()
            }
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}