//
//  AddItemViewController.swift
//  ios_Inventory
//
//  Created by Abhinav Shah on 7/16/16.
//  Copyright © 2016 Abhinav Shah. All rights reserved.
//

import UIKit
import FirebaseDatabase

class AddItemViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextViewDelegate {
    
    var categoryName:String = ""
    @IBOutlet weak var itemNotes: UITextView!
    @IBOutlet weak var itemPrice: UITextField!
    @IBOutlet weak var itemName: UITextField!
    @IBOutlet weak var categoryPicker: UITextField!
    
    var dbRef:FIRDatabaseReference!
    
    var itemArray = [Item]()
    var allItems = [Item]()
    
    let categoryList:[String] = [
        "Clothing, Shoes & Accesories",
        "Home & Garden",
        "Electronics & Office",
        "Toys & Video Games",
        "Sports, Fitness & Outdoors",
        "Beauty & Health",
        "Groceries & Food"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemName.text = ""
        let pickerView = UIPickerView()
        pickerView.delegate = self
        categoryPicker.inputView = pickerView
        categoryPicker.text = ""
        itemNotes.delegate = self
        itemNotes.text = "Add Notes Here..."
        itemNotes.textColor = UIColor.lightGrayColor()
        itemNotes.layer.cornerRadius = 8.0
        itemNotes.layer.masksToBounds = true
        itemNotes.layer.borderColor = UIColor( red: 210/255, green: 210/255, blue:210/255, alpha: 1.0 ).CGColor
        itemNotes.layer.borderWidth = 1.0
        dbRef = FIRDatabase.database().reference().child("inventory-items")
        if categoryName != "" {
            categoryPicker.text = categoryName
        }
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if itemNotes.textColor == UIColor.lightGrayColor() {
            itemNotes.text = ""
            itemNotes.textColor = UIColor.blackColor()
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if itemNotes.text == "" {
            itemNotes.text = "Add Notes Here..."
            itemNotes.textColor = UIColor.lightGrayColor()
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryList.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoryList[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryPicker.text = categoryList[row]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func nameCheck(name: String) -> Bool {
        print(allItems)
        for item in self.allItems {
            if item.name.lowercaseString == name.lowercaseString {
                return true
            }
        }
        return false
    }
    
    func roundToPlaces(var value:Double, places:Int) -> Double {
        value += 0.000001
        let divisor = pow(10.00, Double(places))
        return round(value * divisor) / divisor
    }
    
    @IBAction func addItemButton(sender: AnyObject) {
        if itemPrice.text != "" && itemName.text != "" && categoryPicker.text != "" {
            if nameCheck(itemName.text!) {
                let alert = UIAlertController(title: "Item Exists", message: "Item already exists, do you want to add quantity?", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {
                    [unowned self] (action) -> Void in
                    self.performSegueWithIdentifier("itemAddedAlert", sender: self)
                }))
                self.presentViewController(alert, animated: true, completion: nil)
            } else {
                if itemNotes == "Add Notes Here..." {
                    itemNotes.text = ""
                }
                let newItem = Item(name: itemName.text!, price: roundToPlaces(Double(itemPrice.text!)!, places: 2), category: categoryPicker.text!, notes: itemNotes.text, quantity: 1, time: NSDate())
                let itemRef = self.dbRef.child(newItem.name)
                itemRef.setValue(newItem.toAnyObject())
                let alert = UIAlertController(title: "Item Added", message: "", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:  {
                    [unowned self] (action) -> Void in
                    self.performSegueWithIdentifier("itemAddedAlert", sender: self)
                }))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        } else {
            let alert = UIAlertController(title: "Error", message: "Please fill in all fields.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "itemAddedAlert" {
            let homeVC = segue.destinationViewController as! HomeViewController
            homeVC.itemArray = itemArray
            homeVC.navigationItem.setHidesBackButton(true, animated: true)
        }
    }


}
