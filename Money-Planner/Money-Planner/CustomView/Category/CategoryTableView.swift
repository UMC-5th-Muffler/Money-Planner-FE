//
//  CategoryTableView.swift
//  Money-Planner
//
//  Created by seonwoo on 2024/01/24.
//

import Foundation
import UIKit

class CategoryTableView : UIView{
    
    
    private let table: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    var categoryList : [Category] = [ Category(id: 0, name: "전체"), Category(id: 1, name: "식사"), Category(id: 2, name: "카페"), Category(id: 3, name: "교통"), Category(id: 4, name: "쇼핑")] {
        didSet{
            print("여기")
            table.reloadData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .mpWhite
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .mpWhite
        setupUI()
    }
    
    override func layoutSubviews() {
           super.layoutSubviews()
           
       }
    private func setupUI(){
        print(categoryList.count)
        backgroundColor = .mpWhite
        
        self.table.delegate = self
        self.table.dataSource = self
        self.table.register(CategoryTableCell.self, forCellReuseIdentifier: "CategoryTableCell")
        
        self.addSubview(self.table)

        NSLayoutConstraint.activate([

//            topAnchor.constraint(equalTo: topAnchor),
//            leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
//            trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
//            bottomAnchor.constraint(equalTo:safeAreaLayoutGuide.bottomAnchor),

//            tableView.topAnchor.constraint(equalTo: topAnchor),
//            tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
//            tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
//            tableView.bottomAnchor.constraint(equalTo:bottomAnchor)
        ])
    }

}

extension CategoryTableView : UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
         return 1
     }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableCell", for: indexPath) as? CategoryTableCell else {
            print("여기옴?")
            fatalError("Unable to dequeue CategoryTableCell")
        }
        
        print("여기는 오지?")
        let category = categoryList[indexPath.row]
        
        cell.configure(with: category)
        
        return cell
    }
    
}

class CategoryTableCell: UITableViewCell {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.mpFont18M()
        label.textColor = .mpBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        // 다른 설정을 추가할 수 있습니다.
        return label
    }()
    
    let iconView: UIView = {
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
        print(titleLabel.text)
        addSubview(iconView)
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            iconView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            iconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            iconView.heightAnchor.constraint(equalToConstant: 32),
            iconView.widthAnchor.constraint(equalToConstant: 32),
            
            
            titleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12),
            titleLabel.centerYAnchor.constraint(equalTo: iconView.centerYAnchor)
        ])
    }
    
    func configure(with category: Category) {
        print("여기는")
        titleLabel.text = category.name
        //         iconView.text = category.categoryIcon
    }
}
