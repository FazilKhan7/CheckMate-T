//
//  AccountInfoView.swift
//  FirebaseCheck
//
//  Created by Bakhtiyarov Fozilkhon on 18.03.2023.
//

import Foundation
import UIKit

class AccountInfoView: UIView {
    
    weak var accountInfoViewModel: AccountInfoViewModelType?
    
    private var gradientLayer = CAGradientLayer()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.image = UIImage(named: "avatar-man")
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    let stackView = makeStackView(axis: .vertical, spacing: 8)
    
    var fullName = makeLabel(fontSize: 16, color: .white, weight: .bold)
    
    var email = makeLabel(fontSize: 16, color: .white, weight: .medium)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
        layout()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        fullName.text = "Askar Askarov"
        email.text = "200107111@stu.sdu.edu.kz"
        
        createGradient()
    }
    
    private func layout() {
        addSubview(imageView)
        addSubview(stackView)
        
        stackView.addArrangedSubview(fullName)
        stackView.addArrangedSubview(email)
        
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        ])
        
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10)
        ])
    }
    
    private func createGradient() {
        gradientLayer.colors = [
          UIColor(red: 0, green: 0.141, blue: 0.412, alpha: 1).cgColor,
          UIColor(red: 0.608, green: 0.157, blue: 0.165, alpha: 1).cgColor
        ]
        gradientLayer.locations = [0.01, 1]
        gradientLayer.startPoint = CGPoint(x: 0.25, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0.75, y: 0.5)
        gradientLayer.bounds = bounds.insetBy(dx: -0.5 * bounds.size.width, dy: -0.5 * bounds.size.height)
        gradientLayer.position = center
        
        layer.addSublayer(gradientLayer)
        clipsToBounds = true
        layer.cornerRadius = 10
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: frame.size.width / 5.5),
            imageView.heightAnchor.constraint(equalToConstant: frame.size.width / 5.5),
        ])
        
        imageView.layer.cornerRadius = imageView.frame.size.height / 2
        
        gradientLayer.frame = layer.bounds
        
    }
    
    func accountInfo() {
        fullName.text = accountInfoViewModel?.fullName
        email.text = accountInfoViewModel?.email
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 100, height: 100)
    }
}
