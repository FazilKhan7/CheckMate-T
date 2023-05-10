//
//  StudentAccountView.swift
//  FirebaseCheck
//
//  Created by Bakhtiyarov Fozilkhon on 06.05.2023.
//

import Foundation
import UIKit

class StudentAccountView: UIView {
    
    let name = makeLabel(fontSize: 20, color: #colorLiteral(red: 0, green: 0.2045772076, blue: 0.4879741669, alpha: 1), weight: .medium)
    let email = makeLabel(fontSize: 20, color: #colorLiteral(red: 0, green: 0.2045772076, blue: 0.4879741669, alpha: 1), weight: .thin)
    let stackView = makeStackView(axis: .vertical, spacing: 8)
    
    func updateLabels(n: String, e: String) {
        name.text = n
        email.text = e
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layer.cornerRadius = 10
        addAllSubviews()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 180, height: 70)
    }
    
    private func addAllSubviews() {
        stackView.addArrangedSubview(name)
        stackView.addArrangedSubview(email)
        addSubview(stackView)
    }
    
    private func layout() {
        stackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
    }
}
