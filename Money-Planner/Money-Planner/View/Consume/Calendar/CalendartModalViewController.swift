//
//  CalendarModalViewController.swift
//  Money-Planner
//
//  Created by p_kxn_g on 1/26/24.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol CalendarSelectionDelegate : AnyObject{
    func didSelectCalendarDate(_ date : String,  api : String)
}
class CalendartModalViewController : UIViewController{
    weak var delegate: CalendarSelectionDelegate?
    
    var OverviewExpenseDates : [OverViewExpenseResponse.ZeroDayInfo] = []
    var disableExpenseDates : [String] = []
    var zeroDayList : [Bool] = []

    let disposeBag = DisposeBag()
    let viewModel = MufflerViewModel()
    var checkedDate : String = ""
    var checkedMonth : String = ""
    let currentDate = Date()
    let dateFormatter = DateFormatter()
    lazy var todayMonth: String = {
        dateFormatter.dateFormat = "yyyy-MM"
        return dateFormatter.string(from: currentDate)
    }()
    lazy var todayDate: String = {
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: currentDate)
    }()
    
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
        label.textColor = .mpBlack
        return label
    }()
    let errorLabel : UILabel = {
        let label = UILabel()
        label.text = "목표가 존재하지 않는 날입니다."
        label.textColor = .clear
        label.textAlignment = .center
        label.font = UIFont.mpFont14M()
        return label
    }()
    let containerView = UIView()

    let datePicker :UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.locale = Locale(identifier: "ko_KR")
        datePicker.preferredDatePickerStyle = .inline
        datePicker.datePickerMode = .date
        datePicker.tintColor = .mpMainColor

        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }()
   // let datePicker = UIPickerView()
    let completeButton = MainBottomBtn(title: "완료")
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
    
    func setupBindings() {
        viewModel.expenseOverviewObservable
            .subscribe(onNext: { [weak self] response in
                guard let self = self, let response = response else { return }
                self.OverviewExpenseDates = response.result.overview ?? []
                // 필요한 UI 업데이트 로직 호출, 예를 들어 tableView.reloadData()
                print(self.OverviewExpenseDates)
                updateError()
            })
            .disposed(by: disposeBag)
    }
    init() {
        super.init(nibName: nil, bundle: nil)
        setupBindings()
    }
   
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // 오늘이 속한 월 구해서 api 연결
        
        checkedDate = todayDate
        checkedMonth = todayMonth
        
        // 데이터 요청
        viewModel.fetchAvailableExpenseDates(yearMonth: checkedMonth)
        
        // UI
        presentCustomModal()
        setuptitleLabel()
        setupCalendarCellContainerView()
        setupCompleteButton()
        
        // 액션
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)

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
        customModal.addSubview(errorLabel)

        modalBar.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            modalBar.widthAnchor.constraint(equalToConstant: 49),
            modalBar.heightAnchor.constraint(equalToConstant: 4),
            modalBar.topAnchor.constraint(equalTo: customModal.topAnchor, constant: 12),
            modalBar.centerXAnchor.constraint(equalTo: customModal.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: modalBar.bottomAnchor, constant: 28),
            titleLabel.heightAnchor.constraint(equalToConstant: 28),

            titleLabel.centerXAnchor.constraint(equalTo: customModal.centerXAnchor),
            errorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            errorLabel.centerXAnchor.constraint(equalTo: customModal.centerXAnchor),
            errorLabel.heightAnchor.constraint(equalToConstant: 23),
            ])
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        customModal.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: customModal.leadingAnchor, constant: 9),
            containerView.trailingAnchor.constraint(equalTo: customModal.trailingAnchor, constant: -9),
            containerView.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 5),
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
    
    // UIDatePicker의 값이 변경될 때 호출될 메서드
   @objc func datePickerValueChanged(_ sender: UIDatePicker) {
       // 선택된 날짜를 출력하거나 처리
       let dateFormatter = DateFormatter()
       dateFormatter.dateFormat = "yyyy-MM-dd"
       let selectedDate = dateFormatter.string(from: sender.date)
       checkedDate = selectedDate
       print("선택된 날짜: \(selectedDate)")
       
       updateError()
       //선택된 달이 바뀌는 경우 - 다시 데이터 받기
       dateFormatter.dateFormat = "yyyy-MM"
       let selectedMonth = dateFormatter.string(from: sender.date)
       
       // 새로운 달로 넘어간 경우
       if checkedMonth != selectedMonth {
           print(selectedMonth)
           checkedMonth = selectedMonth
           viewModel.fetchAvailableExpenseDates(yearMonth: selectedMonth)
       }
   }
    private func updateError(){
        print(checkedDate)
        if let currentDateInfo = OverviewExpenseDates.first(where: { $0.date == checkedDate }) {
            removeError()
            print(currentDateInfo)
            print("소비 가능 날짜에 포함되어 있음")
            if currentDateInfo.zeroDay {
                // 제로데이인 경우 알람 띄우기
                // 취소 버튼 비활성화
                completeButton.isEnabled = false
                presentZeroDayModal()
            }
            else{
                completeButton.isEnabled = true
            }
            
        }else{
            addError()
            completeButton.isEnabled = false
        }
    }
    
    @objc private func completeButtonTapped() {
        print("완료 버튼이 탭되었습니다.")
        // 화면 보여주기 용
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
 
    
    private func removeError(){
        errorLabel.textColor = .clear
    }
    private func addError(){
        errorLabel.textColor = .mpRed
    }
    
    private func presentZeroDayModal() {
            let rateContent = "rateInfo"
            let customModalVC = ExpenseZeroDayView()
            customModalVC.modalPresentationStyle = .overFullScreen
            customModalVC.modalTransitionStyle = .crossDissolve
            present(customModalVC, animated: true, completion: nil)
            customModalVC.controlButtons.cancelButton.addTarget(self, action: #selector(dismissCustomModal), for: .touchUpInside)
            customModalVC.controlButtons.completeButton.addTarget(self, action: #selector(cancelZero), for: .touchUpInside)

        }
    @objc private func dismissCustomModal() {
             // 모달 닫기
            print("모달닫기")
             dismiss(animated: true, completion: nil)
         }
        
    @objc private func cancelZero() {
        print("제로데이 해제하기")
        checkZeroDay()
        dismiss(animated: true, completion: nil)
     }
    

    
    func checkZeroDay() {
        ExpenseRepository.shared.isZeroDay(dailyPlanDate: checkedDate) { result in
            switch result {
            case .success(let updatedInfo):
                NotificationCenter.default.post(name: Notification.Name("changeCalendar"), object: nil)
                print("zero updated successfully: \(String(describing: updatedInfo))")
            case .failure(let error):
                print("Failed to update zero info: \(error)")
            }
        }
    }
    
    
    
}


