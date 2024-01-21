//
//  HomeViewController.swift
//  Money-Planner
//
//  Created by 유철민 on 1/6/24.
//

import Foundation
import UIKit

class HomeViewController : UIViewController, MainMonthViewDelegate {
    
    let headerView = UIView()
    
    let calendarView : MainCalendarView = {
        let v = MainCalendarView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let monthView: MainMonthView = {
        let v = MainMonthView()
        v.translatesAutoresizingMaskIntoConstraints=false
        return v
    }()
    
    override func viewDidLoad(){
        view.backgroundColor = UIColor.mpWhite
        setupHeader()
        setupView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        calendarView.myCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    func setupHeader(){
        
        // 검색 버튼 추가
        let searchButton = UIButton(type: .system)
        searchButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        searchButton.tintColor = .mpBlack
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        
        let search = UIBarButtonItem(customView: searchButton)
        
        let bellButton = UIButton(type: .system)
        bellButton.setImage(UIImage(systemName: "bell"), for: .normal)
        bellButton.tintColor = .mpBlack
        bellButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        
        
        let bell = UIBarButtonItem(customView: bellButton)
        
        let menuButton = UIButton(type: .system)
        menuButton.setImage(UIImage(systemName: "bell"), for: .normal)
        menuButton.tintColor = .mpBlack
        menuButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        
        let menu = UIBarButtonItem(customView: menuButton)
        
        navigationItem.rightBarButtonItems = [search, bell, menu]
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        // 제목 레이블 추가
        let titleLabel = MPLabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "✈️ 일본여행 가기 전 돈 모으기"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.mpFont18M()
        headerView.addSubview(titleLabel)
        
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
        ])
    }
    
    func setupView(){
        monthView.delegate=self
        view.addSubview(monthView)
        monthView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20).isActive=true
        monthView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive=true
        monthView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive=true
        monthView.heightAnchor.constraint(equalToConstant: 35).isActive=true
        
    
        view.addSubview(calendarView)
        calendarView.topAnchor.constraint(equalTo: view.topAnchor, constant: 200).isActive=true
        calendarView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive=true
        calendarView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive=true
        calendarView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 100).isActive = true
    }
    
    func didChangeMonth(monthIndex: Int, year: Int) {
        calendarView.changeMonth(monthIndex: monthIndex, year: year)
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
