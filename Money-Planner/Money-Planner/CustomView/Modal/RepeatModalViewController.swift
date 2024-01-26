//
//  RepeatModalViewController.swift
//  Money-Planner
//
//  Created by p_kxn_g on 1/27/24.
//

import Foundation
import UIKit



class RepeatModalViewController : UIViewController {
    

    let customModal = UIView(frame: CGRect(x: 0, y: 0, width: 361, height: 355))
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "언제 반복할까요?"
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
        setupRepeatView()
        setupCancelNComplte()
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
        containerView.backgroundColor = .mpDim
        customModal.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: customModal.leadingAnchor, constant: 24),
            containerView.trailingAnchor.constraint(equalTo: customModal.trailingAnchor, constant: -24),
            containerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            containerView.heightAnchor.constraint(equalToConstant: 107)
        ])
            
    }

    private func setupRepeatView() {
        
        let dayContainerView = UIView()
        dayContainerView.backgroundColor = .green
        let line = UIView()
        line.backgroundColor = .mpLightGray
        let dateContainerView = UIView()
        dateContainerView.backgroundColor = .green
        
        dayContainerView.translatesAutoresizingMaskIntoConstraints = false
        line.translatesAutoresizingMaskIntoConstraints = false
        dateContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(line)
        containerView.addSubview(dayContainerView)
        containerView.addSubview(dateContainerView)
        
        NSLayoutConstraint.activate([
              // containerView의 top에 맞춰서 위치
            line.heightAnchor.constraint(equalToConstant: 1),
            line.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            line.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            //line.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            line.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            dayContainerView.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            dayContainerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            dayContainerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            dayContainerView.topAnchor.constraint(equalTo: containerView.topAnchor),
            dayContainerView.bottomAnchor.constraint(equalTo: line.topAnchor),
            dateContainerView.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            dateContainerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            dateContainerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            dateContainerView.topAnchor.constraint(equalTo: line.bottomAnchor),
            dateContainerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])
        let chooseDay : UILabel = {
            let label = UILabel()
            label.text = "요일 선택"
            label.font = UIFont.mpFont18M()
            label.textColor = .mpBlack
            return label
        }()
        
        let chooseDate : UILabel = {
            let label = UILabel()
            label.text = "날짜 선택"
            label.font = UIFont.mpFont18M()
            label.textColor = .mpBlack
            return label
            
        }()
        
        let chooseDayButton  = CheckBtn()
        chooseDayButton.addTarget(self, action: #selector(showChooseDayModal), for: .touchUpInside)
        let chooseDateButton = CheckBtn()
        chooseDateButton.addTarget(self, action: #selector(showChooseDateModal), for: .touchUpInside)
        chooseDayButton.setChecked(false)
        chooseDateButton.setChecked(false)
        dayContainerView.addSubview(chooseDayButton)
        dayContainerView.addSubview(chooseDay)
        dateContainerView.addSubview(chooseDateButton)
        dateContainerView.addSubview(chooseDate)
        chooseDay.translatesAutoresizingMaskIntoConstraints = false
        chooseDate.translatesAutoresizingMaskIntoConstraints = false
        chooseDayButton.translatesAutoresizingMaskIntoConstraints = false
        chooseDateButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            chooseDayButton.widthAnchor.constraint(equalToConstant:28),
            chooseDayButton.heightAnchor.constraint(equalToConstant: 28),
            chooseDayButton.trailingAnchor.constraint(equalTo: dayContainerView.trailingAnchor),
            chooseDayButton.centerYAnchor.constraint(equalTo: dayContainerView.centerYAnchor),
            chooseDateButton.widthAnchor.constraint(equalToConstant:28),
            chooseDateButton.heightAnchor.constraint(equalToConstant: 28),
            chooseDateButton.trailingAnchor.constraint(equalTo: dateContainerView.trailingAnchor),
            chooseDateButton.centerYAnchor.constraint(equalTo: dateContainerView.centerYAnchor),
            
            chooseDay.leadingAnchor.constraint(equalTo: dayContainerView.leadingAnchor),
            chooseDay.centerYAnchor.constraint(equalTo: dayContainerView.centerYAnchor),
            chooseDay.topAnchor.constraint(equalTo: dayContainerView.topAnchor),
            chooseDay.bottomAnchor.constraint(equalTo: dayContainerView.bottomAnchor),
            chooseDate.leadingAnchor.constraint(equalTo: dateContainerView.leadingAnchor),
            chooseDate.centerYAnchor.constraint(equalTo: dateContainerView.centerYAnchor),
            chooseDate.topAnchor.constraint(equalTo: dateContainerView.topAnchor),
            chooseDate.bottomAnchor.constraint(equalTo: dateContainerView.bottomAnchor),
        ])

    }
    private func setupCancelNComplte(){
        let cancelNcomplte = SmallBtnView()
        customModal.addSubview(cancelNcomplte)
        cancelNcomplte.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cancelNcomplte.bottomAnchor.constraint(equalTo: customModal.bottomAnchor,constant: -20),  // containerView의 top에 맞춰서 위치
            cancelNcomplte.heightAnchor.constraint(equalToConstant: 56),
            cancelNcomplte.leadingAnchor.constraint(equalTo: customModal.leadingAnchor, constant: 20),
            cancelNcomplte.trailingAnchor.constraint(equalTo: customModal.trailingAnchor, constant: -20),
        ])
        cancelNcomplte.addCancelAction(target: self, action: #selector(cancelButtonTapped))
        cancelNcomplte.addCompleteAction(target: self, action: #selector(completeButtonTapped))
    }
    
    
    @objc private func cancelButtonTapped() {
        print("취소 버튼이 탭되었습니다.")
        // 취소 버튼 액션 처리
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func completeButtonTapped() {
        print("완료 버튼이 탭되었습니다.")
        // 완료 버튼 액션 처리
        dismiss(animated: true, completion: nil)
    }
    @objc
    private func showChooseDayModal() {
        print("요일 선택")
        
        }
    
    @objc
    private func showChooseDateModal() {
        print("날짜 선택")
        
        }

    
}




