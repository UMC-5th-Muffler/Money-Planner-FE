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
    var sort : SortType = SortType.descending {
        didSet{
            consumeView.sort = sort
        }
    }
    
    let noDataLabel : MPLabel = {
        let label = MPLabel()
        label.text = "검색 결과가 없습니다."
        label.font = .mpFont16M()
        label.textColor = .mpDarkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let otherKeywordLabel : MPLabel = {
        let label = MPLabel()
        label.text = "다른 키워드로 검색해주세요."
        label.font = .mpFont16M()
        label.textColor = .mpDarkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var noDataView : UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    var imageView : UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "no-result")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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
        
        consumeView.delegate = self
        
        consumeView.isHidden = true
        noDataView.isHidden = true
        setUpNoDataView()
        setUpConsumeView()
    }
}


extension SearchConsumeViewController : UISearchBarDelegate{
    
    func setUpNoDataView(){
        view.addSubview(noDataView)
        
        noDataView.addSubview(imageView)
        noDataView.addSubview(noDataLabel)
        noDataView.addSubview(otherKeywordLabel)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -75),
            imageView.heightAnchor.constraint(equalToConstant: 150),
            imageView.widthAnchor.constraint(equalToConstant: 150),
            
            noDataView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            noDataView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            
            noDataLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            noDataLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            otherKeywordLabel.topAnchor.constraint(equalTo: noDataLabel.bottomAnchor, constant: 10),
            otherKeywordLabel.centerXAnchor.constraint(equalTo: noDataLabel.centerXAnchor)
        ])
    }
    
    func setUpConsumeView(){
        view.addSubview(consumeView)
        
        NSLayoutConstraint.activate([
            consumeView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            consumeView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            consumeView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            consumeView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        fetchData()
    }
    
    func fetchData(){
        guard let searchText = searchBar.text, !searchText.isEmpty else {
            return // 검색어가 비어 있으면 무시
        }
        
        self.loading = true
        
        ExpenseRepository.shared.getExpenseList(text: searchText, order: sort.rawValue, size: nil){
            (result) in
            switch result{
            case .success(let data):
                self.loading = false
                self.hasNext = data!.hasNext
                let consumeList = data?.dailyExpenseList ?? []
                self.consumeList = consumeList
                
                if(self.consumeList.isEmpty){
                    self.consumeView.isHidden = true
                    self.noDataView.isHidden = false
                    return
                }
                
                
                DispatchQueue.main.async {
                    self.consumeView.data = self.consumeList
                    if(self.consumeView.isHidden){
                        self.noDataView.isHidden = true
                        self.consumeView.isHidden = false
                    }
                }
                
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

extension SearchConsumeViewController : HomeConsumeViewDelegate{
    func onTapOrder() {
        let vc = OrderModalViewController()
        vc.selectedSortType = sort
        vc.delegate = self
        present(vc, animated: true)
    }
    
    func changeConsumeData() {
    }
}


extension SearchConsumeViewController : OrderModalDelegate{
    func changeOrder(order: SortType) {
        if(sort == order){
            return
        }
        sort = order
        fetchData()
    }
}
