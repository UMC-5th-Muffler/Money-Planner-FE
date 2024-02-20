//
//  RepeatConsumeViewController.swift
//  Money-Planner
//
//  Created by seonwoo on 2024/02/13.
//

import Foundation
import UIKit

class RepeatConsumeViewController : UIViewController,  UITableViewDataSource, UITableViewDelegate  {
    
    var routineList: [Routine] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var loading : Bool = false
    var hasNext : Bool = false
    
    let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.isScrollEnabled = true
        table.separatorStyle = .none
        table.backgroundColor = .clear
        return table
    }()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        fetchRepeatConsumeData()
        view.backgroundColor = .mpWhite
        
        
        self.navigationController?.navigationBar.tintColor = .mpBlack
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationItem.title = "반복 소비내역"
        
        setupUI()
    }
    
}

extension RepeatConsumeViewController{
    
    func setupUI(){
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(RepeatConsumeRecordCell.self, forCellReuseIdentifier: "RepeatConsumeRecordCell")
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    func fetchRepeatConsumeData(){
        self.loading = true
        RoutineRepository.shared.getRoutineList{
            (result) in
            switch result{
            case .success(let data):
                self.loading = false
                self.hasNext = data!.hasNext
                let routineList = data?.routineList ?? []
                self.routineList = routineList
                
                
            case .failure(.failure(message: let message)):
                print(message)
                self.loading = false
            case .failure(.networkFail(let error)):
                print(error)
                print("networkFail in loginWithSocialAPI")
                self.loading = false
            }
        }
    }
}


extension RepeatConsumeViewController {
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routineList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 86 // 셀의 높이
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RepeatConsumeRecordCell", for: indexPath) as? RepeatConsumeRecordCell else {
            
            fatalError("Unable to dequeue RepeatConsumeRecordCell")
        }
        
        let routine = routineList[indexPath.row]
        
        cell.configure(with: routine)
        cell.selectionStyle = .none
        
        return cell
    }
    
}


class RepeatConsumeRecordCell: UITableViewCell {
    
    private let repeatNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.mpFont16M()
        label.translatesAutoresizingMaskIntoConstraints = false
        // 다른 설정을 추가할 수 있습니다.
        return label
    }()
    
    private let stackView : UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layoutMargins = UIEdgeInsets(top: 5, left: 8, bottom: 5, right: 8)
        view.isLayoutMarginsRelativeArrangement = true
        view.layer.cornerRadius = 6
        view.backgroundColor = .mpGypsumGray
        
        return view
    }()
    
    private let repeatDayLabel: MPLabel = {
        let label = MPLabel()
        label.font = UIFont.mpFont12M()
        label.textColor = .mpDarkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let circleView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = UIColor.mpDarkGray
        view.layer.cornerRadius = 22 // 동그라미의 반지름 설정
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let costLabel: MPLabel = {
        let label = MPLabel()
        label.font = UIFont.mpFont16R()
        label.textColor = .mpDarkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let chevronView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "chevron.right")
        view.tintColor = .mpDarkGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        contentView.addSubview(circleView)
        contentView.addSubview(repeatNameLabel)
        contentView.addSubview(chevronView)
        contentView.addSubview(stackView)
        contentView.addSubview(costLabel)
        
        stackView.addArrangedSubview(repeatDayLabel)
        
        NSLayoutConstraint.activate([
            circleView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
//            circleView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            circleView.heightAnchor.constraint(equalToConstant: 44),
            circleView.widthAnchor.constraint(equalToConstant: 44),
            
            repeatNameLabel.topAnchor.constraint(equalTo: circleView.topAnchor, constant: 0),
            repeatNameLabel.leadingAnchor.constraint(equalTo: circleView.trailingAnchor, constant: 16),
            repeatNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            chevronView.centerYAnchor.constraint(equalTo: repeatNameLabel.centerYAnchor),
            chevronView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            costLabel.topAnchor.constraint(equalTo: repeatNameLabel.topAnchor),
            costLabel.trailingAnchor.constraint(equalTo: chevronView.leadingAnchor, constant: -6),
            
            
            stackView.leadingAnchor.constraint(equalTo: circleView.trailingAnchor, constant: 16),
            stackView.bottomAnchor.constraint(equalTo: circleView.bottomAnchor, constant: 0)
        ])
        
    }
    
    func configure(with routine: Routine) {
        repeatNameLabel.text = routine.routineTitle
        //        repeatDayLabel.text = routine.rout
        
        costLabel.text = routine.routineCost!.formattedWithSeparator() + "원"
        circleView.image = UIImage(named: routine.categoryIcon!)
        
        if(routine.monthlyRepeatDay != nil){
            //매달
            repeatDayLabel.text = "매달 \(routine.monthlyRepeatDay)일"
        }else{
            //매주
            if(routine.weeklyDetail?.weeklyTerm == 1){
                repeatDayLabel.text = "매주 "
            }
            
            if(routine.weeklyDetail?.weeklyTerm == 2){
                repeatDayLabel.text = "격주 "
            }
            
            if(routine.weeklyDetail?.weeklyTerm == 3){
                repeatDayLabel.text = "3주 "
            }
            
            for day in routine.weeklyDetail!.weeklyRepeatDays! {
                switch day {
                case 1:
                    repeatDayLabel.text = repeatDayLabel.text! + "월"
                case 2:
                    repeatDayLabel.text = repeatDayLabel.text! + "화"
                case 3:
                    repeatDayLabel.text = repeatDayLabel.text! + "수"
                case 4:
                    repeatDayLabel.text = repeatDayLabel.text! + "목"
                case 5:
                    repeatDayLabel.text = repeatDayLabel.text! + "금"
                case 6:
                    repeatDayLabel.text = repeatDayLabel.text! + "토"
                case 7:
                    repeatDayLabel.text = repeatDayLabel.text! + "일"
                default:
                    break
                }
                
                if(day != routine.weeklyDetail!.weeklyRepeatDays!.last){
                    repeatDayLabel.text = repeatDayLabel.text! + ","
                }
            }
            
            repeatDayLabel.text = repeatDayLabel.text! + "요일"
            
        }
    }
}
