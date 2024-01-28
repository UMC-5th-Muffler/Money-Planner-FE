//
//  EditGoalViewController.swift
//  Money-Planner
//
//  Created by Jini on 2024/01/26.
//

import Foundation
import UIKit

class EditGoalViewController : UIViewController {
    
    let headerView = HeaderwithDeleteView(title:"소비목표 수정")
    
    let contentScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .white
        scrollView.showsVerticalScrollIndicator = false
        
        return scrollView
    }()
    
    let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.mpWhite
        
        return view
    }()
    
    let tempview : UIView = {
        let view = UIView()
        view.layer.cornerRadius = 38
        view.clipsToBounds = true
        view.backgroundColor = UIColor(hexCode: "#C4C4C4")
        
        return view
    }()
    
    let goalNameLabel = SmallDescriptionView(text: "목표 이름", alignToCenter: false)
    let goalNameTextfield = MainTextField(placeholder: "", iconName: "icon_Paper")
    let characterCountLabel = UILabel()
    
    let goalPeriodLabel = SmallDescriptionView(text: "목표 기간", alignToCenter: false)
    let goalPeriodTextfield = LockedTextField(placeholder: "", iconName: "icon_date")
    let dateLabel = UILabel()
    let totalPeriodLabel = UILabel()
    
    let goalBudgetLabel = SmallDescriptionView(text: "목표 예산", alignToCenter: false)
    let goalBudgetTextfield = LockedTextField(placeholder: "", iconName: "icon_Wallet")
    let numAmount = UILabel()
    let charAmount = UILabel()
    let wonLabel = UILabel()
    
    let moreLabel = SmallDescriptionView(text: "자세히", alignToCenter: false)
    
    var verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 40
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    let nextBtn = MainBottomBtn(title: "다음")
    
    override func viewDidLoad(){
        view.backgroundColor = UIColor.mpWhite
        view.addSubview(contentScrollView)
        contentScrollView.addSubview(contentView)
        contentScrollView.contentInset = UIEdgeInsets(top: headerView.frame.height, left: 0, bottom: 0, right: 0)
        
        setupHeader()
        
        NSLayoutConstraint.activate([
            contentScrollView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 10),
            contentScrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            contentScrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            contentScrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: contentScrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: contentScrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: contentScrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: contentScrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: contentScrollView.widthAnchor)
        ])
        
        setupImageEdit()
        setupNameEdit()
        setupPeriodEdit()
        setupBudgetEdit()
        setupMore()
        setupNextButton()
        
        goalNameTextfield.delegate = self
    }
    
}

extension EditGoalViewController : UIScrollViewDelegate, UITextFieldDelegate {
    func setupHeader() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerView)
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: -25),
            headerView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            headerView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            headerView.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    func setupImageEdit() {
        tempview.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(tempview)
        
        NSLayoutConstraint.activate([
            tempview.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 25),
            tempview.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            tempview.heightAnchor.constraint(equalToConstant: 76),
            tempview.widthAnchor.constraint(equalToConstant: 76)
        ])
    }
    
    func setupNameEdit() {
        goalNameLabel.translatesAutoresizingMaskIntoConstraints = false
        goalNameTextfield.translatesAutoresizingMaskIntoConstraints = false
        characterCountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        //iconContainerView
        contentView.addSubview(goalNameLabel)
        contentView.addSubview(goalNameTextfield)
        contentView.addSubview(characterCountLabel)
        
        // Character count label setup
        characterCountLabel.text = "0/17"
        characterCountLabel.font = UIFont.mpFont14M()
        characterCountLabel.textColor = UIColor.mpDarkGray
        characterCountLabel.textAlignment = .right
        
        NSLayoutConstraint.activate([
            goalNameLabel.topAnchor.constraint(equalTo: tempview.bottomAnchor, constant: 26),
            goalNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 19),
            goalNameLabel.heightAnchor.constraint(equalToConstant: 18),
            
            goalNameTextfield.topAnchor.constraint(equalTo: goalNameLabel.bottomAnchor, constant: 8),
            goalNameTextfield.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 19),
            goalNameTextfield.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -19),
            goalNameTextfield.heightAnchor.constraint(equalToConstant: 64),
            
            characterCountLabel.centerYAnchor.constraint(equalTo: goalNameTextfield.centerYAnchor),
            characterCountLabel.trailingAnchor.constraint(equalTo: goalNameTextfield.trailingAnchor, constant: -20)
        ])
        
        goalNameTextfield.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }
        characterCountLabel.text = "\(text.count)/17"
    }
    
    func setupPeriodEdit() {
        goalPeriodLabel.translatesAutoresizingMaskIntoConstraints = false
        goalPeriodTextfield.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        totalPeriodLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(goalPeriodLabel)
        contentView.addSubview(goalPeriodTextfield)
        contentView.addSubview(dateLabel)
        contentView.addSubview(totalPeriodLabel)
        
        dateLabel.text = "7월 7일 - 7월 21일"
        dateLabel.font = UIFont.mpFont20M()
        dateLabel.textColor = UIColor.mpGray
        
        totalPeriodLabel.text = "n주"
        totalPeriodLabel.font = UIFont.mpFont20M()
        totalPeriodLabel.textColor = UIColor.mpMainColor
        totalPeriodLabel.textAlignment = .right
        
        NSLayoutConstraint.activate([
            goalPeriodLabel.topAnchor.constraint(equalTo: goalNameTextfield.bottomAnchor, constant: 26),
            goalPeriodLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 19),
            goalPeriodLabel.heightAnchor.constraint(equalToConstant: 18),
            
            goalPeriodTextfield.topAnchor.constraint(equalTo: goalPeriodLabel.bottomAnchor, constant: 8),
            goalPeriodTextfield.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 19),
            goalPeriodTextfield.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -19),
            goalPeriodTextfield.heightAnchor.constraint(equalToConstant: 64),
            
            dateLabel.centerYAnchor.constraint(equalTo: goalPeriodTextfield.centerYAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: goalPeriodTextfield.leadingAnchor, constant: 60),
            
            totalPeriodLabel.centerYAnchor.constraint(equalTo: goalPeriodTextfield.centerYAnchor),
            totalPeriodLabel.trailingAnchor.constraint(equalTo: goalPeriodTextfield.trailingAnchor, constant: -20)
        ])
    }
    
    func setupBudgetEdit() {
        goalBudgetLabel.translatesAutoresizingMaskIntoConstraints = false
        goalBudgetTextfield.translatesAutoresizingMaskIntoConstraints = false
        wonLabel.translatesAutoresizingMaskIntoConstraints = false
        numAmount.translatesAutoresizingMaskIntoConstraints = false
        charAmount.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(goalBudgetLabel)
        contentView.addSubview(goalBudgetTextfield)
        contentView.addSubview(wonLabel)
        contentView.addSubview(numAmount)
        contentView.addSubview(charAmount)
        
        numAmount.text = "140,000"
        numAmount.font = UIFont.mpFont20M()
        numAmount.textColor = UIColor.mpGray
        
        charAmount.text = "14만"
        charAmount.font = UIFont.mpFont14M()
        charAmount.textColor = UIColor(hexCode: "#C4C4C4")
        
        wonLabel.text = "원"
        wonLabel.font = UIFont.mpFont20M()
        wonLabel.textColor = UIColor.mpGray
        wonLabel.textAlignment = .right
        
        NSLayoutConstraint.activate([
            goalBudgetLabel.topAnchor.constraint(equalTo: goalPeriodTextfield.bottomAnchor, constant: 26),
            goalBudgetLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 19),
            goalBudgetLabel.heightAnchor.constraint(equalToConstant: 18),
            
            goalBudgetTextfield.topAnchor.constraint(equalTo: goalBudgetLabel.bottomAnchor, constant: 8),
            goalBudgetTextfield.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 19),
            goalBudgetTextfield.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -19),
            goalBudgetTextfield.heightAnchor.constraint(equalToConstant: 64),
            
            numAmount.centerYAnchor.constraint(equalTo: goalBudgetTextfield.centerYAnchor),
            numAmount.leadingAnchor.constraint(equalTo: goalBudgetTextfield.leadingAnchor, constant: 60),
            
            charAmount.centerYAnchor.constraint(equalTo: goalBudgetTextfield.centerYAnchor),
            charAmount.leadingAnchor.constraint(equalTo: numAmount.trailingAnchor, constant: 5),
            
            wonLabel.centerYAnchor.constraint(equalTo: goalBudgetTextfield.centerYAnchor),
            wonLabel.trailingAnchor.constraint(equalTo: goalBudgetTextfield.trailingAnchor, constant: -20)
        ])
    }
    
    func setupMore() {
        let chevronButton1 = UIButton()
        chevronButton1.setImage(UIImage(systemName: "chevron.right"), for: .normal) // 이미지 변경 예정
        chevronButton1.tintColor = .black
        
        let chevronButton2 = UIButton()
        chevronButton2.setImage(UIImage(systemName: "chevron.right"), for: .normal) //이거 왜 화살표 이상한데 가있지....
        chevronButton2.tintColor = .black
        
        let editByCategory = createListLabel(title: "카테고리별 목표 수정")
        let editByDate = createListLabel(title: "날짜별 목표 수정")
        
        let firstStackView = UIStackView(arrangedSubviews: [editByCategory, chevronButton1])
        firstStackView.axis = .horizontal
        firstStackView.distribution = .fill
        firstStackView.alignment = .center
        firstStackView.spacing = 8
        
        let secondStackView = UIStackView(arrangedSubviews: [editByDate, chevronButton2])
        secondStackView.axis = .horizontal
        secondStackView.distribution = .fill
        secondStackView.alignment = .center
        secondStackView.spacing = 8
        
        verticalStackView.addArrangedSubview(firstStackView)
        verticalStackView.addArrangedSubview(secondStackView)
        
        contentView.addSubview(moreLabel)
        contentView.addSubview(verticalStackView)
        
        moreLabel.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            moreLabel.topAnchor.constraint(equalTo: goalBudgetTextfield.bottomAnchor, constant: 55),
             moreLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 19),
             moreLabel.heightAnchor.constraint(equalToConstant: 18),
                     
             verticalStackView.topAnchor.constraint(equalTo: moreLabel.bottomAnchor, constant: 25),
             verticalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
             verticalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
    }
    
    
    func setupNextButton(){
        nextBtn.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nextBtn)
        
        NSLayoutConstraint.activate([
            nextBtn.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            nextBtn.topAnchor.constraint(equalTo: verticalStackView.bottomAnchor, constant: 50),
            nextBtn.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            nextBtn.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nextBtn.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            nextBtn.heightAnchor.constraint(equalToConstant: 55)
        ])
    }
    
    func createListLabel(title: String) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = UIFont.mpFont20M()
        label.textColor = UIColor.mpBlack
        return label
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0 {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        } else {
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == goalNameTextfield {
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            
            return updatedText.count <= 17
        }

        return true
    }
}

class HeaderwithDeleteView: UIView {
    
    private let backButton = UIButton()
    private let titleLabel = MPLabel()
    private let deleteButton = UIButton(type: .system)
    
    init(title: String, frame: CGRect = .zero) {
        super.init(frame: frame)
        setupBackButton()
        setupDeleteButton()
        setupTitleLabel(with: title)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //추후 색 변환 가능
    private func setupBackButton() {
        if let chevronImage = UIImage(systemName: "chevron.left")?.withRenderingMode(.alwaysOriginal) {
            let darkGrayChevron = chevronImage.withTintColor(.mpGray)
            backButton.setImage(darkGrayChevron, for: .normal)
        }
        addSubview(backButton)
    }
    
    // 삭제 버튼 설정
    private func setupDeleteButton() {
        deleteButton.setTitle("삭제", for: .normal)
        deleteButton.titleLabel?.font = UIFont.mpFont18M()
        deleteButton.setTitleColor(UIColor.mpRed, for: .normal) // 버튼 텍스트의 색상 설정
        addSubview(deleteButton)
    }
    
    //나중에 action을 필요에 따라 설정한다.
    public func addBackButtonTarget(target: Any?, action: Selector, for controlEvents: UIControl.Event) {
        backButton.addTarget(target, action: action, for: controlEvents)
    }
    
    //받은 제목에 맞춰서 title 수정
    private func setupTitleLabel(with title: String) {
        titleLabel.text = title
        titleLabel.font = UIFont.mpFont18B()
        titleLabel.textAlignment = .center
        addSubview(titleLabel)
    }
    
    //headerView 내부 contraint
    private func setupConstraints() {
        backButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            backButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            deleteButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
}

class SmallDescriptionView: MPLabel {
    // 초기화 메소드
    init(text: String, alignToCenter: Bool) {
        super.init(frame: .zero)
        self.text = text
        self.textAlignment = alignToCenter ? .center : .left
        self.textColor = UIColor.mpGray
        self.font = UIFont.mpFont14B()
        self.numberOfLines = 0  // 여러 줄 표시 가능
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class LockedTextField: UITextField {
    let systemIconImageView = UIImageView()
    // 초기화 메소드
    init(placeholder: String, iconName: String, keyboardType: UIKeyboardType = .default,frame:CGRect = .zero) {
        super.init(frame: frame)
        setupTextField(placeholder: placeholder, iconName: iconName,keyboardType: keyboardType)
        isUserInteractionEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTextField(placeholder: String, iconName: String,  keyboardType: UIKeyboardType) {
        self.placeholder = placeholder

        layer.cornerRadius = 8
        layer.masksToBounds = true
        layer.borderColor = UIColor.mpLightGray.cgColor
        layer.borderWidth = 1.0
        textColor = UIColor.mpGray
        font = UIFont.mpFont20M()
        backgroundColor = .mpWhite
        self.keyboardType = keyboardType
        
        // 텍스트 필드에 시스템 아이콘 이미지 추가
        systemIconImageView.image = UIImage(named: iconName)
        systemIconImageView.tintColor = UIColor.mpMainColor// 시스템 아이콘 이미지 색상 설정
        //systemIconImageView.contentMode = .scaleAspectFit

        // 아이콘 이미지 크기와 여백 설정
        let iconSize: CGFloat = 25
        let iconContainerView = UIView(frame: CGRect(x: 0, y: 0, width: iconSize, height: iconSize))
        iconContainerView.addSubview(systemIconImageView)

        systemIconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            systemIconImageView.leadingAnchor.constraint(equalTo: iconContainerView.leadingAnchor, constant: 20),
            systemIconImageView.trailingAnchor.constraint(equalTo: iconContainerView.trailingAnchor, constant:-16),
            systemIconImageView.topAnchor.constraint(equalTo: iconContainerView.topAnchor),
            systemIconImageView.bottomAnchor.constraint(equalTo: iconContainerView.bottomAnchor)
        ])

        leftView = iconContainerView
        leftViewMode = .always
    
    }
    
    
}
