//
//  CustomCalendarView.swift
//  Money-Planner
//
//  Created by 유철민 on 2/20/24.
//

import Foundation
import UIKit
import FSCalendar

// Custom UIView which includes FSCalendar
class CustomCalendarView: UIView, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    var calendar: FSCalendar!
    var startDate : Date?
    var endDate: Date?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCalendar()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureCalendar()
    }
    
    private func configureCalendar() {
        // FSCalendar 인스턴스 생성 및 구성
        calendar = FSCalendar()
        calendar.dataSource = self
        calendar.delegate = self
        calendar.appearance.headerDateFormat = "YYYY년 M월"
        calendar.appearance.weekdayTextColor = UIColor.black
        calendar.weekdayHeight = 25 // 요일 표시 높이 설정
        calendar.headerHeight = 50 // 헤더 높이 설정
        calendar.appearance.headerTitleColor = UIColor.black
        calendar.appearance.headerTitleFont = .mpFont20B()
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        calendar.translatesAutoresizingMaskIntoConstraints = false // Auto Layout 사용 설정
        
        addSubview(calendar)
        
        // Auto Layout 제약 조건 추가
        NSLayoutConstraint.activate([
            calendar.topAnchor.constraint(equalTo: topAnchor),
            calendar.bottomAnchor.constraint(equalTo: bottomAnchor),
            calendar.leadingAnchor.constraint(equalTo: leadingAnchor),
            calendar.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        calendar.register(CustomFSCalendarCell.self, forCellReuseIdentifier: "customCell")
    }
    // 특정 기간 설정
    func setPeriod(startDate: Date, endDate: Date) {
        self.startDate = startDate
        self.endDate = endDate
        calendar.setCurrentPage(startDate, animated: false) // startDate의 달로 달력을 설정
        calendar.reloadData()
    }
    
}


class CustomFSCalendarCell: FSCalendarCell {
    private weak var customImageView: UIImageView!
    private weak var amountLabel: UILabel! // 금액 정보를 표시할 UILabel
    var imageSize: CGSize = CGSize(width: 24, height: 24) // 기본 이미지 크기
    
    override init!(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        // Configure the image view
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        self.contentView.insertSubview(imageView, belowSubview: self.titleLabel)
        self.customImageView = imageView
        
        // Configure the amount label
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12) // Use your desired font size
        label.textColor = .black // Set text color to black
        self.contentView.addSubview(label)
        self.amountLabel = label
        
        // Bring the amount label to the front
        self.contentView.bringSubviewToFront(self.amountLabel)
        
        //            // Set borders for the cell
        //            self.layer.borderWidth = 1.0
        //            self.layer.borderColor = UIColor.gray.cgColor // Use your desired border color
    }
    
    // 이미지 크기 조정 메서드
    func configureImageSize(_ size: CGSize) {
        self.imageSize = size
        setNeedsLayout() // 레이아웃 업데이트를 위해 호출
    }
    
    // 이미지 설정 및 크기 조정
    func configureBackgroundImage(image: UIImage?) {
        self.customImageView.image = image
        setNeedsLayout() // 레이아웃 업데이트를 위해 호출
    }
    
    // 금액 텍스트 설정 메서드
    func configureAmountText(_ amount: String) {
        self.amountLabel.text = amount // 금액 정보를 amountLabel에 설정
        setNeedsLayout() // 레이아웃 업데이트를 위해 호출
    }
    
    //    override func layoutSubviews() {
    //        super.layoutSubviews()
    //        // 이미지 뷰의 위치와 크기 조정
    //        let titleLabelSize = self.titleLabel.frame.size
    //        self.customImageView.frame = CGRect(
    //            x: titleLabel.frame.origin.x + (titleLabelSize.width - imageSize.width) / 2,
    //            y: titleLabel.frame.origin.y + (titleLabelSize.height - imageSize.height) / 2,
    //            width: imageSize.width,
    //            height: imageSize.height
    //        )
    //
    //        // 금액 레이블의 위치와 크기 조정
    //        self.amountLabel.frame = CGRect(x: 0, y: self.bounds.height - 10, width: self.bounds.width, height: 20)
    //        self.amountLabel.font = .mpFont12M()
    //    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Constants for layout calculations
        let cellHeight: CGFloat = 42 + 27 // total cell height
        let cellWidth: CGFloat = 47 // total cell width
        
        let dateLabelHeight: CGFloat = 23
        let dateLabelFont = UIFont.systemFont(ofSize: 18, weight: .bold) // Replace with your custom font if necessary
        
        let imageHeight: CGFloat = 42
        let imageWidth: CGFloat = 42
        
        let amountLabelHeight: CGFloat = 27
        let amountLabelWidth: CGFloat = cellWidth // Assuming the amount label takes the full width
        
        // Calculating the Y positions
        let dateLabelY: CGFloat = (imageHeight - dateLabelHeight) / 2 // Vertically center the date label in the image
        let imageY: CGFloat = 0 // Image will be at the top of the cell
        let amountLabelY: CGFloat = imageHeight // Amount label is right below the image
        
        // Centering the titleLabel horizontally and setting the vertical position
        self.titleLabel.frame = CGRect(
            x: (cellWidth - self.titleLabel.frame.width) / 2,
            y: dateLabelY,
            width: self.titleLabel.frame.width,
            height: dateLabelHeight
        )
        self.titleLabel.font = dateLabelFont
        self.titleLabel.textAlignment = .center
        
        // Centering the customImageView horizontally and setting the vertical position
        self.customImageView.frame = CGRect(
            x: (cellWidth - imageWidth) / 2,
            y: imageY,
            width: imageWidth,
            height: imageHeight
        )
        
        // Setting the amountLabel frame, centered horizontally
        self.amountLabel.frame = CGRect(
            x: (cellWidth - amountLabelWidth) / 2,
            y: amountLabelY,
            width: amountLabelWidth,
            height: amountLabelHeight
        )
        self.amountLabel.font = .mpFont12M() // Set the font size according to your design
        self.amountLabel.textAlignment = .center
        
        //        // Setting borders
        //                self.layer.borderWidth = 1.0
        //                self.layer.borderColor = UIColor.black.cgColor // Change the color as needed
        //
        //                // Setting the amountLabel border
        //                amountLabel.layer.borderWidth = 1.0
        //                amountLabel.layer.borderColor = UIColor.black.cgColor
        self.contentView.bringSubviewToFront(self.amountLabel)
    }
}


import UIKit

protocol GoalAmountModalViewControllerDelegate: AnyObject {
    func didChangeAmount(to newAmount: String, for date: Date)
}

class GoalAmountModalViewController: UIViewController, UITextFieldDelegate, MoneyAmountTextCellDelegate {
    
    weak var delegate: GoalAmountModalViewControllerDelegate?
    var backgroundViewBottomConstraint: NSLayoutConstraint!
    
    let backgroundView = UIView()
    let grabberView = UIView()
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    let amountCell = MoneyAmountTextCell()
    let confirmButton = UIButton()
    
    var date: Date?
    var currentTotalAmount: Int64?
    var goalBudget = GoalCreationManager.shared.goalBudget
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackgroundView()
        setupViews()
        setupConstraints()
        setupKeyboardNotifications()
        amountCell.configureCell(image: UIImage(named: "icon_Wallet"), placeholder: "목표 금액을 입력해주세요", cost: "")
        
        amountCell.textField.becomeFirstResponder()
    }
    
    func didChangeAmountText(to newValue: String?, cell: MoneyAmountTextCell, oldValue: String?) {
        
//        if let newValue = newValue, newValue != oldValue {
//            delegate?.didChangeAmount(to: newValue, for: date ?? Date())
//        }
        
        var sum : Int64 = currentTotalAmount!
        var dGSO = false
        var dGO = false
        
        if let newValue = newValue, newValue != oldValue {
            
            let formattedValue = newValue.replacingOccurrences(of: ",", with: "")
            if let amount = Int64(formattedValue) {
                sum += amount
                if amount > GoalCreationManager.shared.goalBudget! {
                    dGO = true
                }
            } else {
                print("잘못된 형식의 금액입니다: \(newValue)")
            }
            
            if sum > GoalCreationManager.shared.goalBudget! {
                dGSO = true
            }
            
            cell.setAmountLabel(dailyGoalSumOver: dGSO, dailyGoalOver: dGO, overCost: GoalCreationManager.shared.goalBudget!-(currentTotalAmount ?? 0))
            
            if dGO {
                confirmButton.isEnabled = false
                confirmButton.backgroundColor = .mpLightGray
            }else{
                confirmButton.isEnabled = true
                confirmButton.backgroundColor = .mpMainColor
            }
        }
    }
    
    @objc private func saveAmount() {
        if let amount = amountCell.textField.text, let date = date {
            delegate?.didChangeAmount(to: amount, for: date)
        }
        dismiss(animated: true, completion: nil)
    }
    
    private func setupBackgroundView() {
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.backgroundColor = .white
        backgroundView.layer.cornerRadius = 20
        view.addSubview(backgroundView)
        
        grabberView.translatesAutoresizingMaskIntoConstraints = false
        grabberView.backgroundColor = UIColor.systemGray4
        grabberView.layer.cornerRadius = 3
        backgroundView.addSubview(grabberView)
        
        NSLayoutConstraint.activate([
            grabberView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 8),
            grabberView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            grabberView.widthAnchor.constraint(equalToConstant: 36),
            grabberView.heightAnchor.constraint(equalToConstant: 6),
            
            backgroundView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        backgroundViewBottomConstraint = backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        backgroundViewBottomConstraint.isActive = true
    }
    
    private func setupViews() {
        view.backgroundColor = .clear
        view.clipsToBounds = true
        
        titleLabel.text = "목표 금액 변경"
        titleLabel.font = .mpFont20B()
        titleLabel.textAlignment = .left
        backgroundView.addSubview(titleLabel)
        
        if let date = date {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy.MM.dd"
            subtitleLabel.text = "\(formatter.string(from: date))의 목표금액을 입력하세요"
        }
        subtitleLabel.font = .mpFont16M()
        subtitleLabel.textAlignment = .left
        backgroundView.addSubview(subtitleLabel)
        
        amountCell.delegate = self
        amountCell.configureCell(image: nil, placeholder: "목표 금액 입력", cost: "")
        backgroundView.addSubview(amountCell)
        
        confirmButton.setTitle("확인", for: .normal)
        confirmButton.layer.cornerRadius = 16
        confirmButton.backgroundColor = UIColor.systemTeal
        confirmButton.addTarget(self, action: #selector(saveAmount), for: .touchUpInside)
        backgroundView.addSubview(confirmButton)
    }
    
    private func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        amountCell.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: backgroundView.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            subtitleLabel.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
            subtitleLabel.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16),
            
            amountCell.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 20),
            amountCell.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 20),
            amountCell.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -20),
            amountCell.heightAnchor.constraint(equalToConstant: 64),
            
            confirmButton.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -40),
            confirmButton.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            confirmButton.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
            confirmButton.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16),
            confirmButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
    
    private func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        let keyboardHeight = keyboardSize.height
        backgroundViewBottomConstraint.constant = -keyboardHeight + view.safeAreaInsets.bottom
        
        view.layoutIfNeeded()
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        backgroundViewBottomConstraint.constant = 0
        view.layoutIfNeeded()
    }
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text, let number = Int64(text.replacingOccurrences(of: ",", with: "")) {
            textField.text = formatNumber(number)
        }
    }
    
    // Format input number to a currency format
    func formatNumber(_ number: Int64) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal // 숫자에 천 단위 구분 기호를 추가합니다.
        return formatter.string(from: NSNumber(value: number)) ?? ""
    }
    
    private func setupPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        grabberView.addGestureRecognizer(panGesture)
    }
    
    @objc private func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        if translation.y > 0 { // Dismiss only on dragging down
            view.transform = CGAffineTransform(translationX: 0, y: translation.y)
        }
        
        if gesture.state == .ended {
            let velocity = gesture.velocity(in: view)
            if velocity.y >= 1500 { // If the speed of dragging is high enough, dismiss
                self.dismiss(animated: true) {
                }
            } else {
                // Return to original position
                UIView.animate(withDuration: 0.3) {
                    self.view.transform = .identity
                }
            }
        }
    }
    
    
}
