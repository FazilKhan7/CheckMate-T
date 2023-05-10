//
//  HomeViewController.swift
//  FirebaseCheck
//
//  Created by Bakhtiyarov Fozilkhon on 18.03.2023.
//

import Foundation
import UIKit

class HomeViewController: UIViewController {
    
    private var homeViewModel: HomeViewModelType?
    
    let accountInfoView = AccountInfoView()
    let signOutButton = UIButton()
    let appTitle = makeLabel(fontSize: 24, color: #colorLiteral(red: 0, green: 0.2045772076, blue: 0.4879741669, alpha: 1), weight: .bold, text: "CheckMate")
    
    static var delegateStr: String = ""
    
    let myClassesLabel = makeLabel(fontSize: 28, weight: .semibold, text: "My Classes")
    
    let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    let sectionInsets = UIEdgeInsets(top: 8, left: 15, bottom: 8, right: 15)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let collectionViewViewModel = CollectionViewViewModel()
        
        //Getting from UserDefaults
        let accountInfoViewModel = AccountInfoViewModel(
            student: Student(name: UserDefaults.standard.value(forKey: "name") as? String ?? "",
                             surname: UserDefaults.standard.value(forKey: "surname") as? String ?? "",
                             email: UserDefaults.standard.value(forKey: "email") as? String ?? "")
        )
        
        homeViewModel = HomeViewModel(collectionViewViewModel: collectionViewViewModel, accountInfoViewModel: accountInfoViewModel)
        
        homeViewModel?.collectionViewViewModel?.querySubjects(
            name: accountInfoViewModel.student.name,
            surname: accountInfoViewModel.student.surname,
            completion: { [weak self] in
                self?.collectionView.reloadData()
            })
        
        signOut()
        setup()
        addAllSubViews()
        layout()
    }
    
    private func signOut() {
        appTitle.translatesAutoresizingMaskIntoConstraints = false
        signOutButton.translatesAutoresizingMaskIntoConstraints = false
        signOutButton.setImage(UIImage(systemName: "rectangle.portrait.and.arrow.right"), for: .normal)
        signOutButton.heightAnchor.constraint(equalToConstant: 28).isActive = true
        signOutButton.widthAnchor.constraint(equalToConstant: 28).isActive = true
        signOutButton.tintColor = #colorLiteral(red: 0, green: 0.2045772076, blue: 0.4879741669, alpha: 1)
        signOutButton.addTarget(self, action: #selector(didTapSignOut), for: .primaryActionTriggered)
    }
    
    @objc func didTapSignOut() {
        let actionSheet = UIAlertController(title: "Sign out", message: "Are you sure?", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        actionSheet.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { [weak self] _ in
            AuthManager.shared.signOut { success in
                if success {
                    DispatchQueue.main.async {
                        let vc = SignInViewController()
                        let navVC = UINavigationController(rootViewController: vc)
                        navVC.modalPresentationStyle = .fullScreen
                        self?.present(navVC, animated: true)
                    }
                }
            }
        }))
        present(actionSheet, animated: true)
    }
    
    private func setup() {
        accountInfoView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.register(ClassCell.self, forCellWithReuseIdentifier: ClassCell.reuseID)
        
        setupInfo()
        
        let db = DB()
        db.attendanceCourseStudentIDValue()
        testQuery()
    }
    
    private func addAllSubViews() {
        view.addSubview(appTitle)
        view.addSubview(signOutButton)
        view.addSubview(accountInfoView)
        view.addSubview(myClassesLabel)
        view.addSubview(collectionView)
    }
    
    private func layout() {
        
        NSLayoutConstraint.activate([
            appTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            appTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        NSLayoutConstraint.activate([
            signOutButton.centerYAnchor.constraint(equalTo: appTitle.centerYAnchor),
            signOutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            accountInfoView.topAnchor.constraint(equalTo: appTitle.bottomAnchor, constant: 16),
            accountInfoView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            accountInfoView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            accountInfoView.heightAnchor.constraint(equalToConstant: view.frame.size.height / 9)
        ])
        
        
        NSLayoutConstraint.activate([
            myClassesLabel.topAnchor.constraint(equalTo: accountInfoView.bottomAnchor, constant: 24),
            myClassesLabel.leadingAnchor.constraint(equalTo: accountInfoView.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: myClassesLabel.bottomAnchor, constant: 24),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    override func viewDidLayoutSubviews() {
        createGradientToLabel()
    }
    
    private func createGradientToLabel() {
        let gradient = getGradientLayer(bounds: myClassesLabel.bounds)
        
        myClassesLabel.textColor = gradientColor(bounds: myClassesLabel.bounds, gradientLayer: gradient)
    }
    
    private func setupInfo() {
        accountInfoView.fullName.text = homeViewModel?.accountInfoViewModel?.fullName
        accountInfoView.email.text = homeViewModel?.accountInfoViewModel?.email
    }
}



extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemsPerRow: CGFloat = 2
        let paddingWidth = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingWidth
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: sectionInsets.left, bottom: 8, right: sectionInsets.right)
    }
}

extension HomeViewController: UICollectionViewDelegate {
    
}

extension HomeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeViewModel?.collectionViewViewModel?.numberOfRows() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ClassCell.reuseID, for: indexPath) as! ClassCell
        
        let cellViewModel = homeViewModel?.collectionViewViewModel?.cellViewModel(for: indexPath)
        
        cell.viewModel = cellViewModel
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cellViewModel = homeViewModel?.collectionViewViewModel?.cellViewModel(for: indexPath)
        
        HomeViewController.delegateStr = cellViewModel!.subjectName
        let vc = LessonsViewController()
        let nv = UINavigationController(rootViewController: vc)
        nv.modalPresentationStyle = .fullScreen
        present(nv, animated: true)
    }
}
