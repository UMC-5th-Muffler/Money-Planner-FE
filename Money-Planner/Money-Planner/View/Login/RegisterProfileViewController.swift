//
//  RegisterProfileViewController.swift
//  Money-Planner
//
//  Created by 유철민 on 1/6/24.
//

import Foundation
import UIKit

class RegisterProfileViewController : UIViewController{
    
    var descriptionView : DescriptionView{
        let s = DescriptionView(text: "닉네임을 입력해주세요", alignToCenter: false)
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
        l.textAlignment = .left
//        l.translatesAutoresizingMaskIntoConstraints = false
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
//        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    let mainBtmBtn = MainBottomBtn(title: "다음")
    
    var mainBtmbtnBottomConstraint: NSLayoutConstraint! //키보드 이동용
    
    private let goalViewModel = GoalViewModel.shared //지금까지 만든 목표 확인용
    private let goalCreationManager = GoalCreationManager.shared //목표 생성용
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        mainBtmBtn.isEnabled = false
        mainBtmBtn.addTarget(self, action: #selector(mainBtmButtonTapped), for: .touchUpInside)
        setupLayout()
        
        // 키보드 알림 구독
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    func setupLayout(){
        
        view.addSubview(descriptionView)
//        view.addSubview(roundProfileImagePicker)
//        view.addSubview(nickNameTitle)
//        view.addSubview(nickNameTextField)
//        view.addSubview(warningLabel)
//        view.addSubview(mainBtmBtn)
        
        descriptionView.translatesAutoresizingMaskIntoConstraints = false
//        roundProfileImagePicker.translatesAutoresizingMaskIntoConstraints = false
//        nickNameTitle.translatesAutoresizingMaskIntoConstraints = false
//        nickNameTextField.translatesAutoresizingMaskIntoConstraints = false
//        warningLabel.translatesAutoresizingMaskIntoConstraints = false
//        mainBtmBtn.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            descriptionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 36),
            descriptionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            descriptionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            descriptionView.heightAnchor.constraint(equalToConstant: 72),
            
//            roundProfileImagePicker.topAnchor.constraint(equalTo: descriptionView.bottomAnchor, constant: 78),
//            roundProfileImagePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            roundProfileImagePicker.widthAnchor.constraint(equalToConstant: 114),
//            roundProfileImagePicker.heightAnchor.constraint(equalToConstant: 114),
//            
//            nickNameTextField.topAnchor.constraint(equalTo: roundProfileImagePicker.bottomAnchor, constant: 80),
//            nickNameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            nickNameTextField.heightAnchor.constraint(equalToConstant: 40),
//            nickNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//            nickNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
//            
//            nickNameTitle.bottomAnchor.constraint(equalTo: nickNameTextField.topAnchor, constant: 10),
//            nickNameTitle.leadingAnchor.constraint(equalTo: nickNameTextField.leadingAnchor),
//            nickNameTitle.widthAnchor.constraint(equalToConstant: 210),
//            nickNameTitle.heightAnchor.constraint(equalToConstant: 20),
//            
//            warningLabel.topAnchor.constraint(equalTo: nickNameTextField.bottomAnchor, constant: 10),
//            warningLabel.leadingAnchor.constraint(equalTo: nickNameTextField.leadingAnchor),
//            warningLabel.widthAnchor.constraint(equalToConstant: 210),
//            warningLabel.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
    
    private func setupmainBtmBtn() {
        mainBtmBtn.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainBtmBtn)
        mainBtmBtn.addTarget(self, action: #selector(mainBtmButtonTapped), for: .touchUpInside)
        
        let guide = view.safeAreaLayoutGuide
        let bottomConstraint = mainBtmBtn.bottomAnchor.constraint(equalTo: guide.bottomAnchor)
        bottomConstraint.isActive = true // 키보드에 의해 변경될 수 있는 제약 조건
        
        NSLayoutConstraint.activate([
            mainBtmBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mainBtmBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            mainBtmBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            mainBtmBtn.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // 키보드 알림 구독
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
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
            self?.mainBtmbtnBottomConstraint.constant = bottomConstraintValue
            self?.view.layoutIfNeeded()
        }
    }
    
    
    //mainBtmBtn 눌렀을때
    @objc func mainBtmButtonTapped() {
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
