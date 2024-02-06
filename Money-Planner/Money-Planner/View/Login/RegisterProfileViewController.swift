//
//  RegisterProfileViewController.swift
//  Money-Planner
//
//  Created by 유철민 on 1/6/24.
//

import Foundation
import UIKit

class RegisterProfileViewController : UIViewController{
    
    var subDescriptionView : SubDescriptionView{
        let s = SubDescriptionView(text: "닉네임을 입력해주세요", alignToCenter: false)
        s.textColor = .mpBlack
        s.font = .mpFont26B()
        return s
    }
    let roundProfileImagePicker = UIPickerView() // 구현해야함.
    let nickNameTitle : MPLabel = {
        let l = MPLabel()
        l.text = "닉네임"
        l.textColor = .mpDarkGray
        l.font = .mpFont14M()
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    let nickNameTextField : UITextField = {
        let textField = UITextField()
        textField.textColor = .mpBlack
        textField.font = .mpFont20M()
        return textField
    }()
    let warningLabel : MPLabel = {
        let l = MPLabel()
        l.text = "이미 존재하는 닉네임입니다."
        l.textColor = .mpRed
        l.font = .mpFont14M()
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    let mainBtmBtn = MainBottomBtn(title: "다음")
    
    var btmbtnBottomConstraint: NSLayoutConstraint! //키보드 이동용
    
    private let goalViewModel = GoalViewModel.shared //지금까지 만든 목표 확인용
    private let goalCreationManager = GoalCreationManager.shared //목표 생성용
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        mainBtmBtn.isEnabled = false
        mainBtmBtn.addTarget(self, action: #selector(btmButtonTapped), for: .touchUpInside)
        setupLayout()
        
        // 키보드 알림 구독
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    //레이아웃
    func setupLayout() {
        [subDescriptionView, nickNameTitle, nickNameTextField, warningLabel, mainBtmBtn].forEach {
            view.addSubview($0)
        }
        
        btmbtnBottomConstraint = mainBtmBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30)
        
        NSLayoutConstraint.activate([
            subDescriptionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            subDescriptionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            subDescriptionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            nickNameTitle.topAnchor.constraint(equalTo: subDescriptionView.bottomAnchor, constant: 40),
            nickNameTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nickNameTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            nickNameTextField.topAnchor.constraint(equalTo: nickNameTitle.bottomAnchor, constant: 8),
            nickNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nickNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            warningLabel.topAnchor.constraint(equalTo: nickNameTextField.bottomAnchor, constant: 8),
            warningLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            warningLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            
            mainBtmBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mainBtmBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            mainBtmBtn.heightAnchor.constraint(equalToConstant: 50),
            btmbtnBottomConstraint
        ])
    }
    
    //키보드 노티
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
    
    
    //btmBtn 눌렀을때
    @objc func btmButtonTapped() {
        print("계정 생성 완료, 홈화면으로 이동")
        
        //userdefaults에 닉네임, 이미지
        if let nickName = nickNameTextField.text, !nickName.isEmpty {
            UserDefaults.standard.set(nickName, forKey: "nickName")
        }
        
//        if let profileImage = roundProfileImagePicker.selectedImage { // `selectedImage`는 사용자가 선택한 이미지를 나타냅니다.
//            if let fileURL = saveImageToDocumentDirectory(profileImage, fileName: "profileImage.png") {
//                UserDefaults.standard.set(fileURL.path, forKey: "profileImagePath")
//            }
//        }
        
        let homeViewController = UIViewController() // Your HomeViewController
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = UINavigationController(rootViewController: homeViewController)
            window.makeKeyAndVisible()
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
        }
        
        
    }
    
    func saveImageToDocumentDirectory(_ image: UIImage, fileName: String) -> URL? {
        guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
            return nil
        }
        
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentDirectory.appendingPathComponent(fileName)
        
        do {
            try data.write(to: fileURL)
            return fileURL
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    
}
