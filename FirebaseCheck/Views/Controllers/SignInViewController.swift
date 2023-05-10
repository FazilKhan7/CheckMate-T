//
//  SignInViewController.swift
//  FirebaseCheck
//
//  Created by Bakhtiyarov Fozilkhon on 18.03.2023.
//

import Foundation
import UIKit

class SignInViewController: UIViewController {
    
    let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "SDU-logo")
        
        return imageView
    }()
    
    let stackView = makeStackView(axis: .vertical, spacing: 60)
    
    let IDTextField: SignInTextFieldView = {
        let textFieldView = SignInTextFieldView(withText: "Username")
        textFieldView.translatesAutoresizingMaskIntoConstraints = false
        textFieldView.textField.keyboardType = .emailAddress
        textFieldView.textField.placeholder = "name.surname"
        return textFieldView
    }()
    
    let passwordTextField: SignInTextFieldView = {
        let textFieldView = SignInTextFieldView(withText: "Password")
        textFieldView.translatesAutoresizingMaskIntoConstraints = false
        textFieldView.textField.keyboardType = .default
        textFieldView.textField.isSecureTextEntry = true
        textFieldView.textField.isUserInteractionEnabled = true
        
        return textFieldView
    }()
    
    let emailEmptyErrorLabel: UILabel = {
        let label = makeLabel(fontSize: 15, weight: .regular)
        label.text = "Please, enter your id."
        label.textColor = .systemRed
        label.isHidden = true
        
        return label
    }()
    
    let passwordEmptyErrorLabel: UILabel = {
        let label = makeLabel(fontSize: 15, weight: .regular)
        label.text = "Please, enter the password."
        label.textColor = .systemRed
        label.isHidden = true
        
        return label
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.style = .large
        activityIndicator.hidesWhenStopped = true
        
        return activityIndicator
    }()
    
    let sduGradientButton: SDUGradientButton = {
        let button = SDUGradientButton(withText: "Sign in")
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    let forgotPasswordLabel = makeLabel(fontSize: 15, color: #colorLiteral(red: 0, green: 0.2045772076, blue: 0.4879741669, alpha: 1), weight: .regular, text: "Forgot password?")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        addAllSubViews()
        setup()
        layout()
        addTapBarGestureRecognizer()
    }
    
    private func addTapBarGestureRecognizer() {
        let tapBarGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapBarGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func addAllSubViews() {
        view.addSubview(logoImageView)
        view.addSubview(stackView)
        
        stackView.addArrangedSubview(IDTextField)
        stackView.addArrangedSubview(passwordTextField)
        
        view.addSubview(emailEmptyErrorLabel)
        view.addSubview(passwordEmptyErrorLabel)
        view.addSubview(forgotPasswordLabel)
        view.addSubview(sduGradientButton)
        view.addSubview(activityIndicator)
    }
    
    
    private func setup() {
        IDTextField.textField.delegate = self
        passwordTextField.textField.delegate = self
        sduGradientButton.addTarget(self, action: #selector(didTapSignIn), for: .primaryActionTriggered)
        
        forgotPasswordLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapForgotPassword))
        forgotPasswordLabel.addGestureRecognizer(tapGesture)
    }
    
    @objc func didTapForgotPassword() {
        let vc = ResetPasswordViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func layout() {
        let stackSpacing = view.frame.size.height / 13
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.size.height / 7),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: view.frame.size.height / 8),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
        
        stackView.spacing = stackSpacing
        
        NSLayoutConstraint.activate([
            IDTextField.textField.heightAnchor.constraint(equalToConstant: view.frame.size.height / 14.5),
            passwordTextField.textField.heightAnchor.constraint(equalToConstant: view.frame.size.height / 14.5),
        ])
        
        NSLayoutConstraint.activate([
            emailEmptyErrorLabel.topAnchor.constraint(equalTo: IDTextField.bottomAnchor, constant: 11),
            emailEmptyErrorLabel.leadingAnchor.constraint(equalTo: IDTextField.leadingAnchor),
            
            passwordEmptyErrorLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 11),
            passwordEmptyErrorLabel.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            sduGradientButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: view.frame.size.height / 18),
            sduGradientButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            sduGradientButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            sduGradientButton.heightAnchor.constraint(equalToConstant: view.frame.size.height / 15)
        ])
        
        NSLayoutConstraint.activate([
            forgotPasswordLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            forgotPasswordLabel.topAnchor.constraint(equalTo: sduGradientButton.bottomAnchor, constant: 16)
        ])
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

extension SignInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//MARK: - Actions

extension SignInViewController {
    
    @objc func didTapSignIn(_ sender: UIButton) {
        IDTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        if IDTextField.textField.text == "" {
            emailEmptyErrorLabel.isHidden = false
            return
        } else {
            emailEmptyErrorLabel.isHidden = true
        }
        
        if passwordTextField.textField.text == "" {
            passwordEmptyErrorLabel.isHidden = false
            return
        } else {
            passwordEmptyErrorLabel.isHidden = true
        }
        
        activityIndicator.startAnimating()
        
        let domain = "@sdu.edu.kz"
        
        guard var email = IDTextField.textField.text,
              let password = passwordTextField.textField.text else {
            return
        }
        
        email += domain
        
        AuthManager.shared.signIn(email: email, password: password) { [weak self] result in
            switch result {
            case .success(_):
                let vc = MainTabBarController()
                let navVC = UINavigationController(rootViewController: vc)
                self?.IDTextField.textField.text = ""
                self?.passwordTextField.textField.text = ""
                navVC.modalPresentationStyle = .fullScreen
                self?.present(navVC, animated: true)
                
            case .failure(let error):
                let alertController = UIAlertController(
                    title: "Sign in error",
                    message: "\(error.localizedDescription)",
                    preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(alertController, animated: true)
                print(error)
            }
            
            self?.activityIndicator.stopAnimating()
        }
    }
}
