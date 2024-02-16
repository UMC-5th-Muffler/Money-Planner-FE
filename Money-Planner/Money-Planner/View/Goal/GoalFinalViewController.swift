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
    private let cheerImageView : UIImageView = {
        var u = UIImageView()
        u.image = UIImage(systemName: "hands.sparkles")
        return u
    }()
    private let goalCard = GoalCard()
    private let btmButton = MainBottomBtn(title: "목표 시작하기")
    
    private let goalCreationManager = GoalCreationManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupViews()
        setupConstraints()
        btmButton.addTarget(self, action: #selector(completeBtnTapped), for: .touchUpInside)
    }
    
    func setupViews(){
        view.addSubview(header)
        view.addSubview(descriptionView)
        view.addSubview(subDescriptionView)
        view.addSubview(cheerImageView)
        view.addSubview(goalCard)
        view.addSubview(btmButton)
    }
    
    func setupConstraints(){
        header.translatesAutoresizingMaskIntoConstraints = false
        descriptionView.translatesAutoresizingMaskIntoConstraints = false
        subDescriptionView.translatesAutoresizingMaskIntoConstraints = false
        cheerImageView.translatesAutoresizingMaskIntoConstraints = false
        goalCard.translatesAutoresizingMaskIntoConstraints = false
        btmButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Constraints for the header
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.topAnchor, constant: 128),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            header.heightAnchor.constraint(equalToConstant: 72)
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
        
//        //cheerImageView
//        NSLayoutConstraint.activate([
//            cheerImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
//            cheerImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60),
//            cheerImageView.heightAnchor.constraint(equalToConstant: 250),
//            cheerImageView.topAnchor.constraint(equalTo: subDescriptionView.bottomAnchor, constant: 10),
//            cheerImageView.bottomAnchor.constraint(equalTo: goalCard.topAnchor, constant: -30)
//        ])
        
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
        //post하기 => 이건 별도로 구현하기
        goalCreationManager.addGoal()
        
        //manager 비우기
        goalCreationManager.clear()
        
        if let navigationController = navigationController {
            self.tabBarController?.tabBar.isHidden = false
            navigationController.popToRootViewController(animated: true)
            
        }
    }
}

class GoalCard : UIView {
    
    var nameTitle = MPLabel()
    var periodTitle = MPLabel()
    var amountTitle = MPLabel()
    var goalTitle = MPLabel()
    var goalPeriod = MPLabel()
    var goalBudget = MPLabel()
    
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
        goalTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            goalTitle.centerYAnchor.constraint(equalTo: nameTitle.centerYAnchor),
            goalTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
        
        // Goal Period
        goalPeriod.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            goalPeriod.centerYAnchor.constraint(equalTo: periodTitle.centerYAnchor),
            goalPeriod.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
        
        // Goal Amount
        goalBudget.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            goalBudget.centerYAnchor.constraint(equalTo: amountTitle.centerYAnchor),
            goalBudget.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
    
    func setView(){
        
        nameTitle.text = "목표 이름"
        nameTitle.textColor = .mpDarkGray
        nameTitle.font = .mpFont16M()
        
        goalTitle.text = goalCreationManager.icon! + " " + goalCreationManager.goalTitle!
        goalTitle.textColor = .mpBlack
        goalTitle.font = .mpFont16M()
        
        periodTitle.text = "목표 기간"
        periodTitle.textColor = .mpDarkGray
        periodTitle.font = .mpFont16M()
        
        setPeriod()
        goalPeriod.textColor = .mpBlack
        goalPeriod.font = .mpFont16M()
        
        amountTitle.text = "목표 금액"
        amountTitle.textColor = .mpDarkGray
        amountTitle.font = .mpFont16M()
        
        goalBudget.text = formatNumber(goalCreationManager.goalBudget!) + "원"
        goalBudget.textColor = .mpBlack
        goalBudget.font = .mpFont16M()
        
        addSubview(nameTitle)
        addSubview(goalTitle)
        addSubview(periodTitle)
        addSubview(goalPeriod)
        addSubview(amountTitle)
        addSubview(goalBudget)
        
    }
    
    func setPeriod() {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "M월 d일"
        formatter.locale = Locale(identifier: "ko_KR")
        
        let startDate = goalCreationManager.startDate!
        let endDate = goalCreationManager.endDate!

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
    
    
    private func formatNumber(_ number: Int64) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal // Use .decimal for formatting with commas.
        return numberFormatter.string(from: NSNumber(value: number)) ?? "0"
    }
    
}
