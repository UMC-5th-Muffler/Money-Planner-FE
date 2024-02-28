//
//  ExpenseView.swift
//  Money-Planner
//
//  Created by 유철민 on 2/28/24.
//

import Foundation
import UIKit

class ExpenseView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    var data: [DailyConsume] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var tapFilterBtn: (() -> Void)?
    
    // 날짜 필터 버튼
    let filterBtn: LabelAndImageBtn = {
        let button = LabelAndImageBtn(type: .system)
        button.setTitle("전체 기간 조회 ", for: .normal)
        button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        button.setTitleColor(.mpCharcoal, for: .normal)
        button.titleLabel?.font = .mpFont12M()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.isScrollEnabled = false
        table.separatorStyle = .none
        return table
    }()
    
    override init(frame: CGRect) {
        //api 호출로 셀 채워넣기 코드
        super.init(frame: frame)
        data = parseDailyConsume(from: jsonString) ?? []
        setupViews()
        tableView.reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(filterBtn)
        addSubview(tableView)
        
        filterBtn.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ConsumeRecordCell.self, forCellReuseIdentifier: "ConsumeRecordCell")
        
        // 필터 버튼 및 테이블뷰의 오토레이아웃 설정을 여기에 추가하세요.
        NSLayoutConstraint.activate([
            filterBtn.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            filterBtn.topAnchor.constraint(equalTo: self.topAnchor, constant: 22),
            
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: filterBtn.bottomAnchor, constant: 24),
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    @objc private func filterButtonTapped() {
        tapFilterBtn?()
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].expenseDetailList!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ConsumeRecordCell", for: indexPath) as? ConsumeRecordCell else {
            fatalError("Unable to dequeue ConsumeRecordCell")
        }
        
        let consumeRecord = data[indexPath.section].expenseDetailList![indexPath.row]
        
        cell.configure(with: consumeRecord)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        
        let separatorView : UIView = {
            let v = UIView()
            v.translatesAutoresizingMaskIntoConstraints = false
            v.backgroundColor = .mpGypsumGray
            v.heightAnchor.constraint(equalToConstant: 1).isActive = true
            return v
        }()
        
        // 섹션 헤더에 표시할 내용을 추가
        let titleLabel = MPLabel()
        titleLabel.text = data[section].date
        titleLabel.textColor = UIColor(hexCode: "9FAAB0")
        titleLabel.font = UIFont.mpFont14M()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(titleLabel)
        
        // "Cost" 텍스트를 추가
        let costLabel = MPLabel()
        
        let result: String = data[section].dailyTotalCost!.formattedWithSeparator()
        
        costLabel.text = "\(result)원"
        costLabel.textColor = UIColor.mpDarkGray
        costLabel.font = UIFont.mpFont14M()
        costLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(costLabel)
        headerView.addSubview(separatorView)
        
        // Auto Layout 설정
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            
            costLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            costLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            
            
            //            separatorView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            //            separatorView.trailingAnchor.constraint(equalTo: costLabel.trailingAnchor)
        ])
        
        return headerView
    }
    
    func parseDailyConsume(from jsonString: String) -> [DailyConsume]? {
        let jsonData = Data(jsonString.utf8)
        let decoder = JSONDecoder()
        do {
            let dailyConsumes = try decoder.decode([DailyConsume].self, from: jsonData)
            return dailyConsumes
        } catch {
            print("Error decoding JSON: \(error)")
            return nil
        }
    }
    
    let jsonString = """
    [
      {
        "date": "2024-02-01",
        "dailyTotalCost": 54787,
        "expenseDetailList": [
          {"title": "교통", "cost": 12074},
          {"title": "쇼핑", "cost": 4267},
          {"title": "기타", "cost": 2734},
          {"title": "기타", "cost": 13783},
          {"title": "식사", "cost": 4426}
        ]
      },
      {
        "date": "2024-02-02",
        "dailyTotalCost": 87180,
        "expenseDetailList": [
          {"title": "교통", "cost": 14498},
          {"title": "쇼핑", "cost": 19898},
          {"title": "식사", "cost": 6872},
          {"title": "쇼핑", "cost": 12139}
        ]
      },
      {
        "date": "2024-02-12",
        "dailyTotalCost": 73836,
        "expenseDetailList": [
          {"title": "식사", "cost": 9805},
          {"title": "식사", "cost": 11865},
          {"title": "기타", "cost": 11343},
          {"title": "교통", "cost": 15389}
        ]
      }
    ]
    """
    
}


