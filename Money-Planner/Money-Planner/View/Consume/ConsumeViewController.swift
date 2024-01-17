//
//  ConsumeViewController.swift
//  Money-Planner
//
//  Created by p_kxn_g on 1/16/24.
//

import Foundation
import UIKit

class ConsumeViewController: UIViewController,UITextFieldDelegate {

    private lazy var headerView = HeaderView(title: "소비내역 입력")
    private var completeButton = MainBottomBtn(title: "완료")
    //소비금액 입력필드 추가
    
    private let amountTextField: UITextField = MainTextField(placeholder: "소비금액을 입력하세요", iconName: "dollarsign.circle", keyboardType: .numberPad)

    // 소비금액 실시간 금액 표시
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.text = "영 원"
        label.font = UIFont.systemFont(ofSize : 11)// 폰트 사이즈
        return label
       }()
    
    private let cateogoryTextField = MainTextField(placeholder: "카테고리를 입력해주세요", iconName: "folder", keyboardType: .numberPad)
    private let titleTextField = MainTextField(placeholder: "제목", iconName: "pencil.circle", keyboardType: .default)
    private let memoTextField = MainTextField(placeholder: "메모", iconName: "square.and.pencil", keyboardType: .default)
    private let calTextField = MainTextField(placeholder: "2024년 7월 7일", iconName: "calendar", keyboardType: .default)
    
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
        
        NSLayoutConstraint.activate([
            
            cateogoryTextField.topAnchor.constraint(equalTo: amountLabel.bottomAnchor, constant: 10),
            cateogoryTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            cateogoryTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            cateogoryTextField.heightAnchor.constraint(equalToConstant: 64)
        ])
    }
    
    // 세팅 : 제목 텍스트 필트
    private func setuptitleTextField(){
        view.addSubview(titleTextField)
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        
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
    }
    // 세팅 : 달력 텍스트 필트
    private func setupcalTextField(){
        view.addSubview(calTextField)
        calTextField.translatesAutoresizingMaskIntoConstraints = false
        
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
           // 입력 중인 금액 업데이트
           let currentText = textField.text ?? ""
           let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
           // 입력된 것이 없는 경우
           if newText.isEmpty{
               amountLabel.text = "영 원"
           }
           // 입력된 금액이 있는 경우
           else{
               // 유효한 숫자인 경우
               if let amount = Int(currentText + string) {
                   let digitOfAmount = String(describing: amount).count
                   
                   // 입력할 수 있는 범위를 초과한 경우
                   if digitOfAmount > 16 {
                       amountLabel.text = "입력할 수 있는 범위를 초과했습니다."
                       amountLabel.textColor = .red
                       return false // 더 이상 입력할 수 없도록 함
                       
                    // 입력할 수 있는 범위인 경우
                   } else {
                       amountLabel.text = "\(numberToKorean(amount)) 원" // 숫자 -> 한국어로 변경하여 입력함
                   }
                   
                // 유효한 숫자가 아닌 경우 (현재 텍스트 + 새로운 문자열)
               } else {
                   amountLabel.text = "유효한 숫자가 아닙니다."
                   amountLabel.textColor = .red
               }
           }
            
   

           return true

       }
    //숫자를 한글로 표현하는 함수(2000 -> 0부터 9999999999999999까지가능)
    func numberToKorean(_ number: Int) -> String {
        let koreanNumbers = ["", "일", "이", "삼", "사", "오", "육", "칠", "팔", "구"]
        let unitSmall = ["", "십", "백", "천"]
        let unitLarge = ["", "만", "억", "조"]

        var result = ""
        var num = number
        var unitIndex = 0

        while num > 0 {
            let segment = num % 10000
            if segment != 0 {
                result = "\(numberToKoreanSegment(segment))\(unitLarge[unitIndex])\(result)"
            }
            num /= 10000
            unitIndex += 1
        }

        return result.isEmpty ? "영" : result
    }

    func numberToKoreanSegment(_ number: Int) -> String {
        let koreanNumbers = ["", "일", "이", "삼", "사", "오", "육", "칠", "팔", "구"]
        let unit = ["", "십", "백", "천"]

        var result = ""
        var num = number

        for (idx, char) in String(number).reversed().enumerated() {
            let digit = Int(String(char))!
            if digit != 0 {
                result = "\(koreanNumbers[digit])\(unit[idx])\(result)"
            }
        }

        return result.isEmpty ? "영" : result
    }

}




