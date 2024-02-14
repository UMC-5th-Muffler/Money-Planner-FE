//
//  zeroModalView.swift
//  Money-Planner
//
//  Created by Jini on 2024/02/12.
//

import Foundation
import UIKit

class zeroModalView : UIViewController {
    
    //제로데이인지
    var isZeroDay = true
    
    let customModal = UIView(frame: CGRect(x: 0, y: 0, width: 322, height: 400))
    
    let titleLabel: MPLabel = {
        let label = MPLabel()
        label.text = ""
        label.numberOfLines = 0
        label.font = UIFont.mpFont20B()
        
        return label
    }()
    
    let contentLabel : MPLabel = {
        let label = MPLabel()
        label.text = ""
        label.numberOfLines = 0
        label.font = UIFont.mpFont16M()
        
        return label
    }()
    
    let ImageView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.mpGray
        
        return view
    }()
    
    let controlButtons = SmallBtnView()
    
    let confirmButton : UIButton = {
        let button = UIButton()
        button.setTitle("확인", for: .normal)
        button.setTitleColor(UIColor.mpWhite, for: .normal)
        button.backgroundColor = UIColor.mpMainColor
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        
        return button
    }()
    
    // 모달 제목 바꾸는 함수
    func changeTitle(title : String){
        titleLabel.text = title
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presentCustomModal()
        setupBackground()
        
        if isZeroDay == true {
            setupZeroView()
        }
        else {
            setupCancelZeroView()
            
            controlButtons.addCancelAction(target: self, action: #selector(cancelButtonTapped))
            controlButtons.addCompleteAction(target: self, action: #selector(confirmButtonTapped))
        }
        

    }
    
    @objc func cancelButtonTapped() {
        print("취소 버튼이 탭되었습니다.")
        dismiss(animated: true, completion: nil)
    }
    
    @objc func confirmButtonTapped() {
        print("해제 버튼이 탭되었습니다.")
        // 해제 버튼 액션 처리
    }
    
    func presentCustomModal() {
        customModal.backgroundColor = UIColor.mpWhite
        view.addSubview(customModal)
        customModal.center = view.center
        
    }
    
    private func setupBackground() {
        view.backgroundColor = UIColor.mpDim
        customModal.layer.cornerRadius = 25
        customModal.layer.masksToBounds = true
    }
    
    private func setupZeroView() {
        customModal.addSubview(titleLabel)
        customModal.addSubview(contentLabel)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        
        let titleAttributedText = NSAttributedString(string: "오늘 0원 소비했어요!", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        titleLabel.attributedText = titleAttributedText
        titleLabel.textAlignment = .center
       
        let contentAttributedText = NSAttributedString(string: "아주 잘 하고 있어요!\n스스로를 칭찬해주세요", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        contentLabel.attributedText = contentAttributedText
        contentLabel.textAlignment = .center
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: customModal.topAnchor, constant: 35),
            titleLabel.centerXAnchor.constraint(equalTo: customModal.centerXAnchor),
            
            contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            contentLabel.centerXAnchor.constraint(equalTo: customModal.centerXAnchor)
            
        ])
        
        ImageView.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        
        customModal.addSubview(ImageView)
        customModal.addSubview(confirmButton)
        
        NSLayoutConstraint.activate([
            ImageView.leadingAnchor.constraint(equalTo: customModal.leadingAnchor, constant: 87),
            ImageView.trailingAnchor.constraint(equalTo: customModal.trailingAnchor, constant: -87),
            ImageView.bottomAnchor.constraint(equalTo: confirmButton.topAnchor, constant: -50),
            ImageView.heightAnchor.constraint(equalToConstant: 87),
            
            confirmButton.bottomAnchor.constraint(equalTo: customModal.bottomAnchor, constant: -15),
            confirmButton.leadingAnchor.constraint(equalTo: customModal.leadingAnchor, constant: 15),
            confirmButton.trailingAnchor.constraint(equalTo: customModal.trailingAnchor, constant: -15),
            confirmButton.heightAnchor.constraint(equalToConstant: 58)
        ])
    }
    
    private func setupCancelZeroView() {
        customModal.addSubview(titleLabel)
        customModal.addSubview(contentLabel)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        
        let titleAttributedText = NSAttributedString(string: "해당날짜는 '0원소비'를\n등록해둔 날이에요", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        titleLabel.attributedText = titleAttributedText
        titleLabel.textAlignment = .center
       
        let contentAttributedText = NSAttributedString(string: "이 날짜에 소비등록을 하려면\n'0원소비'를 해제해야해요", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        contentLabel.attributedText = contentAttributedText
        contentLabel.textAlignment = .center
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: customModal.topAnchor, constant: 35),
            titleLabel.centerXAnchor.constraint(equalTo: customModal.centerXAnchor),
            
            contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            contentLabel.centerXAnchor.constraint(equalTo: customModal.centerXAnchor)
            
        ])
        
        ImageView.translatesAutoresizingMaskIntoConstraints = false
        controlButtons.translatesAutoresizingMaskIntoConstraints = false
        
        customModal.addSubview(ImageView)
        customModal.addSubview(controlButtons)
        
        controlButtons.cancelButton.setTitle("취소", for: .normal)
        controlButtons.completeButton.setTitle("해제하기", for: .normal)
        
        NSLayoutConstraint.activate([
            ImageView.leadingAnchor.constraint(equalTo: customModal.leadingAnchor, constant: 87),
            ImageView.trailingAnchor.constraint(equalTo: customModal.trailingAnchor, constant: -87),
            ImageView.bottomAnchor.constraint(equalTo: controlButtons.topAnchor, constant: -50),
            ImageView.heightAnchor.constraint(equalToConstant: 87),
            
            controlButtons.bottomAnchor.constraint(equalTo: customModal.bottomAnchor, constant: -15),
            controlButtons.leadingAnchor.constraint(equalTo: customModal.leadingAnchor, constant: 15),
            controlButtons.trailingAnchor.constraint(equalTo: customModal.trailingAnchor, constant: -15),
            controlButtons.heightAnchor.constraint(equalToConstant: 58)
        ])
    }
}
