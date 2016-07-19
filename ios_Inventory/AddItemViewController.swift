//
//  AddItemViewController.swift
//  ios_Inventory
//
//  Created by Abhinav Shah on 7/16/16.
//  Copyright © 2016 Abhinav Shah. All rights reserved.
//

import UIKit

class AddItemViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextViewDelegate {
    
    
    @IBOutlet weak var itemNotes: UITextView!
    @IBOutlet weak var itemPrice: UITextField!
    @IBOutlet weak var itemName: UITextField!
    @IBOutlet weak var categoryPicker: UITextField!
    
    var itemArray = [Item]()
    
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
        itemNotes.delegate = self
        itemNotes.text = "Add Notes Here..."
        itemNotes.textColor = UIColor.lightGrayColor()
        itemNotes.layer.cornerRadius = 8.0
        itemNotes.layer.masksToBounds = true
        itemNotes.layer.borderColor = UIColor( red: 210/255, green: 210/255, blue:210/255, alpha: 1.0 ).CGColor
        itemNotes.layer.borderWidth = 1.0
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
    
    @IBAction func addItemButton(sender: AnyObject) {
        if itemPrice.text != "" || itemName.text != "" || categoryPicker.text != "" {
            //TODO FIX PRICE
            itemArray.append(Item(name: itemName.text!, price: 0, category: categoryPicker.text!))
            let alert = UIAlertController(title: "Item Added", message: "", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:  {
                [unowned self] (action) -> Void in
                self.performSegueWithIdentifier("itemAddedAlert", sender: self)
                }))
            self.presentViewController(alert, animated: true, completion: nil)
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
