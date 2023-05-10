//
//  DetailMessageViewController.swift
//  FirebaseCheck
//
//  Created by Bakhtiyarov Fozilkhon on 29.04.2023.
//

import Foundation
import UIKit

protocol TappedButtonForAcception: AnyObject {
    func isTappedDelegate()
}

class DetailMessageViewController: UIViewController {
    
    var acceptDelegation: TappedButtonForAcception?
    
    let acceptButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 26, weight: .semibold)
        button.setImage(UIImage(systemName: "checkmark.circle", withConfiguration: symbolConfiguration), for: .normal)
        button.sizeToFit()
        return button
    }()
    
    let closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 26, weight: .semibold)
        button.setImage(UIImage(systemName: "xmark", withConfiguration: symbolConfiguration), for: .normal)
        button.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        button.sizeToFit()
        return button
    }()
    
    
    let subjectLabel: UILabel = {
        let label = makeLabel(fontSize: 22, color: #colorLiteral(red: 0, green: 0.2045772076, blue: 0.4879741669, alpha: 1), weight: .bold, text: "From:")
        
        return label
    }()
    
    let fullSubjectCodeLabel: UILabel = {
        let label = makeLabel(fontSize: 22, color: #colorLiteral(red: 0.168627451, green: 0.2, blue: 0.2509803922, alpha: 1), weight: .medium, text: "")
        
        return label
    }()
    
    let sentDate: UILabel = {
        let label = makeLabel(fontSize: 22, color: #colorLiteral(red: 0.168627451, green: 0.2, blue: 0.2509803922, alpha: 1), weight: .medium, text: "")
        
        return label
    }()
    
    let toDateLabel: UILabel = {
        let label = makeLabel(fontSize: 22, color: #colorLiteral(red: 0, green: 0.2045772076, blue: 0.4879741669, alpha: 1), weight: .bold, text: "Lesson time: ")
        
        return label
    }()
    
    let toLabel = makeLabel(fontSize: 22, color: #colorLiteral(red: 0, green: 0.2045772076, blue: 0.4879741669, alpha: 1), weight: .bold, text: "Subject:")
    let studentLabel = makeLabel(fontSize: 22, color: #colorLiteral(red: 0.168627451, green: 0.2, blue: 0.2509803922, alpha: 1), weight: .medium, text: "")
    
    let navStackView = makeStackView(axis: .horizontal, spacing: 10)
    let subjectStackView = makeStackView(axis: .horizontal, spacing: 10)
    let recipientStackView = makeStackView(axis: .horizontal, spacing: 10)
    let sentDateStackView = makeStackView(axis: .horizontal, spacing: 10)
    
    let messageTF: UILabel = {
        let tf = UILabel()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.numberOfLines = 0
        tf.lineBreakMode = .byWordWrapping
        return tf
    }()
    
    let separatorLineView1: UIView = {
        let lineView = UIView()
        lineView.translatesAutoresizingMaskIntoConstraints = false
        
        lineView.backgroundColor = .systemGray3
        
        return lineView
    }()
    
    let separatorLineView2: UIView = {
        let lineView = UIView()
        lineView.translatesAutoresizingMaskIntoConstraints = false
        
        lineView.backgroundColor = .systemGray3
        
        return lineView
    }()
    
    let separatorLineView3: UIView = {
        let lineView = UIView()
        lineView.translatesAutoresizingMaskIntoConstraints = false
        
        lineView.backgroundColor = .systemGray3
        
        return lineView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        closeButton.addTarget(self, action: #selector(closeAction), for: .primaryActionTriggered)
        acceptButton.addTarget(self, action: #selector(isTapped), for: .primaryActionTriggered)
        layout()
    }
    
    @objc private func isTapped() {
        let nameOfStudent = studentLabel.text?.components(separatedBy: " ")[0]
        let surnameOfStudent = studentLabel.text?.components(separatedBy: " ")[1]
        let code = fullSubjectCodeLabel.text
        let todaysDay = sentDate.text?.components(separatedBy: " ")[1]
        var id: String = ""
        
        
        let getStudents = DatabaseManager.shared.database.collection("students").whereField("name", isEqualTo: nameOfStudent!)
            .whereField("surname", isEqualTo: surnameOfStudent!)
        
        var dd: [String: [Bool]] = [:]
        let getStudentsStatus = DatabaseManager.shared.database.collection("attendance").whereField("code", isEqualTo: code!)
        
        getStudents.getDocuments { (data, error) in
            guard let data = data?.documents else {
                return
            }
            
            for d in data {
                id = d.data()["id"]! as! String
            }
            
            getStudentsStatus.getDocuments { data, error in
                if error != nil { return }
                guard let data = data, error == nil else { return }
                
                for status in data.documents {
                    let keys = status.data().keys
                    for key in keys {
                        if key == todaysDay! {
                            let value = status.data()[key]
                            if let arr = value as? [Any] {
                                if let dict = arr[0] as? [String: Any] {
                                    for key in dict.keys {
                                        var sum = 0
                                        for k in dict[key] as! [Int] {
                                            sum += k
                                        }
                                        
                                        if key == id && StudentCollectionViewViewModel.numberOfTokens == 1 {
                                            dd[key] = [true, true]
                                        }else if(key == id && StudentCollectionViewViewModel.numberOfTokens == 0) {
                                            dd[key] = [true]
                                        }else if(sum == 2 && StudentCollectionViewViewModel.numberOfTokens == 1){
                                            dd[key] = [true, true]
                                        }else if(sum == 1 && StudentCollectionViewViewModel.numberOfTokens == 1){
                                            dd[key] = [true, false]
                                        }else if(sum == 0 && StudentCollectionViewViewModel.numberOfTokens == 1) {
                                            dd[key] = [false, false]
                                        }else if(sum == 1 && StudentCollectionViewViewModel.numberOfTokens == 0) {
                                            dd[key] = [true]
                                        }else if(sum == 0 && StudentCollectionViewViewModel.numberOfTokens == 0) {
                                            dd[key] = [false]
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                DatabaseManager.shared.database.collection("attendance").document(code!).setData([String(todaysDay!): [dd]], merge: true) { [weak self] error in
                    guard error == nil else {
                        return
                    }
                    
                    let alertController = UIAlertController(title: "Success.", message: "Attendance was put successfully.", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Done", style: .default))
                    self?.present(alertController, animated: true)
                }
            }
        }
    }
    
    @objc private func closeAction() {
        dismiss(animated: true)
    }
    
    private func layout() {
        view.addSubview(navStackView)
        view.addSubview(subjectStackView)
        view.addSubview(separatorLineView1)
        view.addSubview(recipientStackView)
        view.addSubview(separatorLineView2)
        view.addSubview(sentDateStackView)
        view.addSubview(separatorLineView3)
        view.addSubview(messageTF)
        
        navStackView.addArrangedSubview(closeButton)
        navStackView.addArrangedSubview(acceptButton)
        navStackView.distribution = .equalSpacing
        
        subjectStackView.addArrangedSubview(subjectLabel)
        subjectStackView.addArrangedSubview(studentLabel)
    
        recipientStackView.addArrangedSubview(toLabel)
        recipientStackView.addArrangedSubview(fullSubjectCodeLabel)
        
        sentDateStackView.addArrangedSubview(toDateLabel)
        sentDateStackView.addArrangedSubview(sentDate)
        
        NSLayoutConstraint.activate([
            navStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            navStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            navStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15)
        ])
        
       
        NSLayoutConstraint.activate([
            subjectStackView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 20),
            subjectStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
        
        NSLayoutConstraint.activate([
            separatorLineView1.topAnchor.constraint(equalTo: subjectStackView.bottomAnchor, constant: 8),
            separatorLineView1.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            separatorLineView1.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            separatorLineView1.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        NSLayoutConstraint.activate([
            recipientStackView.topAnchor.constraint(equalTo: separatorLineView1.bottomAnchor, constant: 8),
            recipientStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
        
        NSLayoutConstraint.activate([
            separatorLineView2.topAnchor.constraint(equalTo: recipientStackView.bottomAnchor, constant: 8),
            separatorLineView2.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            separatorLineView2.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            separatorLineView2.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        NSLayoutConstraint.activate([
            sentDateStackView.topAnchor.constraint(equalTo: separatorLineView2.bottomAnchor, constant: 8),
            sentDateStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
        
        NSLayoutConstraint.activate([
            separatorLineView3.topAnchor.constraint(equalTo: sentDateStackView.bottomAnchor, constant: 8),
            separatorLineView3.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            separatorLineView3.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            separatorLineView3.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        NSLayoutConstraint.activate([
            messageTF.topAnchor.constraint(equalTo: separatorLineView3.bottomAnchor, constant: 8),
            messageTF.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            messageTF.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
}

