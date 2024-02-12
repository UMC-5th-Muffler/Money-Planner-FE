//
//  GoalDetailsViewController.swift
//  Money-Planner
//
//  Created by 유철민 on 2/7/24.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxMoya
import Moya

//class GoalDetailsViewController : UIViewController {
//    
//    var goal : Goal
//    
//    init(goal: Goal) {
//        //순서 미정의 된 변수, super init, 정의가 이제 된 변수를 바탕으로 한 개변
//        self.goal = goal
//        super.init(nibName: nil, bundle: nil)
//        configureViews()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupButtons()
//        setupUnderlineView()
//        selectButton(spendingButton) // Default selected button
//    }
//    
//    //layer1
//    let dday = DdayLabel()
//    let spanNDuration : MPLabel = {
//        let label = MPLabel()
//        label.text = ""
//        label.font = .mpFont14M()
//        return label
//    }()
//    let editBtn : UIButton = {
//        let btn = UIButton()
//        btn.setImage(UIImage(systemName: "pencil"), for: .normal)
//        btn.tintColor = .mpGray
//        return btn
//    }()
//    
//    //layer2
//    let label1 : MPLabel = {
//        let label = MPLabel()
//        label.text = "소비한 금액"
//        label.font = .mpFont16M()
//        return label
//    }()
//    
//    let label2 : MPLabel = {
//        let label = MPLabel()
//        return label
//    }()
//    
//    //layer3 : button tab
//    private let spendingButton = UIButton()
//    private let reportButton = UIButton()
//    private let underlineView = UIView()
//    
//    private var underlineViewLeadingConstraint: NSLayoutConstraint?
//    
//    private func setupButtons() {
//        spendingButton.setTitle("소비내역", for: .normal)
//        reportButton.setTitle("분석 리포트", for: .normal)
//        
//        spendingButton.setTitleColor(.gray, for: .normal)
//        reportButton.setTitleColor(.gray, for: .normal)
//        
//        spendingButton.setTitleColor(.black, for: .selected)
//        reportButton.setTitleColor(.black, for: .selected)
//        
//        spendingButton.addTarget(self, action: #selector(selectButton(_:)), for: .touchUpInside)
//        reportButton.addTarget(self, action: #selector(selectButton(_:)), for: .touchUpInside)
//        
//        spendingButton.translatesAutoresizingMaskIntoConstraints = false
//        reportButton.translatesAutoresizingMaskIntoConstraints = false
//        
//        view.addSubview(spendingButton)
//        view.addSubview(reportButton)
//        
//        NSLayoutConstraint.activate([
//            spendingButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            spendingButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            spendingButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
//            
//            reportButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            reportButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            reportButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
//        ])
//    }
//    
//    private func setupUnderlineView() {
//        underlineView.backgroundColor = .black
//        underlineView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(underlineView)
//        
//        underlineViewLeadingConstraint = underlineView.leadingAnchor.constraint(equalTo: spendingButton.leadingAnchor)
//        NSLayoutConstraint.activate([
//            underlineViewLeadingConstraint!,
//            underlineView.topAnchor.constraint(equalTo: spendingButton.bottomAnchor),
//            underlineView.widthAnchor.constraint(equalTo: spendingButton.widthAnchor),
//            underlineView.heightAnchor.constraint(equalToConstant: 2)
//        ])
//    }
//    
//    @objc private func selectButton(_ sender: UIButton) {
//        [spendingButton, reportButton].forEach { $0.isSelected = ($0 == sender) }
//        
//        // Animate underline view
//        underlineViewLeadingConstraint?.isActive = false
//        underlineViewLeadingConstraint = underlineView.leadingAnchor.constraint(equalTo: sender.leadingAnchor)
//        underlineViewLeadingConstraint?.isActive = true
//        
//        UIView.animate(withDuration: 0.3) {
//            self.view.layoutIfNeeded()
//        }
//    }
//    
//    //layer4 : 날짜 필터
//    var filterButton : UIButton = {
//        let btn = UIButton()
//        return btn
//    }()
//    
//    //layer5 : tableView
//    
//    ///spendTableView : 섹션은 날짜별로.
//    ///한번에 최신순으로 10개씩 호출. 내려서 맨 아래에 도달할때마다 로딩 표시가 떴다가 10개씩 호출.
//    ///섹션 왼쪽에 제목은 날짜. 섹션 오른쪽에는 해당 날짜의 소비금액합 => 소비금액합은 드러나지 않은 셀들이 있을때 반영되어있어야한다. 이는 백엔드에서 보내줘야한다.
////    let spendTableView : UITableView!
//    
//    ///analysisTableView : 섹션은 3개
//    ///섹션1 : 섹션 제목은 없음. 요약정리셀 : summarizedGoalReportCell
//    ///섹션2 : 제목 : "가장 많이 소비한 곳은?" ; 가장 많이 소비한 곳을 알려주는 막대 그래프. 제일 많이 쓴 3개의 카테고리 표기, 나머지는 묶어서 개수로 표현 : mostSpentGraphCell
//    ///섹션3 : 제목 : "카테고리별 리포트 보기" ; 카테고리별 목표 리포트 보기 : 내가 목표로 설정한 카테고리에 대한 보고서를 담당하는 셀 : categoryReportCell
////    let analysisTableView : UITableView!
//    
//    
//    
//    func configureViews(){
//        
//        //layer1
//        
//        //dday
//        dday.configure(for: self.goal)
//      
//        //spanDuration
//        dateFormatter.dateFormat = "yyyy.MM.dd"
//        let startdatestr = dateFormatter.string(from: goal.goalStart)
//        
//        let enddatestr : String
//        if Calendar.current.dateComponents([.year], from: goal.goalStart) == Calendar.current.dateComponents([.year], from: goal.goalEnd) {
//            enddatestr = dateFormatter.string(from: goal.goalEnd)
//        }else{
//            dateFormatter.dateFormat = "MM.dd"
//            enddatestr = dateFormatter.string(from: goal.goalEnd)
//        }
//        
//        if goal.goalStart < Date() && Date() < goal.goalEnd {
//            let day = Calendar.current.dateComponents([.day], from: goal.goalStart, to: Date())
//            spanNDuration.text = startdatestr + " - " + enddatestr + " | " + "\(day)" + "일차"
//        }else{
//            spanNDuration.text = startdatestr + " - " + enddatestr
//        }
//        
//        //editBtn은 이미 위에 구현됨.
//        
//        //layer2
//        //label1 이미 구현됨.
//        
//        let txt = \() + " / " + \() + "원"
//        
//        
//        
//        
//    }
//    
//    func setupLayout(){
//        
//    }
//}
