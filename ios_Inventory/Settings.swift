//
//  Settings.swift
//  ios_Inventory
//
//  Created by Sohan Shah on 7/28/16.
//  Copyright © 2016 Abhinav Shah. All rights reserved.
//

import UIKit
import FirebaseAuth

class Settings: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func logOut(sender: AnyObject) {
        try! FIRAuth.auth()?.signOut()
    }
 
    // MARK: - Navigation



}
