// LoginController.swift
// Coded by Julien@coulon.xyz

import UIKit
import Firebase
import FirebaseAuth


class LoginController: UIViewController, UITextFieldDelegate {
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        aiv.color = UIColor.blue
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.backgroundColor = UIColor.init(red: 200 , green: 200, blue: 200, alpha: 0.5)
        aiv.layer.cornerRadius = 10
        aiv.layer.masksToBounds = true
        aiv.hidesWhenStopped = true
        return aiv
    }()
    
    
    lazy var loginRegisterSegmentedControl : UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login", "Register"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = UIColor(named: .customGreen)
        sc.setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.white], for: UIControlState.normal)
        sc.setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.black], for: UIControlState.selected)
        sc.selectedSegmentIndex = 1
        sc.addTarget(self, action: #selector(handelLoginRegisterChange), for: .valueChanged)
        
        return sc
    }()
    
    let inputsContainerView : UIView =  {
        let view = UIView()
        view.backgroundColor = UIColor(named: .textFieldColor)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var forgotPasswordButton : UIButton = {
        let button = UIButton(type: .system)
        button.isHidden = true
        button.backgroundColor = UIColor.clear
        button.setTitle("Forgot your password ?", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.black, for: .normal)
        button.contentHorizontalAlignment = .right
        button.titleLabel?.font =  UIFont.systemFont(ofSize: 12.0)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(handleForgotPassword), for: .touchUpInside)
        return button
    }()
    
    lazy var loginRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(named: .customGreen)
        button.setTitle("Register", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        return button
    }()
    
    let nameTextField : UITextField = {
        let tf = UITextField()
        tf.placeholder = "Name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let nameSeparatorView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let emailTextField : UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let emailSeparatorView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let passwordTextField : UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    var delta: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
     
        self.passwordTextField.delegate = self
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "loading_screen")
        self.view.insertSubview(backgroundImage, at: 0)
        
        view.addSubview(inputsContainerView)
        view.addSubview(loginRegisterButton)

        view.addSubview(forgotPasswordButton)
        view.addSubview(loginRegisterSegmentedControl)
        view.addSubview(activityIndicatorView)

        
        
        //  self.passwordTextField.keyboardDismissMode = .Interactive
        
        setupInputsContainersView()
        setupLoginRegisterButton()
        setupLoginRegisterControl()
    //    setupKeyboardObservers()
        setupForgotPasswordButton()
        setupActivityIndicator()
        
    }
    
    // MARK: Setup
    
    
    // Variable declaration for toggles of inputsContainerView
    
    var inputsContainerViewHeightAnchor: NSLayoutConstraint?
    var nameTextFieldHeightAnchor: NSLayoutConstraint?
    var emailTextFieldHeightAnchor: NSLayoutConstraint?
    var passwordTextFieldHeightAnchor: NSLayoutConstraint?
    
    
    func setupLoginRegisterControl() {
        //need x, y, width, height constraints
        
        loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegmentedControl.topAnchor.constraint(equalTo: view.topAnchor, constant: 170).isActive = true
        loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
    }
    
    
    func setupInputsContainersView() {
        // need x,y width heigh constraints
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.topAnchor.constraint(equalTo: loginRegisterSegmentedControl.bottomAnchor, constant: 12).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        
        inputsContainerViewHeightAnchor = inputsContainerView.heightAnchor.constraint(equalToConstant: 150)
        inputsContainerViewHeightAnchor?.isActive = true
        
        inputsContainerView.addSubview(nameTextField)
        inputsContainerView.addSubview(nameSeparatorView)
        inputsContainerView.addSubview(emailTextField)
        inputsContainerView.addSubview(emailSeparatorView)
        inputsContainerView.addSubview(passwordTextField)
        
        
        // need x,y width heigh constraints
        nameTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        nameTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -24).isActive = true
        
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        nameTextFieldHeightAnchor?.isActive = true
        
        // need x,y width heigh constraints
        
        nameSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        nameSeparatorView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        // need x,y width heigh constraints
        emailTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameSeparatorView.topAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -24).isActive = true
        
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        emailTextFieldHeightAnchor?.isActive = true
        
        // need x,y width heigh constraints
        
        emailSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        emailSeparatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        // need x,y width heigh constraints
        passwordTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailSeparatorView.topAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -24).isActive = true
        
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
        
    }
    
    func setupForgotPasswordButton() {
        // x,y,w,h
        
        forgotPasswordButton.rightAnchor.constraint(equalTo: inputsContainerView.rightAnchor).isActive = true
        forgotPasswordButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 0).isActive = true
        forgotPasswordButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        forgotPasswordButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
    }
    
    func setupLoginRegisterButton() {
        // need x,y width heigh constraints
        
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: forgotPasswordButton.bottomAnchor, constant: 6).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    

    
    func handelLoginRegisterChange() {
        
        print("CHANGE")
        
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: .normal)
        
        
        // change height of input container view
        
        inputsContainerViewHeightAnchor?.constant =
            loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 100 : 150
        
        // change height of NameTextField
        
        nameTextFieldHeightAnchor?.isActive = false
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: (        loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1/3))
        nameTextFieldHeightAnchor?.isActive = true
        
        // change height of EmailTextField
        
        emailTextFieldHeightAnchor?.isActive = false
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: (loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3))
        emailTextFieldHeightAnchor?.isActive = true
        
        // change height of passwordTextField
        
        passwordTextFieldHeightAnchor?.isActive = false
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: (loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3))
        passwordTextFieldHeightAnchor?.isActive = true
        
        // hide or not the forgot your password button
        
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            forgotPasswordButton.isHidden = false
        } else {
            forgotPasswordButton.isHidden = true
        }
    }
    
    func setupActivityIndicator() {
        // x,y,w,h
        activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicatorView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        activityIndicatorView.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    
    // MARK: OVERRIDE
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        handleLoginRegister()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
//    func setupKeyboardObservers() {
//        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
//    }
//    
    
    
//    func handleKeyboardWillShow(notification: NSNotification) {
//        let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
//        let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
//        
//        
//        delta = loginRegisterButton.frame.maxY - keyboardFrame!.minY
//        
//        if delta > 0 {
//            profileImageViewTopAnchorConstraint.isActive = false
//            profileImageViewTopAnchorConstraint = profileImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: -delta)
//            profileImageViewTopAnchorConstraint.isActive = true
//        }
//        
//        // move the input area
//        //containerViewBottomAnchor?.constant = -keyboardFrame!.height
//        UIView.animate(withDuration: keyboardDuration!) {
//            self.view.layoutIfNeeded()
//        }
//        
//    }
//    
//    func handleKeyboardWillHide(notification: NSNotification) {
//        let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
//        
//        profileImageViewTopAnchorConstraint.isActive = false
//        profileImageViewTopAnchorConstraint = profileImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20)
//        profileImageViewTopAnchorConstraint.isActive = true
//        
//        // move the input area
//        //containerViewBottomAnchor?.constant = 0
//        UIView.animate(withDuration: keyboardDuration!) {
//            self.view.layoutIfNeeded()
//        }
//        
//    }
    

    
}
