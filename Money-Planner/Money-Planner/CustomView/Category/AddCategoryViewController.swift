//
//  AddCategoryViewController.swift
//  Money-Planner
//
//  Created by p_kxn_g on 1/30/24.
//

import Foundation
import UIKit

// 카테고리 직접 추가
protocol AddCategoryViewDelegate : AnyObject{
    func AddCategoryCompleted (_ name : String, iconName: Int)
    
}
class AddCategoryViewController: UIViewController,UITextFieldDelegate, CategoryIconSelectionDelegate {
    func didSelectCategoryIcon(_ icon: Int?) {
        print("아이콘 설정 완료")
        selectedIcon = icon
        if let icon = icon{
            picButton.setImage(icons[icon], for: .normal)
            
        }
    }
    var selectedIcon : Int? = 3
    let icons: [UIImage?] = [
        UIImage(named: "add-01"),
        UIImage(named: "add-02"),
        UIImage(named: "add-03"),
        UIImage(named: "add-04"),
        UIImage(named: "add-05"),
        UIImage(named: "add-06"),
        UIImage(named: "add-07"),
        UIImage(named: "add-08"),
        UIImage(named: "add-09"),
        UIImage(named: "add-10"),
    ]
    weak var delegate: AddCategoryViewDelegate?
    private lazy var headerView = HeaderView(title: "카테고리 추가")
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
        let buttonImg = UIImage(named: "add-04")
        button.setImage(buttonImg, for: .normal)
        button.backgroundColor = .mpGypsumGray
 
        return button
        
        
    }()
    let textContainer : UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    let errorContainer : UIView = {
        let view = UIView()
        //view.backgroundColor = .red
        return view
    }()
    private var completeButton = MainBottomBtn(title: "완료")
    private let categoryTextField : UITextField = {
        let text = UITextField()
        text.placeholder = "카테고리명을 입력하세요"
        text.layer.cornerRadius = 8
        text.layer.masksToBounds = true
        text.borderStyle = .none
        text.font = UIFont.mpFont20M()
        text.tintColor = UIColor.mpMainColor
        text.backgroundColor = .mpGypsumGray
        text.keyboardType = .default
        // 여백 추가
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 24, height: text.frame.height)) // 조절하고자 하는 여백 크기
        text.leftView = leftView
        text.leftViewMode = .always
        
        return text
    }()
    private let errorLabel : MPLabel = {
        let label = MPLabel()
        label.font = .mpFont14M()
        label.text = "최대 6글자"
        label.textColor = .mpDarkGray
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
        
        // 헤더
        setupHeader()
        
        // 완료 버튼 추가
        setupCompleteButton()
        setupPic()
        setupTextField()
        setupError()
        categoryTextField.delegate = self // Make sure to set the delegate
        picButton.addTarget(self, action: #selector(selectIcon), for: .touchUpInside)

    }
    @objc
    private func selectIcon(){
        let iconSelectionVC = CategoryIconSelectionViewController()
        iconSelectionVC.delegate = self
        present(iconSelectionVC, animated: true)
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
    private func setupTextField(){
        view.addSubview(categoryTextField)
        categoryTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            categoryTextField.topAnchor.constraint(equalTo: picContainer.bottomAnchor, constant: 48),
            categoryTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            categoryTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoryTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            categoryTextField.heightAnchor.constraint(equalToConstant: 64)
        ])
        categoryTextField.isEnabled = true // 수정가능
        categoryTextField.tintColor = .mpMainColor

        
    }
    private func setupError(){
        //4
        //38
        // 높이 23
        view.addSubview(errorLabel)
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            errorLabel.topAnchor.constraint(equalTo: categoryTextField.bottomAnchor, constant: 4),
            errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 38),
            errorLabel.widthAnchor.constraint(equalToConstant: 300), // 가로
            errorLabel.heightAnchor.constraint(equalToConstant: 23)
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
            completeButton.heightAnchor.constraint(equalToConstant: 56)
        ])
        completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)

    }
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        currText = text
        let newText = (text as NSString).replacingCharacters(in: range, with: string)
        // 이미 동일한 카테고리가 있는 경우 return False
        if newText.count != 0 {
            completeButton.isEnabled = true
        }
        if newText.count > 6 {
            
            // Your existing code to handle the error (e.g., update UI elements)
            textField.layer.borderColor = UIColor.mpRed.cgColor
            textField.layer.borderWidth = 1.0  // Set an appropriate border width
            errorLabel.text = "최대 6글자로 입력해주세요"
            errorLabel.textColor = UIColor.mpRed
            return false
        } else {
            
            // Your existing code to handle the case when character count is within limits
            textField.layer.borderColor = UIColor.clear.cgColor
            textField.layer.borderWidth = 0.0
            errorLabel.text = "최대 6글자"
            errorLabel.textColor = UIColor.mpRed
            errorLabel.textColor = .mpDarkGray

            return true
        }
    }
    @objc
    private func completeButtonTapped(){
        print("카테고리 추가가 완료되었습니다.")
        // 카테고리 추가 완료
        delegate?.AddCategoryCompleted(currText, iconName: selectedIcon!)
        dismiss(animated: true, completion: nil)
    }
}
