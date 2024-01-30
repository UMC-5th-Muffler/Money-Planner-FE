//
//  ViewController.swift
//  Money-Planner
//
//  Created by 유철민 on 1/29/24.
//

import Foundation
import UIKit

import Foundation
import UIKit

class ViewController: UIViewController, CalendarSelectionDelegate {
    
    func didSelectCalendarDate(_ date: String) {
        <#code#>
    }
    
    // Define currentDate, dateFormatter, calTextField, calChooseButton

    override func viewDidLoad() {
        super.viewDidLoad()
        presentCalendartModal()
        setupUI()
    }

    private func presentCalendartModal() {
        let calModalVC = CalendartModalViewController()
        calModalVC.delegate = self
        present(calModalVC, animated: true)
    }

    private func setupUI() {
        // Add and configure calTextField and calChooseButton
        // Set constraints and styles
    }

    func didSelectCalendarDate(_ startDate: Date, _ endDate: Date) {
        // Update calTextField with formatted startDate and endDate
        // Update calChooseButton title based on the duration
    }

    @objc private func calChooseButtonTapped() {
        // Present CalendartModalViewController again to adjust dates
    }
}


//class ViewController: UIViewController, CalendarSelectionDelegate {
//   
//    // 오늘 날짜
//    let currentDate = Date()
//    let dateFormatter = DateFormatter()
//    lazy var dateString: String = {
//        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
//        return dateFormatter.string(from: currentDate)
//    }()
//    
//    // 날짜 텍스트 필드
//    private let calTextField = MainTextField(placeholder: "", iconName: "icon_date", keyboardType: .default)
//
//    // 날짜 선택 버튼
//    lazy var calChooseButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("오늘", for: .normal)
//        button.titleLabel?.font = UIFont.mpFont20M()
//        button.setTitleColor(UIColor.mpMainColor, for: .normal)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.isUserInteractionEnabled = true
//        button.addTarget(self, action: #selector(showCalModal), for: .touchUpInside)
//        return button
//    }()
//
//    // 날짜 선택 모달 호출
//    @objc private func showCalModal() {
//        let calModalVC = CalendartModalViewController()
//        calModalVC.delegate = self
//        present(calModalVC, animated: true)
//    }
//    
//    // 선택된 날짜 처리
//    func didSelectCalendarDate(_ date: String) {
//        calTextField.text = date
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .systemBackground
//        setupcalTextField()
//    }
//    
//    // 날짜 텍스트 필드 설정
//    private func setupcalTextField() {
//        view.addSubview(calTextField)
//        calTextField.translatesAutoresizingMaskIntoConstraints = false
//        calTextField.isUserInteractionEnabled = false
//        calTextField.textColor = UIColor.mpBlack
//        calTextField.text = dateString
//        
//        NSLayoutConstraint.activate([
//            calTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
//            calTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            calTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60),
//            calTextField.heightAnchor.constraint(equalToConstant: 50)
//        ])
//
//        view.addSubview(calChooseButton)
//        NSLayoutConstraint.activate([
//            calChooseButton.centerYAnchor.constraint(equalTo: calTextField.centerYAnchor),
//            calChooseButton.leadingAnchor.constraint(equalTo: calTextField.trailingAnchor, constant: 10),
//            calChooseButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            calChooseButton.heightAnchor.constraint(equalTo: calTextField.heightAnchor)
//        ])
//    }
//}
