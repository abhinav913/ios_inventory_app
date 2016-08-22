//
//  SignUpViewController.swift
//  ios_Inventory
//
//  Created by Sohan Shah on 7/29/16.
//  Copyright © 2016 Abhinav Shah. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var fullNameField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordProtect()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func signUp(sender: AnyObject) {
        
        if (checkPassword() == true) {
            createUser()
        }
        else {  //TODO make this actually show up as notification
            print("Passwords don't match")
        }
    }
    
    func createUser() {
        FIRAuth.auth()?.createUserWithEmail(emailField.text!, password: passwordField.text!, completion:
            { (user: FIRUser?, error: NSError?) in
                if (error != nil) {
                    print(error?.description)
                }
                else {
                    self.performSegueWithIdentifier("signUpSegue", sender: self)
                }
        })
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "signUpSegue" {
            // Sign UP
        }
    }
    
    func passwordProtect() {
        passwordField.secureTextEntry = true
        confirmPasswordField.secureTextEntry = true
        
    }
    
    func checkPassword() -> Bool{
        if (passwordField.text! == confirmPasswordField.text!) {
            return true
        }
        return false
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
