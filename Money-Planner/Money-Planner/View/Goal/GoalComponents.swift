//
//  GoalComponents.swift
//  Money-Planner
//
//  Created by 유철민 on 1/17/24.
//

import Foundation
import UIKit


class GoalMainHeaderView: UIView {
    
    let titleLabel: MPLabel
    let addNewGoalBtn: UIButton
    let fixedHeight :CGFloat = 40
    
    override init(frame: CGRect) {
        
        titleLabel = MPLabel()
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
        titleLabel.text = "나의 목표"
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
        addNewGoalBtn.tintColor = .mpBlack
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

//아무 목표도 없었을때 띄울 셀
class GoalEmptyCell: UITableViewCell {
    
    let containerView = UIView()
    //    let borderView = UIView()
    let label = MPLabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        setupCellLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCellLayout() {
        addSubview(containerView)
        containerView.addSubview(label)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        
        // Container View Constraints
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
        ])
        
        // Label Constraints
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
        ])
        
        containerView.layer.cornerRadius = 10
        containerView.backgroundColor = .clear
        
        
        label.textColor = .mpDarkGray
        label.textAlignment = .center
        label.font = UIFont.mpFont16M()
        
    }
    
    private func addDashedBorder(to view: UIView) {
        
        let lineDashPattern: [NSNumber]? = [3,2]
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.mpGray.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineDashPattern = lineDashPattern
        shapeLayer.fillColor = nil
        
        //        이렇게 직접 추가하는 방식도 있다.
        //        let path = CGMutablePath()
        //        path.addLines(between: [CGPoint(x: 0, y: 0),
        //                                    CGPoint(x: view.bounds.size.width, y: view.bounds.size.height / 2)])
        //
        //
        //        shapeLayer.path = path
        
        shapeLayer.path = UIBezierPath(roundedRect: view.bounds, cornerRadius: view.layer.cornerRadius).cgPath
        view.layer.addSublayer(shapeLayer)
    }
    
    func configure(with text: String) {
        //        label.text = text
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8 // 원하는 줄 간격 값
        paragraphStyle.alignment = .center // 가운데 정렬
        
        /* UILabel에서 텍스트를 가운데 정렬하려면 NSTextAlignment 속성을 사용하면 됩니다.
         이미 UILabel의 textAlignment 속성을 .center로 설정하고 있으므로, 가운데 정렬은 이미 적용된 상태입니다.
         하지만, NSMutableAttributedString을 사용할 때는 paragraphStyle의 alignment 속성도 설정해 주어야 합니다.*/
        
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        label.attributedText = attributedString
    }
    
    //내부의 view가 viewDidAppear 때 발동하려고 만드는 함수. autoLayout에 의해 view의 길이가 정해지므로, view가 완전히 생성된 이후에 조작한다.
    override func layoutSubviews() {
        super.layoutSubviews()
        addDashedBorder(to: containerView)
    }
}

//목표가 있을때 셀
class GoalPresentationCell: UITableViewCell {
    
    let goal : Goal
    let containerView = UIView()
    let btn = UIButton()
    let title = MPLabel()
    let dday = MPLabel()
    var progressBar : GoalProgressBar
    let progressPercentage = MPLabel()
    let usedAmount = MPLabel()
    
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
    
    //금액에 , 넣기
    private func setComma(cash: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: cash)) ?? ""
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
        
        // vericalStackView layout 처리
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
        title.font = .mpFont16M()
        title.textColor = .mpBlack
        
        //d-day
        dday.font = .mpFont12M()
        let currentDate = Date()
        let isPastGoal = currentDate > goal.goalEnd
        let isFutureGoal = currentDate < goal.goalStart
        
        let daysLeft = Calendar.current.dateComponents([.day], from: currentDate, to: goal.goalEnd).day ?? 0
        
        var (ddayText, ddayBackgroundColor, ddayTextColor) = isPastGoal ? ("종료", UIColor.mpLightGray, UIColor.mpDarkGray) : ("D\(daysLeft)", UIColor.mpCalendarHighLight, UIColor.mpMainColor)
        
        if isFutureGoal {
            ddayText = "진행 중"
        }
        
        dday.text = ddayText
        dday.backgroundColor = ddayBackgroundColor
        dday.textColor = ddayTextColor
        dday.layer.cornerRadius = 6
        dday.clipsToBounds = true
        dday.textAlignment = .center
        dday.widthAnchor.constraint(equalToConstant: 37).isActive = true
        dday.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        //progressPercentage
        let progressPercentageValue = Double(goal.usedAmount) / Double(goal.goalAmount) * 100.0
        progressPercentage.text = String(format: "%.0f%%", progressPercentageValue)
        progressPercentage.textColor = progressPercentageValue > 100 ? .mpRed : .mpMainColor
        progressPercentage.font = .mpFont14M()
        
        
        let usedAmountText = setComma(cash: goal.usedAmount) + " 원 / " + setComma(cash: goal.goalAmount) + " 원 사용"
        let goalAmountTextCnt = "/ \(goal.goalAmount) 원 사용".count
        let attributedText = NSMutableAttributedString(string: usedAmountText)
        attributedText.addAttribute(.foregroundColor, value: UIColor.mpDarkGray, range: NSRange(location: 0, length: usedAmountText.count))
        attributedText.addAttribute(.foregroundColor, value: UIColor.mpGray, range: NSRange(location: usedAmountText.count - goalAmountTextCnt , length: goalAmountTextCnt))
        usedAmount.attributedText = attributedText
        usedAmount.font = .mpFont14M()
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
        usedAmtBar.backgroundColor = usedAmt > goalAmt ? .mpRed : .mpMainColor
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
        let usingRatio = ratio > 1 ? 1 : ratio
        let usedAmtWidth = usingRatio * frame.width
        
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


/**extension EmojiView: UITextFieldDelegate {
 
 func textFieldDidBeginEditing(_ textField: UITextField) {
 textField.keyboardType = .default // Use default keyboard, customize for emoji input
 // Additional configuration if needed
 }
 
 func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
 // Restrict input to a single emoji character
 if string.count > 1 {
 return false
 }
 
 // Automatically dismiss keyboard after entering one emoji
 if let _ = string.first?.isEmoji {
 textField.text = string
 textField.resignFirstResponder()
 // Notify GoalNameViewController to update emoji and hide scrim (implement delegate or closure)
 }
 return false
 }
 }
 
 
 extension Character {
 var isEmoji: Bool {
 guard let scalarValue = unicodeScalars.first else {
 return false
 }
 
 // Ranges covering emojis (this includes the most common emoji ranges and might need updates when new emojis are released)
 return scalarValue.properties.isEmoji &&
 (scalarValue.value > 0x238C || scalarValue.value < 0x1F600 || scalarValue.value > 0x1F64F)
 }
 }
 */

extension Character {
    var isEmoji: Bool {
        guard let scalarValue = unicodeScalars.first else {
            return false
        }
        
        // Ranges covering emojis (this includes the most common emoji ranges and might need updates when new emojis are released)
        return scalarValue.properties.isEmoji &&
        (scalarValue.value > 0x238C || scalarValue.value < 0x1F600 || scalarValue.value > 0x1F64F)
    }
}

//class EmojiView: UIView {
//    
//    let textField = UITextField()
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupEmojiView()
//        setupTextFieldView()
//    }
//    
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        setupEmojiView()
//        setupTextFieldView()
//    }
//    
//    private func setupEmojiView() {
//        self.backgroundColor = .mpLightGray
//        self.layer.cornerRadius = 10
//    }
//    
//    private func setupTextFieldView() {
//        textField.translatesAutoresizingMaskIntoConstraints = false
//        textField.text = "🙌"
//        textField.font = .mpFont26B()
//        //        textField.delegate = self
//        
//        self.addSubview(textField)
//        
//        NSLayoutConstraint.activate([
//            textField.centerXAnchor.constraint(equalTo: self.centerXAnchor),
//            textField.centerYAnchor.constraint(equalTo: self.centerYAnchor)
//        ])
//    }
//}

class EmojiTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTextField()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTextField()
    }
    
    private func setupTextField() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.text = "🙌" // 기본 이모지 설정
        self.font = .mpFont26B()
        self.textAlignment = .center
        self.backgroundColor = .mpLightGray
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true // 레이어가 뷰의 경계 내로 제한되도록 설정
        self.borderStyle = .none // 테두리 스타일 제거
        self.keyboardType = .default
    }
}


class WriteNameView: UIView {
    
    let textField = UITextField()
    let textDeleteBtn = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupTextDeleteBtn()
        setupTextField()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupTextDeleteBtn()
        setupTextField()
    }
    
    private func setupView() {
        backgroundColor = UIColor.mpLightGray
        layer.cornerRadius = 10
        clipsToBounds = true
    }
    
    private func setupTextField() {
        textField.translatesAutoresizingMaskIntoConstraints = false
        addSubview(textField)
        
        textField.textColor = UIColor.mpGray
        textField.textAlignment = .left
        textField.placeholder = "목표 이름"
        
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: textDeleteBtn.leadingAnchor, constant: -16), // 수정됨
            textField.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            textField.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8)
        ])
    }
    
    private func setupTextDeleteBtn() {
        
        addSubview(textDeleteBtn) // addSubview를 먼저 호출
        textDeleteBtn.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        textDeleteBtn.tintColor = .mpDarkGray
        textDeleteBtn.addTarget(self, action: #selector(deleteText), for: .touchUpInside)
        
        textDeleteBtn.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textDeleteBtn.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            textDeleteBtn.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            textDeleteBtn.widthAnchor.constraint(equalToConstant: 30),
            textDeleteBtn.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    @objc private func deleteText() {
        textField.text = ""
        print("deleteText")
    }
    
}

//protocol WriteNameCellDelegate: AnyObject {
//    func didChangeEmojiText(to newValue: String?, cell: WriteNameCell)
//    func didChangeTitleText(to newValue: String?, cell: WriteNameCell)
//}
//
//// tableView 안에 들어가는 cell 중에 키보드로 수정할 수 있는 textfield를 보유
//class WriteNameCell: UITableViewCell {
//    
//    weak var delegate: WriteNameCellDelegate?
//    
//    let writeNameView = WriteNameView()
//    let emojiView = EmojiView()
//    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        setupViews()
//        selectionStyle = .none
//        
//        emojiView.isUserInteractionEnabled = true
//        writeNameView.isUserInteractionEnabled = true
//        
//        //        writeNameView.textField.delegate = self
//        //        emojiView.textField.delegate = self
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    private func setupViews() {
//        addSubview(emojiView)
//        addSubview(writeNameView)
//        emojiView.translatesAutoresizingMaskIntoConstraints = false
//        writeNameView.translatesAutoresizingMaskIntoConstraints = false
//        
//        // EmojiView와 WriteNameView의 제약 조건 설정
//        NSLayoutConstraint.activate([
//            // EmojiView 제약 조건
//            emojiView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
//            emojiView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
//            emojiView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
//            emojiView.widthAnchor.constraint(equalToConstant: 50), // 예시 너비
//            
//            // WriteNameView 제약 조건
//            writeNameView.leadingAnchor.constraint(equalTo: emojiView.trailingAnchor, constant: 10),
//            writeNameView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
//            writeNameView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
//            writeNameView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
//        ])
//    }
//    
//}


protocol MoneyAmountTextCellDelegate: AnyObject {
    func didChangeAmountText(to newValue: String?, cell: MoneyAmountTextCell)
}


// 금액 입력을 위한 cell
class MoneyAmountTextCell: UITableViewCell, UITextFieldDelegate {
    
    weak var delegate: MoneyAmountTextCellDelegate?
    
    private let iconImageView = UIImageView()
    let textField = UITextField()
    private let unitLabel = MPLabel()
    private let amountLabel = MPLabel()
    
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
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        delegate?.didChangeAmountText(to: textField.text, cell: self)
    }
    
}


//// 기간 입력을 위한 버튼 cell
//class PeriodCell: UITableViewCell {
//    
//    private let periodButton = PeriodCellButton()
//    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        setupCell()
//        setupPeriodButton()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    private func setupCell() {
//        // 기존 PeriodCell setupCell 구현
//        backgroundColor = UIColor.clear  // 셀의 배경을 투명하게 설정
//        contentView.clipsToBounds = true//" subview들이 view의 bounds에 가둬질 수 있는 지를 판단하는 Boolean 값 "
//        
//        selectionStyle = .none  // 셀 선택 시 배경색 변경 없음
//        
//        contentView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            contentView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
//            contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
//            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
//            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
//        ])
//    }
//    
//    private func setupPeriodButton() {
//        contentView.addSubview(periodButton)
//        periodButton.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            periodButton.topAnchor.constraint(equalTo: contentView.topAnchor),
//            periodButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
//            periodButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            periodButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
//        ])
//    }
//}




// 새로운 카테고리를 만들때 쓰는 점선이 있는 버튼
class GoalCreateBtnCell: UITableViewCell {
    
    let addButton = UIButton()
    let shapeLayer = CAShapeLayer()
    
    var onAddButtonTapped: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //        self.layer.cornerRadius = 10
        //        self.clipsToBounds = true
        setupAddButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupAddButton() {
        if let plusImage = UIImage(systemName: "plus") {
            addButton.setImage(plusImage, for: .normal)
        }
        addButton.tintColor = .mpDarkGray
        addButton.backgroundColor = .clear
        addButton.layer.cornerRadius = 10
        contentView.addSubview(addButton)
        addButton.translatesAutoresizingMaskIntoConstraints = false
//        addButton.clipsToBounds = true
        addButton.addTarget(self, action: #selector(addButtonAction), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            addButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            addButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant : 16),
            addButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            addButton.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addDashedBorder(to: addButton)
    }
    
    private func addDashedBorder(to view: UIView) {
        let lineDashPattern: [NSNumber] = [3, 2]
        shapeLayer.strokeColor = UIColor.mpGray.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineDashPattern = lineDashPattern
        shapeLayer.fillColor = nil
        shapeLayer.path = UIBezierPath(roundedRect: addButton.bounds, cornerRadius: addButton.layer.cornerRadius).cgPath
        shapeLayer.frame = view.bounds
        
        // Remove previously added layers to prevent multiple layers on top of each other
        shapeLayer.removeFromSuperlayer()
        view.layer.addSublayer(shapeLayer)
    }
    
    @objc private func addButtonAction() {
        onAddButtonTapped?()
    }
}


class GoalCategoryTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    var categoryTextChanged: ((String) -> Void)?
    var categoryButtonTapped: (() -> Void)?
    
    let categoryTextField = MainTextField(placeholder: "카테고리를 입력해주세요", iconName: "icon_category", keyboardType: .default)
    let amountTextField: UITextField = MainTextField(placeholder: "소비금액을 입력하세요", iconName: "icon_Wallet", keyboardType: .numberPad)
    
    lazy var categoryChooseButton: UIButton = {
        let button = UIButton()
        let arrowImage = UIImage(systemName: "chevron.down")
        button.setImage(arrowImage, for: .normal)
        button.tintColor = .mpBlack
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        categoryTextField.addTarget(self, action: #selector(categoryTextFieldChanged), for: .editingChanged)
        categoryChooseButton.addTarget(self, action: #selector(categoryButtonPressed), for: .touchUpInside)
    }
    
    @objc private func categoryTextFieldChanged(_ textField: UITextField) {
        categoryTextChanged?(textField.text ?? "")
    }
    
    @objc private func categoryButtonPressed() {
        categoryButtonTapped?()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
        categoryTextField.addTarget(self, action: #selector(categoryTextFieldChanged), for: .editingChanged)
        categoryChooseButton.addTarget(self, action: #selector(categoryButtonPressed), for: .touchUpInside)
    }
    
    private func setupUI() {
        backgroundColor = .clear
        
        addSubview(categoryTextField)
        addSubview(amountTextField)
        addSubview(categoryChooseButton)
        
        // Autolayout 설정
        setupConstraints()
    }
    
    private func setupConstraints() {
        categoryTextField.translatesAutoresizingMaskIntoConstraints = false
        amountTextField.translatesAutoresizingMaskIntoConstraints = false
        categoryChooseButton.translatesAutoresizingMaskIntoConstraints = false
        
        // 카테고리 텍스트 필드 제약 조건
        NSLayoutConstraint.activate([
            categoryTextField.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            categoryTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            categoryTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            categoryTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // 금액 텍스트 필드 제약 조건
        NSLayoutConstraint.activate([
            amountTextField.topAnchor.constraint(equalTo: categoryTextField.bottomAnchor, constant: 10),
            amountTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            amountTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            amountTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // 카테고리 선택 버튼 제약 조건
        NSLayoutConstraint.activate([
            categoryChooseButton.centerYAnchor.constraint(equalTo: categoryTextField.centerYAnchor),
            categoryChooseButton.trailingAnchor.constraint(equalTo: categoryTextField.trailingAnchor, constant: -5),
            categoryChooseButton.widthAnchor.constraint(equalToConstant: 30),
            categoryChooseButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    // 필요한 경우 UITextFieldDelegate 메서드를 여기에 구현하세요
    // 예: func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
}
