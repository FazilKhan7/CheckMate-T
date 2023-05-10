//
//  Factory.swift
//  FirebaseCheck
//
//  Created by Bakhtiyarov Fozilkhon on 18.03.2023.
//

import Foundation
import UIKit

func makeStackView(axis: NSLayoutConstraint.Axis, spacing: CGFloat) -> UIStackView {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = axis
    stackView.spacing = spacing
    
    return stackView
}

func makeLabel(fontSize: CGFloat, color: UIColor? = nil, weight: UIFont.Weight, text: String? = nil) -> UILabel {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.systemFont(ofSize: fontSize, weight: weight)
    
    if let color = color {
        label.textColor = color
    }
    
    if let text = text {
        label.text = text
    }
    
    return label
}


func getGradientLayer(bounds : CGRect) -> CAGradientLayer{
    let gradient = CAGradientLayer()
    gradient.frame = bounds
    //order of gradient colors
    
    gradient.colors = [
        UIColor(red: 0.608, green: 0.157, blue: 0.165, alpha: 1).cgColor,
        UIColor(red: 0, green: 0.141, blue: 0.412, alpha: 1).cgColor
      ]
    
    // start and end points
    gradient.startPoint = CGPoint(x: 0.9, y: 0.9)
    gradient.endPoint = CGPoint(x: 0.1, y: 0.1)
    return gradient
}

func gradientColor(bounds: CGRect, gradientLayer :CAGradientLayer) -> UIColor? {
    UIGraphicsBeginImageContext(gradientLayer.bounds.size)
    //create UIImage by rendering gradient layer.

    gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    //get gradient UIcolor from gradient UIImage
    return UIColor(patternImage: image!)
}
