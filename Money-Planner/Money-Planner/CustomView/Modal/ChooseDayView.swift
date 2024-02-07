//
//  ChooseDayView.swift
//  Money-Planner
//
//  Created by p_kxn_g on 1/27/24.
//

import UIKit

// Protocol to handle interactions or events related to ChooseDayView
protocol ChooseDayViewDelegate: AnyObject {
    func chooseIntervalDay(_ view: UIViewController)
    func addEndDay(_ view : UIStackView)
    func removeEndDay()
    // Define methods or properties as needed
}

class ChooseDayView: UIView {
    
    // Weak reference to the delegate
    weak var delegate: ChooseDayViewDelegate?
    var repeatEndChecked = true
    let currentDate = Date()
    let dateFormatter = DateFormatter()
    let button1 = OneDayButton(title: "월", buttonBool: true)
    let button2 = OneDayButton(title: "화", buttonBool: true)
    let button3 = OneDayButton(title: "수", buttonBool: true)
    let button4 = OneDayButton(title: "목", buttonBool: true)
    let button5 = OneDayButton(title: "금", buttonBool: true)
    let button6 = OneDayButton(title: "토", buttonBool: true)
    let button7 = OneDayButton(title: "일", buttonBool: true)
    lazy var dateString: String = {
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        // 일년 뒤 날짜.
        if let oneYearLaterDate = Calendar.current.date(byAdding: .year, value: 1, to: currentDate){
            return dateFormatter.string(from: oneYearLaterDate)
        }else{
            return dateString
        }
        
    }()
    // Other properties and methods of ChooseDayView
    private let backButton = UIButton()
    private let titleLabel = MPLabel()
    private let weekButtons: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.spacing = 10
            return stackView
        }()
    
    private let weekInterval : UIStackView = {
            let stackView = UIStackView()
        // >> stackView.backgroundColor = .blue
            stackView.axis = .horizontal
            stackView.spacing = 8
            return stackView
        }()
    let weekIntervalButton = OneDayButton(title: "1",buttonBool: false)

    private let repeatEndDate : UIStackView = {
            let stackView = UIStackView()
        // >> stackView.backgroundColor = .cyan
            stackView.axis = .horizontal
            stackView.spacing = 8
        stackView.alignment = .leading
            return stackView
        }()
    private let repeatEndDate2 : UIStackView = {
            let stackView = UIStackView()
        // >> stackView.backgroundColor = .mpWhite
            stackView.axis = .horizontal
            stackView.spacing = 8
        stackView.alignment = .trailing
            return stackView
        }()
    
    let RepeatEndDate2Label : UILabel = {
        let label = UILabel()
        label.text = "까지"
        label.font = UIFont.mpFont16R()
        label.textColor = UIColor.mpDarkGray
        return label
    }()
    let blank = UIView()
    lazy var RepeatEndDateButton : CheckBtn = {
        let checkButton = CheckBtn()
        checkButton.setChecked(false)
        checkButton.addTarget(self, action: #selector(repeatEndDateButtonTapped), for: .touchUpInside)
        return checkButton
    }()
    lazy var calChooseButton: UIButton = {
        let button = UIButton()
        
        button.setTitle(dateString, for: .normal)
        button.layer.cornerRadius = 6  // 둥근 모서리 설정
        button.titleLabel?.font = UIFont.mpFont16R()// 폰트 크기 설정
        button.backgroundColor = .mpGypsumGray
        button.setTitleColor(.mpDarkGray, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true  //클릭 활성화
        return button
        
    }()
    
    override init(frame: CGRect  = .zero) {
        super.init(frame: frame)
        //backgroundColor = .blue
        setupContainer()
        setupWeekButtons()
        setupWeekInterval()
        setupRepeatEndDate()
        //setupRepeatEndDateButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupContainer() {
       
        weekButtons.translatesAutoresizingMaskIntoConstraints = false
        weekInterval.translatesAutoresizingMaskIntoConstraints = false
        repeatEndDate.translatesAutoresizingMaskIntoConstraints = false
        weekIntervalButton.titleLabel?.font = .mpFont16R()
        addSubview(weekButtons)
        addSubview(weekInterval)
        addSubview(repeatEndDate)
        //repeatEndDate.backgroundColor = .yellow
           NSLayoutConstraint.activate([
            // 높이 설정
            weekButtons.heightAnchor.constraint(equalToConstant: 38),
            weekInterval.heightAnchor.constraint(equalToConstant: 38),
            repeatEndDate.heightAnchor.constraint(equalToConstant: 24),
               //weekButtons.bottomAnchor.constraint(equalTo: weekInterval.topAnchor),
               weekButtons.topAnchor.constraint(equalTo: topAnchor),
              
            weekButtons.centerXAnchor.constraint(equalTo: centerXAnchor),
            
               weekInterval.topAnchor.constraint(equalTo: weekButtons.bottomAnchor,constant: 16),
               weekInterval.leadingAnchor.constraint(equalTo: leadingAnchor),
               weekInterval.trailingAnchor.constraint(equalTo: trailingAnchor),
               //repeatEndDate.bottomAnchor.constraint(equalTo: bottomAnchor),
               repeatEndDate.topAnchor.constraint(equalTo: weekInterval.bottomAnchor,constant: 16),
               repeatEndDate.leadingAnchor.constraint(equalTo: leadingAnchor),
               repeatEndDate.trailingAnchor.constraint(equalTo: trailingAnchor),
            weekIntervalButton.widthAnchor.constraint(equalToConstant: 38)
           ])
    }
    
    private func setupWeekButtons(){

        NSLayoutConstraint.activate([
            button1.widthAnchor.constraint(equalToConstant: 38),
            button2.widthAnchor.constraint(equalToConstant: 38),
            button3.widthAnchor.constraint(equalToConstant: 38),
            button4.widthAnchor.constraint(equalToConstant: 38),
            button5.widthAnchor.constraint(equalToConstant: 38),
            button6.widthAnchor.constraint(equalToConstant: 38),
            button7.widthAnchor.constraint(equalToConstant: 38),
        ])
        weekButtons.addArrangedSubview(button1)
        weekButtons.addArrangedSubview(button2)
        weekButtons.addArrangedSubview(button3)
        weekButtons.addArrangedSubview(button4)
        weekButtons.addArrangedSubview(button5)
        weekButtons.addArrangedSubview(button6)
        weekButtons.addArrangedSubview(button7)
        
    }
    private func setupWeekInterval(){
        weekIntervalButton.translatesAutoresizingMaskIntoConstraints = false
        
        weekInterval.addArrangedSubview(weekIntervalButton)
        let subLabel : UILabel = {
            let label = UILabel()
            label.text = "주 간격으로 반복"
            label.font = UIFont.mpFont16R() // 폰트 크기 설정
            label.textColor = .mpDarkGray
            return label
        }()
        weekInterval.addArrangedSubview(subLabel)
        
    }
    
    
    private func setupRepeatEndDate(){
        let RepeatEndDateLabel : UILabel = {
            let label = UILabel()
            label.text = "반복 종료일 설정"
            label.font = UIFont.mpFont16R()
            label.textColor = UIColor.mpDarkGray
            return label
        }()
        NSLayoutConstraint.activate([
            RepeatEndDateButton.widthAnchor.constraint(equalToConstant: 24),
            RepeatEndDateLabel.heightAnchor.constraint(equalToConstant: 24),
           

        ])
        repeatEndDate.addArrangedSubview(RepeatEndDateButton)
        repeatEndDate.addArrangedSubview(RepeatEndDateLabel)
        
    }
    private func setupRepeatEndDateButton(){
        repeatEndDate2.translatesAutoresizingMaskIntoConstraints = false
        RepeatEndDate2Label.translatesAutoresizingMaskIntoConstraints = false
           NSLayoutConstraint.activate([
            // 높이 설정
            
            repeatEndDate2.heightAnchor.constraint(equalToConstant: 38),
            repeatEndDate2.topAnchor.constraint(equalTo: repeatEndDate.bottomAnchor,constant: 16),
            repeatEndDate2.leadingAnchor.constraint(equalTo: leadingAnchor),
            repeatEndDate2.trailingAnchor.constraint(equalTo: trailingAnchor),
            RepeatEndDate2Label.heightAnchor.constraint(equalToConstant: 38),
            RepeatEndDate2Label.widthAnchor.constraint(equalToConstant: 28),
            calChooseButton.widthAnchor.constraint(equalToConstant: 137),
            calChooseButton.heightAnchor.constraint(equalToConstant: 38),
            
           ])
       
    }
    @objc
    func repeatEndDateButtonTapped(){
        if RepeatEndDateButton.isChecked {
            repeatEndChecked = false
            print("반복 종료일 설정 클릭함 ")
            delegate?.addEndDay(repeatEndDate2)
            setupRepeatEndDateButton()
            setNeedsLayout()
            layoutIfNeeded()
            
        
        }
        else{
            repeatEndChecked = true
            repeatEndDate2.removeFromSuperview()
            delegate?.removeEndDay()
            
        }
    }
    func updateViewFrame(newHeight: CGFloat) {
            var newFrame = self.frame
            newFrame.size.height = newHeight
            self.frame = newFrame
            setNeedsLayout()
            layoutIfNeeded()
            
        }
                                        

   
}

