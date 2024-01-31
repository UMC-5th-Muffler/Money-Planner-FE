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
    
    let consumeView : HomeConsumeView = {
        let v = HomeConsumeView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        view.translatesAutoresizingMaskIntoConstraints = false
        setUpConsumeView()
    }
    
}


extension SearchConsumeViewController{
    
    func setUpConsumeView(){
        consumeView.data = [
            DailyConsume(date: "1월 17일", dailyTotalCost: 3000, expenseDetailList: [ConsumeDetail(expenseId: 0, title: "아메리카노", cost: 1000, categoryIcon: "1"), ConsumeDetail(expenseId: 1, title: "카페라떼", cost: 1000, categoryIcon: "1"), ConsumeDetail(expenseId: 2, title: "맛있는거", cost: 1000, categoryIcon: "1")]),
            DailyConsume(date: "1월 16일", dailyTotalCost: 3000, expenseDetailList: [ConsumeDetail(expenseId: 0, title: "아메리카노", cost: 1000, categoryIcon: "1"), ConsumeDetail(expenseId: 1, title: "카페라떼", cost: 1000, categoryIcon: "1"), ConsumeDetail(expenseId: 2, title: "맛있는거", cost: 1000, categoryIcon: "1")]),
            DailyConsume(date: "1월 15일", dailyTotalCost: 3000, expenseDetailList: [ConsumeDetail(expenseId: 0, title: "아메리카노", cost: 1000, categoryIcon: "1"), ConsumeDetail(expenseId: 1, title: "카페라떼", cost: 1000, categoryIcon: "1"), ConsumeDetail(expenseId: 2, title: "맛있는거", cost: 1000, categoryIcon: "1")]),
            DailyConsume(date: "1월 14일", dailyTotalCost: 3000, expenseDetailList: [ConsumeDetail(expenseId: 0, title: "아메리카노", cost: 1000, categoryIcon: "1"), ConsumeDetail(expenseId: 1, title: "카페라떼", cost: 1000, categoryIcon: "1"), ConsumeDetail(expenseId: 2, title: "맛있는거", cost: 1000, categoryIcon: "1")])
            
        ]
        
        view.addSubview(consumeView)
        
        NSLayoutConstraint.activate([
            consumeView.topAnchor.constraint(equalTo: view.topAnchor, constant: 24),
            consumeView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            consumeView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            consumeView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            consumeView.heightAnchor.constraint(equalToConstant: 1000)
            
        ])
    }
}
