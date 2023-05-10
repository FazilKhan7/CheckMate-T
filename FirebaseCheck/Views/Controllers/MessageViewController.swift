//
//  MessageViewController.swift
//  FirebaseCheck
//
//  Created by Bakhtiyarov Fozilkhon on 26.04.2023.
//

import Foundation
import UIKit

class MessageViewController: UIViewController {
    
    let messageLabel = makeLabel(fontSize: 20, color: #colorLiteral(red: 0, green: 0.2045772076, blue: 0.4879741669, alpha: 1), weight: .medium)
    var isTapped: Bool = false
    private let refreshControl = UIRefreshControl()
    
    let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    let sectionInsets = UIEdgeInsets(top: 8, left: 11, bottom: 8, right: 11)
    
    private var messageViewModel: MessageViewModelType?
    private var accountInfoView: AccountInfoViewModelType?
    private var studentViewModel: StudentViewModelType?
    var detailVC = DetailMessageViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        detailVC.acceptDelegation = self
        messageLabel.text = "ChekMate"
        
        let accountInfoViewModel = AccountInfoViewModel(
            student: Student(name: UserDefaults.standard.value(forKey: "name") as? String ?? "",
                             surname: UserDefaults.standard.value(forKey: "surname") as? String ?? "",
                             email: UserDefaults.standard.value(forKey: "email") as? String ?? "")
        )
                
        let messageCollectionViewViewModel = MessageCollectionViewViewModel()
        
        messageViewModel = MessageViewModel(messageCollectionViewViewModel: messageCollectionViewViewModel)
        
        messageViewModel?.messageCollectionViewViewModel?.queryLessons(code: "\(accountInfoViewModel.student.name.lowercased()).\(accountInfoViewModel.student.surname.lowercased())", completion: {
            [weak self] in
            self?.collectionView.reloadData()
        })
        
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        
        addAllSubViews()
        setup()
        layout()
    }
    
    @objc private func refreshData(_ sender: Any) {
        let accountInfoViewModel = AccountInfoViewModel(
            student: Student(name: UserDefaults.standard.value(forKey: "name") as? String ?? "",
                             surname: UserDefaults.standard.value(forKey: "surname") as? String ?? "",
                             email: UserDefaults.standard.value(forKey: "email") as? String ?? "")
        )
        
        messageViewModel?.messageCollectionViewViewModel?.queryLessons(code: "\(accountInfoViewModel.student.name.lowercased()).\(accountInfoViewModel.student.surname.lowercased())", completion: {
            [weak self] in
            self?.collectionView.reloadData()
        })
        collectionView.reloadData()
        refreshControl.endRefreshing()
    }
    
    @objc private func labelTapped() {
        isTapped = true
    }
    
    private func setup() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.register(MessageCell.self, forCellWithReuseIdentifier: MessageCell.reuseMessageId)
    }
    
    private func addAllSubViews() {
        view.addSubview(messageLabel)
        view.addSubview(collectionView)
    }
    
    
    private func layout() {
        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 7),
            messageLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: messageLabel.bottomAnchor,constant: 12),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 11),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -11),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension MessageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 1
        let paddingWidth = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingWidth
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 11, bottom: 8, right: 11)
    }
}

extension MessageViewController: UICollectionViewDelegate {
    
}

extension MessageViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messageViewModel?.messageCollectionViewViewModel?.numberOfRows() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MessageCell.reuseMessageId, for: indexPath) as! MessageCell
        
        let cellViewModel = messageViewModel?.messageCollectionViewViewModel?.cellViewModel(for: indexPath)
        
        cell.sendTime.text = cellViewModel?.sendTime
        cell.reasonMessage.text = cellViewModel?.reasonOfAbsence
        cell.classCode.text = cellViewModel?.subCode
        cell.readLabel.image = UIImage(systemName: "checkmark")?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = DetailMessageViewController()
                
        let cellViewModel = messageViewModel?.messageCollectionViewViewModel?.cellViewModel(for: indexPath)
        
        if let cell = collectionView.cellForItem(at: indexPath) as? MessageCell {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                cell.readLabel.image = UIImage(systemName: "checkmark.seal.fill")?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)
            }
        }
        
//        let todaysDay = cellViewModel?.classTime
//        let code = cellViewModel?.subCode
//        let sender = cellViewModel?.sender
//
//        let splitSender = sender!.components(separatedBy: " ")
//        let nameOfStudent = splitSender[0]
//        let surnameOfStudent = splitSender[1]
//        var id: String = ""
//
//        let getStudents = DatabaseManager.shared.database.collection("students").whereField("name", isEqualTo: nameOfStudent)
//            .whereField("surname", isEqualTo: surnameOfStudent)
//
//        var dd: [String: [Bool]] = [:]
//        let getStudentsStatus = DatabaseManager.shared.database.collection("attendance").whereField("code", isEqualTo: code!)
//
//        getStudents.getDocuments { (data, error) in
//            guard let data = data?.documents else {
//                return
//            }
//
//            for d in data {
//                id = d.data()["id"]! as! String
//            }
//
//            getStudentsStatus.getDocuments { data, error in
//                if error != nil { return }
//                guard let data = data, error == nil else { return }
//
//                for status in data.documents {
//                    let keys = status.data().keys
//                    for key in keys {
//                        if key == todaysDay! {
//                            let value = status.data()[key]
//                            if let arr = value as? [Any] {
//                                if let dict = arr[0] as? [String: Any] {
//                                    for key in dict.keys {
//                                        var sum = 0
//                                        for k in dict[key] as! [Int] {
//                                            sum += k
//                                        }
//
//                                        if key == id && StudentCollectionViewViewModel.numberOfTokens == 1 {
//                                            dd[key] = [true, true]
//                                        }else if(key == id && StudentCollectionViewViewModel.numberOfTokens == 0) {
//                                            dd[key] = [true]
//                                        }else if(sum == 2 && StudentCollectionViewViewModel.numberOfTokens == 1){
//                                            dd[key] = [true, true]
//                                        }else if(sum == 1 && StudentCollectionViewViewModel.numberOfTokens == 1){
//                                            dd[key] = [true, false]
//                                        }else if(sum == 0 && StudentCollectionViewViewModel.numberOfTokens == 1) {
//                                            dd[key] = [false, false]
//                                        }else if(sum == 1 && StudentCollectionViewViewModel.numberOfTokens == 0) {
//                                            dd[key] = [true]
//                                        }else if(sum == 0 && StudentCollectionViewViewModel.numberOfTokens == 0) {
//                                            dd[key] = [false]
//                                        }
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//                DatabaseManager.shared.database.collection("attendance").document(code!).setData([todaysDay!: [dd]], merge: true)
//            }
//        }
        
        vc.messageTF.text = cellViewModel?.reasonOfAbsence
        vc.studentLabel.text = cellViewModel?.sender
        vc.fullSubjectCodeLabel.text = cellViewModel?.subCode
        vc.sentDate.text = "\(cellViewModel?.sendDate ?? ""), \(cellViewModel?.classTime ?? "")"
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}

extension MessageViewController: TappedButtonForAcception {
    func isTappedDelegate() {
        print("YESS TAPPED DELEGATION")
    }
}



