//
//  ChooseDateView.swift
//  Money-Planner
//
//  Created by p_kxn_g on 1/28/24.
//

import Foundation
import UIKit

// Protocol to handle interactions or events related to ChooseDayView
protocol ChooseDateViewDelegate: AnyObject {
    func chooseIntervalDate(_ view: UIViewController)
    func addEndDate(_ view : UIStackView)
    func removeEndDate()
    // Define methods or properties as needed
}

class ChooseDateView: UIView {
    // Weak reference to the delegate
    weak var delegate: ChooseDateViewDelegate?
    var weekIBtnConstraint  : NSLayoutConstraint?

    var repeatEndChecked = true
    private let currentDate = Date()
    private let dateFormatter = DateFormatter()
  
    lazy var dateString: String = {
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        // 일년 뒤 날짜.
        if let oneYearLaterDate = Calendar.current.date(byAdding: .year, value: 1, to: currentDate){
            return dateFormatter.string(from: oneYearLaterDate)
        }else{
            return dateString
        }
        
    }()
    lazy var dateString2: String = {
        dateFormatter.dateFormat = "dd일"
        return dateFormatter.string(from: currentDate)
        
    }()
    
    // Other properties and methods of ChooseDayView
    private let backButton = UIButton()
    private let titleLabel = MPLabel()

    private let weekInterval : UIStackView = {
            let stackView = UIStackView()
        // >> stackView.backgroundColor = .blue
            stackView.axis = .horizontal
            stackView.spacing = 8
            return stackView
        }()
  
    lazy var weekIntervalButton: OneDayButton = {
            // Now you can use dateString2 here
            let button = OneDayButton(title: dateString2, buttonBool: false)
            button.titleLabel?.font = .mpFont16R()
            return button
        }()
    private let repeatEndDate : UIStackView = {
            let stackView = UIStackView()
        //>> stackView.backgroundColor = .cyan
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
        
        //let view1 = UIView(frame: CGRect(x: 0, y: 0, width: 313, height: 171))
        super.init(frame: frame)
        
        setupContainer()
        setupWeekInterval()
        setupRepeatEndDate()
        //
        //backgroundColor = .blue
        //ㄹweekInterval.backgroundColor = .green

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupContainer() {
        
       
        weekInterval.translatesAutoresizingMaskIntoConstraints = false
        repeatEndDate.translatesAutoresizingMaskIntoConstraints = false
        addSubview(weekInterval)
        addSubview(repeatEndDate)
        //repeatEndDate.backgroundColor = .yellow
           NSLayoutConstraint.activate([
            // 높이 설정
            
            weekInterval.heightAnchor.constraint(equalToConstant: 38),
            repeatEndDate.heightAnchor.constraint(equalToConstant: 24),
               //weekButtons.bottomAnchor.constraint(equalTo: weekInterval.topAnchor),
              
            
               weekInterval.topAnchor.constraint(equalTo: topAnchor),
               weekInterval.leadingAnchor.constraint(equalTo: leadingAnchor),
               weekInterval.trailingAnchor.constraint(equalTo: trailingAnchor),
               //repeatEndDate.bottomAnchor.constraint(equalTo: bottomAnchor),
               repeatEndDate.topAnchor.constraint(equalTo: weekInterval.bottomAnchor,constant: 16),
               repeatEndDate.leadingAnchor.constraint(equalTo: leadingAnchor),
               repeatEndDate.trailingAnchor.constraint(equalTo: trailingAnchor),
           ])
    }
    
    private func setupWeekInterval(){
        weekIntervalButton.translatesAutoresizingMaskIntoConstraints = false
        let subLabel : UILabel = {
            let label = UILabel()
            label.text = "매월"
            label.font = UIFont.mpFont16R() // 폰트 크기 설정
            label.textColor = .mpDarkGray
            return label
        }()
        let subLabel2 : UILabel = {
            let label = UILabel()
            label.text = "에 반복"
            label.font = UIFont.mpFont16R() // 폰트 크기 설정
            label.textColor = .mpDarkGray
            return label
        }()
       let blank = UIView()
        NSLayoutConstraint.activate([
            subLabel.widthAnchor.constraint(equalToConstant: 30 ),
            subLabel2.widthAnchor.constraint(equalToConstant: 59)
        ])
        //weekIBtnConstraint = weekIntervalButton.widthAnchor.constraint(equalToConstant: 38)

        //weekIBtnConstraint!.isActive = true
        weekIntervalButton.contentEdgeInsets = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        weekInterval.addArrangedSubview(subLabel)
        weekInterval.addArrangedSubview(weekIntervalButton)
        weekInterval.addArrangedSubview(subLabel2)
        weekInterval.addArrangedSubview(blank)

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
    
    // 반복 종료일 설정
    @objc
    func repeatEndDateButtonTapped(){
        if RepeatEndDateButton.isChecked {
            repeatEndChecked = false
            print("반복 종료일 설정 클릭함 ")
            //setupRepeatEndDateButton()
            print("log1")
            delegate?.addEndDate(repeatEndDate2)
            print("log2")

            setNeedsLayout()
            layoutIfNeeded()
        
        }
        else{
            repeatEndChecked = true
            delegate?.removeEndDate()
            
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

