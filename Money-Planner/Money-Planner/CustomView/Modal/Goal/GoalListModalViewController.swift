//
//  GoalListModal.swift
//  Money-Planner
//
//  Created by seonwoo on 2024/01/29.
//

import Foundation
import UIKit

protocol GoalListModalViewDelegate : AnyObject{
    func changeGoal(goalId : Int)
}

class GoalListModalViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    weak var delegate: GoalListModalViewDelegate?
    
    private let customModal: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 25
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let titleLabel: MPLabel = {
        let label = MPLabel()
        label.text = "조회할 목표를 선택해주세요"
        label.textAlignment = .center
        label.font = UIFont.mpFont20B()
        return label
    }()
    
    let addGoalLabel: MPLabel = {
        let label = MPLabel()
        label.text = "새로운 목표 추가하기"
        label.textAlignment = .center
        label.font = UIFont.mpFont16M()
        label.textColor = .mpDarkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        return label
    }()
    
    let plusIconView : UIImageView = {
        let v = UIImageView()
        v.image = UIImage(systemName: "plus")
        v.tintColor = .mpDarkGray
        v.translatesAutoresizingMaskIntoConstraints = false
        v.isUserInteractionEnabled = true
        return v
    }()
    
    var goalList : [Goal] = []{
        didSet{
            showView()
            tableView.reloadData()
        }
    }
    
    let noGoalLabel : MPLabel = {
        let label = MPLabel()
        label.text = "목표가 없어요!"
        label.textAlignment = .center
        label.font = UIFont.mpFont18M()
        label.textColor = .mpDarkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        
        return tableView
    }()
    
    var selectedGoal : Goal?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        fetchData()
        presentCustomModal()
        setuptitleLabel()
        setupView()
    }
    
    func presentCustomModal() {
        // Instantiate your custom modal view
        view.addSubview(customModal)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapAddGoalLabel))
        addGoalLabel.addGestureRecognizer(tapGesture)
        
        NSLayoutConstraint.activate([
            customModal.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            customModal.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -36),
            customModal.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -64),
            customModal.heightAnchor.constraint(equalToConstant: 408),
        ])
        
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
            titleLabel.leadingAnchor.constraint(equalTo: customModal.leadingAnchor, constant: 24),
        ])
        
    }
    
    private func setupView() {
        customModal.addSubview(plusIconView)
        customModal.addSubview(addGoalLabel)
        customModal.addSubview(noGoalLabel)
        customModal.addSubview(tableView)

        showView()
        
        NSLayoutConstraint.activate([
            plusIconView.heightAnchor.constraint(equalToConstant: 18),
            plusIconView.widthAnchor.constraint(equalToConstant: 18),
            
            plusIconView.leadingAnchor.constraint(equalTo: customModal.leadingAnchor, constant:24),
            plusIconView.bottomAnchor.constraint(equalTo: customModal.bottomAnchor, constant: -32),
            
            addGoalLabel.centerYAnchor.constraint(equalTo: plusIconView.centerYAnchor),
            addGoalLabel.leadingAnchor.constraint(equalTo: plusIconView.trailingAnchor, constant: 6),
            
            noGoalLabel.centerXAnchor.constraint(equalTo: customModal.centerXAnchor),
            noGoalLabel.centerYAnchor.constraint(equalTo: customModal.centerYAnchor),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            tableView.leadingAnchor.constraint(equalTo: customModal.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: customModal.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: addGoalLabel.topAnchor),
        ])
    }
    
    @objc private func onTapAddGoalLabel() {
        print("여기!")
    }
    
    func showView(){
        if(goalList.isEmpty){
            noGoalLabel.isHidden = false
            tableView.isHidden = true
        }else{
            noGoalLabel.isHidden = true
            tableView.isHidden = false
        }
    }
}


extension GoalListModalViewController{
    func fetchData(){
        HomeRepository.shared.getGoalList{
            (result) in
            switch result{
            case .success(let data):
                // 아예 골이 없는 경우
                self.goalList = data ?? []
            case .failure(.failure(message: let message)):
                print(message)
            case .failure(.networkFail(let error)):
                print(error)
                print("networkFail in loginWithSocialAPI")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goalList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let goal = goalList[indexPath.row]
        
        cell.textLabel?.text =  (goal.icon != nil) ? (goal.icon! + " " + goal.goalTitle!) : goal.goalTitle
        cell.textLabel?.font = .mpFont16M()
        cell.textLabel?.textColor = .mpDarkGray
        cell.selectionStyle = .none
        
        if(selectedGoal?.goalID == goalList[indexPath.row].goalID){
            cell.textLabel?.textColor = .mpBlack
            cell.accessoryType = .checkmark
            cell.tintColor = .mpMainColor
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.changeGoal(goalId: goalList[indexPath.row].goalID)
        dismiss(animated: true)
    }
}
