//
//  ViewController.swift
//  IDEChat2019
//
//  Created by mohamed gamal mohamed on 6/13/19.
//  Copyright © 2019 mohamed gamal mohamed. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

enum topSegment : Int{
    case login
    case register
}

class ViewController: UIViewController {
    
    var currentPage:topSegment = .login
    
    @IBOutlet weak var mySegemntControl: UISegmentedControl!
    @IBOutlet weak var userNameField: UITextField!{
        didSet{
            userNameField.isHidden = true
        }
    }
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if (Auth.auth().currentUser != nil){
            
         presentHomeScreen()
        }
    }
    func presentHomeScreen(){
        let homeView = self.storyboard?.instantiateViewController(withIdentifier: "HomeNav")
        self.present(homeView!, animated: true)
        
    }

    override func viewDidLoad() {   
        super.viewDidLoad()
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(didDetectSwipe))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(didDetectSwipe))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
    }
    
   @objc func didDetectSwipe(_ sender: UISwipeGestureRecognizer){
    if (sender.direction == .left){
        mySegemntControl.selectedSegmentIndex = 0        
    } else if(sender.direction == .right){
        mySegemntControl.selectedSegmentIndex = 1
    }
    mySegemntControl.sendActions(for: UIControl.Event.valueChanged)

    }
   
   

    @IBAction func didChangeSegment(_ sender: UISegmentedControl) {
        if let selectedEnum = topSegment(rawValue: sender.selectedSegmentIndex){
            switch selectedEnum {
            case .login:
                userNameField.isHidden = true
                submitButton.setTitle("Login", for: .normal)
                currentPage = .login
                
            case .register:
                userNameField.isHidden = false
                submitButton.setTitle("Register", for: .normal)
                currentPage = .register
            }
        }
        
    }
    
    @IBAction func didPressOnSubmit(_ sender: UIButton) {
        let registerationModel = HomeForm.init(formType: currentPage, userName: userNameField.text, passowrd: passwordField.text, email: emailField.text)
        
        guard let email = registerationModel.email , let password = registerationModel.passowrd
            
            else {
                return
        }
        switch currentPage {
        
        case .login:
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                if (error == nil){
                self.presentHomeScreen()
                }
                else{
                    print("error login")
                }
            }
        case .register:
            if (registerationModel.validateField()){
        
                Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                    if error == nil{
                        let data: [String : String] = ["username" : registerationModel.userName! , "profilePicture": "img.png"]
                        
                       let db = Database.database().reference()
                        db.child("Users").child(result!.user.uid).setValue(data)
                    }
                    else{
                        print("Error \(error)")
                    }
                }
      }
    }
  }
}
