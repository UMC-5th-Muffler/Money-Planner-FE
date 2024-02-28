//
//  AskViewController.swift
//  Money-Planner
//
//  Created by p_kxn_g on 2/3/24.
//

import Foundation
import UIKit

//protocol ProfileViewDelegate : AnyObject{
//    func profileNameChanged(_ userName : String)
//    
//}
class AskViewController: UIViewController,UITextFieldDelegate,UITextViewDelegate,PopupViewDelegate {
    func popupChecked() {
        // 확인 누르면 문의하기 화면도 없어짐
        dismiss(animated: true)
    }
    
    private var UserName: String?
    //weak var delegate: ProfileViewDelegate?
    var completeCheck = compeleBtnCheck()
    var currTextSize : Int?

    private lazy var headerView = HeaderView(title: "문의하기")
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
 
  
    private var completeButton = MainBottomBtn(title: "완료")
    private let emailTextField : UITextField = {
        let text = UITextField()
        text.placeholder = "example@email.com"
        let placeholderColor = UIColor.mpGray // Replace with your desired color

        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: placeholderColor,
        ]

        let attributedPlaceholder = NSAttributedString(string: "example@email.com", attributes: attributes)
        text.attributedPlaceholder = attributedPlaceholder        
        text.layer.cornerRadius = 8
        text.layer.masksToBounds = true
        text.borderStyle = .none
        text.font = UIFont.mpFont20M()
        text.tintColor = UIColor.mpMainColor
        text.backgroundColor = .mpGypsumGray
        text.keyboardType = .default
        // 여백 추가
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: text.frame.height)) // 조절하고자 하는 여백 크기
        text.leftView = leftView
        text.leftViewMode = .always
        // 활성화
        text.isEnabled = true

        return text
    }()
    private let contentsTextField : UITextView = {
        let text = UITextView()
        text.text = "어떤 내용이 궁금하신가요?"
        text.layer.cornerRadius = 8
        text.layer.masksToBounds = true
        text.font = UIFont.mpFont16M()
        text.tintColor = UIColor.mpMainColor
        text.textColor = .mpGray
        text.backgroundColor = .mpGypsumGray
        text.keyboardType = .default
        text.isMultipleTouchEnabled = true
        // 자간 설정
        // Set letter spacing directly on typingAttributes
        let letterSpacing: CGFloat = -0.02 // Adjust the value as needed
            text.typingAttributes[NSAttributedString.Key.kern] = letterSpacing


        // 여백 추가
        text.textContainerInset = UIEdgeInsets(top: 20, left: 18, bottom: 0, right: 20)

        // Set placeholder
        text.textColor = UIColor.lightGray


        
        return text
    }()
    private let emailLabel : MPLabel = {
        let label = MPLabel()
        label.font = .mpFont14B()
        label.text = "이메일"
        label.textColor = .mpGray
        return label
    }()
    private let emailLabel2 : MPLabel = {
        let label = MPLabel()
        label.font = .mpFont14M()
        label.text = "문의에 대한 답변을 이메일로 보내드려요"
        label.textColor = .mpDarkGray
        return label
    }()
    private let contentsLabel : MPLabel = {
        let label = MPLabel()
        label.font = .mpFont14B()
        label.text = "문의내용"
        label.textColor = .mpGray
        return label
    }()
    
    private let contentsSize : MPLabel = {
        let label = MPLabel()
        label.font = .mpFont14M()
        label.text = "0/250"
        label.textColor = .mpDarkGray
        return label
    }()
    private let contentsError : MPLabel = {
        let label = MPLabel()
        label.font = .mpFont14M()
        label.text = "최대 글자수는 250자입니다."
        label.textColor = .clear
        return label
    }()
    override func viewDidLoad() {
        setupUI()
    }
    private func setupUI() {
        // 배경색상 추가
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "mpWhite")
        view.backgroundColor = .systemBackground
        // 완료 버튼 활성화 확인
        print(completeCheck.contentsError)
        // 헤더
        setupHeader()
        
        // 완료 버튼 추가
        setupCompleteButton()
        
        setupEmailLabel()
        setupEmailTextField()
        setupContentsLabel()
        setupContentsTextField()
        
        //nameTextField.delegate = self // Make sure to set the delegate
        emailTextField.delegate = self
        contentsTextField.delegate = self
       
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
        
        headerView.addBackButtonTarget(target: self, action: #selector(previousScreen), for: .touchUpInside)
    }
    @objc private func previousScreen(){
        dismiss(animated: true)
    }
                                             
    private func setupEmailLabel(){
        view.addSubview(emailLabel)
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emailLabel.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 40),
            emailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            emailLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
        ])
        

    }
    private func setupEmailTextField(){
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emailTextField)
        NSLayoutConstraint.activate([
            
            emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 10),
            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            emailTextField.heightAnchor.constraint(equalToConstant: 64)
        ])
        
        emailLabel2.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emailLabel2)
        NSLayoutConstraint.activate([
            
            emailLabel2.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 10),
            emailLabel2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            emailLabel2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])


    }
    private func setupContentsLabel(){
        //4
        //38
        // 높이 23
        view.addSubview(contentsLabel)
        contentsLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentsLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 77),
            contentsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            contentsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
    private func setupContentsTextField(){
        view.addSubview(contentsTextField)
        contentsTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentsTextField.topAnchor.constraint(equalTo: contentsLabel.bottomAnchor, constant: 10),
            contentsTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentsTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            contentsTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            contentsTextField.heightAnchor.constraint(equalToConstant: 280)
        ])
        view.addSubview(contentsSize)
        view.addSubview(contentsError)
        contentsSize.translatesAutoresizingMaskIntoConstraints = false
        contentsError.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentsSize.topAnchor.constraint(equalTo: contentsTextField.bottomAnchor, constant: 8),
            contentsSize.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            contentsError.topAnchor.constraint(equalTo: contentsTextField.bottomAnchor, constant: 8),
            contentsError.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
        ])

    }
    // 세팅 : 완료 버튼
    private func setupCompleteButton(){
        completeButton.isEnabled = false // 버튼 활성화
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
    
    private func setTextViewPlaceholder() {
        if contentsTextField.text == "" {
            contentsTextField.text = "어떤 내용이 궁금하신가요?"
            contentsTextField.textColor = UIColor.lightGray
        } else if contentsTextField.text == "어떤 내용이 궁금하신가요?"{
            contentsTextField.text = ""
            contentsTextField.textColor = UIColor.black
        }
    }


    // MARK: - UITextViewDelegate

       func textViewDidBeginEditing(_ textView: UITextView) {
           if textView.textColor == UIColor.lightGray {
               textView.text = nil
               textView.textColor = UIColor.black
           }
       }

       func textViewDidEndEditing(_ textView: UITextView) {
           if textView.text.isEmpty {
               textView.text = "Placeholder Text"
               textView.textColor = UIColor.lightGray
               completeCheck.contentsWriten = false
               updateCompleteButtonState()
           }
           completeCheck.contentsWriten = true
           updateCompleteButtonState()
       }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // 현재 텍스트뷰의 글자 수 계산
        guard let currentText = textView.text else { return false }
        let newText = (currentText as NSString).replacingCharacters(in: range, with: text)
        
        // 텍스트뷰가 비어있지 않으면 플레이스홀더 숨기기
        let textSize = newText.count
        
        
        // 글자 수가 10을 초과하면 입력을 허용하지 않음
        if newText.count > 250 {
            contentsError.textColor = .mpRed
            contentsTextField.layer.borderWidth = 1.0
            contentsTextField.layer.borderColor = UIColor.mpRed.cgColor
            completeCheck.contentsError = false
            updateCompleteButtonState()
            return false
        } else {
            contentsSize.text = "\(textSize)/250"
            contentsError.textColor = .clear
            contentsTextField.layer.borderColor = UIColor.clear.cgColor
            completeCheck.contentsError = true
            updateCompleteButtonState()
            return true
        }
    }


   
    // MARK: - UItextFieldDelegate

    
    func textField(_ textField: UITextField,shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == emailTextField {
            // 현재 텍스트필드의 텍스트
            let currentText = textField.text ?? ""
            // 새로 입력되는 문자열
            let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
            let textSize = newText.count
            if textSize > 0 {
                completeCheck.emailWriten = true
                updateCompleteButtonState()
            }
            else{
                completeCheck.emailWriten = false
                updateCompleteButtonState()
            }
            // 이메일 형식 검사
            if isValidEmail(email: newText) {
                // 올바른 이메일 형식
                emailTextField.layer.borderColor = UIColor.clear.cgColor
                emailLabel2.textColor = .mpDarkGray
                emailLabel2.text = "문의에 대한 답변을 이메일로 보내드려요."
                completeCheck.emailError = true
                updateCompleteButtonState()


            } else {
                // 잘못된 이메일 형식

                emailTextField.layer.borderColor = UIColor.mpRed.cgColor
                emailTextField.layer.borderWidth = 1.0
                emailLabel2.textColor = .mpRed
                emailLabel2.text = "이메일 형식이 올바르지 않습니다."
                completeCheck.emailError = false
                updateCompleteButtonState()
            }
        }

        return true
    }
    
    // 이메일 형식 검사 함수
        func isValidEmail(email: String) -> Bool {
            let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
            return emailPredicate.evaluate(with: email)
        }
    
    @objc
    private func completeButtonTapped(){
        print("문의하기가 완료되었습니다..")
      // api 연결
        let completeVC = PopupViewController() // 로그아웃 완료 팝업 띄우기
        completeVC.titleLabel.text = "문의하기가 완료되었습니다."
        completeVC.contentLabel.text = "1:1 문의에 대한 답변은 이메일로 보내드려요"
        completeVC.contentLabel.font = .mpFont16M()
        completeVC.delegate = self
        present(completeVC, animated: true)
        //dismiss(animated: true, completion: nil)
    }
    
    struct compeleBtnCheck {
        var contentsWriten : Bool = false
        var emailWriten : Bool = false
        var emailError : Bool = true
        var contentsError : Bool = true

        
    }
    // 완료 버튼 상태 갱신
        private func updateCompleteButtonState() {
            // email, contents 입력 여부 및 에러 상태에 따라 버튼 활성화/비활성화 결정
            let isButtonEnabled = completeCheck.emailWriten && completeCheck.contentsWriten && completeCheck.emailError && completeCheck.contentsError
            print(isButtonEnabled)
            print(completeCheck.emailWriten )
            print(completeCheck.emailError )
            print(completeCheck.contentsWriten )
            print(completeCheck.contentsError )

            completeButton.isEnabled = isButtonEnabled
        }
}
