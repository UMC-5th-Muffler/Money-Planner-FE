//
//  HomeConsumeView.swift
//  Money-Planner
//
//  Created by seonwoo on 2024/01/23.
//

import Foundation
import UIKit

protocol HomeConsumeViewDelegate : AnyObject {
    func onTapOrder()
}

class HomeConsumeView: UIView, UITableViewDataSource, UITableViewDelegate {
    
    weak var delegate : HomeConsumeViewDelegate?
    
    let tableHeaderView : UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.isUserInteractionEnabled = true
        return v
    }()

    let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.isScrollEnabled = true
        table.separatorStyle = .none
        table.backgroundColor = .clear
        table.showsVerticalScrollIndicator = false
        return table
    }()
    
    var data: [DailyConsume] = [] {
        didSet {
            showView()
            tableView.reloadData()
            layoutIfNeeded()
        }
    }
    
    var noDataView : MPLabel = {
       let v = MPLabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.text = "소비내역이 없습니다."
        v.textColor = .mpDarkGray
        return v
    }()
    
    let arrow_small : UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.image = UIImage(named: "btn_arrow_small")
        return img
    }()
    
    let orderLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mpBlack
        label.font = UIFont.mpFont14M()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "최신순"
        label.isUserInteractionEnabled = true
        return label
    }()
    
    let button : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("최신순", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(sortByLatest), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true
        return button
    }()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapOrder))
        orderLabel.addGestureRecognizer(tapGesture)
        showView()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapOrder))
        orderLabel.addGestureRecognizer(tapGesture)
        showView()
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
    
    func showView(){
        if(data.isEmpty){
            noDataView.isHidden = false
            tableView.isHidden = true
        }else{
            noDataView.isHidden = true
            tableView.isHidden = false
        }
    }
    
    private func setupUI() {
        tableHeaderView.addSubview(button)
        tableHeaderView.addSubview(arrow_small)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .mpWhite
        
        tableView.tableHeaderView = tableHeaderView
        tableHeaderView.isUserInteractionEnabled = true
        tableView.tableHeaderView?.isUserInteractionEnabled = true
        
        addSubview(tableView)
        addSubview(noDataView)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ConsumeRecordCell.self, forCellReuseIdentifier: "ConsumeRecordCell")
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: tableHeaderView.topAnchor, constant: 32),
            button.leadingAnchor.constraint(equalTo: tableHeaderView.leadingAnchor, constant: 16),
            button.heightAnchor.constraint(equalToConstant: 24),
            button.bottomAnchor.constraint(equalTo: tableHeaderView.bottomAnchor, constant: -32),
            
            arrow_small.leadingAnchor.constraint(equalTo: button.trailingAnchor, constant: 4),
            arrow_small.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            noDataView.topAnchor.constraint(equalTo: topAnchor, constant: 100),
            noDataView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}

extension HomeConsumeView {
    // MARK: - UITableViewDataSource
    
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
        cell.selectionStyle = .none
        
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
        titleLabel.text = data[section].date.formatMonthAndDate
        titleLabel.textColor = UIColor(hexCode: "9FAAB0")
        titleLabel.font = UIFont.mpFont14M()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(titleLabel)
        
        // "Cost" 텍스트를 추가
        let costLabel = UILabel()
        
        if(data[section].dailyTotalCost != nil){
            let result: String = data[section].dailyTotalCost!.formattedWithSeparator()
            
            costLabel.text = "\(result)원"
        }else{
            costLabel.text = ""
        }

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
    
    // 소비내역 셀 클릭 시 이동하는 함수 - 박근영
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 선택한 셀에 대한 처리를 구현합니다.
        // 예를 들어, 선택한 셀의 데이터를 가져와 다른 뷰로 전달하거나, 다른 뷰로 이동하는 등의 작업을 수행할 수 있습니다.
        
        let selectedRecord = data[indexPath.section].expenseDetailList![indexPath.row]

        // expenseID
        let expenseId : Int64 = Int64(selectedRecord.expenseId)
        let detailViewController = ConsumeDetailViewController(expenseId: expenseId)
        detailViewController.modalPresentationStyle = .fullScreen
        self.window?.rootViewController?.present(detailViewController, animated: true, completion: nil)
        
    }
    
    @objc func onTapOrder(){
        print("여기 안옴?")
        delegate?.onTapOrder()
    }
    
    @objc func sortByLatest() {
        print("안녕")
    }
}

extension HomeConsumeView{
    func tableViewHeader(section: Int) -> UIView? {
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
        titleLabel.text = data[section].date.formatMonthAndDate
        titleLabel.textColor = UIColor(hexCode: "9FAAB0")
        titleLabel.font = UIFont.mpFont14M()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(titleLabel)
        
        // "Cost" 텍스트를 추가
        let costLabel = UILabel()
        
        if(data[section].dailyTotalCost != nil){
            let result: String = data[section].dailyTotalCost!.formattedWithSeparator()
            
            costLabel.text = "\(result)원"
        }else{
            costLabel.text = ""
        }

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
            
        ])
        
        return headerView
    }
    
    func tableViewRowSelect(indexPath: IndexPath){
        let selectedRecord = data[indexPath.section].expenseDetailList![indexPath.row]

        // expenseID
        let expenseId : Int64 = Int64(selectedRecord.expenseId)
        let detailViewController = ConsumeDetailViewController(expenseId: expenseId)
        detailViewController.modalPresentationStyle = .fullScreen
        self.window?.rootViewController?.present(detailViewController, animated: true, completion: nil)
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
