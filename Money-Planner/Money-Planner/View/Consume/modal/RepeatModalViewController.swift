//
//  RepeatModalViewController.swift
//  Money-Planner
//
//  Created by p_kxn_g on 1/27/24.
//

import Foundation
import UIKit
protocol RepeatModalViewDelegate : AnyObject{
    func GetResultofInterval(_ result : String, api : ExpenseCreateRequest.RoutineRequest?)
}


class RepeatModalViewController : UIViewController {

    weak var delegate: RepeatModalViewDelegate?
    // 데이터 연결
    var routineRequest : ExpenseCreateRequest.RoutineRequest?
    var currEndDate : String?
    var endDay : UIStackView?
    // 높이 제약 조건
    var heightConstraint : NSLayoutConstraint?
    var checkedIndex : Int?
    // 날짜
    let currentDate = Date()
    let dateFormatter = DateFormatter()
    lazy var dateString: String = {
         dateFormatter.dateFormat = "dd일"
         return dateFormatter.string(from: currentDate)
     }()
    
    // 모달의 메인 컨테이너 뷰
    private let customModal: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 40
        view.backgroundColor = .mpWhite
        view.layer.cornerRadius = 25
        view.layer.masksToBounds = true
        return view
    }()
    
    
    let headerView = UIView()
    let titleLabel = UILabel()
    
    // 제목 위에 작은 바
    let modalBar : UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.backgroundColor = .mpLightGray
        return view
    }()

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
    let contentsContainer : UIStackView = {
        let s = UIStackView()
        s.axis = .vertical
        s.spacing = 24
        s.distribution = .fill
        return s
    }()

    let dayContainerView = UIView() // 요일 선택 + 체크 버튼
    let dateContainerView = UIView() // 날짜 선택 + 체크 버튼
    let line = UIView() // 요일 선택과 날짜 선택 구분선
    let chooseDayButton  = CheckBtn() // 요일 선택 체크 버튼
    let chooseDateButton = CheckBtn() // 날짜 선택 체크 버튼
    let view1 = ChooseDayView() // 요일 선택 시 나오는 화면
    let view2 = ChooseDateView() // 날짜 선택 시 나오는 화면
    let cancelNcomplte = SmallBtnView() // 취소 & 완료
    
    var checkedDate : String = ""
    // 이니셜라이저를 정의하여 expenseId를 전달 받을 수 있도록 합니다.
    
    init(currCal : String) {
        print(currCal)
        checkedDate = currCal
        super.init(nibName: nil, bundle: nil)
     
    }
   
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        presentCustomModal() // 배경설정
        setuptitleLabel()
        setupContentsContainer()
        setupCancelNComplete()
        setupRepeatView()
        // 요일 선택
        view1.delegate = self
        // 날짜 선택
        view2.delegate = self
        
        if (routineRequest != nil) {
            // 이미 반복 날짜를 선택한 경우
            print("데이터 반영한 반복 모달")
            print(routineRequest as Any)
            print(routineRequest!.type)
            if routineRequest?.type == .weekly {
                print("log")
                chooseDayButton.isChecked = true // 요일 선택 버튼 체크 활성화
                showChooseDayModal()
                let days = routineRequest?.weeklyRepeatDays
                let weeklyTerm = routineRequest?.weeklyTerm
                view1.weekIntervalButton.setTitle(weeklyTerm, for: .normal)
                
                if (routineRequest?.endDate != nil){
                    // 반복 종료일이 있는 경우
                    print("log2")
                    view1.RepeatEndDateButton.isChecked = true // 반복 종요일 설정 체크 활성화
                    addEndDate( view1.repeatEndDate2)
                }
            }
            if routineRequest?.type == .monthly{
                print("log")
                chooseDateButton.isChecked = true // 요일 선택 버튼 체크 활성화
                showChooseDateModal()
                let monthlyRepeatType = routineRequest?.monthlyRepeatType
//              view2.weekIntervalButton.setTitle(monthlyRepeatDay, for: .normal)
                
                if (routineRequest?.endDate != nil){
                    // 반복 종료일이 있는 경우
                    print("log2")
                    view2.RepeatEndDateButton.isChecked = true // 반복 종요일 설정 체크 활성화
                    addEndDateDirectly( view2.repeatEndDate2 )
                }
            }
        }

    }
    // 반복종료일 추가
    func addEndDateDirectly (_ view : UIStackView) {
        //view.backgroundColor = .green
        updateHeightConstraint(forView: contentsContainer, height: 260)
        updateHeightConstraint(forView: customModal, height: 502)
        // 요일 선택 시 나오는 화면 추가
        if let index = indexOfView(view2) {
            contentsContainer.insertArrangedSubview(view, at: index+1)
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view2.calChooseButton.heightAnchor.constraint(equalToConstant: 38),
            view2.calChooseButton.widthAnchor.constraint(equalToConstant: 137),
            view2.RepeatEndDate2Label.heightAnchor.constraint(equalToConstant: 38)
        ])
        view2.calChooseButton.addTarget(self, action: #selector(showCalModal), for: .touchUpInside)
        endDay = view
        view.addArrangedSubview(view2.blank)
        view.addArrangedSubview(view2.calChooseButton)
        view.addArrangedSubview(view2.RepeatEndDate2Label)
    }
    
    func presentCustomModal() {
        view.addSubview(customModal)
        customModal.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
                customModal.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
                customModal.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                customModal.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                
                // 필요하다면 customModal의 높이에 대한 제약 조건도 추가
            ])
        // UIStackView에 높이 제약조건 추가
        heightConstraint = customModal.heightAnchor.constraint(equalToConstant: 355)
        heightConstraint!.isActive = true // 이를 활성화합니다.
        

   
    }
    private func setuptitleLabel() {
        // 스타일
        UIHelper.configureLabel(titleLabel, text: "언제 반복할까요?", font: UIFont.mpFont20B(), textColor: .mpBlack, textAlignment: .center)
        let titleContainerView = UIView()
        titleContainerView.addSubview(modalBar)
        titleContainerView.addSubview(titleLabel)
        
        modalBar.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            modalBar.widthAnchor.constraint(equalToConstant: 49),
            modalBar.heightAnchor.constraint(equalToConstant: 4),
            modalBar.topAnchor.constraint(equalTo: titleContainerView.topAnchor, constant: 12),
            modalBar.centerXAnchor.constraint(equalTo: titleContainerView.centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 28),
            titleLabel.topAnchor.constraint(equalTo: modalBar.bottomAnchor, constant: 40),
            titleLabel.centerXAnchor.constraint(equalTo: titleContainerView.centerXAnchor),
            titleContainerView.heightAnchor.constraint(equalToConstant: 72)
        ])
        
        customModal.addArrangedSubview(titleContainerView)
        
    }
    private func setupContentsContainer(){
        customModal.addArrangedSubview(contentsContainer)
    }
    private func setupRepeatView() {
        updateHeightConstraint(forView: contentsContainer, height: 107)
        contentsContainer.addArrangedSubview(dayContainerView)
        contentsContainer.addArrangedSubview(line)
        contentsContainer.addArrangedSubview(dateContainerView)
        line.backgroundColor = .mpLightGray
        
        dayContainerView.translatesAutoresizingMaskIntoConstraints = false
        line.translatesAutoresizingMaskIntoConstraints = false
        dateContainerView.translatesAutoresizingMaskIntoConstraints = false

  
        NSLayoutConstraint.activate([
            
            // 변경되는 컨텐츠를 담는 뷰
            contentsContainer.leadingAnchor.constraint(equalTo: customModal.leadingAnchor,constant: 24),
            contentsContainer.trailingAnchor.constraint(equalTo: customModal.trailingAnchor,constant: -24),
            
            // 요일 선택 컨테이너 박스
            dayContainerView.leadingAnchor.constraint(equalTo: contentsContainer.leadingAnchor),
            dayContainerView.trailingAnchor.constraint(equalTo: contentsContainer.trailingAnchor),
            dayContainerView.heightAnchor.constraint(equalToConstant: 28),
            // 구분선
            line.heightAnchor.constraint(equalToConstant: 1),
            line.leadingAnchor.constraint(equalTo: contentsContainer.leadingAnchor),
            line.trailingAnchor.constraint(equalTo: contentsContainer.trailingAnchor),
            
            // 날짜 선택 컨테이너 박스
            dateContainerView.heightAnchor.constraint(equalToConstant: 28),
            dateContainerView.leadingAnchor.constraint(equalTo: contentsContainer.leadingAnchor),
            dateContainerView.trailingAnchor.constraint(equalTo: contentsContainer.trailingAnchor),

        ])
        dayContainerView.addSubview(chooseDayButton)
        dayContainerView.addSubview(chooseDay)
        dateContainerView.addSubview(chooseDateButton)
        dateContainerView.addSubview(chooseDate)
        
        chooseDay.translatesAutoresizingMaskIntoConstraints = false
        chooseDate.translatesAutoresizingMaskIntoConstraints = false
        chooseDayButton.translatesAutoresizingMaskIntoConstraints = false
        chooseDateButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // 요일 선택 - 체크 버튼
            chooseDayButton.widthAnchor.constraint(equalToConstant:28),
            chooseDayButton.heightAnchor.constraint(equalToConstant: 28),
            chooseDayButton.trailingAnchor.constraint(equalTo: dayContainerView.trailingAnchor),
            chooseDayButton.centerYAnchor.constraint(equalTo: dayContainerView.centerYAnchor),
            // 날짜 선택 - 체크 버튼
            chooseDateButton.widthAnchor.constraint(equalToConstant:28),
            chooseDateButton.heightAnchor.constraint(equalToConstant: 28),
            chooseDateButton.trailingAnchor.constraint(equalTo: dateContainerView.trailingAnchor),
            chooseDateButton.centerYAnchor.constraint(equalTo: dateContainerView.centerYAnchor),
            // 요일 선택 라벨
            chooseDay.leadingAnchor.constraint(equalTo: dayContainerView.leadingAnchor),
            chooseDay.centerYAnchor.constraint(equalTo: dayContainerView.centerYAnchor),
            chooseDay.topAnchor.constraint(equalTo: dayContainerView.topAnchor),
            chooseDay.bottomAnchor.constraint(equalTo: dayContainerView.bottomAnchor),
            // 날짜 선택 라벨
            chooseDate.leadingAnchor.constraint(equalTo: dateContainerView.leadingAnchor),
            chooseDate.centerYAnchor.constraint(equalTo: dateContainerView.centerYAnchor),
            chooseDate.topAnchor.constraint(equalTo: dateContainerView.topAnchor),
            chooseDate.bottomAnchor.constraint(equalTo: dateContainerView.bottomAnchor),
        ])
        // 체크버튼 초기화 - 비활성화
        chooseDayButton.setChecked(false)
        chooseDateButton.setChecked(false)
        
        // 체크버튼 - 타겟 추가
        chooseDayButton.addTarget(self, action: #selector(showChooseDayModal), for: .touchUpInside)
        chooseDateButton.addTarget(self, action: #selector(showChooseDateModal), for: .touchUpInside)
    }
    
    private func setupCancelNComplete(){
        let completeContainer = UIView()
        completeContainer.translatesAutoresizingMaskIntoConstraints = false
        completeContainer.addSubview(cancelNcomplte)
        
        cancelNcomplte.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cancelNcomplte.bottomAnchor.constraint(equalTo: completeContainer.bottomAnchor,constant: -20),
            cancelNcomplte.heightAnchor.constraint(equalToConstant: 56),
            cancelNcomplte.leadingAnchor.constraint(equalTo: completeContainer.leadingAnchor, constant: 20),
            cancelNcomplte.trailingAnchor.constraint(equalTo: completeContainer.trailingAnchor, constant: -20),
        ])
        // 버튼 액션 추가
        cancelNcomplte.addCancelAction(target: self, action: #selector(cancelButtonTapped))
        cancelNcomplte.addCompleteAction(target: self, action: #selector(completeButtonTapped))
        
        // 컨테이너 화면에 추가
        customModal.addArrangedSubview(completeContainer)
    }
    
    
    @objc
    private func showChooseDayModal() {
        if chooseDayButton.isChecked {
            if chooseDateButton.isChecked{
                // 날짜 선택이 이미 선택된 경우
                
                // 날짜 선택 시 나온 화면 삭제 - view2, endDay
                contentsContainer.removeArrangedSubview(view2)
                if (endDay != nil){
                    contentsContainer.removeArrangedSubview(endDay!)
                }
                
                view2.removeFromSuperview()
                endDay?.removeFromSuperview()
                updateViewHeightConstraint(forView: view1, height: 116)
                view1.RepeatEndDateButton.isChecked = false
            }
            print("요일 선택")
            // 날짜 버튼 선택 취소
            chooseDateButton.isChecked = false
            
            // 요일/날짜 선택 텍스트 색상 변경
            chooseDay.textColor = .mpMainColor
            chooseDate.textColor = .mpBlack
            
            // 가변높이 설정
            updateHeightConstraint(forView: customModal, height: 500)
            updateHeightConstraint(forView: contentsContainer, height: 255)
            updateViewHeightConstraint(forView: view1, height: 132)
            
            // 요일 선택 시 나오는 화면 추가
            if let index = indexOfView(dayContainerView) {
                contentsContainer.insertArrangedSubview(view1, at: index+1)
            }
            view1.weekIntervalButton.addTarget(self, action: #selector(showIntervalModal), for: .touchUpInside)
            setupView1()
            // 애니메이션 0.3초
            UIView.animate(withDuration: 0.3) {
                    self.contentsContainer.layoutIfNeeded()
                }
            
        }
        else{
            // 가변높이 설정
            updateHeightConstraint(forView: contentsContainer, height: 105)
            updateHeightConstraint(forView: customModal, height: 355)
            
            // 요일 버튼 선택 취소
            chooseDayButton.isChecked = false
            
            // 요일 선택 라벨 색상 변경 -> 검정색
            chooseDay.textColor = .mpBlack
            
            // 요일 선택 시 나온 화면 삭제
            contentsContainer.removeArrangedSubview(view1)
            view1.removeFromSuperview()
            if (endDay != nil){
                contentsContainer.removeArrangedSubview(endDay!)
            }
            endDay?.removeFromSuperview()
            //애니메이션 0.3초
            UIView.animate(withDuration: 0.3) {
                    self.view.layoutIfNeeded()
            }
        }
    }
    // 레이아웃 - 요일 선택 시 나오는 화면
    private func setupView1(){
        view1.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            // 요일 선택 시 나오는 화면
            view1.leadingAnchor.constraint(equalTo: contentsContainer.leadingAnchor),
            view1.trailingAnchor.constraint(equalTo: contentsContainer.trailingAnchor),
    
        ])
        
    }
   
    
    
    @objc
    private func showChooseDateModal() {
        if chooseDateButton.isChecked {
            if chooseDayButton.isChecked{
                // 요일 선택이 이미 선택된 경우
                
                // 요일 선택 시 나온 화면 삭제 - view1, endDay
                contentsContainer.removeArrangedSubview(view1)
                if (endDay != nil){
                    contentsContainer.removeArrangedSubview(endDay!)
                }
                
                view1.removeFromSuperview()
                endDay?.removeFromSuperview()
                view2.RepeatEndDateButton.isChecked = false
            }
            print("날짜 선택")
            // 날짜 버튼 선택 취소
            chooseDayButton.isChecked = false
            
            // 요일/날짜 선택 텍스트 색상 변경
            chooseDate.textColor = .mpMainColor
            chooseDay.textColor = .mpBlack
            
            // 가변높이 설정
            updateHeightConstraint(forView: customModal, height: 448)
            updateHeightConstraint(forView: contentsContainer, height: 200)

            // 요일 선택 시 나오는 화면 추가
            if let index = indexOfView(dateContainerView) {
                contentsContainer.insertArrangedSubview(view2, at: index+1)
            }
            view2.weekIntervalButton.addTarget(self, action: #selector(showIntervalModal), for: .touchUpInside)
            setupView2()
            
            // 애니메이션 0.3초
            UIView.animate(withDuration: 0.3) {
                    self.contentsContainer.layoutIfNeeded()
                }
            
        }
        else{
            // 가변높이 설정
            updateHeightConstraint(forView: contentsContainer, height: 105)
            updateHeightConstraint(forView: customModal, height: 355)
            
            // 요일 버튼 선택 취소
            chooseDateButton.isChecked = false
            
            // 요일 선택 라벨 색상 변경 -> 검정색
            chooseDate.textColor = .mpBlack
            
            // 요일 선택 시 나온 화면 삭제
            contentsContainer.removeArrangedSubview(view2)
            view2.removeFromSuperview()
            if (endDay != nil){
                contentsContainer.removeArrangedSubview(endDay!)
            }
            endDay?.removeFromSuperview()
            //애니메이션 0.3초
            UIView.animate(withDuration: 0.3) {
                    self.view.layoutIfNeeded()
            }
        }
    }
    
    // 레이아웃 - 날짜 선택 시 나오는 화면
    private func setupView2(){
        view1.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            // 날짜 선택 시 나오는 화면
            view2.leadingAnchor.constraint(equalTo: contentsContainer.leadingAnchor),
            view2.trailingAnchor.constraint(equalTo: contentsContainer.trailingAnchor),
        ])
        
    }
    
    // 간격 선택 모달 - 간격 버튼 탭 시 호출되는 메서드
    @objc private func showIntervalModal() {
        let IntervalSelectionVC = RepeatIntervalViewController()
        IntervalSelectionVC.delegate = self
        if chooseDayButton.isChecked{
            IntervalSelectionVC.changeTitle(title: "몇 주 간격으로 반복할까요?")
        }
        if chooseDateButton.isChecked{
            IntervalSelectionVC.changeTitle(title: "매월 언제 반복할까요?")
            IntervalSelectionVC.intervals = ["매월 \(checkedDate)에 반복","매월 첫째 날에 반복", "매월 마지막 날에 반복"]
        }
        present(IntervalSelectionVC, animated: true)
        print("간격 모달 뷰로 스위치")
    }
    
    // 날짜 선택 모달 보여주기
    @objc func showCalModal(_ sender: UIDatePicker) {
        print("날짜 선택")
        let calVC = CalendartModalViewController()
        calVC.titleLabel.text = "종료 날짜를 선택해주세요"
        calVC.delegate = self
        present(calVC, animated: true)
    }
    
    // 취소 버튼 액션 처리
    @objc private func cancelButtonTapped() {
        print("취소 버튼이 탭되었습니다.")
        // 취소 버튼 액션 처리
        dismiss(animated: true, completion: nil)
    }
    
    // 완료 버튼 액션 처리
    @objc private func completeButtonTapped() {
        let lst = [view1.button1, view1.button2,view1.button3, view1.button4,view1.button5, view1.button6,view1.button7]
        let days = ["월","화","수","목","금","토","일"]
        let apiDays = [ "MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY", "SUNDAY" ]
        var apiWeeklyRepeatDays : [String]? = []
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
                
                // api
                let index = lst.firstIndex(of: item)!
                apiWeeklyRepeatDays?.append(apiDays[index])
            }
        }
        print(apiWeeklyRepeatDays as Any)
        print(view1.weekIntervalButton.titleLabel?.text ?? "")
        print(returnLst)
        print("완료 버튼이 탭되었습니다.")
        if returnInterval == "1주마다 "{ returnInterval = "매주 "}
        returnValue = returnInterval + returnLst
        // 완료 버튼 액션 처리
        
        // 화면에 띄워줄 텍스트
        var resultButtonString : String = ""

        // api 용
        // 반복종료일
        var endDate : String?
        // 요일 선택 - 주 반복 날짜
        var weeklyRepeatDays : [String]?
        // 요일 선택 - 주 반복 간격
        var weeklyTerm : String?
        // 날짜 선택 - 매월 반복되는 날짜
        var monthlyRepeatType : ExpenseCreateRequest.monthlyRepeatType?
        
        var routineType : ExpenseCreateRequest.RoutineType?
        // 초기화 - 요일 선택
        if chooseDayButton.isChecked {
            // 요일 선택을 한 경우
            
            // 화면에 띄워줄 텍스트
            resultButtonString = returnValue
            // api
            // 반복 종료일 체크하면
            routineType = .weekly
            if view1.RepeatEndDateButton.isChecked {
                endDate = currEndDate
            }
            else{
                endDate = ""
            }
            // 요일 반복 - 월,화,수,목,금,토
            weeklyRepeatDays = apiWeeklyRepeatDays
            weeklyTerm = view1.weekIntervalButton.title(for: .normal)
            // 날짜 선택 시 나오는 것 nill 처리
            monthlyRepeatType = .first
            
            
        }
        if chooseDateButton.isChecked{
            // 날짜 선택이 눌린 경우

            // 화면에 띄워줄 텍스트
            // 반복할 날짜 (매월 + 첫째날/00일/마지막날)
            if  let weekIntervalText = view2.weekIntervalButton.titleLabel!.text {
                resultButtonString = "매월 \(weekIntervalText) "
            }
            
            // api
            routineType = .monthly
            // 반복 종료일 체크하면
            if view1.RepeatEndDateButton.isChecked {
                endDate = currEndDate
            }
            else{
                endDate = ""
            }

            switch checkedIndex {
            case 0:
                monthlyRepeatType = .specific
            case 1:
                monthlyRepeatType = .first
            case 2:
                monthlyRepeatType = .last
            default: // 아무것도 선택한 게 없으면 소비등록 날짜로
                monthlyRepeatType = .specific
               
            }
            // 요일 선택 시 보내는 것들 데이터 처리
            weeklyRepeatDays = []
            weeklyTerm = ""

        }
        if let routineType = routineType{
            routineRequest  = ExpenseCreateRequest.RoutineRequest(type: routineType, endDate: endDate, weeklyRepeatDays:weeklyRepeatDays, weeklyTerm: weeklyTerm, monthlyRepeatType: monthlyRepeatType)
        }
        
        // 소비등록 화면으로 전달
        delegate?.GetResultofInterval(resultButtonString, api : routineRequest)
      
        dismiss(animated: true, completion: nil)
    }
    
    // 인덱스 찾아내는 함수
    func indexOfView(_ viewToFind: UIView) -> Int? {
        return contentsContainer.arrangedSubviews.firstIndex { subview in
            return subview === viewToFind
        }
    }
    
    // 높이 제약 조건 업데이트 함수 - 스택뷰
    func updateHeightConstraint(forView view: UIStackView, height: CGFloat) {
        // 뷰의 높이 제약 조건을 찾아서 업데이트합니다.
        if let heightConstraint = view.constraints.first(where: { $0.firstAttribute == .height }) {
            heightConstraint.constant = height
        } else {
            // 뷰에 높이 제약 조건이 없다면 새로 생성합니다.
            let heightConstraint = view.heightAnchor.constraint(equalToConstant: height)
            heightConstraint.isActive = true
        }
    }
    
    // 높이 제약 조건 업데이트 함수 - 뷰
    func updateViewHeightConstraint(forView view: UIView, height: CGFloat) {
        // 뷰의 높이 제약 조건을 찾아서 업데이트합니다.
        if let heightConstraint = view.constraints.first(where: { $0.firstAttribute == .height }) {
            heightConstraint.constant = height
        } else {
            // 뷰에 높이 제약 조건이 없다면 새로 생성합니다.
            let heightConstraint = view.heightAnchor.constraint(equalToConstant: height)
            heightConstraint.isActive = true
        }
    }
}




// MARK: - 요일 선택 - ChooseDayViewDelegate

extension RepeatModalViewController : ChooseDayViewDelegate {
    
    // 반복 요일 선택
    func chooseIntervalDay(_ view: UIViewController) {
        present(view, animated: true)

    }
    // 반복종료일 추가
    func addEndDay(_ view : UIStackView) {
        updateHeightConstraint(forView: customModal, height: 554)
        updateHeightConstraint(forView: contentsContainer, height: 310)
        // 요일 선택 시 나오는 화면 추가
        if let index = indexOfView(view1) {
            contentsContainer.insertArrangedSubview(view, at: index+1)
        }
        endDay = view
        view.addArrangedSubview(view1.blank)
        view.addArrangedSubview(view1.calChooseButton)
        view.addArrangedSubview(view1.RepeatEndDate2Label)
        view1.calChooseButton.addTarget(self, action: #selector(showCalModal), for: .touchUpInside)
    }
    // 반복종료일 삭제
    func removeEndDay() {
        updateHeightConstraint(forView: customModal, height: 499)
        updateHeightConstraint(forView: contentsContainer, height: 252)
        if (endDay != nil){
            contentsContainer.removeArrangedSubview(endDay!)
        }
        endDay?.removeFromSuperview()
        
    }
}

// MARK: - 날짜 선택  - ChooseDateViewDelegate

extension RepeatModalViewController : ChooseDateViewDelegate{
    
    // 반복 날짜 선택
    func chooseIntervalDate(_ view: UIViewController) {
        present(view, animated: true)
    }
    // 반복종료일 추가
    func addEndDate(_ view : UIStackView) {
        //view.backgroundColor = .green
        updateHeightConstraint(forView: contentsContainer, height: 260)
        updateHeightConstraint(forView: customModal, height: 502)
        // 요일 선택 시 나오는 화면 추가
        if let index = indexOfView(view2) {
            contentsContainer.insertArrangedSubview(view, at: index+1)
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view2.calChooseButton.heightAnchor.constraint(equalToConstant: 38),
            view2.calChooseButton.widthAnchor.constraint(equalToConstant: 137),
            view2.RepeatEndDate2Label.heightAnchor.constraint(equalToConstant: 38)
        ])
        view2.calChooseButton.addTarget(self, action: #selector(showCalModal), for: .touchUpInside)
        endDay = view
        view.addArrangedSubview(view2.blank)
        view.addArrangedSubview(view2.calChooseButton)
        view.addArrangedSubview(view2.RepeatEndDate2Label)
    }

    // 반복종료일 삭제
    func removeEndDate() {
        
        if (endDay != nil){
            contentsContainer.removeArrangedSubview(endDay!)
        }
        endDay?.removeFromSuperview()
        updateHeightConstraint(forView: contentsContainer, height: 200)
        updateHeightConstraint(forView: customModal, height: 448)
    }
}
// MARK: - 반복 날짜/요일 선택
extension RepeatModalViewController : RepeatIntervalDelegate {
    func didIntervalSelected(_ index : Int){
        checkedIndex = index
        UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        print(" 간격 반복을 선택하였습니다 ")
        // 요일 선택인 경유
        if chooseDayButton.isChecked {
            print("log : 요일 선택을 감지함")
            view1.weekIntervalButton.setTitle("\(index+1)", for: .normal)
        }
        // 날짜 선택인 경우
        if chooseDateButton.isChecked{
            let dateString: String = {
                dateFormatter.dateFormat = "dd일"
                return dateFormatter.string(from: currentDate)}()
            let intervalList = ["\(dateString)","첫째 날", "마지막 날"]
            print(intervalList[index])
            view2.weekIntervalButton.setTitle(intervalList[index], for: .normal)
            //view2.weekIBtnConstraint?.constant = 110
        }

    }
}
// MARK: - 반복종료일 선택
extension RepeatModalViewController : CalendarSelectionDelegate {
    func didSelectCalendarDate(_ date: String, api : String) {
        print("Selected Date in YourPresentingViewController: \(date)")
        view1.calChooseButton.setTitle(date, for: .normal)
        view2.calChooseButton.setTitle(date, for: .normal)
        
        currEndDate = api
    }
}


