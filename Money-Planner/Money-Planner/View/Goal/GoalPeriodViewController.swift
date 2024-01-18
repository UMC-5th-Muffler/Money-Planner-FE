//
//  MakeGoalViewController.swift
//  Money-Planner
//
//  Created by 유철민 on 1/6/24.
//

import Foundation
import UIKit
import Moya

class GoalPeriodViewController : UIViewController, UITableViewDataSource {
    
    private var header : HeaderView = HeaderView(title: "목표 기간 설정")
    private var descriptionView : DescriptionView = DescriptionView(text: "도전할 소비 목표의 기간을 선택해주세요", alignToCenter: true)
    private lazy var calendarEmojiLabel = UILabel()
    private var tableView: UITableView!
    private lazy var btmbtn : MainBottomBtn = MainBottomBtn(title: "다음")
    
    private let goalViewModel = GoalViewModel.shared // 싱글턴용
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupHeader()
        setupDescriptionView()
        setUpBtmBtn()
        setupCalendarEmojiLabel()
        setupTableView()
    }
    
    private func setupHeader() {
        header.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(header)
        
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            header.heightAnchor.constraint(equalToConstant: 60) // 예시 높이값
        ])
    }
    
    private func setupDescriptionView() {
        descriptionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionView)
        
        NSLayoutConstraint.activate([
            descriptionView.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 30),
            descriptionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func setupCalendarEmojiLabel(){
        calendarEmojiLabel.translatesAutoresizingMaskIntoConstraints = false
        calendarEmojiLabel.text = "🗓️"
        calendarEmojiLabel.font = UIFont.systemFont(ofSize: 100, weight: .medium)
        view.addSubview(calendarEmojiLabel)
        
        NSLayoutConstraint.activate([
            calendarEmojiLabel.topAnchor.constraint(equalTo: descriptionView.bottomAnchor, constant: 20),
            calendarEmojiLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    
    }
    
    private func setUpBtmBtn(){
        btmbtn.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(btmbtn)
        NSLayoutConstraint.activate([
            btmbtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            btmbtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            btmbtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            btmbtn.heightAnchor.constraint(equalToConstant: 50)
        ])
        
    }
    
    private func setupTableView() {
        
        tableView = UITableView()
        tableView.dataSource = self
        tableView.register(WriteTextCell.self, forCellReuseIdentifier: "WriteTextCell")
        tableView.rowHeight = 60
        view.addSubview(tableView)
        
        tableView.separatorStyle = .none  // 셀 사이 구분선 제거
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: calendarEmojiLabel.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: btmbtn.topAnchor, constant: -20)
        ])
    }
    
    
    // UITableViewDataSource 메서드
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 // 두 개의 셀
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WriteTextCell", for: indexPath) as! WriteTextCell
        // 셀 설정
        switch indexPath.row {
        case 0:
            cell.configureCell(image: UIImage(systemName: "calendar"), placeholder: "목표 기간 설정하기")
        default:
            break
        }
        
        return cell
    }
    
//    // UITableViewDelegate 메서드
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.row == 1 {  // 두 번째 셀에 대한 높이 설정
//            return 180
//        } else {
//            return 60  // 다른 셀에 대한 기본 높이
//        }
//    }
}
