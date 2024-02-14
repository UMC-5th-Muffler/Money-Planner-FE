//
//  CategoryTableView.swift
//  Money-Planner
//
//  Created by seonwoo on 2024/01/24.
//

import Foundation
import UIKit

class CategoryTableView : UIView{
    
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.isEditing = true
        table.allowsSelectionDuringEditing = true
        return table
    }()
    
    var categoryList : [Category] = [ Category(id: 0, name: "전체"), Category(id: 1, name: "식사"), Category(id: 2, name: "카페"), Category(id: 3, name: "교통"), Category(id: 4, name: "쇼핑")] {
        didSet{
            print("여기")
            tableView.reloadData()
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
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(CategoryTableCell.self, forCellReuseIdentifier: "CategoryTableCell")
        
        self.addSubview(self.tableView)
        
        tableView.separatorInset.left = 0

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo:bottomAnchor)
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
            fatalError("Unable to dequeue CategoryTableCell")
        }
        
        let category = categoryList[indexPath.row]
        
        cell.configure(with: category)
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return tableView.rowHeight
       }
    
    // 왼쪽 버튼 없애기
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    // editing = true 일 때 왼쪽 버튼이 나오기 위해 들어오는 indent 없애기
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let removed = categoryList.remove(at: sourceIndexPath.row)
        categoryList.insert(removed, at: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            print("Selected row at index: \(indexPath.row)")
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
        view.layer.cornerRadius = 16 // 동그라미의 반지름 설정
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
        addSubview(iconView)
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            iconView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            iconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            iconView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            
            iconView.heightAnchor.constraint(equalToConstant: 32),
            iconView.widthAnchor.constraint(equalToConstant: 32),
            
            
            titleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12),
            titleLabel.centerYAnchor.constraint(equalTo: iconView.centerYAnchor)
        ])
    }
    
    func configure(with category: Category) {
        titleLabel.text = category.name
        //         iconView.text = category.categoryIcon
    }
}
