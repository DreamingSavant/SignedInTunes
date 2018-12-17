//
//  SignInViewController.swift
//  SignedInTunes
//
//  Created by Kevin Yu on 12/17/18.
//  Copyright © 2018 Kevin Yu. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func signInButtonAction(_ sender: Any) {
        // verify the email and password are valid
        
        // if they are valid, sign in
        
        // if they are not valid, error
        
        self.goToSignedInExperience()
    }
    
    func goToSignedInExperience() {
        let musicVC = self.storyboard?.instantiateViewController(withIdentifier: "MusicTableViewController") as! MusicTableViewController
        
        self.present(musicVC, animated: true, completion: nil)
    }
}

