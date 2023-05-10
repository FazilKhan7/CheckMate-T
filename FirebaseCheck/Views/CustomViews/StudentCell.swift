//
//  StudentCell.swift
//  FirebaseCheck
//
//  Created by Bakhtiyarov Fozilkhon on 29.03.2023.
//

import Foundation
import UIKit

class StudentCell: UICollectionViewCell {
    
    static let studentCell = "Student"
            
    let indexOfName = makeLabel(fontSize: 20, color: #colorLiteral(red: 0, green: 0.2045772076, blue: 0.4879741669, alpha: 1), weight: .medium)
    var nameAndSurname = makeLabel(fontSize: 20, color: #colorLiteral(red: 0, green: 0.2045772076, blue: 0.4879741669, alpha: 1), weight: .medium)
    
    let stackView = makeStackView(axis: .horizontal, spacing: 10)
    let verticalStackView = makeStackView(axis: .vertical, spacing: 5)
        
    var presentFirstButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 25).isActive = true
        button.heightAnchor.constraint(equalToConstant: 25).isActive = true
        button.sizeToFit()
        return button
    }()
    
    var presentSecondButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 25).isActive = true
        button.heightAnchor.constraint(equalToConstant: 25).isActive = true
        button.sizeToFit()
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    weak var viewModel: StudentCollectionViewCellViewModelType? {
        willSet(viewModel) {
            guard let viewModel = viewModel else {
                return
            }
            
            if viewModel.status == true && StudentViewController.refreshController == false && StudentCollectionViewViewModel.numberOfTokens == 1 {
                presentFirstButton.setImage(UIImage(named: "unchecked"), for: .normal)
                presentSecondButton.setImage(UIImage(named: "unchecked"), for: .normal)
            }else if viewModel.status == true && StudentViewController.refreshController == false && StudentCollectionViewViewModel.numberOfTokens == 0 {
                presentFirstButton.setImage(UIImage(named: "unchecked"), for: .normal)
                presentSecondButton.isHidden = true
            }
            
            if viewModel.attCount == 2 && StudentViewController.refreshController == true && StudentCollectionViewViewModel.numberOfTokens == 1 {
                presentFirstButton.setImage(UIImage(named: "attend"), for: .normal)
                presentSecondButton.setImage(UIImage(named: "attend"), for: .normal)
            }else if(viewModel.attCount == 1 && StudentViewController.refreshController == true && StudentCollectionViewViewModel.numberOfTokens == 1) {
                presentFirstButton.setImage(UIImage(named: "attend"), for: .normal)
                presentSecondButton.setImage(UIImage(named: "xmark"), for: .normal)
            }else if(viewModel.attCount == 0 && StudentViewController.refreshController == true && StudentCollectionViewViewModel.numberOfTokens == 1) {
                presentFirstButton.setImage(UIImage(named: "xmark"), for: .normal)
                presentSecondButton.setImage(UIImage(named: "xmark"), for: .normal)
            }else if(viewModel.attCount == 1 && StudentViewController.refreshController == true && StudentCollectionViewViewModel.numberOfTokens == 0) {
                presentFirstButton.setImage(UIImage(named: "attend"), for: .normal)
                presentSecondButton.isHidden = true
            }else if(viewModel.attCount == 0 && StudentViewController.refreshController == true && StudentCollectionViewViewModel.numberOfTokens == 0) {
                presentFirstButton.setImage(UIImage(named: "xmark"), for: .normal)
                presentSecondButton.isHidden = true
            }
        }
    }
    
    private func setup() {
        backgroundColor = .white
        nameAndSurname.numberOfLines = 0
        layer.cornerRadius = 10
    }
    
    private func layout() {
        contentView.addSubview(indexOfName)
        stackView.addArrangedSubview(nameAndSurname)
        stackView.addArrangedSubview(presentFirstButton)
        stackView.addArrangedSubview(presentSecondButton)
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            indexOfName.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            indexOfName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 11)
        ])
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: indexOfName.trailingAnchor, constant: 11),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -11),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
