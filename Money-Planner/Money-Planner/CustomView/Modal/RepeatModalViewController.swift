//
//  RepeatModalViewController.swift
//  Money-Planner
//
//  Created by p_kxn_g on 1/27/24.
//

import Foundation
import UIKit
protocol RepeatModalViewDelegate : AnyObject{
    func GetResultofInterval(_ result : String)
}


class RepeatModalViewController : UIViewController, ChooseDayViewDelegate,CalendarSelectionDelegate, RepeatIntervalDelegate, ChooseDateViewDelegate {

    var dayContainerViewBottomConstraint: NSLayoutConstraint?
    var dateContainerViewBottomConstraint: NSLayoutConstraint?
    var ChooseDayHeightConstraint : NSLayoutConstraint?
    var ChooseDateHeightConstraint : NSLayoutConstraint?
    var lineConstraintHeight: NSLayoutConstraint?
    var lineConstraintBottom: NSLayoutConstraint?
    var stackViewHeightConstraint : NSLayoutConstraint?
    var stackView2HeightConstraint : NSLayoutConstraint?


    var containerViewBottomConstraint : NSLayoutConstraint?
    weak var delegate: RepeatModalViewDelegate?
   // 오늘 날짜(일)
    let currentDate = Date()
    let dateFormatter = DateFormatter()
    lazy var dateString: String = {
         dateFormatter.dateFormat = "dd일"
         return dateFormatter.string(from: currentDate)
     }()

    let IntervalSelectionModalVC = RepeatIntervalViewController()
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
    let chooseDateButton = CheckBtn()
    let dayContainerView = UIView()
    let line : UIView = {
        let line = UIView()
        line.backgroundColor = .mpLightGray
        line.layer.cornerRadius = 10
        return line
    }()
    let dateContainerView = UIView()
    let stackView = UIStackView()
    let stackView2 = UIStackView()
    let view1 = ChooseDayView()
    let view2 = ChooseDateView()
    
    // delegate
    func didIntervalSelected(_ Interval: String,_ num : Int) {
        UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        if num == 1{view1.weekIntervalButton.setTitle(Interval, for: .normal)}
        if num == 2{view2.weekIntervalButton.setTitle(Interval, for: .normal)}
        print("[data] 얼마나 반복할 지 결정됨 : \(Interval)")
    }
    
    func didSelectCalendarDate(_ date: String) {
        print("Selected Date in YourPresentingViewController: \(date)")
        view1.calChooseButton.setTitle(date, for: .normal)
        view2.calChooseButton.setTitle(date, for: .normal)

    }
    

    func chooseDateViewDidUpdateFrame(_ newHeight: CGFloat) {
        if newHeight == 0 {
            calSelectionModal()
        }
        if newHeight == 1{
            print("스위치 완료 - 매월 언제 반복할까요?")
            IntervalSelectionModal(2)
            
        }
        if newHeight == 200{
            print("log1")
            changeContainer(-60,2)
            customModal.frame.size = CGSize(width: 361, height: 502)
        }
        if newHeight == 201 {
            print("log2")
           
            changeContainer(-60,2)
            customModal.frame.size = CGSize(width: 361, height: 448)
        }
    }

    
    //let view1 = ChooseDayView(frame: CGRect(x: 0, y: 0, width: 313, height: 171) )
    //let view1 = UIView(frame: CGRect(x: 0, y: 0, width: 313, height: 147))
    //let view2 = UIView(frame: CGRect(x: 0, y: 0, width: 313, height: 97))
    
    let cancelNcomplte = SmallBtnView()
    
    // 날짜 선택 시 나오는 화면
    // 모달 제목 바꾸는 함수
    func changeTitle(title : String){
        titleLabel.text = title
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        presentCustomModal()
        setupBackground()
        setuptitleLabel()
        setupCancelNComplte()
        setupRepeatView()
        print(chooseDayButton.isChecked)
        // 요일 선택
        view1.delegate = self
        view1.translatesAutoresizingMaskIntoConstraints = false
        view2.delegate = self
        view2.translatesAutoresizingMaskIntoConstraints = false

    }
    func presentCustomModal() {
        // Instantiate your custom modal view
        customModal.backgroundColor = UIColor.mpWhite
        view.addSubview(customModal)
        customModal.center = view.center
        
    }
    private func setupBackground() {
        //customModal.backgroundColor = .white
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
            titleLabel.heightAnchor.constraint(equalToConstant: 28),
            titleLabel.topAnchor.constraint(equalTo: modalBar.bottomAnchor, constant: 40),
            titleLabel.centerXAnchor.constraint(equalTo: customModal.centerXAnchor),
        ])
        
        
        
    }
    
    private func setupRepeatView() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        //containerView.backgroundColor = .mpDim
        customModal.addSubview(containerView)
        containerViewBottomConstraint = containerView.bottomAnchor.constraint(equalTo: cancelNcomplte.topAnchor, constant: -60)
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: customModal.leadingAnchor, constant: 24),
            containerView.trailingAnchor.constraint(equalTo: customModal.trailingAnchor, constant: -24),
            containerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            containerViewBottomConstraint!
        ])
        

        
        dayContainerView.translatesAutoresizingMaskIntoConstraints = false
        line.translatesAutoresizingMaskIntoConstraints = false
        dateContainerView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView2.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(dayContainerView)
        containerView.addSubview(stackView)
        containerView.addSubview(stackView2)
        containerView.addSubview(line)
        containerView.addSubview(dateContainerView)
        
        dayContainerViewBottomConstraint = dayContainerView.bottomAnchor.constraint(equalTo: line.topAnchor,constant: -24)
        lineConstraintHeight = line.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        dateContainerViewBottomConstraint = dateContainerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        stackViewHeightConstraint = stackView.heightAnchor.constraint(equalToConstant: 0)
        stackView2HeightConstraint = stackView2.heightAnchor.constraint(equalToConstant: 0)

        NSLayoutConstraint.activate([
            
            // 요일 선택 컨테이너 박스
            dayContainerView.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            //dayContainerView.heightAnchor.constraint(equalToConstant:40),
            dayContainerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            dayContainerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            dayContainerView.topAnchor.constraint(equalTo: containerView.topAnchor),
            dayContainerViewBottomConstraint!,
            
            // 요일 선택 시 등장 화면
            //stackView.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: dayContainerView.bottomAnchor),
            stackView.bottomAnchor.constraint(equalTo: line.topAnchor),
            
            // containerView의 top에 맞춰서 위치
            line.heightAnchor.constraint(equalToConstant:2),
            line.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            line.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            lineConstraintHeight!,
            line.topAnchor.constraint(equalTo: stackView.bottomAnchor),
            
            // 날짜 선택 컨테이너 박스
            
            //ChooseDayHeightConstraint!,
            dateContainerView.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            dateContainerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            dateContainerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            dateContainerView.topAnchor.constraint(equalTo: line.bottomAnchor,constant: 24),
            dateContainerViewBottomConstraint!,
            // 날짜 선택 시 등장 화면
            stackView2.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            stackView2.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            stackView2.topAnchor.constraint(equalTo: dateContainerView.bottomAnchor),
            stackView2.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        chooseDayButton.addTarget(self, action: #selector(showChooseDayModal), for: .touchUpInside)
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
        customModal.addSubview(cancelNcomplte)
        cancelNcomplte.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cancelNcomplte.bottomAnchor.constraint(equalTo: customModal.bottomAnchor,constant: -20),
            cancelNcomplte.heightAnchor.constraint(equalToConstant: 56),
            cancelNcomplte.leadingAnchor.constraint(equalTo: customModal.leadingAnchor, constant: 20),
            cancelNcomplte.trailingAnchor.constraint(equalTo: customModal.trailingAnchor, constant: -20),
        ])
        
        // 버튼 액션 추가
        // 취소)
        cancelNcomplte.addCancelAction(target: self, action: #selector(cancelButtonTapped))
        // 완료)
        cancelNcomplte.addCompleteAction(target: self, action: #selector(completeButtonTapped))
    }
    
    
    @objc private func cancelButtonTapped() {
        print("취소 버튼이 탭되었습니다.")
        // 취소 버튼 액션 처리
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func completeButtonTapped() {
        let lst = [view1.button1, view1.button2,view1.button3, view1.button4,view1.button5, view1.button6,view1.button7]
        let days = ["월","화","수","목","금","토","일"]
        var returnLst = ""
        var returnInterval = (view1.weekIntervalButton.titleLabel?.text ?? "") + "주마다 "
        var returnValue = ""
        for item in lst {
            if !item.checked {
                if returnLst == ""{
                    returnLst += days[lst.firstIndex(of: item)!] // 해당 버튼의 인덱스를 사용하여 days 배열에서 요일을 가져옴

                }else{
                    returnLst += "," + days[lst.firstIndex(of: item)!] // 해당 버튼의 인덱스를 사용하여 days 배열에서 요일을 가져옴

                }
            }
        }
        print(view1.weekIntervalButton.titleLabel?.text ?? "")
        print(returnLst)
        print("완료 버튼이 탭되었습니다.")
        if returnInterval == "1주마다 "{ returnInterval = "매주 "}
        returnValue = returnInterval + returnLst
        print(returnValue)
        // 완료 버튼 액션 처리
        
        if IntervalSelectionModalVC.type == 1{
            delegate?.GetResultofInterval(returnValue)
        }
        if IntervalSelectionModalVC.type == 2{
            delegate?.GetResultofInterval("매월 "+(view2.weekIntervalButton.titleLabel?.text ?? "") )
            
        }
        animationViewChange ()
        dismiss(animated: true, completion: nil)
    }
    @objc
    private func showChooseDayModal() {
        print("화면 변경 : 요일 선택")
        // 체크
        if chooseDayButton.isChecked {
            view2.removeFromSuperview() // 날짜 선택 화면 지우기
            stackView.backgroundColor = .red
            view1.backgroundColor = .mpMainColor
            chooseDateButton.isChecked = false
            chooseDay.textColor = .mpMainColor
            chooseDate.textColor = .mpBlack
            
            stackView.addArrangedSubview(view1)
            view1.translatesAutoresizingMaskIntoConstraints = false
            customModal.frame.size = CGSize(width: 361, height: 499)
            //stackView.frame.size = CGSize(width: 313 , height: 147)
            
            NSLayoutConstraint.deactivate([
                dayContainerViewBottomConstraint!,
                lineConstraintHeight!,
                stackViewHeightConstraint!,
            ])

            dayContainerViewBottomConstraint = dayContainerView.bottomAnchor.constraint(equalTo: stackView.topAnchor)
            ChooseDayHeightConstraint = dayContainerView.heightAnchor.constraint(equalToConstant: 28)
            ChooseDateHeightConstraint = dateContainerView.heightAnchor.constraint(equalToConstant: 28)
            lineConstraintBottom = line.topAnchor.constraint(equalTo: view1.bottomAnchor, constant: 28)

            NSLayoutConstraint.activate([
                dayContainerViewBottomConstraint!,
                ChooseDayHeightConstraint!,
                ChooseDateHeightConstraint!,
                lineConstraintBottom!,
                stackView2HeightConstraint!,
            ])
            IntervalSelectionModalVC.type = 1 // 새로 등장하는 화면 타입 설정
            
            animationViewChange ()
            
        }// 체크 취소
        else{
            chooseDayButton.isChecked = false
            chooseDay.textColor = .mpBlack
            
            // 선택 시 나오는 화면 삭제
            stackView.removeArrangedSubview(view1)
            view1.removeFromSuperview()
            
            // 커스텀 모달 (가장 큰 화면 ) 초기화
            customModal.frame.size = CGSize(width: 361, height: 355)
            //stackView.frame.size = CGSize(width: 313 , height: 0)
            dayContainerViewBottomConstraint = dayContainerView.bottomAnchor.constraint(equalTo: line.topAnchor, constant:  -24)
            NSLayoutConstraint.deactivate([
                ChooseDayHeightConstraint!,
                ChooseDateHeightConstraint!,
                lineConstraintBottom!,
                stackView2HeightConstraint!,])
            lineConstraintHeight = line.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
            NSLayoutConstraint.activate([
                dayContainerViewBottomConstraint!,
                lineConstraintHeight!,
            
            ])
            IntervalSelectionModalVC.type = 2 // 새로 등장하는 화면 타입 설정

            animationViewChange ()
        }
        
    }

    
    @objc
    private func showChooseDateModal() {
        if chooseDateButton.isChecked {
            print("날짜 선택")
            view1.removeFromSuperview()
            
            chooseDayButton.isChecked = false
            view2.translatesAutoresizingMaskIntoConstraints = false
            // 디자인 초기화
            chooseDate.textColor = .mpMainColor
            chooseDay.textColor = .mpBlack
            customModal.frame.size = CGSize(width: 361, height: 448)
            
            // 날짜 선택 시 추가되는 화면
            stackView2.addArrangedSubview(view2)
            view2.backgroundColor = .mpMainColor
            //stackView.frame.size = CGSize(width: 313 , height: 147)

            NSLayoutConstraint.deactivate([
                dayContainerViewBottomConstraint!,
                dateContainerViewBottomConstraint!,
                lineConstraintHeight!,
                stackView2HeightConstraint!
            ])
            dayContainerViewBottomConstraint = dayContainerView.bottomAnchor.constraint(equalTo: stackView.topAnchor)
            dateContainerViewBottomConstraint = dateContainerView.bottomAnchor.constraint(equalTo: stackView2.topAnchor)
            ChooseDayHeightConstraint = dayContainerView.heightAnchor.constraint(equalToConstant: 28)
            ChooseDateHeightConstraint = dateContainerView.heightAnchor.constraint(equalToConstant: 28)
            lineConstraintBottom = line.topAnchor.constraint(equalTo: stackView.bottomAnchor)
            stackViewHeightConstraint = stackView.heightAnchor.constraint(equalToConstant: 28)
            NSLayoutConstraint.activate([
                dateContainerViewBottomConstraint!,
                ChooseDayHeightConstraint!,
                ChooseDateHeightConstraint!,
                lineConstraintBottom!,
                stackViewHeightConstraint!,
                dayContainerViewBottomConstraint!,

            ])
            animationViewChange ()
            IntervalSelectionModalVC.type = 2 // 새로 등장하는 화면 타입 설정
            
        }
        else{
            chooseDateButton.isChecked = false
            chooseDate.textColor = .mpBlack
            // 커스텀 모달 (가장 큰 화면 ) 초기화
            
            // 선택 시 나오는 화면 삭제
            stackView2.removeArrangedSubview(view2)
            view2.removeFromSuperview()
            
            // 커스텀 모달 (가장 큰 화면 ) 초기화
            customModal.frame.size = CGSize(width: 361, height: 355)
            //stackView.frame.size = CGSize(width: 313 , height: 0)
            
            NSLayoutConstraint.deactivate([
                ChooseDayHeightConstraint!,
                ChooseDateHeightConstraint!,
                lineConstraintBottom!,
                stackViewHeightConstraint!,])
            
            lineConstraintHeight = line.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
            dateContainerViewBottomConstraint = dateContainerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            stackViewHeightConstraint = stackView.heightAnchor.constraint(equalToConstant: 28)
            stackView2HeightConstraint = stackView.heightAnchor.constraint(equalToConstant: 0)

            NSLayoutConstraint.activate([
                dateContainerViewBottomConstraint!,
                lineConstraintHeight!,
                stackViewHeightConstraint!,
                stackView2HeightConstraint!,
            ])
            animationViewChange ()
            
        }
        
        
        }
    
    @objc
        private func repeatEndDateButtonTapped() {
            print("반복 종료일 설정 클릭함 ")
            view1.updateViewFrame(newHeight: 200)
        }
    func chooseDayViewDidUpdateFrame(_ newHeight: CGFloat) {
        if newHeight == 0 {
            calSelectionModal()
        }
        if newHeight == 1{
            print("스위치 완료 - 매월 언제 반복할까요?")
            IntervalSelectionModal(1)
        }
        if newHeight == 200{
            // 안쪽 공간을 위해 컨테이너 화면을 늘립니다
            print("화면 변경: 컨테이터 화면 늘림")
            changeContainer(-22 ,1)
        }
        if newHeight == 201 {
            // 안쪽 공간 컨테이너 위치 초기솨
            print("화면 변경 : 컨테이너 위치 초기화")
            changeContainer(-60,1)
        }
    }
    
    func calSelectionModal(){
        print("종료 날짜 선택 모달")
        let calModalVC = CalendartModalViewController()
        calModalVC.changeTitle(title: " 종료날짜를 선택해주세요")
        calModalVC.delegate = self
        present(calModalVC, animated: true)
        animationViewChange ()
    }
    
    func IntervalSelectionModal(_ num : Int ){
        print("반복 모달")
       
        if num == 1{
            IntervalSelectionModalVC.changeTitle(title: "몇 주 간격으로 반복할까요?")
        }
        if num == 2{
            IntervalSelectionModalVC.changeTitle(title: "매월 언제 반복할까요?")

            IntervalSelectionModalVC.intervals = ["매월 \(dateString)에 반복","매월 첫째 날에 반복", "매월 마지막 날에 반복"]
            IntervalSelectionModalVC.return2 = ["\(dateString)", "첫째 날", "마지막 날"]
            IntervalSelectionModalVC.type = num
        }

        IntervalSelectionModalVC.delegate = self
        present(IntervalSelectionModalVC, animated: true)
        animationViewChange ()
    }
    
    func changeContainer( _ constant : CGFloat, _ num : Int){
        print("화면 변경 : 반복 화면 초기화")

        NSLayoutConstraint.deactivate([
            containerViewBottomConstraint!
        ])
        
        if num == 1{
            containerViewBottomConstraint = containerView.bottomAnchor.constraint(equalTo: cancelNcomplte.topAnchor, constant: constant )
        }
        if num == 2 {
            containerViewBottomConstraint = containerView.bottomAnchor.constraint(equalTo: cancelNcomplte.topAnchor, constant: constant )
        }
        
        NSLayoutConstraint.activate([
            containerViewBottomConstraint!
        ])
        animationViewChange ()
    }
    func animationViewChange (){
        UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
    }

    
}




