//
//  SearchConsumeViewController.swift
//  Money-Planner
//
//  Created by seonwoo on 2024/01/24.
//

import Foundation

import Foundation
import UIKit

class SearchConsumeViewController : UIViewController {
    let searchBar = UISearchBar()
    
    let consumeView : HomeConsumeView = {
        let v = HomeConsumeView()
        v.backgroundColor = .mpWhite
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    var hasNext : Bool = false
    var loading : Bool = false
//    var noData : Bool = false
    
    var consumeList : [DailyConsume] = []
    
    override func viewDidLoad(){
        super.viewDidLoad()
        view.backgroundColor = .mpWhite
        self.navigationController?.navigationBar.tintColor = .mpBlack
        self.navigationController?.navigationBar.topItem?.title = ""
        
        searchBar.delegate = self
        searchBar.placeholder = "어떤 소비내역을 찾으세요?"
        searchBar.searchTextField.font = .mpFont16M()
        self.navigationItem.titleView = searchBar
                
        setUpConsumeView()
    }
}


extension SearchConsumeViewController : UISearchBarDelegate{
    
    func setUpConsumeView(){
        
        consumeView.data = [
            DailyConsume(date: "2024-01-17", dailyTotalCost: 3000, expenseDetailList: [ConsumeDetail(expenseId: 0, title: "아메리카노", cost: 1000, categoryIcon: "1"), ConsumeDetail(expenseId: 1, title: "카페라떼", cost: 1000, categoryIcon: "1"), ConsumeDetail(expenseId: 2, title: "맛있는거", cost: 1000, categoryIcon: "1")]),
            DailyConsume(date: "2024-01-16", dailyTotalCost: 3000, expenseDetailList: [ConsumeDetail(expenseId: 0, title: "아메리카노", cost: 1000, categoryIcon: "1"), ConsumeDetail(expenseId: 1, title: "카페라떼", cost: 1000, categoryIcon: "1"), ConsumeDetail(expenseId: 2, title: "맛있는거", cost: 1000, categoryIcon: "1")]),
            DailyConsume(date: "2024-01-15", dailyTotalCost: 3000, expenseDetailList: [ConsumeDetail(expenseId: 0, title: "아메리카노", cost: 1000, categoryIcon: "1"), ConsumeDetail(expenseId: 1, title: "카페라떼", cost: 1000, categoryIcon: "1"), ConsumeDetail(expenseId: 2, title: "맛있는거", cost: 1000, categoryIcon: "1")]),
            DailyConsume(date: "2024-01-14", dailyTotalCost: 3000, expenseDetailList: [ConsumeDetail(expenseId: 0, title: "아메리카노", cost: 1000, categoryIcon: "1"), ConsumeDetail(expenseId: 1, title: "카페라떼", cost: 1000, categoryIcon: "1"), ConsumeDetail(expenseId: 2, title: "맛있는거", cost: 1000, categoryIcon: "1")])
            
        ]
        
        view.addSubview(consumeView)
        
        NSLayoutConstraint.activate([
            consumeView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            consumeView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            consumeView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            consumeView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else {
            return // 검색어가 비어 있으면 무시
        }
        
        ExpenseRepository.shared.getExpenseList(text: searchText, order: nil, size: nil){
            (result) in
            switch result{
            case .success(let data):
                
                self.hasNext = data!.hasNext
                let consumeList = data?.dailyExpenseList ?? []
//                self.consumeList.append(contentsOf: consumeList)
//
//                DispatchQueue.main.async {
//                    self.consumeView.data = self.consumeList
//                }
//                self.loading = false
                
                print("확인")
                print(consumeList)
                
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
