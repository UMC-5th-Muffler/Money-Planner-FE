//
//  GoalMainViewController.swift
//  Money-Planner
//
//  Created by 유철민 on 1/17/24.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

extension GoalMainViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let offsetY = scrollView.contentOffset.y
//        let contentHeight = scrollView.contentSize.height
//        let boundsHeight = scrollView.bounds.size.height
//
//        // Check if the user has scrolled to the bottom of the table view
//        if offsetY > (contentHeight - boundsHeight) {
//            // Attempt to fetch more not-now goals
//            viewModel.fetchNotNowGoals()
//        }
//        onNotNowGoalsUpdated()
//        self.goalTable.reloadData()
    }
}


class GoalMainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    private let disposeBag = DisposeBag()
    private let headerView = GoalMainHeaderView()
    private let goalTable = UITableView()
    private let viewModel = GoalMainViewModel.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(getNotificationGoalView), name: Notification.Name("addGoal"), object: nil)
        
        view.backgroundColor = .mpGypsumGray
        setupSubscriptions()
//        viewModel.resetData()
        viewModel.fetchNowGoal()
        viewModel.fetchNotNowGoals()
        setupHeaderView()
        setupGoalTable()
        goalTable.delegate = self
        headerView.addNewGoalBtn.addTarget(self, action: #selector(addNewGoalButtonTapped), for: .touchUpInside)
    }
    
    private func setupSubscriptions() {
        viewModel.nowGoalResponse.asObservable()
            .subscribe(onNext: { [weak self] _ in
            self?.goalTable.reloadData()
        }).disposed(by: disposeBag)
        
        viewModel.notNowGoals.asObservable()
            .skip(1) // 초기값을 스킵하고 실제 업데이트 될 때만 반응하도록 설정
            .subscribe(onNext: { [weak self] _ in
                self?.onNotNowGoalsUpdated() // 여기서 UI 업데이트 로직 호출
            }).disposed(by: disposeBag)
    }
    
    @objc func addNewGoalButtonTapped() {
        // Create and present GoalTitleViewController
        let goalTitleViewController = GoalTitleViewController()
        navigationController?.pushViewController(goalTitleViewController, animated: true)
        
        //탭바가 안보이도록
        self.tabBarController?.tabBar.isHidden = true
    }
    
    private func setupHeaderView() {
        view.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 50) // 설정한 헤더 높이
        ])
    }
    
    private func setupGoalTable() {
        
        view.addSubview(goalTable)
        goalTable.showsVerticalScrollIndicator = false
        goalTable.backgroundColor = .mpLightGray
        goalTable.separatorStyle = .none
        goalTable.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            goalTable.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            goalTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            goalTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            goalTable.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        goalTable.dataSource = self
        goalTable.delegate = self
        
        // Register the GoalPresentationCell class for the cell identifier
        goalTable.register(GoalPresentationCell.self, forCellReuseIdentifier: "GoalPresentationCell")
        goalTable.register(GoalEmptyCell.self, forCellReuseIdentifier: "GoalEmptyCell")
        
        // Set the estimated and actual section header height
        goalTable.estimatedSectionHeaderHeight = 50 // Set your estimated header height
        goalTable.sectionHeaderHeight = UITableView.automaticDimension
        
    }
    
    // UITableViewDataSource 메서드
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2 // 두 개의 섹션
    }
    
    // UITableViewDataSource 메서드
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            let count = viewModel.notNowGoals.value.count
            return count == 0 ? 1 : count
        default:
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            // Now Goals section
            if let nowGoal = viewModel.nowGoalResponse.value?.result {
                // If there is a current goal, configure and return a GoalPresentationCell
                let cell = tableView.dequeueReusableCell(withIdentifier: "GoalPresentationCell", for: indexPath) as! GoalPresentationCell
                cell.configureCell(with: nowGoal, isNow: true)
                cell.btnTapped = { [weak self] in
                    // Navigate to GoalDetailsViewController with the selected goal's details
                    let goalDetailsVC = GoalDetailsViewController(goalID: nowGoal.goalId)
                    self?.navigationController?.pushViewController(goalDetailsVC, animated: true)
                    self?.tabBarController?.tabBar.isHidden = true
                }
                return cell
            } else {
                // If there are no current goals, configure and return a GoalEmptyCell
                let cell = tableView.dequeueReusableCell(withIdentifier: "GoalEmptyCell", for: indexPath) as! GoalEmptyCell
                cell.configure(with: "현재 진행 중인 목표가 없습니다.\n+ 버튼을 눌러 새 목표를 생성해보세요!")
                return cell
            }
        } else if indexPath.section == 1 {
            // Not Now Goals section
            let notNowGoals = viewModel.notNowGoals.value
            if notNowGoals.isEmpty {
                // If there are no past or future goals, configure and return a GoalEmptyCell
                let cell = tableView.dequeueReusableCell(withIdentifier: "GoalEmptyCell", for: indexPath) as! GoalEmptyCell
                cell.configure(with: "아직 지난/예정된 목표가 없습니다.")
                return cell
            } else {
                // If there are past or future goals, configure and return a GoalPresentationCell
//                let goal = notNowGoals[indexPath.row]
                let cell = tableView.dequeueReusableCell(withIdentifier: "GoalPresentationCell", for: indexPath) as! GoalPresentationCell
                let goal = viewModel.notNowGoals.value[indexPath.row]
                cell.configureCell(with: goal, isNow: false)
//                cell.btnTapped = { [weak self] in
//                    // Navigate to GoalDetailsViewController with the selected goal's details
//                    let goalDetailsVC = GoalDetailsViewController(goalID: goal.goalId)
//                    self?.navigationController?.pushViewController(goalDetailsVC, animated: true)
//                    self?.tabBarController?.tabBar.isHidden = true
//                }
                return cell
            }
        } else {
            // Fallback for any other section
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "진행 중인 목표"
        } else {
            return "나의 목표들"
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 111
    }
    
    // section 편집용 UITableViewDelegate
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear // Set the background color of the header
        
        // Create a label for the section title with your desired font
        let titleLabel = MPLabel()
        titleLabel.font = .mpFont16M() // Set your desired font
        titleLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
        
        headerView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Add constraints to position the label within the header view
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])
        
        return headerView
    }
    
    // UITableViewDelegate 메서드
    // UITableViewDelegate 메서드
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) // 선택된 셀의 하이라이트 제거
        
        if indexPath.section == 0 {
            // 현재 진행 중인 목표 선택 처리
            if let goal = viewModel.nowGoalResponse.value?.result {
                let goalDetailsVC = GoalDetailsViewController(goalID: Int(goal.goalId))
                navigationController?.pushViewController(goalDetailsVC, animated: true)
                self.tabBarController?.tabBar.isHidden = true
            }
        } else if indexPath.section == 1 {
            // 과거 혹은 미래 목표 선택 처리
            let notNowGoals = viewModel.notNowGoals.value
            
            if notNowGoals.count == 0 {
                return
            }
            
            if indexPath.row < notNowGoals.count {
                let selectedGoal = notNowGoals[indexPath.row]
                let goalDetailsVC = GoalDetailsViewController(goalID: selectedGoal.goalId)
                navigationController?.pushViewController(goalDetailsVC, animated: true)
                self.tabBarController?.tabBar.isHidden = true
            }
        }
    }

    
    func onNotNowGoalsUpdated() {
        let currentCount = goalTable.numberOfRows(inSection: 1)

        let newCount = viewModel.notNowGoals.value.count // 새로운 데이터의 개수

        // 새로운 항목이 추가되었는지 확인
        guard newCount > currentCount else { return }
        
        // 새로 추가될 셀들의 인덱스 경로를 계산
        var indexPaths: [IndexPath] = []
        for index in currentCount..<newCount {
            let indexPath = IndexPath(row: index, section: 1)
            indexPaths.append(indexPath)
        }
        
        // 테이블 뷰 업데이트 시작
        goalTable.beginUpdates()
        
        // 새로운 셀들을 삽입
        goalTable.insertRows(at: indexPaths, with: .automatic) // .automatic은 애니메이션 효과
        
        // 테이블 뷰 업데이트 종료
        goalTable.endUpdates()
        
        goalTable.reloadData()
    }

    @objc func getNotificationGoalView(){
        viewModel.fetchNowGoal()
        viewModel.fetchNotNowGoals()
    }
}

