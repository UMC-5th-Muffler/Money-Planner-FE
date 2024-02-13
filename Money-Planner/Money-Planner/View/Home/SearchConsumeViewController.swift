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
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .mpWhite
        self.navigationController?.navigationBar.tintColor = .mpBlack
        self.navigationController?.navigationBar.topItem?.title = ""
        
        searchBar.delegate = self
        searchBar.placeholder = "어떤 소비내역을 찾으세요?"
        searchBar.searchTextField.font = .mpFont16M()
        self.navigationItem.titleView = searchBar

//        setUpConsumeView()
    }
    
}


extension SearchConsumeViewController : UISearchBarDelegate{
    
    func setUpConsumeView(){

        view.addSubview(consumeView)
        
        NSLayoutConstraint.activate([
            consumeView.topAnchor.constraint(equalTo: view.topAnchor, constant: 24),
            consumeView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            consumeView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            consumeView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            consumeView.heightAnchor.constraint(equalToConstant: 1000)
            
        ])
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
           guard let searchText = searchBar.text, !searchText.isEmpty else {
               return // 검색어가 비어 있으면 무시
           }
            
        
       }
}
