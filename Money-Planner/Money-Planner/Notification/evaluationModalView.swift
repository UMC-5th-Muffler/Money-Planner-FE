//
//  evaluationModalView.swift
//  Money-Planner
//
//  Created by Jini on 2024/02/12.
//

import Foundation
import UIKit

class evaluationModalView : UIViewController {
    
    var dateText = ""
    var rateInfo : RateInfo?
    
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
    
    let imageView : UIImageView = {
        let view = UIImageView()
        
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
        
        fetchRateData()

    }
    
    func presentCustomModal() {
        customModal.backgroundColor = UIColor.mpWhite
        view.addSubview(customModal)
        customModal.center = view.center
        
    }
    
    func fetchRateData() {
        let date = dateText
        ExpenseRepository.shared.getRateInformation(date: date) { result in
            switch result {
            case .success(let data):
                print(data)
                self.rateInfo = data!
                self.amount = (self.rateInfo?.dailyPlanBudget ?? 0) - (self.rateInfo?.dailyTotalCost ?? 0)
                
                DispatchQueue.main.async {
                    self.presentCustomModal()
                    self.setupBackground()
                    print(self.amount)
                    print(self.dateText)
                    
                    if self.rateInfo?.isZeroDay == true {
                        self.setupZeroView()
                    }
                    else {
                        if self.amount > 0 { //목표 금액보다 ~원 아꼈어요 (amount값 양수일때)
                            self.setupSpareView()
                        }
                        else if self.amount < 0 { //목표 금액보다 ~원 더 썼어요 (amount값 음수일때)
                            self.setupWasteView()
                        }
                        else if self.amount == 0 { //목표 금액 = 소비금액
                            self.setupGoodView()
                        }
                    }

                }
            case .failure(let error):
                // 에러가 발생했을 때 처리
                print("Error: \(error)")
            }
        }
    }
    
    private func setupBackground() {
        view.backgroundColor = UIColor.mpDim
        customModal.layer.cornerRadius = 25
        customModal.layer.masksToBounds = true
    }

    private func setupSpareView() {
        customModal.frame = CGRect(x: 0, y: 0, width: 322, height: 426)
        customModal.center = view.center
        
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
        
        imageView.image = UIImage(named: "img_popup_save")
        imageView.contentMode = .scaleAspectFit
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        completeButton.translatesAutoresizingMaskIntoConstraints = false
        
        customModal.addSubview(imageView)
        customModal.addSubview(completeButton)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: customModal.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 12),
            imageView.heightAnchor.constraint(equalToConstant: 178),
            imageView.widthAnchor.constraint(equalToConstant: 210),
            
            completeButton.bottomAnchor.constraint(equalTo: customModal.bottomAnchor, constant: -19),
            completeButton.leadingAnchor.constraint(equalTo: customModal.leadingAnchor, constant: 15),
            completeButton.trailingAnchor.constraint(equalTo: customModal.trailingAnchor, constant: -15),
            completeButton.heightAnchor.constraint(equalToConstant: 58)
        ])
    }
    
    private func setupWasteView() {
        customModal.frame = CGRect(x: 0, y: 0, width: 322, height: 426)
        customModal.center = view.center
        
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
        
        imageView.image = UIImage(named: "img_popup_over")
        imageView.contentMode = .scaleAspectFit
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        completeButton.translatesAutoresizingMaskIntoConstraints = false
        
        customModal.addSubview(imageView)
        customModal.addSubview(completeButton)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: customModal.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 12),
            imageView.heightAnchor.constraint(equalToConstant: 161),
            imageView.widthAnchor.constraint(equalToConstant: 194),
            
            completeButton.bottomAnchor.constraint(equalTo: customModal.bottomAnchor, constant: -19),
            completeButton.leadingAnchor.constraint(equalTo: customModal.leadingAnchor, constant: 15),
            completeButton.trailingAnchor.constraint(equalTo: customModal.trailingAnchor, constant: -15),
            completeButton.heightAnchor.constraint(equalToConstant: 58)
        ])
    }
    
    private func setupGoodView() {
        customModal.frame = CGRect(x: 0, y: 0, width: 322, height: 426)
        customModal.center = view.center
        
        customModal.addSubview(titleLabel)
        customModal.addSubview(contentLabel)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        
        let titleText = "오늘 목표 금액만큼\n소비했어요"
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
        
        imageView.image = UIImage(named: "img_popup_save")
        imageView.contentMode = .scaleAspectFit
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        completeButton.translatesAutoresizingMaskIntoConstraints = false
        
        customModal.addSubview(imageView)
        customModal.addSubview(completeButton)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: customModal.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 12),
            imageView.heightAnchor.constraint(equalToConstant: 178),
            imageView.widthAnchor.constraint(equalToConstant: 210),
            
            completeButton.bottomAnchor.constraint(equalTo: customModal.bottomAnchor, constant: -19),
            completeButton.leadingAnchor.constraint(equalTo: customModal.leadingAnchor, constant: 15),
            completeButton.trailingAnchor.constraint(equalTo: customModal.trailingAnchor, constant: -15),
            completeButton.heightAnchor.constraint(equalToConstant: 58)
        ])
    }
    
    private func setupZeroView() {
        customModal.addSubview(titleLabel)
        customModal.addSubview(contentLabel)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        
        let titleText = "오늘 0원 소비했어요"
        let titleAttributedText = NSAttributedString(string: titleText, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
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
        
        imageView.image = UIImage(named: "img_popup_save-zero")
        imageView.contentMode = .scaleAspectFit
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        completeButton.translatesAutoresizingMaskIntoConstraints = false
        
        customModal.addSubview(imageView)
        customModal.addSubview(completeButton)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: customModal.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 12),
            imageView.heightAnchor.constraint(equalToConstant: 161),
            imageView.widthAnchor.constraint(equalToConstant: 194),
            
            completeButton.bottomAnchor.constraint(equalTo: customModal.bottomAnchor, constant: -19),
            completeButton.leadingAnchor.constraint(equalTo: customModal.leadingAnchor, constant: 15),
            completeButton.trailingAnchor.constraint(equalTo: customModal.trailingAnchor, constant: -15),
            completeButton.heightAnchor.constraint(equalToConstant: 58)
        ])
    }

}
