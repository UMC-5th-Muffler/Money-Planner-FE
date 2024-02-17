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
class CalendartModalViewController : UIViewController {
    weak var delegate: CalendarSelectionDelegate?

    let customModal = UIView(frame: CGRect(x: 0, y: 0, width: 361, height: 548))
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "소비 날짜를 선택해주세요"
        label.textAlignment = .center
        label.font = UIFont.mpFont20B()
        return label
    }()
    let containerView = UIView()
    let datePicker :UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.locale = Locale(identifier: "ko_KR")
        datePicker.preferredDatePickerStyle = .inline
        datePicker.datePickerMode = .date
        datePicker.tintColor = .mpMainColor
        //datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        //datePicker.backgroundColor = .mpRed
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }()
    
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
        setupBackground()
        setuptitleLabel()
        setupCalendarCellContainerView()
    }
    func presentCustomModal() {
        // Instantiate your custom modal view
        customModal.backgroundColor = UIColor.mpWhite
        view.addSubview(customModal)
        customModal.center = view.center
        
    }
    private func setupBackground() {
        customModal.backgroundColor = .white
        customModal.layer.cornerRadius = 25
        customModal.layer.masksToBounds = true
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
        NSLayoutConstraint.activate([
            datePicker.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            datePicker.topAnchor.constraint(equalTo: containerView.topAnchor),  // containerView의 top에 맞춰서 위치
            datePicker.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)  // containerView의 bottom에 맞춰서 위치
        ])
        
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
        let selectedDate = dateFormatter.string(from: datePicker.date)
        // api 전달용
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let apiDate = dateFormatter.string(from: datePicker.date)
        delegate?.didSelectCalendarDate(selectedDate, api : apiDate)
        dismiss(animated: true, completion: nil as (() -> Void)?)
        // 완료 버튼 액션 처리
    }
    @objc private func todayButtonTapped() {
        print("오늘 선택하기 버튼이 탭되었습니다.")
        datePicker.setDate(Date(), animated: true)
        // 완료 버튼 액션 처리
    }
    
    
    
    
    
}



