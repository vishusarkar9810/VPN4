////
////  GradiantImageBorder.swift
////  OVOApp
////
////  Created by Creative on 27/01/24.
////
//
//import Foundation
//
//import UIKit
//
//@IBDesignable
//class GradientBorderImageView: UIImageView {
//    
//    @IBInspectable var startColor: UIColor = .red
//    @IBInspectable var endColor: UIColor = .blue
//    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        setupBorder()
//    }
//    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        setupBorder()
//    }
//    
//    private func setupBorder() {
//        // Remove any existing layers with the name "gradientBorder"
//        layer.sublayers?.filter { $0.name == "gradientBorder" }.forEach { $0.removeFromSuperlayer() }
//        
//        // Create gradient layer
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.frame = bounds
//        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
//        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
//        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
//        
//        // Create shape layer for the border
//        let borderLayer = CAShapeLayer()
//        borderLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
//        borderLayer.fillColor = UIColor.clear.cgColor
//        borderLayer.strokeColor = UIColor.clear.cgColor // Set stroke color to clear
//        
//        // Mask the gradient layer with the border layer
//        gradientLayer.mask = borderLayer
//        
//        // Add the gradient layer to the image view's layer
//        layer.addSublayer(gradientLayer)
//    }
//}
//
