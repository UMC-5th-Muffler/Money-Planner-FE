//
//  CalendarModalViewController.swift
//  Money-Planner
//
//  Created by p_kxn_g on 1/26/24.
//

import Foundation
import UIKit

protocol CalendarSelectionDelegate : AnyObject{
    func didSelectCalendarDate(_ date : String,  api : String)
}
class CalendartModalViewController : UIViewController{
    weak var delegate: CalendarSelectionDelegate?

    //let customModal = UIView(frame: CGRect(x: 0, y: 0, width: 361, height: 548))
    var decorations: [Date?: UICalendarView.Decoration]?

    // 모달의 메인 컨테이너 뷰
    private let customModal: UIView = {
        let view = UIView()
        view.backgroundColor = .mpWhite
        view.layer.cornerRadius = 25
        view.layer.masksToBounds = true
        return view
    }()
    
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "소비 날짜를 선택해주세요"
        label.textAlignment = .center
        label.font = UIFont.mpFont20B()
        return label
    }()
    let containerView = UIView()
    let datePicker : UICalendarView = {
        let datePicker = UICalendarView()
        datePicker.locale = Locale(identifier: "ko_KR")
        datePicker.tintColor = .mpMainColor
        return datePicker
    }()
//    let datePicker :UIDatePicker = {
//        let datePicker = UIDatePicker()
//        datePicker.locale = Locale(identifier: "ko_KR")
//        datePicker.preferredDatePickerStyle = .inline
//        datePicker.datePickerMode = .date
//        datePicker.tintColor = .mpMainColor
//        //datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
//        //datePicker.backgroundColor = .mpRed
//        datePicker.translatesAutoresizingMaskIntoConstraints = false
//        return datePicker
//    }()
   // let datePicker = UIPickerView()
    let completeButton : UIButton = {
        let button = UIButton()
        button.setTitle("완료", for: .normal)
        button.setTitleColor(UIColor.mpWhite, for: .normal)
        button.backgroundColor = UIColor.mpMainColor
        button.layer.cornerRadius = 11  // 적절한 둥글기 값 설정
        button.clipsToBounds = true
        return button
    }()
    let chooseTodayButton: UIButton = {
        let button = UIButton()
        button.setTitle("오늘 선택하기", for: .normal)
        button.setTitleColor(.mpBlack, for: .normal)
        
        // 밑줄 스타일 속성
        let underlineAttribute: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
            NSAttributedString.Key.font: UIFont.mpFont14R()
        ]
        
        // NSAttributedString 생성
        let underlineAttributedString = NSAttributedString(string: "오늘 선택하기", attributes: underlineAttribute)
        
        // 버튼에 NSAttributedString 설정
        button.setAttributedTitle(underlineAttributedString, for: .normal)
        
        return button
    }()
    // 모달 제목 바꾸는 함수
    func changeTitle(title : String){
        titleLabel.text = title
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        presentCustomModal()
        setuptitleLabel()
        setupCalendarCellContainerView()
        setupCompleteButton()
        
        // UICalendarView의 Delegate를 설정합니다.
        datePicker.delegate = self
        
        // 날짜 선택 동작을 설정합니다.
        let dateSelection = UICalendarSelectionSingleDate(delegate: self)
        datePicker.selectionBehavior = dateSelection
        
        let valentinesDay = DateComponents(
                    calendar: Calendar(identifier: .gregorian),
                    year: 2024,
                    month: 2,
                    day: 14
                )
                
        // Create a calendar decoration for Valentine's day.
        let heart = UICalendarView.Decoration.default()
        
        
        decorations = [valentinesDay.date: heart]
    }
    
    func presentCustomModal() {
        view.addSubview(customModal)
        customModal.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
                customModal.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
                customModal.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                customModal.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                customModal.heightAnchor.constraint(equalToConstant: 548)
                
            ])
    }

    private func setuptitleLabel() {
        let modalBar = UIView()
        modalBar.layer.cornerRadius = 8
        modalBar.backgroundColor = .mpLightGray
        
        customModal.addSubview(modalBar)
        customModal.addSubview(titleLabel)
        modalBar.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
       
        NSLayoutConstraint.activate([
            modalBar.widthAnchor.constraint(equalToConstant: 49),
            modalBar.heightAnchor.constraint(equalToConstant: 4),
            modalBar.topAnchor.constraint(equalTo: customModal.topAnchor, constant: 12),
            modalBar.centerXAnchor.constraint(equalTo: customModal.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: modalBar.bottomAnchor, constant: 28),
            titleLabel.centerXAnchor.constraint(equalTo: customModal.centerXAnchor),
            ])
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        //containerView.backgroundColor = .mpDim
        customModal.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: customModal.leadingAnchor, constant: 9),
            containerView.trailingAnchor.constraint(equalTo: customModal.trailingAnchor, constant: -9),
            containerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            //containerView.bottomAnchor.constraint(equalTo: customModal.bottomAnchor, constant: -72)
        ])
            
    }

    private func setupCalendarCellContainerView() {
        
        containerView.addSubview(datePicker)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            datePicker.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            datePicker.topAnchor.constraint(equalTo: containerView.topAnchor),  // containerView의 top에 맞춰서 위치
            datePicker.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)  // containerView의 bottom에 맞춰서 위치
        ])
        

    }
    
    // 세팅 : 오늘 선택하기와 완료 버튼
    private func setupCompleteButton(){
        customModal.addSubview(completeButton)
        completeButton.isUserInteractionEnabled = true
        completeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            completeButton.widthAnchor.constraint(equalToConstant: 164),
            completeButton.heightAnchor.constraint(equalToConstant: 53),
            completeButton.bottomAnchor.constraint(equalTo: customModal.bottomAnchor,constant: -24),  // containerView의 top에 맞춰서 위치
            completeButton.trailingAnchor.constraint(equalTo: customModal.trailingAnchor,constant: -24)  // containerView의 bottom에 맞춰서 위치
        ])
        completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
        
        customModal.addSubview(chooseTodayButton)
        chooseTodayButton.isUserInteractionEnabled = true
        chooseTodayButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            chooseTodayButton.widthAnchor.constraint(equalToConstant: 100),
            chooseTodayButton.heightAnchor.constraint(equalToConstant: 18),
            chooseTodayButton.bottomAnchor.constraint(equalTo: customModal.bottomAnchor,constant: -42),  // containerView의 top에 맞춰서 위치
            chooseTodayButton.leadingAnchor.constraint(equalTo: customModal.leadingAnchor,constant: 24)  // containerView의 bottom에 맞춰서 위치
        ])
        chooseTodayButton.addTarget(self, action: #selector(todayButtonTapped), for: .touchUpInside)
    }
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
            let selectedDate = sender.date
            print("Selected Date: \(selectedDate)")
        }

    
    @objc private func completeButtonTapped() {
        print("완료 버튼이 탭되었습니다.")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        //let selectedDate = dateFormatter.string(from: datePicker.date)
        // api 전달용
        dateFormatter.dateFormat = "yyyy-MM-dd"
        //let apiDate = dateFormatter.string(from: datePicker.date)
        //delegate?.didSelectCalendarDate(selectedDate, api : apiDate)
        dismiss(animated: true, completion: nil as (() -> Void)?)
        // 완료 버튼 액션 처리
    }
    @objc private func todayButtonTapped() {
        print("오늘 선택하기 버튼이 탭되었습니다.")
        //datePicker.setDate(Date(), animated: true)
        // 완료 버튼 액션 처리
    }
    
    
    
    
    
}

extension CalendartModalViewController : UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate{
    
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        if let currDate = dateComponents{
            print(currDate)
        }
        
    }
  

    
    // Return a decoration (if any) for the specified day.
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        // Get a copy of the date components that only contain
        // the calendar, year, month, and day.
        let day = DateComponents(
            calendar: dateComponents.calendar,
            year: dateComponents.year,
            month: dateComponents.month,
            day: dateComponents.day
        )
        
        // Return any decoration saved for that date.
        return decorations![day.date]
    }
    
}

