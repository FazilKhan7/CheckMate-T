//
//  MessageCell.swift
//  FirebaseCheck
//
//  Created by Bakhtiyarov Fozilkhon on 26.04.2023.
//

import Foundation
import UIKit

class MessageCell: UICollectionViewCell {
    
    static let reuseMessageId = "Message"
    
    let classCode = makeLabel(fontSize: 20, color: #colorLiteral(red: 0.22167027, green: 0.2620023489, blue: 0.3193107247, alpha: 1), weight: .medium)
    let sendTime = makeLabel(fontSize: 20, color: #colorLiteral(red: 0.22167027, green: 0.2620023489, blue: 0.3193107247, alpha: 1), weight: .medium)
    let reasonMessage = makeLabel(fontSize: 17, color: #colorLiteral(red: 0.22167027, green: 0.2620023489, blue: 0.3193107247, alpha: 1), weight: .thin)
    let readLabel: UIImageView = {
        let label = UIImageView()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let stackView = makeStackView(axis: .horizontal, spacing: 5)
    let readStackView = makeStackView(axis: .horizontal, spacing: 5)
    let stackViewGen = makeStackView(axis: .vertical, spacing: 7)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layer.cornerRadius = 10
        layout()
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        readStackView.distribution = .fill
        readLabel.setContentHuggingPriority(.required, for: .horizontal)
        readLabel.contentMode = .right
        stackView.addArrangedSubview(classCode)
        stackView.addArrangedSubview(sendTime)
        readStackView.addArrangedSubview(reasonMessage)
        readStackView.addArrangedSubview(readLabel)
        stackViewGen.addArrangedSubview(stackView)
        stackViewGen.addArrangedSubview(readStackView)
        contentView.addSubview(stackViewGen)
    }
    
    public func setUp() {
        NSLayoutConstraint.activate([
            stackViewGen.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            stackViewGen.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            stackViewGen.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
    }
}
