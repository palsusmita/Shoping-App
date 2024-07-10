//
//  LoginViewController.swift
//  Shopping-App-eCommerce
//
//  Created by Osman Emre Ömürlü on 27.01.2023.
//

import UIKit

class LoginViewController: UIViewController {

    //MARK: - Properties
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    //MARK: - Interaction handlers
    @IBAction func signInButtonPressed(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            self.performSegue(withIdentifier: K.Segues.loginToHome, sender: self)
        }
    }
    
    @IBAction func forgotPasswordPressed(_ sender: UIButton) {
    //    self.performSegue(withIdentifier: K.Segues.loginToForgot, sender: self)

    }
    
}

