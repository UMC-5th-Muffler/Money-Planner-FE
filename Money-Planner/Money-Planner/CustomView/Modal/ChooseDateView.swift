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
    func chooseDateViewDidUpdateFrame(_ newHeight: CGFloat)
    // Define methods or properties as needed
}

class ChooseDateView: UIView {
    // Weak reference to the delegate
    weak var delegate: ChooseDateViewDelegate?
    
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
    
    private let RepeatEndDate2Label : UILabel = {
        let label = UILabel()
        label.text = "까지"
        label.font = UIFont.mpFont16R()
        label.textColor = UIColor.mpDarkGray
        return label
    }()
    let blank = UIView()
    private lazy var RepeatEndDateButton : CheckBtn = {
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
        button.addTarget(self, action: #selector(showCalModal), for: .touchUpInside) //클릭시 모달 띄우기
        return button
        
    }()
    
    override init(frame: CGRect  = .zero) {
        
        //let view1 = UIView(frame: CGRect(x: 0, y: 0, width: 313, height: 171))
        super.init(frame: frame)
        
        setupContainer()
        setupWeekInterval()
        setupRepeatEndDate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupContainer() {
        
       
        weekInterval.translatesAutoresizingMaskIntoConstraints = false
        repeatEndDate.translatesAutoresizingMaskIntoConstraints = false
        addSubview(weekInterval)
        addSubview(repeatEndDate)

           NSLayoutConstraint.activate([
            // 높이 설정
            
            weekInterval.heightAnchor.constraint(equalToConstant: 38),
            repeatEndDate.heightAnchor.constraint(equalToConstant: 24),
               //weekButtons.bottomAnchor.constraint(equalTo: weekInterval.topAnchor),
              
            
               weekInterval.topAnchor.constraint(equalTo: topAnchor,constant: 16),
               weekInterval.leadingAnchor.constraint(equalTo: leadingAnchor),
               weekInterval.trailingAnchor.constraint(equalTo: trailingAnchor),
               //repeatEndDate.bottomAnchor.constraint(equalTo: bottomAnchor),
               repeatEndDate.topAnchor.constraint(equalTo: weekInterval.bottomAnchor,constant: 16),
               repeatEndDate.leadingAnchor.constraint(equalTo: leadingAnchor),
               repeatEndDate.trailingAnchor.constraint(equalTo: trailingAnchor),
           ])
    }
    

    private func setupWeekInterval(){
        weekIntervalButton.addTarget(self, action: #selector(buttonTapped2), for: .touchUpInside)
        weekIntervalButton.translatesAutoresizingMaskIntoConstraints = false
        let subLabel : UILabel = {
            let label = UILabel()
            label.text = "매월"
            label.font = UIFont.mpFont14R() // 폰트 크기 설정
            label.textColor = .mpDarkGray
            return label
        }()
        let subLabel2 : UILabel = {
            let label = UILabel()
            label.text = "에 반복"
            label.font = UIFont.mpFont14R() // 폰트 크기 설정
            label.textColor = .mpDarkGray
            return label
        }()
       let blank = UIView()
        NSLayoutConstraint.activate([
            subLabel.widthAnchor.constraint(equalToConstant: 30 ),
            weekIntervalButton.widthAnchor.constraint(equalToConstant: 110),
            subLabel2.widthAnchor.constraint(equalToConstant: 59)
        ])
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
            RepeatEndDateLabel.heightAnchor.constraint(equalToConstant: 38),
           

        ])
        repeatEndDate.addArrangedSubview(RepeatEndDateButton)
        repeatEndDate.addArrangedSubview(RepeatEndDateLabel)
        
    }
    @objc
    func repeatEndDateButtonTapped(){
        if repeatEndChecked {
            repeatEndChecked = false
            print("반복 종료일 설정 클릭함 ")
            
            repeatEndDate2.translatesAutoresizingMaskIntoConstraints = false
            RepeatEndDate2Label.translatesAutoresizingMaskIntoConstraints = false
            addSubview(repeatEndDate2)

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

            repeatEndDate2.addArrangedSubview(blank)
            repeatEndDate2.addArrangedSubview(calChooseButton)
            repeatEndDate2.addArrangedSubview(RepeatEndDate2Label)
            
            //frame = CGRect(x: 0, y: 0, width:313, height: 200)
            setNeedsLayout()
            layoutIfNeeded()
            delegate?.chooseDateViewDidUpdateFrame(200)
        
        }
        else{
            repeatEndChecked = true
            repeatEndDate2.removeFromSuperview()
            delegate?.chooseDateViewDidUpdateFrame(201)
            
        }
    }
    func updateViewFrame(newHeight: CGFloat) {
            var newFrame = self.frame
            newFrame.size.height = newHeight
            self.frame = newFrame
            setNeedsLayout()
            layoutIfNeeded()
            
        }
    @objc func showCalModal(_ sender: UIDatePicker) {
          // 뷰 체인지
            delegate?.chooseDateViewDidUpdateFrame(0)
        }
    // 버튼 탭 시 호출되는 메서드
    @objc private func buttonTapped2() {
        delegate?.chooseDateViewDidUpdateFrame(1)
        print("간격 모달 뷰로 스위치")
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
            }
    }
   
}

