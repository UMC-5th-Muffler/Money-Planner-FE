//
//  ProfileViewController.swift
//  Money-Planner
//
//  Created by p_kxn_g on 2/2/24.
//

import Foundation
import UIKit

protocol ProfileViewDelegate : AnyObject{
    func profileNameChanged(_ userName : String)
    
}
class ProfileViewController: UIViewController,UITextFieldDelegate {
    private var UserName: String?

    weak var delegate: ProfileViewDelegate?
    private lazy var headerView = HeaderView(title: "프로필 설정")
    var currText : String = ""
    let picContainer : UIView = {
        let view = UIView()
        //view.backgroundColor = .red
        return view
    }()
    let picButton : UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 45
        button.layer.masksToBounds = true
        button.backgroundColor = .red
        let buttonImg = UIImage(systemName: "pencil")
        button.setImage(buttonImg, for: .normal)
        button.backgroundColor = .red
        return button
        
        
    }()

    
    let nameContainer : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.mpGypsumGray
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false // Add this line
        return view
    }()
    let errorContainer : UIView = {
        let view = UIView()
        //view.backgroundColor = .red
        return view
    }()
    // 이름 수정 버튼
    lazy var nameEditButton: UIButton = {
        let button = UIButton()
        let arrowImage = UIImage(systemName:"pencil") // Replace "arrow_down" with the actual image name in your assets
        arrowImage?.withTintColor(.mpDarkGray)
        button.setImage(arrowImage, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true  // 클릭 활성화
        //button.backgroundColor = UIColor.red
        button.addTarget(self, action: #selector(editName), for: .touchUpInside) //이름 수정 가능하게
        return button
        
    }()
    @objc
    func editName(){
        print("이름을 수정할 수 있습니다")
        // 이름 수정 가능하게 변경
        nameTextField.isEnabled = true
        nameEditButton.isEnabled = false // 수정 버튼 클릭 막기
        let currTextSize = nameTextField.text?.count
        nameEditButton.setImage(nil, for: .normal)// 버튼 이미지 삭제
        if let textSize = currTextSize {
            nameEditButton.setTitle("\(textSize)/16", for: .normal)
        }
        nameEditButton.titleLabel?.font = .mpFont14B()
        nameEditButton.setTitleColor(.mpDarkGray, for: .normal)
    }
    private var completeButton = MainBottomBtn(title: "완료")
    private let nameTextField : UITextField = {
        let text = UITextField()
        text.layer.cornerRadius = 8
        text.layer.masksToBounds = true
        text.borderStyle = .none
        text.font = UIFont.mpFont20M()
        text.tintColor = UIColor.mpMainColor
        text.backgroundColor = .clear
        text.keyboardType = .default
        // 여백 추가
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 24, height: text.frame.height)) // 조절하고자 하는 여백 크기
        text.leftView = leftView
        text.leftViewMode = .always
        
        return text
    }()
    private let emailTextField : UITextField = {
        let text = UITextField()
        text.placeholder = "mufler@kakao.com"// 이메일 주소
        text.layer.cornerRadius = 8
        text.layer.masksToBounds = true
        text.layer.borderColor = UIColor.mpLightGray.cgColor
        text.layer.borderWidth = 1
        text.font = UIFont.mpFont20M()
        text.tintColor = UIColor.mpMainColor
        text.backgroundColor = .clear
        text.keyboardType = .default
        // 여백 추가
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 24, height: text.frame.height)) // 조절하고자 하는 여백 크기
        text.leftView = leftView
        text.leftViewMode = .always
        
        return text
    }()
    private let nameLabel : MPLabel = {
        let label = MPLabel()
        label.font = .mpFont14B()
        label.text = "이름"
        label.textColor = .mpGray
        return label
    }()
    private let emailLabel : MPLabel = {
        let label = MPLabel()
        label.font = .mpFont14B()
        label.text = "이메일 주소"
        label.textColor = .mpGray
        return label
    }()
    
    init(tempUserName: String?) {
            super.init(nibName: nil, bundle: nil)
            self.UserName = tempUserName
            nameTextField.text = UserName // 마이페이지에서 사용자 이름 가져오기
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        // 완료 버튼 추가
        setupCompleteButton()
        setupPic()
        setupNameLabel()
        setupTextField()
        setupEmailLabel()
        setupEmailTextField()
        
        nameTextField.delegate = self // Make sure to set the delegate

    }
    
    // 세팅 : 헤더
    private func setupHeader(){
        view.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 60)
            
        ])
        
        
    }
    private func setupPic(){
        // 컨테이너 추가
        view.addSubview(picContainer)
        picContainer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            picContainer.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 48),
            picContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            picContainer.heightAnchor.constraint(equalToConstant: 90),
            picContainer.widthAnchor.constraint(equalToConstant: 90)
        ])
        // 버튼 추가
        picContainer.addSubview(picButton)
           picButton.translatesAutoresizingMaskIntoConstraints = false
           NSLayoutConstraint.activate([
               picButton.topAnchor.constraint(equalTo: picContainer.topAnchor),
               picButton.leadingAnchor.constraint(equalTo: picContainer.leadingAnchor),
               picButton.trailingAnchor.constraint(equalTo: picContainer.trailingAnchor),
               picButton.bottomAnchor.constraint(equalTo: picContainer.bottomAnchor)
           ])
        
        
    }
    private func setupNameLabel(){
        //4
        //38
        // 높이 23
        // 컨테이터
        
        
        view.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: picContainer.bottomAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
        

    }
    private func setupTextField(){
        view.addSubview(nameContainer)
        NSLayoutConstraint.activate([
            
            nameContainer.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 3),
            nameContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameContainer.heightAnchor.constraint(equalToConstant: 64)
        ])
        // 텍스트 필드
                nameContainer.addSubview(nameTextField)
                
                // 텍스트 필드
                NSLayoutConstraint.activate([
                    nameTextField.topAnchor.constraint(equalTo: nameContainer.topAnchor),
                    nameTextField.bottomAnchor.constraint(equalTo: nameContainer.bottomAnchor),
                    nameTextField.leadingAnchor.constraint(equalTo: nameContainer.leadingAnchor),
                    nameTextField.trailingAnchor.constraint(equalTo: nameContainer.trailingAnchor),
                ])
                nameTextField.translatesAutoresizingMaskIntoConstraints = false
                nameTextField.isEnabled = false // 수정가능

        
        // 버튼 컨테이너
        let buttonContainerView = UIView()
        buttonContainerView.translatesAutoresizingMaskIntoConstraints = false
        buttonContainerView.backgroundColor = .clear
        nameContainer.addSubview(buttonContainerView)
        
        NSLayoutConstraint.activate([
            buttonContainerView.widthAnchor.constraint(equalToConstant: 40),
                buttonContainerView.heightAnchor.constraint(equalToConstant: 40),
                buttonContainerView.centerYAnchor.constraint(equalTo: nameContainer.centerYAnchor),
                buttonContainerView.trailingAnchor.constraint(equalTo: nameContainer.trailingAnchor, constant: -16)
              
    
        
        ])
        buttonContainerView.addSubview(nameEditButton)
        // 클릭 되게 하려고.... 시도 중
        buttonContainerView.isUserInteractionEnabled = true
//        self.view.bringSubviewToFront(nameEditButton)
//        nameEditButton.isUserInteractionEnabled = true
//        buttonContainerView.layer.zPosition = 999
        
        NSLayoutConstraint.activate([
            nameEditButton.leadingAnchor.constraint(equalTo: buttonContainerView.leadingAnchor),
            nameEditButton.trailingAnchor.constraint(equalTo: buttonContainerView.trailingAnchor),
            nameEditButton.topAnchor.constraint(equalTo: buttonContainerView.topAnchor),
            nameEditButton.bottomAnchor.constraint(equalTo: buttonContainerView.bottomAnchor)
        ])

    }
    private func setupEmailLabel(){
        //4
        //38
        // 높이 23
        view.addSubview(emailLabel)
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emailLabel.topAnchor.constraint(equalTo: nameContainer.bottomAnchor, constant: 36),
            emailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            emailLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
    private func setupEmailTextField(){
        view.addSubview(emailTextField)
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 3),
            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            emailTextField.heightAnchor.constraint(equalToConstant: 64)
        ])
        emailTextField.isEnabled = false // 수정불가
        
        //60
        //16,16
        // 높이 64
        
    }
    // 세팅 : 완료 버튼
    private func setupCompleteButton(){
        completeButton.isEnabled = true // 버튼 활성화
        view.addSubview(completeButton)
        completeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            completeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            completeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            completeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            completeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            completeButton.heightAnchor.constraint(equalToConstant: 56)
        ])
        completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)

    }
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        currText = text
        let newText = (text as NSString).replacingCharacters(in: range, with: string)
        // 이미 동일한 카테고리가 있는 경우 return False
        let textSize = newText.count
        
        if textSize > 16 {
            
            // Your existing code to handle the error (e.g., update UI elements)
            textField.layer.borderColor = UIColor.mpRed.cgColor
            textField.layer.borderWidth = 1.0  // Set an appropriate border width
            nameEditButton.setTitleColor(.mpRed, for: .normal)

            return false
        } else {
            nameEditButton.setTitle("\(textSize)/16", for: .normal)
            textField.layer.borderColor = UIColor.clear.cgColor
            textField.layer.borderWidth = 0.0
            nameEditButton.setTitleColor(.mpDarkGray, for: .normal)
            return true
        }
    }
    
    @objc
    private func completeButtonTapped(){
        print("프로필 설정이 완료되었습니다..")
        if let changedName = nameTextField.text{
            delegate?.profileNameChanged (changedName)
            print(changedName)
        }
       
        dismiss(animated: true, completion: nil)
    }
}
