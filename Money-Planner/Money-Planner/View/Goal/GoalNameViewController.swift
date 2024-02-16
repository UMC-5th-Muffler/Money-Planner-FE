//
//  GoalNameViewController.swift
//  Money-Planner
//
//  Created by 유철민 on 1/12/24.
//

import Foundation
import UIKit

extension GoalNameViewController {
    
    // UITextFieldDelegate 메서드
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
        
        // 이모지 필드에서는 이모지만 입력 가능하도록 합니다.
        if textField == emojiTextField {
            if newText.unicodeScalars.allSatisfy({ $0.properties.isEmoji }) && newText.count == 1 {
                warningLabel.isHidden = true
                writeNameView.isUserInteractionEnabled = true
            } else {
                warningLabel.isHidden = false
                writeNameView.isUserInteractionEnabled = false
                if newText.unicodeScalars.allSatisfy({ $0.properties.isEmoji }) {
                    warningLabel.text = "이모지를 한 자만 입력해주세요"
                } else {
                    warningLabel.text = "이모지만 입력해주세요"
                }
            }
        }
        
        if textField == writeNameView.textField {
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            
            // 16자 제한 검사
            if updatedText.count > 16 {
                warningLabel.text = "목표는 최대 16자까지 입력 가능합니다."
                warningLabel.isHidden = false // 경고 레이블 표시
                btmbtn.isEnabled = false
                return false
            }else if updatedText.count == 0 {
                warningLabel.isHidden = true // 경고 레이블 미표시
                btmbtn.isEnabled = false
            }else if goalViewModel.goalExistsWithName(goalName: updatedText) {
                warningLabel.text = "이미 존재하는 이름의 목표가 있습니다."
                warningLabel.isHidden = false // 경고 레이블 표시
                btmbtn.isEnabled = false
            }
            else {
                warningLabel.isHidden = true // 경고 레이블 숨김
                btmbtn.isEnabled = true
            }
        }
        
        return true
    }
    
    
}

class GoalNameViewController : UIViewController, UITextFieldDelegate {
    
    private var header = HeaderView(title: "")
    private var descriptionView = DescriptionView(text: "목표 이름을 설정해주세요", alignToCenter: false)
    private var emojiTextField = GoalEmojiTextField()
    private var writeNameView = WriteNameView()
    private let warningLabel = MPLabel()
    private var btmbtn = MainBottomBtn(title: "다음")
    private var scrim = UIView()
    
    private let goalViewModel = GoalViewModel.shared //지금까지 만든 목표 확인용
    private let goalCreationManager = GoalCreationManager.shared //목표 생성용
    
    
    var btmbtnBottomConstraint: NSLayoutConstraint! //키보드 이동용
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupHeader()
        setupDescriptionView()
        setupEmojiTextField()
        setupWarningLabel()
        setupWriteNameView()
        setUpBtmBtn()
        
        emojiTextField.delegate = self
        writeNameView.textField.delegate = self
        
        // 기본 네비게이션 바의 뒤로 가기 버튼 숨기기
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = nil
        
        btmbtn.addTarget(self, action: #selector(btmButtonTapped), for: .touchUpInside)
        btmbtn.isEnabled = false
        
        // 키보드 알림 구독
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc func btmButtonTapped() {
        print("이름 입력 완료. 기간 화면으로.")
        goalCreationManager.goalEmoji = emojiTextField.text
        goalCreationManager.goalName = writeNameView.textField.text
        let goalPeriodViewController = GoalPeriodViewController()
        navigationController?.pushViewController(goalPeriodViewController, animated: true)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    private func setupHeader() {
        header.translatesAutoresizingMaskIntoConstraints = false
        header.addBackButtonTarget(target: self, action: #selector(backButtonTapped), for: .touchUpInside)
        view.addSubview(header)
        
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            header.heightAnchor.constraint(equalToConstant: 60) // 예시 높이값
        ])
    }
    
    @objc private func backButtonTapped() {
        // 뒤로 가기 기능 구현
        goalCreationManager.clear() // 만들려고 했던 데이터 전부 clear
        navigationController?.popViewController(animated: true)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private func setupDescriptionView() {
        descriptionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionView)
        
        NSLayoutConstraint.activate([
            descriptionView.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 30),
            descriptionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    // 이모지 뷰 설정
    private func setupEmojiTextField() {
        emojiTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emojiTextField)
        
        NSLayoutConstraint.activate([
            emojiTextField.topAnchor.constraint(equalTo: descriptionView.bottomAnchor, constant: 30),
            emojiTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emojiTextField.widthAnchor.constraint(equalToConstant: 64),
            emojiTextField.heightAnchor.constraint(equalToConstant: 64)
        ])
    }
    
    // 이름 입력 뷰 설정
    private func setupWriteNameView() {
        writeNameView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(writeNameView)
        
        NSLayoutConstraint.activate([
            writeNameView.topAnchor.constraint(equalTo: emojiTextField.topAnchor),
            writeNameView.leadingAnchor.constraint(equalTo: emojiTextField.trailingAnchor, constant: 10),
            writeNameView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            writeNameView.heightAnchor.constraint(equalToConstant: 64)
        ])
    }
    
    
    //navigation 말고 present
    //    // Action when the backButton is tapped
    //    @objc func backButtonTapped() {
    //        // Dismiss the current view controller and go back to GoalMainViewController
    //        self.dismiss(animated: true, completion: nil)
    //    }
    
    
    
    func setUpBtmBtn(){
        btmbtn.translatesAutoresizingMaskIntoConstraints = false
        //        btmbtn.isEnabled = false
        view.addSubview(btmbtn)
        
        btmbtnBottomConstraint = btmbtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30)
        
        NSLayoutConstraint.activate([
            btmbtnBottomConstraint,
            btmbtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            btmbtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            btmbtn.heightAnchor.constraint(equalToConstant: 50)
        ])
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        adjustButtonWithKeyboard(notification: notification, show: true)
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        adjustButtonWithKeyboard(notification: notification, show: false)
    }
    
    func adjustButtonWithKeyboard(notification: NSNotification, show: Bool) {
        guard let userInfo = notification.userInfo,
              let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        let keyboardHeight = keyboardSize.height
        let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0.3
        
        // 키보드 상태에 따른 버튼의 bottom constraint 조정
        let bottomConstraintValue = show ? -keyboardHeight : -30  // -30은 키보드가 없을 때의 기본 간격입니다.
        
        UIView.animate(withDuration: animationDuration) { [weak self] in
            self?.btmbtnBottomConstraint.constant = bottomConstraintValue
            self?.view.layoutIfNeeded()
        }
    }
    
    
    // 경고 레이블 설정
    private func setupWarningLabel() {
        warningLabel.translatesAutoresizingMaskIntoConstraints = false
        warningLabel.textColor = .mpRed
        warningLabel.font = .mpFont14M()
        warningLabel.isHidden = true // 기본적으로는 숨겨진 상태
        view.addSubview(warningLabel)
        
        NSLayoutConstraint.activate([
            warningLabel.topAnchor.constraint(equalTo: emojiTextField.bottomAnchor, constant: 5),
            warningLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            warningLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
}



