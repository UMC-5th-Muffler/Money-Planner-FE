//
//  PeriodSelectionModalViewController.swift
//  Money-Planner
//
//  Created by 유철민 on 1/30/24.
//

import Foundation
import UIKit

// 기간 선택 대리자 프로토콜 정의
protocol PeriodSelectionDelegate: AnyObject {
    func periodSelectionDidSelectDates(startDate: Date, endDate: Date)
}

class StartDateSelectionViewController: UIViewController {
    // 사용자 인터페이스 구성 요소 정의
    let customModal = UIView()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "시작일을 선택해주세요"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "-"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.locale = Locale(identifier: "ko_KR")
        datePicker.preferredDatePickerStyle = .inline
        datePicker.datePickerMode = .date
        datePicker.tintColor = .mpMainColor // 메인 색상 지정
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }()
    let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("완료", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = .mpMainColor
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // viewDidLoad에서 뷰 설정
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        // 기본 네비게이션 바의 뒤로 가기 버튼 숨기기
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = nil
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 네비게이션 바 숨기기
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    

    // StartDateSelectionViewController에서 setupLayout 메소드 구현
    private func setupLayout() {
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        customModal.backgroundColor = .white
        customModal.layer.cornerRadius = 25
        customModal.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(customModal)
        
        // Custom modal 레이아웃
        customModal.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            customModal.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            customModal.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20), // 위치 조정
            customModal.widthAnchor.constraint(equalToConstant: 350), // 너비 조정
            customModal.heightAnchor.constraint(equalToConstant: 550) // 높이 조정
        ])
        
        // Title label 레이아웃
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        customModal.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: customModal.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: customModal.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: customModal.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(subTitleLabel)
        NSLayoutConstraint.activate([
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            subTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        // Date picker 레이아웃
        customModal.addSubview(datePicker)
        NSLayoutConstraint.activate([
            datePicker.centerXAnchor.constraint(equalTo: customModal.centerXAnchor),
            datePicker.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 20),
            datePicker.widthAnchor.constraint(equalTo: customModal.widthAnchor),
            datePicker.heightAnchor.constraint(equalToConstant: 300)
        ])

        // Next button 레이아웃
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        customModal.addSubview(nextButton)
        NSLayoutConstraint.activate([
            nextButton.bottomAnchor.constraint(equalTo: customModal.bottomAnchor, constant: -20),
            nextButton.leadingAnchor.constraint(equalTo: customModal.leadingAnchor, constant: 20),
            nextButton.trailingAnchor.constraint(equalTo: customModal.trailingAnchor, constant: -20),
            nextButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }


    @objc private func nextButtonTapped() {
        // datePicker에서 선택된 날짜를 가져와서 EndDateSelectionViewController로 전달
        let endDateSelectionVC = EndDateSelectionViewController()
        endDateSelectionVC.selectedStartDate = datePicker.date
        navigationController?.pushViewController(endDateSelectionVC, animated: false)
    }
}


class EndDateSelectionViewController: UIViewController {
    
    var selectedStartDate: Date?
    let customModal = UIView()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "종료일을 선택해주세요"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    let subTitleLabel: UILabel = {
        let label = UILabel()
        // 초기 텍스트 설정은 viewDidLoad에서 설정됩니다.
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    let endDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.locale = Locale(identifier: "ko_KR")
        datePicker.preferredDatePickerStyle = .inline
        datePicker.datePickerMode = .date
        datePicker.tintColor = .mpMainColor
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }()
    let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal) // 시스템 아이콘 사용
        button.tintColor = .black
        return button
    }()
    let completeButton: UIButton = {
        let button = UIButton()
        button.setTitle("완료", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = .mpMainColor
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        
        if let startDate = selectedStartDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            subTitleLabel.text = "\(dateFormatter.string(from: startDate)) - "
        }
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
        
        // 기본 네비게이션 바의 뒤로 가기 버튼 숨기기
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 네비게이션 바 숨기기
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    

    private func setupLayout() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        customModal.backgroundColor = .white
        customModal.layer.cornerRadius = 25
        customModal.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(customModal)

        customModal.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            customModal.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            customModal.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20), // 위치 조정
            customModal.widthAnchor.constraint(equalToConstant: 350), // 너비 조정
            customModal.heightAnchor.constraint(equalToConstant: 550) // 높이 조정
        ])
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        customModal.addSubview(backButton)
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: customModal.topAnchor, constant: 10),
            backButton.leadingAnchor.constraint(equalTo: customModal.leadingAnchor, constant: 10),
            backButton.widthAnchor.constraint(equalToConstant: 40),
            backButton.heightAnchor.constraint(equalToConstant: 40)
        ])

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        customModal.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: customModal.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: customModal.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: customModal.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(subTitleLabel)
        NSLayoutConstraint.activate([
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            subTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        customModal.addSubview(endDatePicker)
        NSLayoutConstraint.activate([
            endDatePicker.centerXAnchor.constraint(equalTo: customModal.centerXAnchor),
            endDatePicker.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 20),
            endDatePicker.widthAnchor.constraint(equalTo: customModal.widthAnchor),
            endDatePicker.heightAnchor.constraint(equalToConstant: 300)
        ])

        completeButton.translatesAutoresizingMaskIntoConstraints = false
        customModal.addSubview(completeButton)
        NSLayoutConstraint.activate([
            completeButton.bottomAnchor.constraint(equalTo: customModal.bottomAnchor, constant: -20),
            completeButton.leadingAnchor.constraint(equalTo: customModal.leadingAnchor, constant: 20),
            completeButton.trailingAnchor.constraint(equalTo: customModal.trailingAnchor, constant: -20),
            completeButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func backButtonTapped() {
        // 뒤로 가기 로직 구현
        navigationController?.popViewController(animated: false)
    }

    @objc func completeButtonTapped() {
        // 종료일 선택 완료 로직
        print("종료일 선택")
        let periodConfirmationVC = PeriodConfirmationViewController()
        periodConfirmationVC.selectedStartDate = selectedStartDate
        periodConfirmationVC.selectedEndDate = endDatePicker.date
        //delegate 설정 있었는데 뺐음.
        print("완료")
        navigationController?.pushViewController(periodConfirmationVC, animated: false)
    }
    
}



class PeriodConfirmationViewController: UIViewController {
    
    weak var delegate: PeriodSelectionDelegate?
    
    var selectedStartDate: Date?
    var selectedEndDate: Date?
    
    let customModal = UIView()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "선택한 기간 확인"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    let subTitleLabel: UILabel = {
        let label = UILabel()
        // 초기 텍스트 설정은 viewDidLoad에서 설정됩니다.
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal) // 시스템 아이콘 사용
        button.tintColor = .black
        return button
    }()
    let completeButton: UIButton = {
        let button = UIButton()
        button.setTitle("완료", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.blue
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        return button
    }()
    // 이 예제에서는 달력 뷰를 직접 구현하지 않습니다.
    // 대신, 선택된 기간을 표시하는 데모 방식으로 UILabel을 사용합니다.
    let periodLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0 // 여러 줄 표시 가능
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        displaySelectedPeriod()
        
        
        if let start = selectedStartDate, let end = selectedEndDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            subTitleLabel.text = "\(dateFormatter.string(from: start)) - \(dateFormatter.string(from: end))"
        }
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        completeButton.addTarget(self, action: #selector(didTapCompleteButton), for: .touchUpInside)
        // 기본 네비게이션 바의 뒤로 가기 버튼 숨기기
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = nil
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 네비게이션 바 숨기기
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    

    private func setupLayout() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        customModal.backgroundColor = .white
        customModal.layer.cornerRadius = 25
        view.addSubview(customModal)
        
        // Custom Modal Constraints
        customModal.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            customModal.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            customModal.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20), // 위치 조정
            customModal.widthAnchor.constraint(equalToConstant: 350), // 너비 조정
            customModal.heightAnchor.constraint(equalToConstant: 550) // 높이 조정
        ])
        
        // backButton Layout
        backButton.translatesAutoresizingMaskIntoConstraints = false
        customModal.addSubview(backButton)
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: customModal.topAnchor, constant: 10),
            backButton.leadingAnchor.constraint(equalTo: customModal.leadingAnchor, constant: 10),
            backButton.widthAnchor.constraint(equalToConstant: 40),
            backButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // titleLabel Layout
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        customModal.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 10), // Adjusted to be below the backButton
            titleLabel.leadingAnchor.constraint(equalTo: customModal.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: customModal.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(subTitleLabel)
        NSLayoutConstraint.activate([
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            subTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        // periodLabel Layout
        periodLabel.translatesAutoresizingMaskIntoConstraints = false
        customModal.addSubview(periodLabel)
        NSLayoutConstraint.activate([
            periodLabel.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 20),
            periodLabel.leadingAnchor.constraint(equalTo: customModal.leadingAnchor, constant: 20),
            periodLabel.trailingAnchor.constraint(equalTo: customModal.trailingAnchor, constant: -20)
        ])
        
        // completeButton Layout
        completeButton.translatesAutoresizingMaskIntoConstraints = false
        customModal.addSubview(completeButton)
        NSLayoutConstraint.activate([
            completeButton.bottomAnchor.constraint(equalTo: customModal.bottomAnchor, constant: -20),
            completeButton.leadingAnchor.constraint(equalTo: customModal.leadingAnchor, constant: 20),
            completeButton.trailingAnchor.constraint(equalTo: customModal.trailingAnchor, constant: -20),
            completeButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    
    func displaySelectedPeriod() {
        guard let start = selectedStartDate, let end = selectedEndDate else { return }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        // 선택된 기간을 문자열로 표시
        periodLabel.text = "시작일: \(dateFormatter.string(from: start))\n종료일: \(dateFormatter.string(from: end))"
        
        
    }
    
    @objc func backButtonTapped() {
        // 뒤로 가기 로직 구현
        navigationController?.popViewController(animated: false)
    }
    
    @objc func didTapCompleteButton() {
        if let start = selectedStartDate, let end = selectedEndDate {
            delegate?.periodSelectionDidSelectDates(startDate: start, endDate: end)
        }
        dismiss(animated: true, completion: nil)
    }
}
