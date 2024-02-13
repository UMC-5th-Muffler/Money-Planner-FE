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

class GoalMainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    private let disposeBag = DisposeBag()
    private let headerView = GoalMainHeaderView()
    private let goalTable = UITableView()
    private let goalViewModel = GoalViewModel.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mpHomeBackground
        setupHeaderView()
        setupGoalTable()
        
        goalViewModel.goalsObservable
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.goalTable.reloadData()
            })
            .disposed(by: disposeBag)
        
        headerView.addNewGoalBtn.addTarget(self, action: #selector(addNewGoalButtonTapped), for: .touchUpInside)
    }
    
    @objc func addNewGoalButtonTapped() {
        // Create and present GoalNameViewController
        print("aaaa")
        let goalNameViewController = GoalNameViewController()
//        self.present(GoalNameViewController(), animated: true)
        navigationController?.pushViewController(goalNameViewController, animated: true)
        
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
        goalTable.backgroundColor = .mpHomeBackground
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
        // 현재 섹션이 0번째 섹션이고 목표가 없으면 비었다는 것을 알려줄 셀이 들어가므로 1을 반환하고, 그렇지 않으면 현재 목표의 개수를 반환
        if section == 0 {
            return goalViewModel.currentGoals.isEmpty ? 1 : goalViewModel.currentGoals.count
        } else {
            // 이전 섹션이고 목표가 없으면 비었다는 것을 알려줄 셀이 들어가므로 1을 반환
            return goalViewModel.pastGoals.isEmpty && goalViewModel.futureGoals.isEmpty ? 1 : goalViewModel.pastGoals.count + goalViewModel.futureGoals.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 첫 번째 섹션인 경우
        if indexPath.section == 0 {
            if goalViewModel.currentGoals.isEmpty {
                // 현재 목표가 없으면 GoalEmptyCell을 반환
                let cell = tableView.dequeueReusableCell(withIdentifier: "GoalEmptyCell", for: indexPath) as! GoalEmptyCell
                cell.configure(with: "현재 진행 중인 목표가 없습니다.\n+ 버튼을 눌러 새 목표를 생성해보세요!")
                return cell
            } else {
                // 현재 목표가 있으면 GoalPresentationCell을 반환
                let goal = goalViewModel.currentGoals[indexPath.row]
                let cell = GoalPresentationCell(goal: goal, reuseIdentifier: "GoalPresentationCell")
                
                cell.btnTapped = { [weak self] in
                    guard let self = self else { return }
                    
                    //해당 cell의 goal에 대한 정보를 api로 요청
                    print("detailVC로")
                    //해당 객체를 인자로 받고, 이동
                    let goalDetailsVC = GoalDetailsViewController(goal: cell.goal)
                    self.navigationController?.pushViewController(goalDetailsVC, animated: true)
                    self.tabBarController?.tabBar.isHidden = true
                }
                
                return cell
            }
        } else {
            // 두 번째 섹션인 경우
            if goalViewModel.pastGoals.isEmpty {
                // 이전 목표가 없으면 GoalEmptyCell을 반환
                let cell = tableView.dequeueReusableCell(withIdentifier: "GoalEmptyCell", for: indexPath) as! GoalEmptyCell
                cell.configure(with: "아직 지난/예정된 목표가 없습니다.")
                return cell
            } else {
                // 이전 목표가 있으면 GoalPresentationCell을 반환
                let goal = goalViewModel.notCurrentGoals[indexPath.row] //좀 더 깔끔한 로직이 없을까?
                let cell = GoalPresentationCell(goal: goal, reuseIdentifier: "GoalPresentationCell")
                cell.btnTapped = { [weak self] in
                    guard let self = self else { return }
                    
                    //해당 cell의 goal에 대한 정보를 api로 요청
                    print("detailVC로")
                    //해당 객체를 인자로 받고, 이동
                    let goalDetailsVC = GoalDetailsViewController(goal: cell.goal)
                    navigationController?.pushViewController(goalDetailsVC, animated: true)
                    self.tabBarController?.tabBar.isHidden = true
                }
                return cell
            }
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) // 선택된 셀의 하이라이트 제거

        let goal: Goal
        if indexPath.section == 0 {
            if goalViewModel.currentGoals.isEmpty {
                // 현재 진행 중인 목표가 없는 경우
                return // 또는 적절한 액션 수행
            } else {
                // 현재 진행 중인 목표가 있는 경우
                goal = goalViewModel.currentGoals[indexPath.row]
            }
        } else {
            if goalViewModel.pastGoals.isEmpty && goalViewModel.futureGoals.isEmpty {
                // 이전 목표가 없는 경우
                return // 또는 적절한 액션 수행
            } else {
                // 이전 목표가 있는 경우
                goal = goalViewModel.notCurrentGoals[indexPath.row] // 적절한 배열 인덱스 접근 방식으로 수정 필요
            }
        }

        // GoalDetailsViewController로 화면 전환
        let goalDetailsVC = GoalDetailsViewController(goal: goal)
        navigationController?.pushViewController(goalDetailsVC, animated: true)
        self.tabBarController?.tabBar.isHidden = true
    }


}
