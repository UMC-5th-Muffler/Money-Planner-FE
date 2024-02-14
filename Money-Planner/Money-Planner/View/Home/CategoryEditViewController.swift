//
//  CategoryEditViewController.swift
//  Money-Planner
//
//  Created by seonwoo on 2024/01/24.
//

import Foundation
import UIKit

class CategoryEditViewController : UIViewController {
    
    var categoryTableView : CategoryTableView = {
        let v = CategoryTableView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
        
    var settingButton : UIBarButtonItem = {
        let button = UIButton(type: .system)
        button.setTitle("추가", for: .normal)
        button.tintColor = .mpMainColor
        button.addTarget(CategoryEditViewController.self, action: #selector(addButtonTapped), for: .touchUpInside)
        
        return UIBarButtonItem(customView: button)
    }()
    
    var canCategoryEditGrayView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.mpGypsumGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    private let canEditLabel: MPLabel = {
        let label = MPLabel()
        label.text = "카테고리 순서를 편집할 수 있습니다."
        label.font = .mpFont14M()
        label.textColor = UIColor.mpDarkGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        view.backgroundColor = .mpWhite
        
        self.navigationController?.navigationBar.tintColor = .mpBlack
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationItem.title = "카테고리 편집"
        self.navigationItem.rightBarButtonItems = [settingButton]
        
        setupUI()
    }

}

extension CategoryEditViewController{
    
    func setupUI(){
        
        categoryTableView.categoryList = [
            Category(id: 0, name: "전체"), Category(id: 1, name: "식사"), Category(id: 2, name: "카페"), Category(id: 3, name: "교통"), Category(id: 4, name: "쇼핑")
        ]
        

        view.addSubview(categoryTableView)
        view.addSubview(canCategoryEditGrayView)
        view.addSubview(canEditLabel)
        
        NSLayoutConstraint.activate([
            canCategoryEditGrayView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            canCategoryEditGrayView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            canCategoryEditGrayView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            canCategoryEditGrayView.heightAnchor.constraint(equalToConstant: 40),
            
            canEditLabel.centerXAnchor.constraint(equalTo: canCategoryEditGrayView.centerXAnchor),
            canEditLabel.centerYAnchor.constraint(equalTo: canCategoryEditGrayView.centerYAnchor),
            
            categoryTableView.topAnchor.constraint(equalTo: self.canCategoryEditGrayView.bottomAnchor),
            categoryTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            categoryTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            categoryTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    @objc func addButtonTapped() {
        print("add button tapped")
    }
}
