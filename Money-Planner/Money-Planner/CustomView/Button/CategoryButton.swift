//
//  CategoryButton.swift
//  Money-Planner
//
//  Created by seonwoo on 2024/01/21.
//

import Foundation
import UIKit

class CategoryButton: UIView {
    
    var category : Category = Category(id: -1, name: "테스트"){
        didSet{
            textLabel.text = category.name
        }
    }
    
    var textLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = UIColor.mpWhite
        label.textAlignment = .center
        label.font = UIFont.mpFont14B()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let circleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.mpWhite
        view.layer.cornerRadius = 6.5 // 동그라미의 반지름 설정
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    func setupUI() {
        
        let stackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.spacing = 8
            stackView.translatesAutoresizingMaskIntoConstraints = false
            return stackView
        }()
        
        textLabel.text = category.name
        // UIView의 기본적인 설정
        backgroundColor = .mpMainColor
        layer.cornerRadius = 18
        
        stackView.addArrangedSubview(circleView)
        stackView.addArrangedSubview(textLabel)
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 37),
            
            // StackView의 제약 설정
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            circleView.heightAnchor.constraint(equalToConstant: 13),
            circleView.widthAnchor.constraint(equalToConstant: 13),
        ])
    }
}

class CategoryButtonsScrollView: UIScrollView {
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var categories : [Category] = []{
        didSet{
            bind()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Not implemented xib init")
    }
    
    func setupUI() {
        showsHorizontalScrollIndicator = false
        
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.heightAnchor.constraint(equalTo: heightAnchor)
        ])
    }
    
    func bind() {
        for category in categories {
            let categoryButton = CategoryButton()
            categoryButton.category = category
            
            stackView.addArrangedSubview(categoryButton)
        }
    }
}
