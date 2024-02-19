//
//  CategoryEditViewController.swift
//  Money-Planner
//
//  Created by seonwoo on 2024/01/24.
//

import Foundation
import UIKit

class CategoryEditViewController : UIViewController,CategoryTableViewDelegate, AddCategoryViewDelegate {
    func categoryDidSelect(at indexPath: IndexPath) {
        let category = categoryTableView.categoryList[indexPath.item]
        categoryName = category.name
        categoryIcon = category.categoryIcon
        categoryId = Int64(category.id)
        presentCategoryDetail()
    }
    
    func AddCategoryCompleted(_ name: String, iconName: String) {
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
        
    var originalCategoryList : [Category] = []
    var categoryName : String?
    var categoryIcon : String?
    var categoryId : Int64?
    
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
        
        if(!arraysAreEqual(array1: originalCategoryList, array2: categoryTableView.categoryList)){
            
            CategoryRepository.shared.updateCategoryFilter(categories: categoryTableView.categoryList){
                _ in
            }
        }
    }
    
    func arraysAreEqual(array1: [Category],array2: [Category]) -> Bool {
        guard array1.count == array2.count else {
            return false
        }
        
        for (element1, element2) in zip(array1, array2) {
            if element1.id != element2.id {
                return false
            }
        }
        
        return true
    }
    
}

extension CategoryEditViewController{
    
    func setupUI(){
        
        categoryTableView.categoryList = originalCategoryList
        categoryTableView.delegate = self
        
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
                self.originalCategoryList = categoryList!
                self.categoryTableView.categoryList = self.originalCategoryList
                
            case .failure(.failure(message: let message)):
                print(message)
            case .failure(.networkFail(let error)):
                print(error)
                print("networkFail in loginWithSocialAPI")
            }
        }
    }
  
    func presentCategoryDetail(){
        let catDetailVC = AddCategoryViewController(name: categoryName ?? "", icon: categoryIcon ?? "", id : categoryId ?? -1)
            catDetailVC.modalPresentationStyle = .overFullScreen
            catDetailVC.delegate = self
            present(catDetailVC, animated: true)
        }
    
    @objc
    private func addButtonTapped() {
        print("add button tapped")
        // 카테고리 추가화면
        let addCategoryVC = AddCategoryViewController(name: "", icon: "", id: -1)
        addCategoryVC.modalPresentationStyle = .fullScreen
        addCategoryVC.delegate = self
        present(addCategoryVC, animated: true)
    }
}
