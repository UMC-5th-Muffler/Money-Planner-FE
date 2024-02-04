//
//  GoalFinalViewController.swift
//  Money-Planner
//
//  Created by 유철민 on 1/12/24.
//

import Foundation
import RxMoya
import UIKit


class GoalFinalViewController : UIViewController{
    
    private let header = HeaderView(title: "")
    private let descriptionView = DescriptionView(text: "목표 생성이\n완료되었어요!", alignToCenter: false)
    private let subDescriptionView = SubDescriptionView(text: "혜원님의 알뜰한 소비를 응원해요!", alignToCenter: false)
    private let goalCard = GoalCard()
    private let btmButton = MainBottomBtn(title: "목표 시작하기")
    
    private let goalCreationManager = GoalCreationManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupViews()
        setupConstraints()
    }
    
    func setupViews(){
        view.addSubview(header)
        view.addSubview(descriptionView)
        view.addSubview(subDescriptionView)
        view.addSubview(goalCard)
        view.addSubview(btmButton)
    }
    
    func setupConstraints(){
        header.translatesAutoresizingMaskIntoConstraints = false
        descriptionView.translatesAutoresizingMaskIntoConstraints = false
        subDescriptionView.translatesAutoresizingMaskIntoConstraints = false
        goalCard.translatesAutoresizingMaskIntoConstraints = false
        btmButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Constraints for the header
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            header.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        // Constraints for the descriptionView
        NSLayoutConstraint.activate([
            descriptionView.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 30),
            descriptionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        // Constraints for the subDescriptionView
        NSLayoutConstraint.activate([
            subDescriptionView.topAnchor.constraint(equalTo: descriptionView.bottomAnchor, constant: 10),
            subDescriptionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            subDescriptionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        // Constraints for the goalCard
        NSLayoutConstraint.activate([
            goalCard.bottomAnchor.constraint(equalTo: btmButton.topAnchor, constant: -20),
            goalCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            goalCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            goalCard.heightAnchor.constraint(equalToConstant: 144)
        ])
        
        // Constraints for the main bottom button
        NSLayoutConstraint.activate([
            btmButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            btmButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            btmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            btmButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // It's important to also set the vertical constraints for goalCard to avoid vertical ambiguity.
        // Since we don't have the exact vertical size of goalCard, we can set the bottom constraint to be greater than or equal to the btmButton's topAnchor with a constant spacing
        NSLayoutConstraint.activate([
            goalCard.bottomAnchor.constraint(lessThanOrEqualTo: btmButton.topAnchor, constant: -20)
        ])
    }
    
    @objc func completeBtnTapped(){
        //navigation을 시작한 첫 화면인 GoalMainViewController 으로 돌아가기
        
        //post하기
        
        //manager 비우기
        goalCreationManager.clear()
    }
}

class GoalCard : UIView {
    
    var nameTitle = UILabel()
    var periodTitle = UILabel()
    var amountTitle = UILabel()
    var goalName = UILabel()
    var goalPeriod = UILabel()
    var goalAmount = UILabel()
    
    var goalCreationManager = GoalCreationManager.shared
    var goalViewModel = GoalViewModel.shared
    
    override init(frame: CGRect){
        super.init(frame: frame)// 이게 무슨 의미인가 추후 공부
        backgroundColor = .mpGypsumGray
        layer.cornerRadius = 10
        setView()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLayout() {
        // Name Title
        nameTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameTitle.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            nameTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            nameTitle.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        // Period Title
        periodTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            periodTitle.centerYAnchor.constraint(equalTo: centerYAnchor),
            periodTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            periodTitle.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        // Amount Title
        amountTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            amountTitle.heightAnchor.constraint(equalToConstant: 20),
            amountTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            amountTitle.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -20)
        ])
        
        // Goal Name
        goalName.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            goalName.centerYAnchor.constraint(equalTo: nameTitle.centerYAnchor),
            goalName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
        
        // Goal Period
        goalPeriod.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            goalPeriod.centerYAnchor.constraint(equalTo: periodTitle.centerYAnchor),
            goalPeriod.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
        
        // Goal Amount
        goalAmount.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            goalAmount.centerYAnchor.constraint(equalTo: amountTitle.centerYAnchor),
            goalAmount.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
    
    func setView(){
        
        nameTitle.text = "목표 이름"
        nameTitle.textColor = .mpDarkGray
        nameTitle.font = .mpFont16M()
        
        goalName.text = goalCreationManager.goalEmoji! + " " + goalCreationManager.goalName!
        goalName.textColor = .mpBlack
        goalName.font = .mpFont16M()
        
        periodTitle.text = "목표 기간"
        periodTitle.textColor = .mpDarkGray
        periodTitle.font = .mpFont16M()
        
        setPeriod()
        goalPeriod.textColor = .mpBlack
        goalPeriod.font = .mpFont16M()
        
        amountTitle.text = "목표 금액"
        amountTitle.textColor = .mpDarkGray
        amountTitle.font = .mpFont16M()
        
        goalAmount.text = String(goalCreationManager.goalAmount!) // , 필요해.
        goalAmount.textColor = .mpBlack
        goalAmount.font = .mpFont16M()
        
        addSubview(nameTitle)
        addSubview(goalName)
        addSubview(periodTitle)
        addSubview(goalPeriod)
        addSubview(amountTitle)
        addSubview(goalAmount)
        
    }
    
    func setPeriod() {
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        let startDate = goalCreationManager.goalStart!
        let endDate = goalCreationManager.goalEnd!

        var tmpStr : String
        let startDateString = formatter.string(from: startDate)
        let endDateString = formatter.string(from: endDate)
        tmpStr = "\(startDateString) - \(endDateString) "
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: startDate, to: endDate)
        if let day = components.day {
            tmpStr += day%7==0 ? "(\(day/7)주)" : "(\(day)일)"
        }
        
        goalPeriod.text = tmpStr
        
    }
    
}
