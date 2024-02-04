//
//  ConsumeViewController.swift
//  Money-Planner
//
//  Created by p_kxn_g on 1/16/24.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class ConsumeViewController: UIViewController,UITextFieldDelegate, CategorySelectionDelegate,CalendarSelectionDelegate,RepeatModalViewDelegate,AddCategoryViewDelegate {
    
    // api 연결
    let disposeBag = DisposeBag()
    let viewModel = MufflerViewModel()
    //
    
    func AddCategoryCompleted(_ name: String, iconName: String) {
        print("카테고리 추가 반영 완료\(name)\(iconName)")
        cateogoryTextField.text = name
        cateogoryTextField.changeIcon(iconName: iconName)
        catAdd = true // 카테고리 선택된 것 반영
        checkAndEnableCompleteButton()
        view.layoutIfNeeded()
    }
    func AddCategory() {
        let addCategoryVC = AddCategoryViewController()
        addCategoryVC.modalPresentationStyle = .fullScreen
        addCategoryVC.delegate = self
        present(addCategoryVC, animated: true)
    }
    
    
    let resultbutton : UITextField = {
        let button = UITextField()
        button.layer.cornerRadius = 6
        button.layer.masksToBounds = true
        button.borderStyle = .none
        button.textColor = .mpDarkGray
        button.font = UIFont.mpFont16M()
        button.tintColor = UIColor.mpMainColor
        //button.backgroundColor = .mpGypsumGray // 수정 - 근영/ 텍스트 필드 배경 색상 F6F6F6
        button.isUserInteractionEnabled = false
        button.text = ""
        return button
    }()
    // 소비 등록 여부 확인 (메모 제외)
    var amountAdd = false
    var catAdd = false
    var titleAdd = false
    
    let currentDate = Date()
    let dateFormatter = DateFormatter()
    lazy var todayDate: String = {
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        return dateFormatter.string(from: currentDate)
    }()
    private lazy var headerView = HeaderView(title: "소비내역 입력")
    private var completeButton = MainBottomBtn(title: "완료")
    //소비금액 입력필드 추가
    
    private let amountTextField: UITextField = MainTextField(placeholder: "소비금액을 입력하세요", iconName: "icon_Wallet", keyboardType: .numberPad)
    
    // 소비금액 실시간 금액 표시
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.text = "0 원"
        label.font = UIFont.mpFont14M()
        label.textColor = UIColor.mpDarkGray
        return label
    }()
    // 제목 에러 표시
    private let titleErrorLabel: UILabel = {
        let label = UILabel()
        label.text = "최대 16글자로 입력해주세요"
        label.font = UIFont.systemFont(ofSize : 11)// 폰트 사이즈
        label.textColor = UIColor.mpRed
        return label
    }()
    let catContainerView : UIView = {
        let uiView = UIView()
        uiView.backgroundColor = UIColor.mpGypsumGray
        uiView.layer.cornerRadius = 8
        uiView.translatesAutoresizingMaskIntoConstraints = false // Add this line
        return uiView
    }()
    private let cateogoryTextField = MainTextField(placeholder: "카테고리를 입력해주세요", iconName: "icon_category", keyboardType: .default)
    
    // 카테고리 선택 버튼 추가
    lazy var categoryChooseButton: UIButton = {
        let button = UIButton()
        let arrowImage = UIImage(systemName:"pencil") // Replace "arrow_down" with the actual image name in your assets
        button.setImage(arrowImage, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true  // 클릭 활성화
        //button.backgroundColor = UIColor.red
        button.addTarget(self, action: #selector(showCategoryModal), for: .touchUpInside) //클릭시 모달 띄우기
        return button
        
    }()
    
    @objc
    private func showCategoryModal() {
        print("클릭 : 카테고리 선택을 위해 카테고리 선택 모달로 이동합니다")
        //categoryChooseButton.backgroundColor = UIColor.green
        let categoryModalVC = CategoryModalViewController()
        categoryModalVC.delegate = self
        present(categoryModalVC, animated: true)
    }
    
    func didSelectCategory(_ category: String, iconName : String) {
        catAdd = true // 카테고리 선택된 것 반영
        cateogoryTextField.text = category
        cateogoryTextField.changeIcon(iconName: iconName)
        checkAndEnableCompleteButton()
    }
    
    private let titleTextField = MainTextField(placeholder: "제목", iconName: "icon_Paper", keyboardType: .default)
    private let memoTextField = MainTextField(placeholder: "메모", iconName: "icon_Edit", keyboardType: .default)
    let calContainerView : UIView = {
        let uiView = UIView()
        uiView.layer.cornerRadius = 8
        uiView.backgroundColor = .mpGypsumGray
        uiView.translatesAutoresizingMaskIntoConstraints = false // Add this line
        return uiView
    }()
    private let calTextField = MainTextField(placeholder: "", iconName: "icon_date", keyboardType: .default)
    // 카테고리 선택 버튼 추가
    lazy var calChooseButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("오늘", for: .normal)
        button.titleLabel?.font = UIFont.mpFont20M()
        button.setTitleColor(UIColor.mpMainColor, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true  //클릭 활성화
        button.backgroundColor = .red
        button.addTarget(self, action: #selector(showCalModal), for: .touchUpInside) //클릭시 모달 띄우기
        return button
        
    }()
    private lazy var checkButton : CheckBtn = {
        let checkButton = CheckBtn()
        checkButton.addTarget(self, action: #selector(showRepeatModal), for: .touchUpInside)
        return checkButton
    }()
    
    let containerview: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    
    
    let repeatLabel : UILabel = {
        let label = UILabel()
        label.text = "반복"
        label.font = UIFont.mpFont16R()
        label.textColor = UIColor.mpDarkGray
        return label
    }()
    
    
    
    @objc
    private func showCalModal() {
        print("클릭 : 소비날짜 버튼 클리")
        calChooseButton.backgroundColor = UIColor.green
        let calModalVC = CalendartModalViewController()
        calModalVC.delegate = self
        present(calModalVC, animated: true)
    }
    
    @objc
    private func showRepeatModal() {
        print(checkButton.isChecked)
        if checkButton.isChecked {
            print("반복 모달로 이동합니다")
            let repeatModalVC = RepeatModalViewController()
            repeatModalVC.delegate = self
            present(repeatModalVC, animated: true)
        }
        else{
            checkButton.isChecked = false
        }
    }
    
    func didSelectCalendarDate(_ date: String) {
        print("Selected Date in YourPresentingViewController: \(date)")
        calTextField.text = date
        // 선택한 날짜가 오늘이 아닌 경우, 선택으로 달력 버튼 텍스트 변경
        // 오늘인 경우에는 오늘로 세팅
        if date == todayDate {
            // 선택한 날짜가 오늘인 경우
            calChooseButton.setTitle("오늘", for: .normal)
        }else{
            // 선택한 날짜가 오늘이 아닌 경우
            calChooseButton.setTitle("선택", for: .normal)
        }
    }
    
    
    
    
    
    override func viewDidLoad() {
        setupUI()
    }
    
    private func setupUI() {
        // 배경색상 추가
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "mpWhite")
        view.backgroundColor = .systemBackground
        
        // 헤더
        setupHeader()
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
        view.addSubview(headerView)
        headerView.backgroundColor = .red
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 60)
        ])
        
//       
//           let customBarButtonItem = UIBarButtonItem(customView: customHeaderView)
//            navigationItem.leftBarButtonItem = customBarButtonItem
//            navigationItem.title = "소비등록"
//            customBarButtonItem.addBackButtonTarget(target: self, action: #selector(previousScreen), for: .touchUpInside)
        
    }
    @objc private func previousScreen(){
        dismiss(animated: true)
    }
    // 세팅 : 소비금액 추가
    private func setupAmountTextField() {
        view.addSubview(amountTextField)
        
        amountTextField.delegate = self
        amountTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            amountTextField.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20),
            amountTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            amountTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
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
        view.addSubview(amountLabel)
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
        
        view.addSubview(catContainerView)
        NSLayoutConstraint.activate([
            
            catContainerView.topAnchor.constraint(equalTo: amountLabel.bottomAnchor, constant: 10),
            catContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            catContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
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
        self.view.bringSubviewToFront(categoryChooseButton)
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
        view.addSubview(titleTextField)
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.delegate = self
        
        NSLayoutConstraint.activate([
            
            titleTextField.topAnchor.constraint(equalTo: catContainerView.bottomAnchor, constant: 10),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            titleTextField.heightAnchor.constraint(equalToConstant: 64)
        ])
        
    }
    
    
    // 세팅 : 메모 텍스트 필트
    private func setupmemoTextField(){
        view.addSubview(memoTextField)
        memoTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            memoTextField.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 10),
            memoTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            memoTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            memoTextField.heightAnchor.constraint(equalToConstant: 64)
        ])
        
        // 간격 24
        let blank = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        memoTextField.rightView = blank
        memoTextField.rightViewMode = .always
    }
    // 세팅 : 달력 텍스트 필트
    private func setupcalTextField(){
        
        view.addSubview(calContainerView)
        NSLayoutConstraint.activate([
            
            calContainerView.topAnchor.constraint(equalTo: memoTextField.bottomAnchor, constant: 10),
            calContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            calContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
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
        
        view.addSubview(containerview)
        NSLayoutConstraint.activate([
            checkButton.widthAnchor.constraint(equalToConstant:24),
            checkButton.heightAnchor.constraint(equalToConstant: 24),
            
        ])
        containerview.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerview.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            containerview.heightAnchor.constraint(equalToConstant: 30),
            containerview.topAnchor.constraint(equalTo: calContainerView.bottomAnchor, constant: 16),
            containerview.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 16)
            
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
        view.addSubview(completeButton)
        completeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            completeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            completeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            completeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            completeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            completeButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)    }
    // UITextFieldDelegate 메서드 구현
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // Check if the current text field is amountTextField
        if textField == amountTextField {
            // 입력 중인 금액 업데이트
            let currentText = textField.text ?? ""
            let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
            print(newText)
            amountTextField.layer.borderColor = UIColor.clear.cgColor
            amountTextField.layer.borderWidth = 0.0
            // 입력된 것이 없는 경우
            if newText.isEmpty{
                amountLabel.text = "0 원"
                
            }
            // 입력된 금액이 있는 경우
            else{
                amountAdd = true // 입력된 것이 있는 것 확인
                checkAndEnableCompleteButton()
                // 유효한 숫자인 경우
                amountLabel.textColor = UIColor.mpDarkGray
                // 소비금액 텍스트필드에 에러 표시 취소 - 빨간색 스트로크
                amountTextField.layer.borderColor = UIColor.clear.cgColor
                amountTextField.layer.borderWidth = 0.0
                
                if let amount = Int(currentText + string) {
                    print(amount)
                    let digitOfAmount = String(describing: amount).count
                    // 소비금액 텍스트필드에 에러 표시 취소 - 빨간색 스트로크
                    
                    
                    // 입력할 수 있는 범위를 초과한 경우
                    if digitOfAmount > 16 {
                        // 소비금액 보여주는 곳에 에러 메세지 표시
                        amountLabel.text = "입력할 수 있는 범위를 초과했습니다."
                        amountLabel.textColor = .red
                        // 소비금액 텍스트필드에 에러 표시 - 빨간색 스트로크
                        amountTextField.layer.borderColor = UIColor.mpRed.cgColor
                        amountTextField.layer.borderWidth = 1.0
                        
                        return false // 더 이상 입력할 수 없도록 함
                        
                        // 입력할 수 있는 범위인 경우
                    } else {
                        amountLabel.text = "\(numberToKorean(amount))  원" // 숫자 -> 한국어로 변경하여 입력함
                        // 소비금액 텍스트필드에 에러 표시 취소 - 빨간색 스트로크
                        amountTextField.layer.borderColor = UIColor.clear.cgColor
                        amountTextField.layer.borderWidth = 0.0
                    }
                    
                    // 유효한 숫자가 아닌 경우 (현재 텍스트 + 새로운 문자열)
                } else {
                    
                    
                    print("유효한 숫자가 아님 : ")
                    amountLabel.text = "유효한 숫자가 아닙니다."
                    amountLabel.textColor = UIColor.mpRed
                    // 소비금액 텍스트필드에 에러 표시 - 빨간색 스트로크
                    amountTextField.layer.borderColor = UIColor.mpRed.cgColor
                    amountTextField.layer.borderWidth = 1.0
                    
                    
                    
                }
            }
            
            
            return true
            
            
        } else if textField == titleTextField {
            // Handle character count limit for titleTextField
            // Calculate the resulting text after replacement
            guard let text = textField.text else { return false }
            let newText = (text as NSString).replacingCharacters(in: range, with: string)
            
            if !newText.isEmpty {
                titleAdd = true // 입력된 것이 있는 것 확인
                checkAndEnableCompleteButton()
            }
            
            // Apply character count limit
            if newText.count > 16 {
                // 소비금액 텍스트필드에 에러 표시 - 빨간색 스트로크
                titleTextField.layer.borderColor = UIColor.mpRed.cgColor
                titleTextField.layer.borderWidth = 1.0
                view.addSubview(titleErrorLabel)
                titleErrorLabel.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    titleErrorLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 8),
                    titleErrorLabel.leadingAnchor.constraint(equalTo: titleTextField.leadingAnchor),
                    titleErrorLabel.trailingAnchor.constraint(equalTo: titleTextField.trailingAnchor),
                    titleErrorLabel.heightAnchor.constraint(equalToConstant: 20)
                ])
                // Move memoTextField down
                memoTextField.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    memoTextField.topAnchor.constraint(equalTo: titleErrorLabel.bottomAnchor, constant: 30), // Adjust the constant as needed
                    memoTextField.leadingAnchor.constraint(equalTo: titleTextField.leadingAnchor),
                    memoTextField.trailingAnchor.constraint(equalTo: titleTextField.trailingAnchor),
                    memoTextField.heightAnchor.constraint(equalToConstant: 64)
                ])
                
                
                return false
            }
            titleTextField.layer.borderColor = UIColor.clear.cgColor
            titleTextField.layer.borderWidth = 0.0
        }
        
        return true
        
        
    }
    
    //숫자를 한글로 표현하는 함수(2000 -> 0부터 9999999999999999까지가능)
    func numberToKorean(_ number: Int) -> String {
        let unitLarge = ["", "만", "억", "조"]
        
        var result = ""
        var num = number
        var unitIndex = 0
        
        while num > 0 {
            let segment = num % 10000
            if segment != 0 {
                result = "\((segment))\(unitLarge[unitIndex]) \(result)"
            }
            num /= 10000
            unitIndex += 1
        }
        
        return result.isEmpty ? "0" : result
    }
    
    func GetResultofInterval(_ result: String) {
        print("버튼에 데이터 반영합니다\(result)")
        resultbutton.text = "  \(result)  "
        resultbutton.backgroundColor = .mpGypsumGray
        view.layoutIfNeeded()
    }
    private func checkAndEnableCompleteButton() {
        let enableButton = amountAdd && catAdd && titleAdd
        completeButton.isEnabled = enableButton
        print("\(enableButton)")
        print("\(amountAdd)\(catAdd)\(titleAdd)")
        
    }
    
    
    @objc
    private func completeButtonTapped(){
        print("소비등록을 완료하였습니다")
        // api 연결
        // Create an Expense object with the required data
        
        // Create an ExpenseCreateRequest object with the required data
        let expenseRequest = ExpenseCreateRequest(
            expenseCost: 11,
            categoryId: 2,
            expenseTitle: "Sample Expense",
            expenseMemo: "Sample Memo",
            expenseDate: "2024-01-23",
            routineRequest: nil,
            isRoutine: false
        )
        
        
        
        
        viewModel.createExpense(expenseRequest: expenseRequest)
            .subscribe(
            onSuccess: { response in
                print(response)
            }, onFailure: {error in
                print(error)
            }).disposed(by: disposeBag)
        
    }
}

