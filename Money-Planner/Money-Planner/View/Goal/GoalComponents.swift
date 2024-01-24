//
//  GoalComponents.swift
//  Money-Planner
//
//  Created by 유철민 on 1/17/24.
//

import Foundation
import UIKit

class GoalMainHeaderView: UIView {
    
    let titleLabel: UILabel
    let addNewGoalBtn: UIButton
    let fixedHeight :CGFloat = 40
    
    override init(frame: CGRect) {
        
        titleLabel = UILabel()
        addNewGoalBtn = UIButton()
        
        super.init(frame: frame)
        
        setupTitleLabel()
        setupAddNewGoalBtn()
        setupFixedHeight()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTitleLabel() {
        addSubview(titleLabel)
        titleLabel.text = "나의 목표" // 여기에 원하는 텍스트를 설정하세요.
        titleLabel.textColor = .mpBlack
        titleLabel.font = UIFont.mpFont20B()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    private func setupAddNewGoalBtn() {
        addSubview(addNewGoalBtn)
        let plusImage = UIImage(systemName: "plus")
        addNewGoalBtn.setImage(plusImage, for: .normal)
        addNewGoalBtn.tintColor = .black // mpBlack 대신 .black 사용
        addNewGoalBtn.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            addNewGoalBtn.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            addNewGoalBtn.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    private func setupFixedHeight() {
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: fixedHeight)
        ])
    }
}


class GoalPresentationCell: UITableViewCell {
    
    let goal : Goal
    let containerView = UIView()
    let btn = UIButton()
    let title = UILabel()
    let dday = UILabel()
    var progressBar : GoalProgressBar
    let progressPercentage = UILabel()
    let usedAmount = UILabel()
    
    init(goal: Goal, reuseIdentifier: String?) {
        self.goal = goal // goal을 초기화
        self.progressBar = GoalProgressBar(goalAmt: goal.goalAmount, usedAmt: goal.usedAmount)
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        setupCellLayout()
        configureCell(with: goal) // 바로 cell을 설정
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCellLayout() {
        
        addSubview(containerView)
        containerView.addSubview(btn)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            btn.topAnchor.constraint(equalTo: containerView.topAnchor),
            btn.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            btn.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            btn.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
        
        let horizontalStackView1 = UIStackView(arrangedSubviews: [title, dday])
        let horizontalStackView2 = UIStackView(arrangedSubviews: [progressBar])
        let horizontalStackView3 = UIStackView(arrangedSubviews: [progressPercentage, usedAmount])
        let verticalStackView = UIStackView(arrangedSubviews: [horizontalStackView1, horizontalStackView2, horizontalStackView3])
        
        verticalStackView.axis = .vertical
        horizontalStackView2.alignment = .center
        
        horizontalStackView3.axis = .horizontal
        horizontalStackView3.distribution = .fill
        horizontalStackView3.alignment = .leading
        

        btn.addSubview(verticalStackView)
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: btn.topAnchor, constant: 10),
            verticalStackView.bottomAnchor.constraint(equalTo: btn.bottomAnchor, constant: -10),
            verticalStackView.leadingAnchor.constraint(equalTo: btn.leadingAnchor, constant: 20),
            verticalStackView.trailingAnchor.constraint(equalTo: btn.trailingAnchor, constant: -20)
        ])
    }
    
    func configureCell(with goal: Goal) {
        
        btn.backgroundColor = .mpWhite
        btn.layer.cornerRadius = 10
        
        //title
        title.text = goal.goalEmoji + "  " + goal.goalName
        title.font = .mpFont18B()
        
        //d-day
        let startDateString = dateFormatter.string(from: goal.goalStart)
        let endDateString = dateFormatter.string(from: goal.goalEnd)
        
        let currentDate = Date()
        let isPastGoal = currentDate > goal.goalEnd
        let daysLeft = Calendar.current.dateComponents([.day], from: currentDate, to: goal.goalEnd).day ?? 0
        
        let (ddayText, ddayBackgroundColor, ddayTextColor) = isPastGoal ? ("종료", UIColor.mpLightGray, UIColor.mpGray) : ("D-\(daysLeft)", UIColor.mpCalendarHighLight, UIColor.mpMainColor)
        
        dday.text = ddayText
        dday.backgroundColor = ddayBackgroundColor
        dday.textColor = ddayTextColor
        dday.layer.cornerRadius = 10
        dday.clipsToBounds = true
        dday.textAlignment = .center
        dday.widthAnchor.constraint(equalToConstant: 50).isActive = true
        dday.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        //progressPercentage
        let progressPercentageValue = Double(goal.usedAmount) / Double(goal.goalAmount) * 100.0
        progressPercentage.text = String(format: "%.0f%%", progressPercentageValue)
        progressPercentage.textColor = .mpMainColor
        
        
        let usedAmountText = "\(goal.usedAmount) / \(goal.goalAmount) 사용"
        let goalAmountTextCnt = "/ \(goal.goalAmount) 사용".count
        let attributedText = NSMutableAttributedString(string: usedAmountText)
        attributedText.addAttribute(.foregroundColor, value: UIColor.mpGray, range: NSRange(location: 0, length: usedAmountText.count))
        attributedText.addAttribute(.foregroundColor, value: UIColor.mpLightGray, range: NSRange(location: usedAmountText.count - goalAmountTextCnt , length: goalAmountTextCnt))
        usedAmount.attributedText = attributedText
    }
}

class GoalProgressBar: UIView {
    
    let goalAmtBar = UIView()
    let usedAmtBar = UIView()
    let goalAmt: Int
    let usedAmt: Int
    
    init(goalAmt: Int, usedAmt: Int) {
        self.goalAmt = goalAmt
        self.usedAmt = usedAmt
        super.init(frame: .zero)
        setupGoalAmtBar()
        setupUsedAmtBar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupGoalAmtBar() {
        addSubview(goalAmtBar)
        goalAmtBar.backgroundColor = .mpLightGray
        goalAmtBar.layer.cornerRadius = goalAmtBar.frame.height / 2
        goalAmtBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            goalAmtBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            goalAmtBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            goalAmtBar.heightAnchor.constraint(equalToConstant: 10)
        ])
    }
    
    func setupUsedAmtBar() {
        addSubview(usedAmtBar)
        usedAmtBar.backgroundColor = usedAmt > goalAmt ? .red : .mpMainColor
        usedAmtBar.layer.cornerRadius = usedAmtBar.frame.height / 2
        usedAmtBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            usedAmtBar.leftAnchor.constraint(equalTo: goalAmtBar.leftAnchor),
            usedAmtBar.topAnchor.constraint(equalTo: goalAmtBar.topAnchor),
            usedAmtBar.heightAnchor.constraint(equalTo: goalAmtBar.heightAnchor),
            usedAmtBar.widthAnchor.constraint(equalToConstant: 0)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 현재 프레임 너비를 기반으로 usedAmtBar의 너비 계산
        let ratio = CGFloat(usedAmt) / CGFloat(goalAmt)
        let usedAmtWidth = ratio * frame.width
        
        // usedAmtBar의 너비 제약 조건(width constraint) 업데이트
        for constraint in usedAmtBar.constraints {
            if constraint.firstAttribute == .width {
                constraint.constant = usedAmtWidth
                break
            }
        }
        
        // 바의 모서리 반지름(corner radius) 업데이트
        goalAmtBar.layer.cornerRadius = goalAmtBar.frame.height / 2
        usedAmtBar.layer.cornerRadius = usedAmtBar.frame.height / 2
    }
}



// tableView 안에 들어가는 cell 중에 키보드로 수정할 수 있는 textfield를 보유
class WriteTextCell: UITableViewCell {
    
    let iconImageView = UIImageView()
    let textField = UITextField()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
        setupIconImageView()
        setupTextField()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        
        backgroundColor = UIColor.clear  // 셀의 배경을 투명하게 설정
        contentView.backgroundColor = UIColor.mpLightGray
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true//" subview들이 view의 bounds에 가둬질 수 있는 지를 판단하는 Boolean 값 "
        
        selectionStyle = .none  // 셀 선택 시 배경색 변경 없음
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
        ])
        
    }
    
    private func setupIconImageView() {
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(iconImageView)
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 30),
            iconImageView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func setupTextField() {
        textField.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(textField)
        
        textField.textColor = UIColor.mpGray
        textField.textAlignment = .left
        
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            textField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func configureCell(image: UIImage?, placeholder: String) {
        if let image = image {
            iconImageView.image = image.withTintColor(.mpGray, renderingMode: .alwaysOriginal)
        } else {
            iconImageView.image = nil
        }
        textField.placeholder = placeholder
    }
}


class MultiLineTextCell: UITableViewCell {
    
    let iconImageView = UIImageView()
    let textView = UITextView()  // UITextView로 변경
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
        setupIconImageView()
        setupTextView()  // UITextView 설정 메서드 호출
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        backgroundColor = UIColor.clear  // 셀의 배경을 투명하게 설정
        contentView.backgroundColor = UIColor.mpLightGray
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true//" subview들이 view의 bounds에 가둬질 수 있는 지를 판단하는 Boolean 값 "
        
        selectionStyle = .none  // 셀 선택 시 배경색 변경 없음
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
        ])
    }
    
    private func setupIconImageView() {
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(iconImageView)
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 30),
            iconImageView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func setupTextView() {
        textView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(textView)
        
        textView.textColor = UIColor.mpGray
        textView.textAlignment = .left
        textView.isScrollEnabled = false  // 스크롤 비활성화
        textView.font = UIFont.systemFont(ofSize: 16)  // 폰트 설정
        
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            textView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func configureCell(image: UIImage?, placeholder: String) {
        if let image = image {
            iconImageView.image = image.withTintColor(.mpGray, renderingMode:
                    .alwaysOriginal)
        } else {
            iconImageView.image = nil
        }
        
    }
}

// 금액 입력을 위한 cell
class MoneyAmountTextCell: UITableViewCell, UITextFieldDelegate {
    
    private let iconImageView = UIImageView()
    private let textField = UITextField()
    private let unitLabel = UILabel()
    private let amountLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
        setupIconImageView()
        setupUnitLabelField()
        setupTextField()
        setupAmountLabel()
        // Set the delegate for the textField
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        
        backgroundColor = UIColor.clear  // 셀의 배경을 투명하게 설정
        contentView.backgroundColor = UIColor.mpLightGray
        contentView.layer.cornerRadius = 10
        //        contentView.clipsToBounds = true//" subview들이 view의 bounds에 가둬질 수 있는 지를 판단하는 Boolean 값 "
        
        selectionStyle = .none  // 셀 선택 시 배경색 변경 없음
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
        ])
        
    }
    
    private func setupIconImageView() {
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(iconImageView)
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 30),
            iconImageView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func setupTextField() {
        textField.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(textField)
        
        textField.textColor = UIColor.mpGray
        textField.textAlignment = .left
        textField.keyboardType = .numberPad // Limit keyboard to numeric input
        
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: unitLabel.trailingAnchor, constant: -20),
            textField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    private func setupUnitLabelField() {
        unitLabel.translatesAutoresizingMaskIntoConstraints = false
        unitLabel.text = "원"
        contentView.addSubview(unitLabel)
        
        unitLabel.textColor = .mpBlack
        
        NSLayoutConstraint.activate([
            unitLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            unitLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            unitLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            unitLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    private func setupAmountLabel(){
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        amountLabel.text = "입력값이 없습니다."
        amountLabel.font = .mpFont12M()
        amountLabel.textColor = .mpGray
        contentView.addSubview(amountLabel)
        
        NSLayoutConstraint.activate([
            amountLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            amountLabel.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 1),
            amountLabel.heightAnchor.constraint(equalToConstant: 30),
            amountLabel.widthAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    func configureCell(image: UIImage?, placeholder: String) {
        if let image = image {
            iconImageView.image = image.withTintColor(.mpGray, renderingMode: .alwaysOriginal)
        } else {
            iconImageView.image = nil
        }
        textField.placeholder = placeholder
    }
    
    func showNeatAmount() {
        guard let amountText = textField.text else {
            amountLabel.textColor = .mpGray
            amountLabel.text = "입력값이 없습니다."
            return
        }
        
        let allowedCharacterSet = CharacterSet(charactersIn: "0123456789")
        let stringCharacterSet = CharacterSet(charactersIn: amountText)
        
        // Check if the entered characters are numbers
        if !allowedCharacterSet.isSuperset(of: stringCharacterSet) {
            amountLabel.textColor = .red
            amountLabel.text = "숫자만 입력 가능합니다."
            return
        }
        
        // Convert the text to an integer
        guard let amount = Int(amountText) else {
            amountLabel.textColor = .mpGray
            amountLabel.text = "유효한 숫자를 입력하세요."
            return
        }
        
        let maximumLimit: Int = 2147483647  // Define your own maximum limit
        
        if amount > maximumLimit {
            amountLabel.textColor = .red
            amountLabel.text = "숫자가 너무 큽니다."
            return
        } else {
            amountLabel.textColor = .mpGray
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal // 10진수
        formatter.maximumFractionDigits = 0 // 소수점 없음
        
        if let formattedAmount = formatter.string(from: NSNumber(value: amount)) {
            var result = ""
            let hundredMillion = amount / 100_000_000
            let tenThousand = (amount % 100_000_000) / 10_000
            let remainder = amount % 10_000
            
            if hundredMillion > 0 {
                result += "\(hundredMillion)억 "
            }
            
            if tenThousand > 0 {
                result += "\(tenThousand)만 "
            }
            
            if remainder > 0 {
                result += "\(remainder)원"
            } else if hundredMillion == 0 && tenThousand == 0 {
                result += "0원"
            }
            
            amountLabel.text = result
        }
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        showNeatAmount()
    }
    
}


// 기간 입력을 위한 버튼 cell
class PeriodCell: UITableViewCell {
    
    private let periodButton = PeriodCellButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
        setupPeriodButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        // 기존 PeriodCell setupCell 구현
        backgroundColor = UIColor.clear  // 셀의 배경을 투명하게 설정
        contentView.clipsToBounds = true//" subview들이 view의 bounds에 가둬질 수 있는 지를 판단하는 Boolean 값 "
        
        selectionStyle = .none  // 셀 선택 시 배경색 변경 없음
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
        ])
    }
    
    private func setupPeriodButton() {
        contentView.addSubview(periodButton)
        periodButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            periodButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            periodButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            periodButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            periodButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}

class PeriodCellButton: UIButton {
    
    // 이전 PeriodCell의 모든 구현을 여기로 이동
    private let iconImageView = UIImageView()
    private let periodLabel = UILabel()
    private let spanLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSelf()
        setupIconImageView()
        setupSpanLabelField()
        setupPeriodLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSelf(){
        self.backgroundColor = .mpLightGray
        self.layer.cornerRadius = 10
    }
    
    private func setupIconImageView() {
        
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.image = UIImage(systemName: "calendar")
        iconImageView.tintColor = .mpGray
        self.addSubview(iconImageView)
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 30),
            iconImageView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func setupPeriodLabel() {
        periodLabel.translatesAutoresizingMaskIntoConstraints = false
        periodLabel.text = "목표 기간 설정하기"
        self.addSubview(periodLabel)
        
        periodLabel.textColor = UIColor.mpGray
        periodLabel.textAlignment = .left
        
        NSLayoutConstraint.activate([
            periodLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 16),
            periodLabel.trailingAnchor.constraint(equalTo: spanLabel.trailingAnchor, constant: -20),
            periodLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            periodLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8)
        ])
    }
    
    private func setupSpanLabelField() {
        spanLabel.translatesAutoresizingMaskIntoConstraints = false
        spanLabel.text = ""
        self.addSubview(spanLabel)
        
        spanLabel.textColor = .mpMainColor
        
        NSLayoutConstraint.activate([
            spanLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            spanLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            spanLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            spanLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8)
        ])
    }
    
    @objc func changePeriodAndSpanLabel(){
        
    }
    
    private func getPeriod(){
        
    }
}
