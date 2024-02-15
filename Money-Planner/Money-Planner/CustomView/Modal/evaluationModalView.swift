//
//  evaluationModalView.swift
//  Money-Planner
//
//  Created by Jini on 2024/02/12.
//

import Foundation
import UIKit

class evaluationModalView : UIViewController {
    
    //amount = 목표금액 - 쓴금액
    var amount = 3000 //임시값
    
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
    
    let completeButton : UIButton = {
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
        
        //isZeroDay = 0
        //0원 소비했어요 (쓴 금액 0일때)
        //setupZeroView()
        
        if amount >= 0 { //목표 금액보다 ~원 아꼈어요 (amount값 양수일때)
            setupSpareView()
        }
        else if amount < 0 { //목표 금액보다 ~원 더 썼어요 (amount값 음수일때)
            setupWasteView()
        }
        
        

        
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

    private func setupSpareView() {
        customModal.addSubview(titleLabel)
        customModal.addSubview(contentLabel)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        
        let formattedAmount = Formatter.decimalFormatter.string(from: NSNumber(value: amount)) ?? "\(amount)"
        let titleText = "오늘 목표 금액보다\n\(formattedAmount)원을 아꼈어요"
        let titleAttributedText = NSAttributedString(string: titleText, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        titleLabel.attributedText = titleAttributedText
        titleLabel.textAlignment = .center
       
        let contentAttributedText = NSAttributedString(string: "아주 잘 하고 있어요!\n이대로 알뜰함을 유지해요", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
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
        completeButton.translatesAutoresizingMaskIntoConstraints = false
        
        customModal.addSubview(ImageView)
        customModal.addSubview(completeButton)
        
        NSLayoutConstraint.activate([
            ImageView.leadingAnchor.constraint(equalTo: customModal.leadingAnchor, constant: 87),
            ImageView.trailingAnchor.constraint(equalTo: customModal.trailingAnchor, constant: -87),
            ImageView.bottomAnchor.constraint(equalTo: completeButton.topAnchor, constant: -50),
            ImageView.heightAnchor.constraint(equalToConstant: 87),
            
            completeButton.bottomAnchor.constraint(equalTo: customModal.bottomAnchor, constant: -15),
            completeButton.leadingAnchor.constraint(equalTo: customModal.leadingAnchor, constant: 15),
            completeButton.trailingAnchor.constraint(equalTo: customModal.trailingAnchor, constant: -15),
            completeButton.heightAnchor.constraint(equalToConstant: 58)
        ])
    }
    
    private func setupWasteView() {
        customModal.addSubview(titleLabel)
        customModal.addSubview(contentLabel)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        
        let absoluteAmount = abs(amount)
        let formattedAmount = Formatter.decimalFormatter.string(from: NSNumber(value: absoluteAmount)) ?? "\(absoluteAmount)"
        let titleText = "오늘 목표 금액보다\n\(formattedAmount)원을 더 썼어요"
        let titleAttributedText = NSAttributedString(string: titleText, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        titleLabel.attributedText = titleAttributedText
        titleLabel.textAlignment = .center
       
        let contentAttributedText = NSAttributedString(string: "내일부터 다시 알뜰하게!\n알뜰한 소비를 응원해요", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
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
        completeButton.translatesAutoresizingMaskIntoConstraints = false
        
        customModal.addSubview(ImageView)
        customModal.addSubview(completeButton)
        
        NSLayoutConstraint.activate([
            ImageView.leadingAnchor.constraint(equalTo: customModal.leadingAnchor, constant: 87),
            ImageView.trailingAnchor.constraint(equalTo: customModal.trailingAnchor, constant: -87),
            ImageView.bottomAnchor.constraint(equalTo: completeButton.topAnchor, constant: -50),
            ImageView.heightAnchor.constraint(equalToConstant: 87),
            
            completeButton.bottomAnchor.constraint(equalTo: customModal.bottomAnchor, constant: -15),
            completeButton.leadingAnchor.constraint(equalTo: customModal.leadingAnchor, constant: 15),
            completeButton.trailingAnchor.constraint(equalTo: customModal.trailingAnchor, constant: -15),
            completeButton.heightAnchor.constraint(equalToConstant: 58)
        ])
    }
    

}
