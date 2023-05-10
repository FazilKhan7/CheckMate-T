//
//  StatisticsCell.swift
//  FirebaseCheck
//
//  Created by Bakhtiyarov Fozilkhon on 06.05.2023.
//

import Foundation
import UIKit

class StatisticsCell: UICollectionViewCell {
    
    static let statisticsCell = "StatisticsCell"
    
    let subName = makeLabel(fontSize: 17, color: #colorLiteral(red: 0, green: 0.2045772076, blue: 0.4879741669, alpha: 1), weight: .regular, text: "Design Patterns")
    
    let hoursLabel = makeLabel(fontSize: 20, color: #colorLiteral(red: 0, green: 0.2045772076, blue: 0.4879741669, alpha: 1), weight: .regular)
    
    let attendButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "attend"), for: .normal)
        button.widthAnchor.constraint(equalToConstant: 28).isActive = true
        button.heightAnchor.constraint(equalToConstant: 28).isActive = true
        return button
    }()
    
    let absenceButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "xmark"), for: .normal)
        button.widthAnchor.constraint(equalToConstant: 28).isActive = true
        button.heightAnchor.constraint(equalToConstant: 28).isActive = true
        return button
    }()
    
    let pButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "pbutton"), for: .normal)
        button.widthAnchor.constraint(equalToConstant: 28).isActive = true
        button.heightAnchor.constraint(equalToConstant: 28).isActive = true
        return button
    }()
    
    let viewDetailsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("View Details", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.6950817704, green: 0.724460423, blue: 0.7711529136, alpha: 1), for: .normal)
        return button
    }()

    
    let hoursCount = makeLabel(fontSize: 20, color: #colorLiteral(red: 0, green: 0.2045772076, blue: 0.4879741669, alpha: 1), weight: .regular)
    let attendCount = makeLabel(fontSize: 20, color: #colorLiteral(red: 0, green: 0.2045772076, blue: 0.4879741669, alpha: 1), weight: .regular)
    let absenceCount = makeLabel(fontSize: 20, color: #colorLiteral(red: 0, green: 0.2045772076, blue: 0.4879741669, alpha: 1), weight: .regular)
    let pCount = makeLabel(fontSize: 20, color: #colorLiteral(red: 0, green: 0.2045772076, blue: 0.4879741669, alpha: 1), weight: .regular)
    
    let hoursStackView = makeStackView(axis: .vertical, spacing: 10)
    let attendStackView = makeStackView(axis: .vertical, spacing: 10)
    let absensStackView = makeStackView(axis: .vertical, spacing: 10)
    let pStackView = makeStackView(axis: .vertical, spacing: 10)
    
    let vStackView = makeStackView(axis: .horizontal, spacing: 0)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        addAllSubview()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addAllSubview() {
        hoursStackView.addArrangedSubview(hoursLabel)
        hoursStackView.addArrangedSubview(hoursCount)
        
        attendStackView.addArrangedSubview(attendButton)
        attendStackView.addArrangedSubview(attendCount)
        
        absensStackView.addArrangedSubview(absenceButton)
        absensStackView.addArrangedSubview(absenceCount)
        
        pStackView.addArrangedSubview(pButton)
        pStackView.addArrangedSubview(pCount)
        
        vStackView.addArrangedSubview(hoursStackView)
        vStackView.addArrangedSubview(attendStackView)
        vStackView.addArrangedSubview(absensStackView)
        vStackView.addArrangedSubview(pStackView)
        
        contentView.addSubview(subName)
        contentView.addSubview(vStackView)
        contentView.addSubview(viewDetailsButton)
    }
    
    private func setup() {
        layer.cornerRadius = 10
        hoursCount.textAlignment = .center
        attendCount.textAlignment = .center
        absenceCount.textAlignment = .center
        pCount.textAlignment = .center
        subName.numberOfLines = 0
        subName.textAlignment = .center
        subName.lineBreakMode = .byWordWrapping
        vStackView.distribution = .equalSpacing
        backgroundColor = .white
    }
    
    private func layout() {
        
        NSLayoutConstraint.activate([
            subName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            subName.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            subName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            subName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])
        
        NSLayoutConstraint.activate([
            vStackView.topAnchor.constraint(equalTo: subName.bottomAnchor, constant: 12),
            vStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            vStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            viewDetailsButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -1),
            viewDetailsButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
    }
}
