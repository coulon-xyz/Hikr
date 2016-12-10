//
//  LoginController+handlers.swift
//  ChatApp
//
//  Created by Julien Coulon on 15/09/2016.
//  Copyright © 2016 CoulonXYZ. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

extension LoginController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    func handleSelectProfileImageView() {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
        
    }
    
      
    func handleLoginRegister() {
        
        self.activityIndicatorView.startAnimating()
        view.isUserInteractionEnabled = false
        
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            handleLogin()
        } else {
            handleRegister()
        }
        
    }
    
    func handleLogin () {
        
        
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            handleAlert(message: "Form is not valid")
            return
        }

        if !email.isValidEmail()  {
            self.handleAlert(message: "Please, enter a valid email adress")
            return
        }
        
        if password.isEmpty {
            self.handleAlert(message: "Please, enter a password")
            return
        }
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                
                self.handleAlert(message: error!.localizedDescription)
            
                return
            }
            
            self.dismiss(animated: true, completion: nil)
            
        })
        
    }
    
    
    func handleRegister() {
        
        print("HELLO")
        
        guard let name = nameTextField.text, let email = emailTextField.text, let password = passwordTextField.text else {
            print("form is not valid")
            return
        }
        
        if name.removeWhitespace().isEmpty {
            self.handleAlert(message: "Please, enter a name")
            return
        }
        
        if !email.isValidEmail() {
            self.handleAlert(message: "Please, enter a valid email adress")
            return
        }
        
        if password.isEmpty {
            self.handleAlert(message: "Please, enter a password")
            return
        }
        
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error) in
            
            if error != nil {
                self.handleAlert(message: error!.localizedDescription)
                return
            }
            
            guard let uid = user?.uid else {
                return
            }
            
            
            self.dismiss(animated: true, completion: nil)
            
            
        })
    }
    
    private func registerUserIntoDatabase(uid: String, values: [String:AnyObject]) {
        
        let ref = FIRDatabase.database().reference()
        let usersReference = ref.child("users").child(uid)
        //    let values = ["name": name, "email": email, "profileImageUrl": metadata.downloadUrl()]
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if err != nil {
                self.handleAlert(message: err!.localizedDescription)
                self.activityIndicatorView.stopAnimating()
                return
            }

            // self.messagesController?.navigationItem.title = values["name"] as? String
            
//           let user = User()
//            // This setter might crash if keys don't match
//            user.setValuesForKeysWithDictionary(values)
//            self.messagesController?.setupNavBarWithUser(user)
            
            self.dismiss(animated: true, completion: nil)
        })
        
        
        
    }

    func handleAlert(message: String) {
        
        // create the alert
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
        //stop activity indicator and re-enable user interaction in the view
        activityIndicatorView.stopAnimating()
        view.isUserInteractionEnabled = true
    }
    
    func handleForgotPassword() {
        
        guard let email = emailTextField.text else {
            handleAlert(message: "Form is not valid")
            return
        }

        if !email.isValidEmail() {
            handleAlert(message: "Please, enter a valid email in the email field.")
        }
        
            let alertController = UIAlertController(title: "Password Reset", message: "Do you really want to reset the password for \(email) ?", preferredStyle: .alert)
                
            // Create the actions
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                UIAlertAction in
                    FIRAuth.auth()?.sendPasswordReset(withEmail: email) { error in
                        if let error = error {
                            self.handleAlert(message: error.localizedDescription)
                        } else {
                            
                        }
                    }
                }
        
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
                UIAlertAction in
                  
                }
                
                // Add the actions
                alertController.addAction(okAction)
                alertController.addAction(cancelAction)
                
                // Present the controller
                self.present(alertController, animated: true, completion: nil)

    }
}

    

