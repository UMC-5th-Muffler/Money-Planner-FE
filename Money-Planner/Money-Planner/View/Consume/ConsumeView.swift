//
//  ConsumeView.swift
//  Money-Planner
//
//  Created by p_kxn_g on 2/5/24.
//

import Foundation
import UIKit

// [View] 소비등록/수정
class ConsumeView: UIView {
    
    
    // 오늘 날짜
    let currentDate = Date()
    let dateFormatter = DateFormatter()
    lazy var todayDate: String = {
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        return dateFormatter.string(from: currentDate)
    }()
    
    // MARK: - View
    
    // 헤더
    lazy var headerView = HeaderView(title: "소비내역 입력")
    
    // 카테고리 컨테이너뷰
    let catContainerView : UIView = {
        let uiView = UIView()
        uiView.backgroundColor = UIColor.mpGypsumGray
        uiView.layer.cornerRadius = 8
        uiView.translatesAutoresizingMaskIntoConstraints = false // Add this line
        return uiView
    }()
    
    // 달력 컨테이너뷰
    let calContainerView : UIView = {
        let uiView = UIView()
        uiView.layer.cornerRadius = 8
        uiView.backgroundColor = .mpGypsumGray
        uiView.translatesAutoresizingMaskIntoConstraints = false // Add this line
        return uiView
    }()
    
    // 반복 버튼 컨테이너뷰
    let containerview: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    
    // MARK: - TextField
    
    // 소비금액
    let amountTextField: UITextField = MainTextField(placeholder: "소비금액을 입력하세요", iconName: "icon_Wallet", keyboardType: .numberPad)
    // 카테고리
    let cateogoryTextField = MainTextField(placeholder: "카테고리를 입력해주세요", iconName: "icon_category", keyboardType: .default)
    // 제목
    let titleTextField = MainTextField(placeholder: "제목", iconName: "icon_Paper", keyboardType: .default)
    // 메모
    let memoTextField = MainTextField(placeholder: "메모", iconName: "icon_Edit", keyboardType: .default)
    // 달력
    let calTextField = MainTextField(placeholder: "", iconName: "icon_date", keyboardType: .default)
    // 반복 결과 버튼
    
    let resultbutton : UITextField = {
        let button = UITextField()
        button.layer.cornerRadius = 6
        button.layer.masksToBounds = true
        button.borderStyle = .none
        button.textColor = .mpDarkGray
        button.font = UIFont.mpFont16M()
        button.tintColor = UIColor.mpMainColor
        button.isUserInteractionEnabled = false
        button.text = ""
        return button
    }()
    
    // MARK: - Label
    
    // 소비금액 실시간 금액 표시
    let amountLabel: UILabel = {
        let label = UILabel()
        label.text = "0 원"
        label.font = UIFont.mpFont14M()
        label.textColor = UIColor.mpDarkGray
        return label
    }()
    
    // 제목 에러 표시
    let titleErrorLabel: UILabel = {
        let label = UILabel()
        label.text = "최대 16글자로 입력해주세요"
        label.font = UIFont.systemFont(ofSize : 11)// 폰트 사이즈
        label.textColor = UIColor.mpRed
        return label
    }()
    
    // 반복 라벨
    let repeatLabel : UILabel = {
        let label = UILabel()
        label.text = "반복"
        label.font = UIFont.mpFont16R()
        label.textColor = UIColor.mpDarkGray
        return label
    }()
    
    // MARK: - Button
    
    // 완료 버튼
    var completeButton = MainBottomBtn(title: "완료")
    
    // 카테고리 선택 버튼 추가
    lazy var categoryChooseButton: UIButton = {
        let button = UIButton()
        let arrowImage = UIImage(systemName:"pencil") // Replace "arrow_down" with the actual image name in your assets
        button.setImage(arrowImage, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true  // 클릭 활성화
        return button
        
    }()
    
    
    // 카테고리 선택 버튼 추가
    lazy var calChooseButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("오늘", for: .normal)
        button.titleLabel?.font = UIFont.mpFont20M()
        button.setTitleColor(UIColor.mpMainColor, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true  //클릭 활성화
        button.backgroundColor = .red
        return button
        
    }()
    
    // 반복 체크 버튼
    lazy var checkButton : CheckBtn = {
        let checkButton = CheckBtn()
        return checkButton
    }()
    
    // MARK: -
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        // 배경색상 추가
        backgroundColor = UIColor(named: "mpWhite")
        // 헤더
        //setupHeader()
        // 소비금액
        setupAmountTextField()
        // 카테고리
        setupCategoryTextField()
        // 제목
        setuptitleTextField()
        // 메모
        setupmemoTextField()
        // 날짜
        setupcalTextField()
        // 반복
        setupRepeatButton()
        // 완료 버튼 추가
        setupCompleteButton()
        
    }
    
    
    // 세팅 : 헤더
    private func setupHeader(){
        addSubview(headerView)
        headerView.backgroundColor = .red
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 60)
        ])
        
    }
   
    // 세팅 : 소비금액 추가
    private func setupAmountTextField() {
        addSubview(amountTextField)
        
        amountTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            amountTextField.topAnchor.constraint(equalTo: bottomAnchor, constant: 20),
            amountTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            amountTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            amountTextField.heightAnchor.constraint(equalToConstant: 64)
        ])
        // 원 추가
        let infoLabel: UILabel = {
            let label = UILabel()
            label.text = "원"
            label.textColor = UIColor.mpDarkGray
            label.font = UIFont.mpFont20M()
            return label
        }()
        
        let wonContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        wonContainerView.addSubview(infoLabel)
        
        // Set the frame for infoLabel relative to wonContainerView
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            infoLabel.leadingAnchor.constraint(equalTo: wonContainerView.leadingAnchor),
            infoLabel.trailingAnchor.constraint(equalTo: wonContainerView.trailingAnchor,constant: -25),
            infoLabel.topAnchor.constraint(equalTo: wonContainerView.topAnchor),
            infoLabel.bottomAnchor.constraint(equalTo: wonContainerView.bottomAnchor)
        ])
        
        amountTextField.rightView = wonContainerView
        amountTextField.rightViewMode = .always
        // 입력 중인 금액 표시 레이블 추가
        addSubview(amountLabel)
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            amountLabel.topAnchor.constraint(equalTo: amountTextField.bottomAnchor, constant: 8),
            amountLabel.leadingAnchor.constraint(equalTo: amountTextField.leadingAnchor),
            amountLabel.trailingAnchor.constraint(equalTo: amountTextField.trailingAnchor),
            amountLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    // 세팅 : 카테고리 텍스트 필트
    private func setupCategoryTextField(){
        
        addSubview(catContainerView)
        NSLayoutConstraint.activate([
            
            catContainerView.topAnchor.constraint(equalTo: amountLabel.bottomAnchor, constant: 10),
            catContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            catContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            catContainerView.heightAnchor.constraint(equalToConstant: 64)
        ])
        
        let buttonContainerView = UIView()
        buttonContainerView.translatesAutoresizingMaskIntoConstraints = false
        buttonContainerView.backgroundColor = .mpMainColor
        catContainerView.addSubview(buttonContainerView)
        
        NSLayoutConstraint.activate([
            buttonContainerView.widthAnchor.constraint(equalToConstant: 40),
            buttonContainerView.heightAnchor.constraint(equalToConstant: 40),
            buttonContainerView.centerYAnchor.constraint(equalTo: catContainerView.centerYAnchor),
            buttonContainerView.trailingAnchor.constraint(equalTo: catContainerView.trailingAnchor, constant: -16)
            
            
            
        ])
        buttonContainerView.addSubview(categoryChooseButton)
        
        // 클릭 되게 하려고.... 시도 중
        buttonContainerView.isUserInteractionEnabled = true
        categoryChooseButton.isUserInteractionEnabled = true
        buttonContainerView.layer.zPosition = 999
        
        
        NSLayoutConstraint.activate([
            categoryChooseButton.widthAnchor.constraint(equalToConstant: 40),  // 버튼의 폭 제약 조건 추가
            categoryChooseButton.heightAnchor.constraint(equalToConstant: 40), // 버튼의 높이 제약 조건 추가
            categoryChooseButton.leadingAnchor.constraint(equalTo: buttonContainerView.leadingAnchor),
            categoryChooseButton.trailingAnchor.constraint(equalTo: buttonContainerView.trailingAnchor),
            categoryChooseButton.topAnchor.constraint(equalTo: buttonContainerView.topAnchor),
            categoryChooseButton.bottomAnchor.constraint(equalTo: buttonContainerView.bottomAnchor)
        ])
        
        buttonContainerView.addSubview(cateogoryTextField)
        cateogoryTextField.translatesAutoresizingMaskIntoConstraints = false
        cateogoryTextField.isUserInteractionEnabled = false // 수정 불가능하도록 설정
        cateogoryTextField.textColor = UIColor.mpBlack
        cateogoryTextField.text = "카테고리를 선택해주세요"
        cateogoryTextField.backgroundColor = .clear
        NSLayoutConstraint.activate([
            
            cateogoryTextField.topAnchor.constraint(equalTo: catContainerView.topAnchor),
            cateogoryTextField.bottomAnchor.constraint(equalTo: catContainerView.bottomAnchor),
            cateogoryTextField.leadingAnchor.constraint(equalTo: catContainerView.leadingAnchor),
            cateogoryTextField.trailingAnchor.constraint(equalTo: buttonContainerView.leadingAnchor),

        ])
        
    }
    
    // 세팅 : 제목 텍스트 필트
    private func setuptitleTextField(){
        addSubview(titleTextField)
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: catContainerView.bottomAnchor, constant: 10),
            titleTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            titleTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            titleTextField.heightAnchor.constraint(equalToConstant: 64)
        ])
        
    }
    
    
    // 세팅 : 메모 텍스트 필트
    private func setupmemoTextField(){
        addSubview(memoTextField)
        memoTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            memoTextField.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 10),
            memoTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            memoTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            memoTextField.heightAnchor.constraint(equalToConstant: 64)
        ])
        
        // 간격 24
        let blank = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        memoTextField.rightView = blank
        memoTextField.rightViewMode = .always
    }
    // 세팅 : 달력 텍스트 필트
    private func setupcalTextField(){
        
        addSubview(calContainerView)
        NSLayoutConstraint.activate([
            
            calContainerView.topAnchor.constraint(equalTo: memoTextField.bottomAnchor, constant: 10),
            calContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            calContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            calContainerView.heightAnchor.constraint(equalToConstant: 64)
        ])
        
        let calbuttonContainerView = UIView()
        calbuttonContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        calbuttonContainerView.backgroundColor = .mpMainColor
        calContainerView.addSubview(calbuttonContainerView)
        
        NSLayoutConstraint.activate([
            calbuttonContainerView.widthAnchor.constraint(equalToConstant: 40),
            calbuttonContainerView.heightAnchor.constraint(equalToConstant: 40),
            calbuttonContainerView.centerYAnchor.constraint(equalTo: calContainerView.centerYAnchor),
            calbuttonContainerView.trailingAnchor.constraint(equalTo: catContainerView.trailingAnchor, constant: -16)
            
            
            
        ])
        calbuttonContainerView.addSubview(calChooseButton)
        
        // 클릭 가능하게 함
        calbuttonContainerView.isUserInteractionEnabled = true
        calChooseButton.isUserInteractionEnabled = true
        calbuttonContainerView.layer.zPosition = 999
        
        
        NSLayoutConstraint.activate([
            calChooseButton.widthAnchor.constraint(equalToConstant: 40),  // 버튼의 폭 제약 조건 추가
            calChooseButton.heightAnchor.constraint(equalToConstant: 40), // 버튼의 높이 제약 조건 추가
            calChooseButton.leadingAnchor.constraint(equalTo: calbuttonContainerView.leadingAnchor),
            calChooseButton.trailingAnchor.constraint(equalTo: calbuttonContainerView.trailingAnchor),
            calChooseButton.topAnchor.constraint(equalTo: calbuttonContainerView.topAnchor),
            calChooseButton.bottomAnchor.constraint(equalTo: calbuttonContainerView.bottomAnchor)
        ])
        
        calContainerView.addSubview(calTextField)
        calTextField.translatesAutoresizingMaskIntoConstraints = false
        calTextField.isUserInteractionEnabled = false // 수정 불가능하도록 설정
        calTextField.textColor = UIColor.mpBlack
        calTextField.text = todayDate
        
        NSLayoutConstraint.activate([
            
            calTextField.topAnchor.constraint(equalTo: calContainerView.topAnchor),
            calTextField.bottomAnchor.constraint(equalTo: calContainerView.bottomAnchor),
            calTextField.leadingAnchor.constraint(equalTo: calContainerView.leadingAnchor),
            calTextField.trailingAnchor.constraint(equalTo: calbuttonContainerView.leadingAnchor),
            
            
        ])
        
    }
    // 세팅 : 반복 버튼 + 반복 선택 결과 표시
    private func setupRepeatButton(){
        
        addSubview(containerview)
        NSLayoutConstraint.activate([
            checkButton.widthAnchor.constraint(equalToConstant:24),
            checkButton.heightAnchor.constraint(equalToConstant: 24),
            
        ])
        containerview.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerview.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            containerview.heightAnchor.constraint(equalToConstant: 30),
            containerview.topAnchor.constraint(equalTo: calContainerView.bottomAnchor, constant: 16),
            containerview.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 16)
            
        ])
        // >> containerview.backgroundColor = .red
        containerview.addArrangedSubview(checkButton)
        containerview.addArrangedSubview(repeatLabel)
        let blank = UIView()
        containerview.addArrangedSubview(blank)
        containerview.addArrangedSubview(resultbutton)
        
        checkButton.setChecked(false)
        
        checkButton.translatesAutoresizingMaskIntoConstraints = false
        repeatLabel.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    // 세팅 : 완료 버튼
    private func setupCompleteButton(){
        completeButton.isEnabled = false
        addSubview(completeButton)
        completeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            completeButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            completeButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
            completeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            completeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            completeButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
    }
}
