//
//  CategoryButton.swift
//  Money-Planner
//
//  Created by seonwoo on 2024/01/21.
//

import Foundation
import UIKit

protocol CategoryButtonDelegate{
    func onTapCategoryButton(categoryId : Int)
}

class CategoryButton: UIView {
    var delegate : CategoryButtonDelegate?
    
    var isSelected : Bool = false {
        didSet{
            setBackGroundColor()
        }
    }
    
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
        setBackGroundColor()
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapButton)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapButton)))
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
    
    func setBackGroundColor(){
        if(self.isSelected){
            backgroundColor = .mpMainColor
            textLabel.textColor = .mpWhite
            textLabel.font = .mpFont14B()
        }else{
            backgroundColor = UIColor(hexCode: "E4E6EB")
            textLabel.textColor = .mpBlack
            textLabel.font = .mpFont14M()
        }
    }
    
    @objc func onTapButton(){
        delegate?.onTapCategoryButton(categoryId: category.id)
    }
}

protocol CategoryButtonScrollDelegate{
    func onTapChangeCategory(categoryId : Int)
}

class CategoryButtonsScrollView: UIView , CategoryButtonDelegate{
    var delegate : CategoryButtonScrollDelegate?
    
    private var scrollView : UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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
    
    var categoryButtons : [CategoryButton] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Not implemented xib init")
    }
    
    func setupUI() {
        addSubview(scrollView)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.addSubview(stackView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.heightAnchor.constraint(equalTo: heightAnchor)
        ])
    }
    
    func bind() {
        categoryButtons.removeAll()
        
        for subview in stackView.arrangedSubviews {
            stackView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
        
        for category in categories {
            let categoryButton = CategoryButton()
            categoryButton.delegate = self
            categoryButton.category = category
            categoryButtons.append(categoryButton)
            
            stackView.addArrangedSubview(categoryButton)
        }
        
        if let firstButton = categoryButtons.first {
            firstButton.isSelected = true
        }
    }
    
    func changeSelectedButton(index : Int){
        if let targetButton = categoryButtons.first(where: { $0.category.id == index }) {
            targetButton.isSelected = true
            
            for button in categoryButtons where button !== targetButton {
                button.isSelected = false
            }
        }
    }
}

extension CategoryButtonsScrollView {
    func onTapCategoryButton(categoryId: Int) {
        delegate?.onTapChangeCategory(categoryId: categoryId)
        
        if let targetButton = categoryButtons.first(where: { $0.category.id == categoryId }) {
            targetButton.isSelected = true
            
            for button in categoryButtons where button !== targetButton {
                button.isSelected = false
            }
        }
    }
}
