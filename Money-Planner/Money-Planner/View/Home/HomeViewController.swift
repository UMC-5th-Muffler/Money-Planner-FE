//
//  HomeViewController.swift
//  Money-Planner
//
//  Created by 유철민 on 1/6/24.
//

import Foundation
import UIKit

class HomeViewController : UIViewController {
    
    override func viewDidLoad(){
        setupHeader()
        view.backgroundColor = UIColor.mpWhite
    }
    
    func setupHeader(){
        // 헤더 뷰 생성
        let headerView = UIView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        // 제목 레이블 추가
        let titleLabel = MPLabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "✈️ 일본여행 가기 전"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.mpFont21SB()
        headerView.addSubview(titleLabel)
        
        // 검색 버튼 추가
        let searchButton = UIButton(type: .system)
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        searchButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        searchButton.tintColor = .mpBlack
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        headerView.addSubview(searchButton)
        
        // 플러스 버튼 추가
        let plusButton = UIButton(type: .system)
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        plusButton.setImage(UIImage(systemName: "plus"), for: .normal)
        plusButton.tintColor = .mpBlack
        plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        headerView.addSubview(plusButton)
        
        // 화면에 헤더 뷰 추가
        view.addSubview(headerView)
        
        // Auto Layout 설정
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            
            headerView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 21),
            headerView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -21),
            headerView.heightAnchor.constraint(equalToConstant: 25),
            
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            
            plusButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            plusButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            
            searchButton.trailingAnchor.constraint(equalTo: plusButton.leadingAnchor, constant: -14),
            searchButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            
            searchButton.widthAnchor.constraint(equalToConstant: 24),
            searchButton.heightAnchor.constraint(equalToConstant: 24),
            
            plusButton.widthAnchor.constraint(equalToConstant: 30),
            plusButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    @objc func searchButtonTapped() {
        // 왼쪽 버튼이 탭되었을 때의 동작
        print("Search button tapped")
    }
    
    @objc func plusButtonTapped() {
        // 오른쪽 버튼이 탭되었을 때의 동작
        print("Plus button tapped")
    }
}
