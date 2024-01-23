//
//  ConsumeViewController.swift
//  Money-Planner
//
//  Created by p_kxn_g on 1/16/24.
//

import Foundation
import UIKit

class ConsumeViewController: UIViewController,UITextFieldDelegate {
    let currentDate = Date()
    let dateFormatter = DateFormatter()
    lazy var dateString: String = {
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
        label.font = UIFont.systemFont(ofSize : 11)// 폰트 사이즈
        label.textColor = UIColor.mpBlack
        return label
    }()
    
    private let cateogoryTextField = MainTextField(placeholder: "카테고리를 입력해주세요", iconName: "icon_category", keyboardType: .numberPad)
    private let titleTextField = MainTextField(placeholder: "제목", iconName: "icon_Paper", keyboardType: .default)
    private let memoTextField = MainTextField(placeholder: "메모", iconName: "icon_Edit", keyboardType: .default)
    private let calTextField = MainTextField(placeholder: "", iconName: "icon_date", keyboardType: .default)
 
    
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
        
        // 완료 버튼 추가
        setupCompleteButton()
        
        
        
        // Auto Layout 설정
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
    }
    // 세팅 : 헤더
    private func setupHeader(){
        // HeaderView 추가
        view.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        
    }
    // 세팅 : 소비금액 추가
    private func setupAmountTextField() {
        view.addSubview(amountTextField)
        amountTextField.delegate = self
        amountTextField.translatesAutoresizingMaskIntoConstraints = false
        //
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
        view.addSubview(cateogoryTextField)
        cateogoryTextField.translatesAutoresizingMaskIntoConstraints = false
        cateogoryTextField.isUserInteractionEnabled = false // 수정 불가능하도록 설정
        cateogoryTextField.textColor = UIColor.mpBlack
        cateogoryTextField.text = "카테고리를 선택해주세요"
        
        NSLayoutConstraint.activate([
            
            cateogoryTextField.topAnchor.constraint(equalTo: amountLabel.bottomAnchor, constant: 10),
            cateogoryTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            cateogoryTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            cateogoryTextField.heightAnchor.constraint(equalToConstant: 64)
        ])
        // 원 추가
        lazy var categoryChooseButton: UIButton = {
            let button = UIButton()
            let arrowImage = UIImage(systemName:"pencil") // Replace "arrow_down" with the actual image name in your assets
            button.setImage(arrowImage, for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()

        let buttonContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        buttonContainerView.addSubview(categoryChooseButton)

        NSLayoutConstraint.activate([
            categoryChooseButton.leadingAnchor.constraint(equalTo: buttonContainerView.leadingAnchor),
            categoryChooseButton.trailingAnchor.constraint(equalTo: buttonContainerView.trailingAnchor, constant: -10),
            categoryChooseButton.topAnchor.constraint(equalTo: buttonContainerView.topAnchor),
            categoryChooseButton.bottomAnchor.constraint(equalTo: buttonContainerView.bottomAnchor)
        ])

        cateogoryTextField.rightView = buttonContainerView
        cateogoryTextField.rightViewMode = .always
    }
    
    // 세팅 : 제목 텍스트 필트
    private func setuptitleTextField(){
        view.addSubview(titleTextField)
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.delegate = self
        
        NSLayoutConstraint.activate([
            
            titleTextField.topAnchor.constraint(equalTo: cateogoryTextField.bottomAnchor, constant: 10),
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
        view.addSubview(calTextField)
        calTextField.translatesAutoresizingMaskIntoConstraints = false
        calTextField.isUserInteractionEnabled = false // 수정 불가능하도록 설정
        calTextField.textColor = UIColor.mpBlack
        calTextField.text = dateString

        NSLayoutConstraint.activate([
            
            calTextField.topAnchor.constraint(equalTo: memoTextField.bottomAnchor, constant: 10),
            calTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            calTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            calTextField.heightAnchor.constraint(equalToConstant: 64)
        ])
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
    }
    // UITextFieldDelegate 메서드 구현
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // Check if the current text field is amountTextField
          if textField == amountTextField {
              // 입력 중인 금액 업데이트
              let currentText = textField.text ?? ""
              let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
              amountTextField.layer.borderColor = UIColor.clear.cgColor
              amountTextField.layer.borderWidth = 0.0
              // 입력된 것이 없는 경우
              if newText.isEmpty{
                  amountLabel.text = "0 원"
                 
              }
              // 입력된 금액이 있는 경우
              else{
                  // 유효한 숫자인 경우
                  amountLabel.textColor = UIColor.mpBlack
                  // 소비금액 텍스트필드에 에러 표시 취소 - 빨간색 스트로크
                  amountTextField.layer.borderColor = UIColor.clear.cgColor
                  amountTextField.layer.borderWidth = 0.0
                  if let amount = Int(currentText + string) {
                      let digitOfAmount = String(describing: amount).count
                      // 소비금액 텍스트필드에 에러 표시 취소 - 빨간색 스트로크
                      amountTextField.layer.borderColor = UIColor.clear.cgColor
                      amountTextField.layer.borderWidth = 0.0
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

              // Apply character count limit
              if newText.count > 16 {
                  return false
              }
          }
        
        

          // Your existing implementation for other text fields...

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

}
