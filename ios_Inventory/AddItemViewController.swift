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
    
    @IBOutlet weak var aeNav: UINavigationItem!
    @IBOutlet weak var itemQuantity: UITextField!
    @IBOutlet weak var aeButton: UIButton!
    var categoryName:String = ""
    @IBOutlet weak var itemNotes: UITextView!
    @IBOutlet weak var itemPrice: UITextField!
    @IBOutlet weak var itemName: UITextField!
    @IBOutlet weak var categoryPicker: UITextField!
    var tField:UITextField!
    var itemRepeat:Item!
    var edit = false
    
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
        hideKeyboardWhenTappedAround()
        let pickerView = UIPickerView()
        pickerView.delegate = self
        itemQuantity.keyboardType = UIKeyboardType.NumberPad
        itemNotes.text = ""
        itemNotes.delegate = self
        itemNotes.textColor = UIColor.lightGrayColor()
        itemNotes.layer.cornerRadius = 8.0
        itemNotes.layer.masksToBounds = true
        itemNotes.layer.borderColor = UIColor( red: 210/255, green: 210/255, blue:210/255, alpha: 1.0 ).CGColor
        itemNotes.layer.borderWidth = 1.0
        if !edit || self.itemRepeat.notes == "" {
            itemNotes.text = "Add Notes Here..."
        } else {
            itemNotes.text = self.itemRepeat.notes
        }
        if edit {
            itemName.text = self.itemRepeat.name
            itemName.enabled = false
            itemPrice.text = String(self.itemRepeat.price)
            categoryPicker.text = self.itemRepeat.category
            categoryPicker.inputView = pickerView
            itemQuantity.text = String(self.itemRepeat.quantity)
            aeButton.setTitle("Save Changes", forState: UIControlState.Normal)
            aeNav.title = "Edit"
        } else {
            aeButton.setTitle("Add Item", forState: UIControlState.Normal)
            itemName.text = ""
            itemQuantity.text = "1"
            categoryPicker.inputView = pickerView
            categoryPicker.text = ""
            if categoryName != "" {
                categoryPicker.text = categoryName
            }
        }
        dbRef = FIRDatabase.database().reference().child("inventory-items")
    }
    
    func setupNotes(itemNotes: UITextView!, notes: String) {
        if !edit || notes == "" {
            itemNotes.text = "Add Notes Here..."
        } else {
            itemNotes.text = notes
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
    
    func nameCheck(name: String, category: String) -> Bool {
        print(allItems)
        for item in self.allItems {
            if item.name.lowercaseString == name.lowercaseString {
                if item.category == category {
                    self.itemRepeat = item
                    return true
                }
            }
        }
        return false
    }
    
    func roundToPlaces(var value:Double, places:Int) -> Double {
        value += 0.000001
        let divisor = pow(10.00, Double(places))
        return round(value * divisor) / divisor
    }
    
    func configurationTextField(textField: UITextField!) {
        print("generating the TextField")
        textField.text = String(self.itemRepeat.quantity)
        textField.keyboardType = UIKeyboardType.NumberPad
        tField = textField
    }
    
    @IBAction func addItemButton(sender: AnyObject) {
        itemQuantity.keyboardType = UIKeyboardType.NumberPad
        if edit == false {
            if itemPrice.text != "" && itemName.text != "" && categoryPicker.text != "" {
                if nameCheck(itemName.text!, category: categoryPicker.text!) {
                    let alert = UIAlertController(title: "Item Exists", message: "Item already exists. Update quantity below: ", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addTextFieldWithConfigurationHandler(configurationTextField)
                    alert.addAction(UIAlertAction(title: "Update Quantity", style: UIAlertActionStyle.Default, handler: {
                        [unowned self] (action) -> Void in
                        self.itemRepeat.itemRef?.updateChildValues(["quantity": Int(self.tField.text!)!])
                        self.itemRepeat.itemRef?.updateChildValues(["time": NSDate().timeIntervalSince1970])
                        self.performSegueWithIdentifier("itemAddedAlert", sender: self)
                        }))
                    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                } else {
                    if itemNotes == "Add Notes Here..." {
                        itemNotes.text = ""
                    }
                    let newItem = Item(name: itemName.text!, price: roundToPlaces(Double(itemPrice.text!)!, places: 2), category: categoryPicker.text!, notes: itemNotes.text, quantity: Int(itemQuantity.text!)!, time: NSDate().timeIntervalSince1970)
                    print(newItem.time)
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
        } else {
            self.itemRepeat.itemRef?.updateChildValues(["price": roundToPlaces(Double(itemPrice.text!)!, places: 2)])
            self.itemRepeat.itemRef?.updateChildValues(["quantity": Int(itemQuantity.text!)!])
            if itemNotes.text == "" || itemNotes.text == "Add Notes Here..." {
                self.itemRepeat.itemRef?.updateChildValues(["notes": ""])
            } else {
                self.itemRepeat.itemRef?.updateChildValues(["notes": itemNotes.text!])
            }
            self.itemRepeat.itemRef?.updateChildValues(["category": categoryPicker.text!])
            self.itemRepeat.itemRef?.updateChildValues(["time": NSDate().timeIntervalSince1970])
            let alert = UIAlertController(title: "Changes Saved", message: "Item has been updated.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {
                [unowned self] (action) -> Void in
                self.performSegueWithIdentifier("itemAddedAlert", sender: self)
            }))
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
