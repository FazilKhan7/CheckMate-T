//
//  AbsenceCell.swift
//  FirebaseCheck
//
//  Created by Bakhtiyarov Fozilkhon on 09.05.2023.
//

import Foundation
import UIKit

class AbsenceCell: UICollectionViewCell {
    
    static let absenceCell = "AbsenceCell"
    
    let date = makeLabel(fontSize: 15, color: #colorLiteral(red: 0, green: 0.1411764706, blue: 0.4117647059, alpha: 1), weight: .medium)
    let hour = makeLabel(fontSize: 15, color: #colorLiteral(red: 0, green: 0.1411764706, blue: 0.4117647059, alpha: 1), weight: .medium)
    let absenceImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "xmark")
        image.widthAnchor.constraint(equalToConstant: 28).isActive = true
        image.heightAnchor.constraint(equalToConstant: 28).isActive = true
        return image
    }()
    
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
    
    private func addAllSubviews() {
        contentView.addSubview(date)
        contentView.addSubview(hour)
        contentView.addSubview(absenceImage)
    }
    
    private func setup() {
        
    }
    
    private func layout() {
        NSLayoutConstraint.activate([
            date.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            date.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12)
        ])
        
        NSLayoutConstraint.activate([
            hour.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            hour.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            absenceImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            absenceImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12)
        ])
    }
}
