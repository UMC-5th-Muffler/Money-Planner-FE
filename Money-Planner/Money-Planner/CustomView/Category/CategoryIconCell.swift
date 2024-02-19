//
//  IconCell.swift
//  Money-Planner
//
//  Created by p_kxn_g on 2/16/24.
//

import Foundation
import UIKit

class CategoryIconCell: UICollectionViewCell {
    
    // Circular button
    let circularButton: UIImageView = {
        let button = UIImageView()
        button.backgroundColor = .clear
        button.layer.cornerRadius = 25
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.cgColor
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // Icon image view
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        // Add circular button to cell
        addSubview(circularButton)
        NSLayoutConstraint.activate([
            circularButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            circularButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            circularButton.widthAnchor.constraint(equalToConstant: 50),
            circularButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // Add icon image view to circular button
        circularButton.addSubview(iconImageView)
        NSLayoutConstraint.activate([
            iconImageView.centerXAnchor.constraint(equalTo: circularButton.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: circularButton.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 50),
            iconImageView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // Configure cell with icon image
    func configure(with iconImage: UIImage?) {
        iconImageView.image = iconImage
        iconImageView.accessibilityIdentifier = iconImage?.accessibilityIdentifier // 저장
    }
    
//    // Update cell selection state
//    override var isSelected: Bool {
//        didSet {
//            // Apply blur effect if cell is not selected
//            if isSelected {
//                iconImageView.alpha = 1.0 // Remove blur effect
//            } else {
//                iconImageView.alpha = 0.5 // Apply blur effect
//            }
//        }
//    }
}
