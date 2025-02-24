//
//  GradiantButton.swift
//  VPN
//
//  Created by creative on 13/07/24.
//

import Foundation
import UIKit
public class GradiantButton: UIButton {

    public override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }

    private lazy var gradientLayer: CAGradientLayer = {
      let gradient: CAGradientLayer = CAGradientLayer()
      
      // Set green colors (modify these for your desired shades)
      let colorTop = UIColor(red: 0.35, green: 0.80, blue: 0.20, alpha: 1.0).cgColor  // Lighter green
      let colorBottom = UIColor(red: 0.20, green: 0.60, blue: 0.30, alpha: 1.0).cgColor // Darker green

      gradient.colors = [colorTop, colorBottom]
      gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
      gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
      gradient.frame = self.bounds
      gradient.cornerRadius = 20
      layer.insertSublayer(gradient, at: 0)
      return gradient
    }()
}
