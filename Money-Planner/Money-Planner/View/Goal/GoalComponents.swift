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
        
        /* MPLabel에서 텍스트를 가운데 정렬하려면 NSTextAlignment 속성을 사용하면 됩니다.
         이미 MPLabel의 textAlignment 속성을 .center로 설정하고 있으므로, 가운데 정렬은 이미 적용된 상태입니다.
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
    
    var goal : Goal_?
    let containerView = UIView()
    let btn = UIButton()
    let title = MPLabel()
    let dday = MPLabel()
    var progressBar = GoalProgressBar(goalAmt: 1, usedAmt: 0)
    let progressPercentage = MPLabel()
    let totalCost = MPLabel()
    
    var btnTapped : (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        setupCellLayout()
        btn.addTarget(self, action: #selector(onBtnTapped), for: .touchUpInside)
    }
    
    @objc func onBtnTapped(){
        btnTapped!()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //금액에 , 넣기
    private func setComma(cash: Int64) -> String {
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
        let horizontalStackView3 = UIStackView(arrangedSubviews: [progressPercentage, totalCost])
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
    
    func configureCell(with goal: Goal_, isNow : Bool) {
        
        self.goal = goal
        self.progressBar = GoalProgressBar(goalAmt: goal.totalBudget, usedAmt: goal.totalCost! )
        
        btn.backgroundColor = .mpWhite
        btn.layer.cornerRadius = 10
        
        // Title
        title.text = goal.icon + "  " + goal.goalTitle
        title.font = .mpFont16M()
        title.textColor = .mpBlack
        
        // D-day
        dday.font = .mpFont12M()
        
        //00시 00분으로 맞춰야 됨.
        let calendar = Calendar.current
        let currentDateComponents = calendar.dateComponents([.year, .month, .day], from: Date())
        
        let currentDate = calendar.date(from: currentDateComponents) ?? Date()
        
        let goalEndDate = goal.endDate.toMPDate() ?? currentDate // Fallback to current date if conversion fails
        let daysLeft = Calendar.current.dateComponents([.day], from: currentDate, to: goalEndDate).day ?? 0
        
        // Initialize D-day text and color variables
        var ddayText: String
        var ddayBackgroundColor: UIColor
        var ddayTextColor: UIColor
        
        if isNow {
            if daysLeft == 0 {
                ddayText = "D-Day"
                ddayBackgroundColor = UIColor.mpCalendarHighLight
                ddayTextColor = UIColor.mpMainColor
            } else {
                ddayText = "D-\(daysLeft)"
                ddayBackgroundColor = UIColor.mpCalendarHighLight
                ddayTextColor = UIColor.mpMainColor
            }
        } else {
            if currentDate > goalEndDate {
                ddayText = "종료"
                ddayBackgroundColor = UIColor.mpLightGray
                ddayTextColor = UIColor.mpDarkGray
            } else {
                ddayText = "시작 전"
                ddayBackgroundColor = UIColor.mpLightGray
                ddayTextColor = UIColor.mpDarkGray
            }
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
        let progressPercentageValue = Double(goal.totalCost!) / Double(goal.totalBudget) * 100.0
        progressPercentage.text = String(format: "%.0f%%", progressPercentageValue)
        progressPercentage.textColor = progressPercentageValue > 100 ? .mpRed : .mpMainColor
        progressPercentage.font = .mpFont14M()
        
        
        let totalCostText = setComma(cash: goal.totalCost!) + " 원 / " + setComma(cash: goal.totalBudget) + " 원 사용"
        let totalBudgetTextCnt = "/ \(goal.totalBudget) 원 사용".count
        let attributedText = NSMutableAttributedString(string: totalCostText)
        attributedText.addAttribute(.foregroundColor, value: UIColor.mpDarkGray, range: NSRange(location: 0, length: totalCostText.count))
        attributedText.addAttribute(.foregroundColor, value: UIColor.mpGray, range: NSRange(location: totalCostText.count - totalBudgetTextCnt , length: totalBudgetTextCnt))
        totalCost.attributedText = attributedText
        totalCost.font = .mpFont14M()
    }
}


class GoalProgressBar: UIView {
    
    let goalAmtBar = UIView()
    let usedAmtBar = UIView()
    var goalAmt: Int64
    var usedAmt: Int64
    let pointer = MPLabel()
    let line : UIView = {
        let l = UIView()
        l.backgroundColor = .clear
        return l
    }()
    
    var usedAmtBarWidthConstraint: NSLayoutConstraint?
    
    init(goalAmt: Int64, usedAmt: Int64) {
        self.goalAmt = goalAmt
        self.usedAmt = usedAmt
        super.init(frame: .zero)
        setupGoalAmtBar()
        setupUsedAmtBar()
        setupPointer()
        setupLine()
        changeUsedAmt(usedAmt: self.usedAmt, goalAmt: self.goalAmt)
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
        
        let widthConstraint = usedAmtBar.widthAnchor.constraint(equalToConstant: 0)
           widthConstraint.isActive = true
           usedAmtBarWidthConstraint = widthConstraint
        
        NSLayoutConstraint.activate([
            usedAmtBar.leftAnchor.constraint(equalTo: goalAmtBar.leftAnchor),
            usedAmtBar.topAnchor.constraint(equalTo: goalAmtBar.topAnchor),
            usedAmtBar.heightAnchor.constraint(equalTo: goalAmtBar.heightAnchor),
//            usedAmtBar.widthAnchor.constraint(equalToConstant: 0)
        ])
    }
    
    func setupPointer(){
        addSubview(pointer)
        pointer.text = "목표"
        pointer.textColor = .mpDarkGray
        pointer.font = .mpFont12M()
        
        pointer.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pointer.centerXAnchor.constraint(equalTo: usedAmtBar.leftAnchor, constant: 0),
            pointer.bottomAnchor.constraint(equalTo: usedAmtBar.topAnchor),
            pointer.heightAnchor.constraint(equalToConstant: 15)
        ])
    }
    
    func setupLine(){
        addSubview(line)
        line.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            line.centerXAnchor.constraint(equalTo: pointer.centerXAnchor),
            line.topAnchor.constraint(equalTo: pointer.bottomAnchor),
            line.bottomAnchor.constraint(equalTo: usedAmtBar.bottomAnchor),
            line.widthAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    private func addDashedBorder(to view: UIView) {
        let lineDashPattern: [NSNumber]? = [3,2]
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.mpDarkGray.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineDashPattern = lineDashPattern
        shapeLayer.fillColor = nil
        
        let path = CGMutablePath()
        path.addLines(between: [CGPoint(x: 0, y: 0),
                                CGPoint(x: 0, y: view.frame.size.height)])
        shapeLayer.path = path
        
        view.layer.addSublayer(shapeLayer)
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        
//        // 현재 프레임 너비를 기반으로 usedAmtBar의 너비 계산
//        let ratio = CGFloat(usedAmt) / CGFloat(goalAmt)
//        let usingRatio = min(max(ratio, 0), 1) //ratio > 1 ? 1 : ratio 도 가능
//        let usedAmtWidth = usingRatio * frame.width
//        let pointerX = ratio == 0 ?  0 : frame.width / ratio
//        
//        
//        // usedAmtBar의 너비 제약 조건(width constraint) 업데이트
//        NSLayoutConstraint.activate([
//            usedAmtBar.widthAnchor.constraint(equalTo: goalAmtBar.widthAnchor, multiplier: usingRatio)
//        ])
//        
//        pointer.center.x = pointerX
//        line.center.x = pointer.center.x
//        
//        // 바의 모서리 반지름(corner radius) 업데이트
//        goalAmtBar.layer.cornerRadius = goalAmtBar.frame.height / 2
//        usedAmtBar.layer.cornerRadius = usedAmtBar.frame.height / 2
//        
//        addDashedBorder(to: line)
//        
//        pointer.isHidden = ratio <= 1
//        line.isHidden = ratio <= 1
//        
//        usedAmtBar.backgroundColor = usedAmt > goalAmt ? .mpRed : .mpMainColor
//    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()

        // goalAmtBar의 레이아웃 설정
        goalAmtBar.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: 10)
        goalAmtBar.layer.cornerRadius = goalAmtBar.frame.height / 2

        // usedAmtBar의 너비 계산
        let ratio = CGFloat(usedAmt) / CGFloat(goalAmt)
        let usingRatio = min(max(ratio, 0), 1) // ratio가 0과 1 사이의 값이 되도록 조정
        let usedAmtWidth = usingRatio * self.bounds.width

        // usedAmtBar의 프레임 설정
        usedAmtBar.frame = CGRect(x: 0, y: 0, width: usedAmtWidth, height: 10)
        usedAmtBar.layer.cornerRadius = usedAmtBar.frame.height / 2

        // pointer 및 line의 레이아웃 조정
        let pointerX = ratio == 0 ?  0 : frame.width / ratio
        pointer.center.x = pointerX
        line.center.x = pointer.center.x
//        addDashedBorder(to: line)
    
    }

    func changeUsedAmt (usedAmt : Int64, goalAmt : Int64){
        self.goalAmt = goalAmt
        self.usedAmt = usedAmt
        //setNeedsLayout() // 이걸 쓰면 layoutSubview가 재업. 어째서, 막대 길이에 오류가 생겼는지는 불명...
        
        //애니메이션 적용
        UIView.animate(withDuration: 0.5, animations: {
            // usedAmtBar의 너비 계산 및 업데이트
            let ratio = CGFloat(self.usedAmt) / CGFloat(self.goalAmt)
            let usingRatio = min(max(ratio, 0), 1) // 0과 1 사이의 값으로 조정
            let usedAmtWidth = usingRatio * self.bounds.width
            
            // usedAmtBar의 프레임 조정
            self.usedAmtBar.frame.size.width = usedAmtWidth
            
            // pointer 및 line의 위치 조정
            let pointerX = ratio == 0 ?  0 : self.frame.width / ratio
            self.pointer.center.x = pointerX
            self.line.center.x = self.pointer.center.x
            
            self.layoutIfNeeded() // 현재 뷰와 관련된 레이아웃을 강제로 업데이트
        })
        
        // usedAmtBar의 배경색 조건부 업데이트는 애니메이션 블록 외부에서 진행
        self.usedAmtBar.backgroundColor = usedAmt > goalAmt ? .mpRed : .mpMainColor
        self.pointer.isHidden = CGFloat(self.usedAmt) / CGFloat(self.goalAmt) <= 1
        self.line.isHidden = CGFloat(self.usedAmt) / CGFloat(self.goalAmt) <= 1
        addDashedBorder(to: line)
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
 // Notify GoalTitleViewController to update emoji and hide scrim (implement delegate or closure)
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

class GoalTitleTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTextField()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTextField()
    }
    
    //추가
    override var textInputMode: UITextInputMode? {
        for mode in UITextInputMode.activeInputModes {
            if mode.primaryLanguage == "emoji" {
                return mode
            }
        }
        return nil
    }
    
    private func setupTextField() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.text = "🙌" // 기본 이모지 설정
        self.font = .mpFont26B()
        self.textAlignment = .center
        self.backgroundColor = .mpGypsumGray
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
        backgroundColor = UIColor.mpGypsumGray
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



protocol MoneyAmountTextCellDelegate: AnyObject {
    func didChangeAmountText(to newValue: String?, cell: MoneyAmountTextCell, oldValue : String?)
}


class MoneyAmountTextCell: UITableViewCell, UITextFieldDelegate {
    
    weak var delegate: MoneyAmountTextCellDelegate?
    
    private let iconImageView = UIImageView()
    let textField = UITextField()
    private let unitLabel = MPLabel()
    let amountLabel = MPLabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
        setupIconImageView()
        setupUnitLabelField()
        setupTextField()
        setupAmountLabel()
        textField.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        let digitsOnly = updatedText.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let number = Int64(digitsOnly) ?? 0
        
        // 숫자 길이 제한
        if digitsOnly.count > 12 {
            amountLabel.text = "12자리 이상 입력하실 수 없습니다."
            amountLabel.textColor = .mpRed
            self.contentView.layer.borderWidth = 1
            self.contentView.layer.borderColor = UIColor.mpRed.cgColor
            return false
        }else{
            amountLabel.textColor = .mpBlack
            self.contentView.layer.borderWidth = 0
        }
        
        textField.text = formatNumber(number)
        amountLabel.text = formatAmount(number)
    
        delegate?.didChangeAmountText(to: textField.text, cell: self, oldValue: currentText)
        
        return false
    }
    
    ///경고문을 외부에서 설정하기 위해서 만듦. 피그마 경고문 반영
    ///우선순위는 위의 textField 함수에 의한 금액 -> 이 함수로 설정하는 경고문 -> 위의 12자 이상일때 경고문
    func setAmountLabel(categoryGoalSumOver : Bool, categoryGoalOver : Bool){
        
        //단독 오버
        if categoryGoalOver {
            amountLabel.text = "전체 목표 금액을 초과했어요."
            amountLabel.textColor = .mpRed
            self.contentView.layer.borderWidth = 1
            self.contentView.layer.borderColor = UIColor.mpRed.cgColor
            return
        }else{
            amountLabel.textColor = .mpBlack
            self.contentView.layer.borderWidth = 0
        }
        
        //총합이 오버
        if categoryGoalSumOver {
            amountLabel.text = "다른 카테고리의 금액을 낮춰주세요."
            amountLabel.textColor = .mpRed
            self.contentView.layer.borderWidth = 1
            self.contentView.layer.borderColor = UIColor.mpRed.cgColor
        }else{
            amountLabel.textColor = .mpBlack
            self.contentView.layer.borderWidth = 0
        }
        
    }
    
    func setAmountLabel(dailyGoalSumOver : Bool, dailyGoalOver : Bool, overCost : Int64?){
        //단독 오버
        if dailyGoalOver {
            amountLabel.text = "전체 목표 금액을 초과했어요."
            amountLabel.textColor = .mpRed
            self.contentView.layer.borderWidth = 1
            self.contentView.layer.borderColor = UIColor.mpRed.cgColor
            return
        }else{
            amountLabel.textColor = .mpBlack
            self.contentView.layer.borderWidth = 0
        }
        
        //총합이 오버
        if dailyGoalSumOver {
            amountLabel.text = "입력 가능한 최대 금액은 " + formatNumber(overCost ?? 0) + "원이에요"
            amountLabel.textColor = .mpRed
            self.contentView.layer.borderWidth = 1
            self.contentView.layer.borderColor = UIColor.mpRed.cgColor
        }else{
            amountLabel.textColor = .mpBlack
            self.contentView.layer.borderWidth = 0
        }
    }
    
    func formatNumber(_ number: Int64) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return  formatter.string(from: NSNumber(value: number)) ?? ""
    }
    
    private func formatAmount(_ number: Int64) -> String {
        if number == 0 { return "0원" }
        
//        let thousand_billion = number / 1_0000_0000_0000
        let hundred_million = (number % 1_0000_0000_0000) / 1_0000_0000
        let ten_thousand = (number % 1_0000_0000) / 1_0000
        let thousand = (number % 1_0000) / 1000
        let remainder = number % 1000
        
        var result = ""
//        if thousand_billion > 0 {result += "\(thousand_billion)조 "}
        if hundred_million > 0 { result += "\(hundred_million)억 " }
        if ten_thousand > 0 { result += "\(ten_thousand)만 " }
        if thousand > 0 { result += "\(thousand)천 " }
        if remainder > 0 || result.isEmpty { result += "\(remainder)" }
        
        return result + "원"
    }
    
    private func setupCell() {
        
        backgroundColor = UIColor.clear  // 셀의 배경을 투명하게 설정
        contentView.backgroundColor = UIColor.mpGypsumGray
        contentView.layer.cornerRadius = 10
        //        contentView.clipsToBounds = true//" subview들이 view의 bounds에 가둬질 수 있는 지를 판단하는 Boolean 값 "
        
        selectionStyle = .none  // 셀 선택 시 배경색 변경 없음
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            contentView.heightAnchor.constraint(equalToConstant: 64),
            //            contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
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
        
        textField.textColor = UIColor.mpBlack
        textField.font = .mpFont20M()
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
            amountLabel.widthAnchor.constraint(equalToConstant: 200)
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


// 새로운 카테고리를 만들때 쓰는 점선이 있는 버튼
class GoalCreateCategoryBtnCell: UITableViewCell {
    
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
            addButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            addButton.heightAnchor.constraint(equalToConstant: 64)
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


//class GoalCategoryTableViewCell: UITableViewCell, UITextFieldDelegate {
//
//    var amountTextChanged: ((String) -> Void)?
//    var categoryButtonTapped: (() -> Void)?
//
//    let categoryTextField = MainTextField(placeholder: "카테고리를 입력해주세요", iconName: "icon_category", keyboardType: .default)
//    let amountTextField: UITextField = MainTextField(placeholder: "목표금액을 입력하세요", iconName: "icon_Wallet", keyboardType: .numberPad)
//
//    lazy var categoryChooseButton: UIButton = {
//        let button = UIButton()
//        let arrowImage = UIImage(systemName: "chevron.down")
//        button.setImage(arrowImage, for: .normal)
//        button.tintColor = .mpBlack
//
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
//
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        setupUI()
//        amountTextField.delegate = self
//        amountTextField.addTarget(self, action: #selector(amountTextFieldChanged), for: .editingChanged)
//        amountTextField.isUserInteractionEnabled = true
//        categoryChooseButton.addTarget(self, action: #selector(categoryButtonPressed), for: .touchUpInside)
//    }
//
////    @objc private func categoryTextFieldChanged(_ textField: UITextField) {
////        categoryTextChanged?(textField.text ?? "")
////    }
//
//    @objc private func categoryButtonPressed() {
//        categoryButtonTapped?()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        setupUI()
//        amountTextField.delegate = self
//        amountTextField.addTarget(self, action: #selector(amountTextFieldChanged), for: .editingChanged)
//        categoryChooseButton.addTarget(self, action: #selector(categoryButtonPressed), for: .touchUpInside)
//    }
//
//    private func setupUI() {
//        backgroundColor = .clear
//
//        addSubview(categoryTextField)
//        addSubview(amountTextField)
//        addSubview(categoryChooseButton)
//
//        // Autolayout 설정
//        setupConstraints()
//    }
//
//    private func setupConstraints() {
//        categoryTextField.translatesAutoresizingMaskIntoConstraints = false
//        amountTextField.translatesAutoresizingMaskIntoConstraints = false
//        categoryChooseButton.translatesAutoresizingMaskIntoConstraints = false
//
//        // 카테고리 텍스트 필드 제약 조건
//        NSLayoutConstraint.activate([
//            categoryTextField.topAnchor.constraint(equalTo: topAnchor, constant: 10),
//            categoryTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
//            categoryTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
//            categoryTextField.heightAnchor.constraint(equalToConstant: 50)
//        ])
//
//        // 금액 텍스트 필드 제약 조건
//        NSLayoutConstraint.activate([
//            amountTextField.topAnchor.constraint(equalTo: categoryTextField.bottomAnchor, constant: 10),
//            amountTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
//            amountTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
//            amountTextField.heightAnchor.constraint(equalToConstant: 50)
//        ])
//
//        // 카테고리 선택 버튼 제약 조건
//        NSLayoutConstraint.activate([
//            categoryChooseButton.centerYAnchor.constraint(equalTo: categoryTextField.centerYAnchor),
//            categoryChooseButton.trailingAnchor.constraint(equalTo: categoryTextField.trailingAnchor, constant: -5),
//            categoryChooseButton.widthAnchor.constraint(equalToConstant: 30),
//            categoryChooseButton.heightAnchor.constraint(equalToConstant: 30)
//        ])
//    }
//
//    @objc private func amountTextFieldChanged(_ textField: UITextField) {
//        if let amountText = textField.text, let amount = Int64(amountText) {
//            amountTextChanged?(amountText)
//        }
//    }
//
//    @objc func categoryChooseBtnTapped(){
//        categoryButtonTapped?()
//    }
//
//    //categoryTextField 바꾸기
//    func didSelectCategory(_ category: String?, iconName : String?) {
//        // Update the category text field in ConsumeViewController
//        categoryTextField.text = category
//        categoryTextField.changeIcon(iconName: iconName ?? "")
//    }
//}

class GoalCategoryTableViewCell: UITableViewCell {
    
    var categoryId : Int?
    var isModified = false // 추후에 새로운 카테고리 목표를 저장하는 목적
    var iconImageView : UIImageView = {
        let i = UIImageView(image: UIImage(named: "icon_category"))
        i.contentMode = .scaleAspectFit
        return i
    }()
    var textField : UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .clear
        tf.text = "카테고리를 선택해주세요"
        tf.textColor = .mpBlack
        tf.font = .mpFont20M()
        tf.isUserInteractionEnabled = false // 직접 수정 불가
        return tf
    }()
    var categoryModalBtn : UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        return btn
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
        setupIconImageView()
        setupCategoryModalBtn()
        setupTextField()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(){
        
        //기본 컨테이너 뷰 세팅
        backgroundColor = UIColor.clear  // 셀의 배경을 투명하게 설정
        contentView.backgroundColor = UIColor.mpGypsumGray
        contentView.layer.cornerRadius = 10
        //        contentView.clipsToBounds = true//" subview들이 view의 bounds에 가둬질 수 있는 지를 판단하는 Boolean 값 "
        
        selectionStyle = .none  // 셀 선택 시 배경색 변경 없음
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            contentView.heightAnchor.constraint(equalToConstant: 64)
        ])
        //겹치지 않게 왼쪽에서 오른쪽으로 배치
    }
    
    func setupIconImageView() {
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
        
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 16),
            textField.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            textField.trailingAnchor.constraint(equalTo: categoryModalBtn.leadingAnchor, constant: -16)
        ])
    }
    
    private func setupCategoryModalBtn() {
        categoryModalBtn.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(categoryModalBtn)
        
        NSLayoutConstraint.activate([
            categoryModalBtn.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            categoryModalBtn.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            categoryModalBtn.widthAnchor.constraint(equalToConstant: 30),
            categoryModalBtn.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    
    func configureCell(categoryId : Int?, text : String, iconName : String){
        self.categoryId = categoryId
        iconImageView.image = UIImage(named: iconName)
        textField.text = text
    }
    
}
