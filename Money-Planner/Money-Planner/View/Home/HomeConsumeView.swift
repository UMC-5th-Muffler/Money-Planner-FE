//
//  HomeConsumeView.swift
//  Money-Planner
//
//  Created by seonwoo on 2024/01/23.
//

import Foundation
import UIKit

class HomeConsumeView: UIView, UITableViewDataSource, UITableViewDelegate {

    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.isScrollEnabled = false
        table.separatorStyle = .none
        return table
    }()
    
    var data: [DailyConsume] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    let orderLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mpBlack
        label.font = UIFont.mpFont14M()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "최신순"
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        tableView.isScrollEnabled = false
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 적용하고자 하는 둥근 모서리의 크기
        let cornerRadius: CGFloat = 20.0
        
        // UIBezierPath를 사용하여 상단 부분에만 둥근 모서리를 생성
        let maskPath = UIBezierPath(roundedRect: bounds,
                                    byRoundingCorners: [.topLeft, .topRight],
                                    cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        
        // CAShapeLayer를 생성하고 mask로 사용
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        layer.mask = maskLayer
    }

    private func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .mpWhite
        
        addSubview(orderLabel)
        addSubview(tableView)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ConsumeRecordCell.self, forCellReuseIdentifier: "ConsumeRecordCell")

        NSLayoutConstraint.activate([
            orderLabel.topAnchor.constraint(equalTo: topAnchor, constant : 32),
            orderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            orderLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            orderLabel.heightAnchor.constraint(equalToConstant: 24),
            
            tableView.topAnchor.constraint(equalTo: orderLabel.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

extension HomeConsumeView {
    // MARK: - UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].expenseDetailList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ConsumeRecordCell", for: indexPath) as? ConsumeRecordCell else {
            fatalError("Unable to dequeue ConsumeRecordCell")
        }
        
        let consumeRecord = data[indexPath.section].expenseDetailList[indexPath.row]
        
        cell.configure(with: consumeRecord)

        return cell
    }

    // MARK: - UITableViewDelegate

    // 여기에 UITableViewDelegate 관련 메서드를 추가할 수 있습니다.
    // 예를 들면, 셀을 선택했을 때의 동작 등을 구현할 수 있습니다.
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        
        let separatorView : UIView = {
            let v = UIView()
            v.translatesAutoresizingMaskIntoConstraints = false
            v.backgroundColor = .mpGypsumGray
            v.heightAnchor.constraint(equalToConstant: 1)
            return v
        }()

        // 섹션 헤더에 표시할 내용을 추가
        let titleLabel = UILabel()
        titleLabel.text = data[section].date
        titleLabel.textColor = UIColor(hexCode: "9FAAB0")
        titleLabel.font = UIFont.mpFont14M()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(titleLabel)
        
        // "Cost" 텍스트를 추가
        let costLabel = UILabel()
        
        let result: String = data[section].dailyTotalCost.formattedWithSeparator()
        
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
}


class ConsumeRecordCell: UITableViewCell {
   
    private let costLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.mpFont16B()
        label.translatesAutoresizingMaskIntoConstraints = false
        // 다른 설정을 추가할 수 있습니다.
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.mpFont14M()
        label.textColor = .mpDarkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        // 다른 설정을 추가할 수 있습니다.
        return label
    }()
    
    let circleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.mpDarkGray
        view.layer.cornerRadius = 22 // 동그라미의 반지름 설정
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
        addSubview(circleView)
        addSubview(costLabel)
        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            circleView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            circleView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            circleView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            circleView.heightAnchor.constraint(equalToConstant: 44),
            circleView.widthAnchor.constraint(equalToConstant: 44),
            
            costLabel.topAnchor.constraint(equalTo: circleView.topAnchor, constant: 2),
            costLabel.leadingAnchor.constraint(equalTo: circleView.trailingAnchor, constant: 16),
            costLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: circleView.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: circleView.bottomAnchor, constant: -2)
        ])
    }

    func configure(with consumeRecord: ConsumeDetail) {
        titleLabel.text = consumeRecord.title
        costLabel.text = consumeRecord.cost.formattedWithSeparator() + "원"
        // 다른 데이터를 사용하여 셀을 업데이트할 수 있습니다.
    }
}
