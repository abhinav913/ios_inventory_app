//
//  SignInViewController.swift
//  
//
//  Created by Sohan Shah on 7/20/16.
//
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController {

    

    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordProtect()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        FIRAuth.auth()?.addAuthStateDidChangeListener({ (auth:FIRAuth, user:FIRUser?)  in
            if let user = user {
                print("Welcome \(user.email)")
                self.performSegueWithIdentifier("loginSegue", sender: self)
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signIn(sender: AnyObject) {
        FIRAuth.auth()?.signInWithEmail(emailField.text!, password: passwordField.text!, completion: { (user: FIRUser?, error: NSError?) in
            if (error != nil) {
                print(error?.description)
            }
            else {
                self.performSegueWithIdentifier("loginSegue", sender: self)
            }
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "loginSegue" {
            // Logs In
        }
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func passwordProtect() {
        passwordField.secureTextEntry = true
    }

}
