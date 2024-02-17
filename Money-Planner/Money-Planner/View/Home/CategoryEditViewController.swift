//
//  CategoryEditViewController.swift
//  Money-Planner
//
//  Created by seonwoo on 2024/01/24.
//

import Foundation
import UIKit

class CategoryEditViewController : UIViewController, AddCategoryViewDelegate {
    func AddCategoryCompleted(_ name: String, iconName: Int) {
        // 카테고리 추가 후 실행되는 함수
    }
    
    
    var categoryTableView : CategoryTableView = {
        let v = CategoryTableView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()


    
    var canCategoryEditGrayView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.mpGypsumGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
        
    var categoryList : [Category] = []
    
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
        
        // settingButton의 액션 설정
        let addButton = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(addButtonTapped))
        addButton.tintColor = .mpMainColor
        self.navigationItem.rightBarButtonItem = addButton

        fetchCategoryList()
        setupUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        CategoryRepository.shared.updateCategoryFilter(categories: categoryTableView.categoryList){
            _ in
        }
    }
    
}

extension CategoryEditViewController{
    
    func setupUI(){
        
        categoryTableView.categoryList = categoryList
        
        
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
    
    func fetchCategoryList(){
        CategoryRepository.shared.getCategoryAllList{
            (result) in
            switch result{
            case .success(let data):
                let categoryList = data
                self.categoryList = categoryList!
                self.categoryTableView.categoryList = self.categoryList
                
            case .failure(.failure(message: let message)):
                print(message)
            case .failure(.networkFail(let error)):
                print(error)
                print("networkFail in loginWithSocialAPI")
            }
        }
    }
    
    @objc 
    private func addButtonTapped() {
        print("add button tapped")
        // 카테고리 추가화면
        let addCategoryVC = AddCategoryViewController()
        addCategoryVC.modalPresentationStyle = .fullScreen
        addCategoryVC.delegate = self
        present(addCategoryVC, animated: true)
    }
}
