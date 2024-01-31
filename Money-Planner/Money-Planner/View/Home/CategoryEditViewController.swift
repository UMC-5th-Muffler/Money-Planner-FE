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
    
//    lazy var textView : UIView = {
//        let v = UIView()
//    }

    var settingButton : UIBarButtonItem = {
        let button = UIButton(type: .system)
        button.setTitle("추가", for: .normal)
        button.tintColor = .mpMainColor
        button.addTarget(CategoryEditViewController.self, action: #selector(addButtonTapped), for: .touchUpInside)
        
        return UIBarButtonItem(customView: button)
    }()
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .mpWhite
        
        self.navigationController?.navigationBar.tintColor = .mpBlack
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationItem.title = "카테고리 편집"
        self.navigationItem.rightBarButtonItems = [settingButton]
        

    }
    
    override func loadView() {
        super.loadView()
        setupUI()
    }
        
}

extension CategoryEditViewController{
    
    func setupUI(){
//        categoryTableView.categoryList = [
//            Category(id: 0, name: "전체"), Category(id: 1, name: "식사"), Category(id: 2, name: "카페"), Category(id: 3, name: "교통"), Category(id: 4, name: "쇼핑")
//        ]
        
        categoryTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(categoryTableView)

//        NSLayoutConstraint.activate([
//            categoryTableView.topAnchor.constraint(equalTo: self.view.topAnchor),
//            categoryTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
//            categoryTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
//            categoryTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
//        ])
    }
    
    @objc func addButtonTapped() {
        print("add button tapped")
    }
}
