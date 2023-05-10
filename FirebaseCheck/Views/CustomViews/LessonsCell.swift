//
//  LessonsCell.swift
//  FirebaseCheck
//
//  Created by Bakhtiyarov Fozilkhon on 24.03.2023.
//

import Foundation
import UIKit

class LessonsCell: UICollectionViewCell {
    
    static let lessonReuseID = "LessonCell"

    let stackView = makeStackView(axis: .vertical, spacing: 2)
    let HstackView = makeStackView(axis: .horizontal, spacing: 0)

    let startTime = makeLabel(fontSize: 15, color: #colorLiteral(red: 0, green: 0.1445877552, blue: 0.4285367131, alpha: 1), weight: .medium, text: "")
    let endTime = makeLabel(fontSize: 15, color: #colorLiteral(red: 0, green: 0.1445877552, blue: 0.4285367131, alpha: 1), weight: .medium, text: "")
    
    let subjectName = makeLabel(fontSize: 15, color: #colorLiteral(red: 0, green: 0.1445877552, blue: 0.4285367131, alpha: 1), weight: .bold, text: "")
    let subjectCode = makeLabel(fontSize: 15, color: #colorLiteral(red: 0, green: 0.1445877552, blue: 0.4285367131, alpha: 1), weight: .medium, text: "")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        subjectName.numberOfLines = 0
        subjectName.textAlignment = .center
        HstackView.distribution = .equalSpacing
        layer.cornerRadius = 10
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    weak var viewModel: LessonsCollectionViewCellViewModelType? {
        willSet(viewModel) {
            guard let viewModel = viewModel else {
                return
            }
            
            subjectCode.text = viewModel.subjectCode
            subjectName.text = viewModel.subjectName
            startTime.text = viewModel.startTime
            endTime.text = viewModel.endTime
            
        }
    }
}

extension LessonsCell  {
    
    private func layout() {
        
        stackView.addArrangedSubview(startTime)
        stackView.addArrangedSubview(endTime)
        
        HstackView.addArrangedSubview(stackView)
        HstackView.addArrangedSubview(subjectName)
        HstackView.addArrangedSubview(subjectCode)
        
        contentView.addSubview(HstackView)
        
        NSLayoutConstraint.activate([
            HstackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 11),
            HstackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -11),
            HstackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
