//
//  HomeViewController.swift
//  Money-Planner
//
//  Created by 유철민 on 1/6/24.
//

import Foundation
import UIKit

class HomeViewController : UIViewController, MainMonthViewDelegate {
    
    private let contentScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .white
        scrollView.showsVerticalScrollIndicator = false
        
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let headerView = UIView()
    
    let monthView: MainMonthView = {
        let v = MainMonthView()
        v.translatesAutoresizingMaskIntoConstraints=false
        return v
    }()
    
    var categoryScrollView : CategoryScrollView = {
        let v = CategoryScrollView()
        v.translatesAutoresizingMaskIntoConstraints=false
        return v
    }()
    
    var categoryButton : CategoryButton = {
        let v = CategoryButton()
        v.translatesAutoresizingMaskIntoConstraints=false
        return v
    }()
    
    let calendarView : MainCalendarView = {
        let v = MainCalendarView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    override func viewDidLoad(){
        view.backgroundColor = UIColor.mpWhite
        view.addSubview(contentScrollView)
        contentScrollView.addSubview(contentView)
        
        // 스크롤 뷰 작업
        NSLayoutConstraint.activate([
            contentScrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            contentScrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            contentScrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            contentScrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: contentScrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: contentScrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: contentScrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: contentScrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: contentScrollView.widthAnchor)
        ])
        
        setupHeader()
        setupMonthAndCategoryView()
        setupCalendarView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        calendarView.myCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    
    // MainMonthView의 delegate
    func didChangeMonth(monthIndex: Int, year: Int) {
        calendarView.changeMonth(monthIndex: monthIndex, year: year)
    }
    
}


extension HomeViewController{
    
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
        contentView.addSubview(headerView)
        
        // Auto Layout 설정
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            headerView.heightAnchor.constraint(equalToConstant: 25),
            
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
        ])
    }
    
    func setupMonthAndCategoryView(){
        monthView.delegate=self
        contentView.addSubview(monthView)
        monthView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20).isActive=true
        monthView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive=true
        monthView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive=true
        monthView.heightAnchor.constraint(equalToConstant: 35).isActive=true
        
        //        categoryScrollView.categories = [Category(id: 0, name: "전체"), Category(id: 1, name: "식사"), Category(id: 2, name: "카페"), Category(id: 3, name: "교통"), Category(id: 4, name: "쇼핑")]
        //        view.addSubview(categoryScrollView)
        
        //        categoryButton.category = Category(id: 0, name: "식사")
        //        view.addSubview(categoryButton)
        
        //        categoryButton.topAnchor.constraint(equalTo: monthView.bottomAnchor, constant: 100).isActive = true
        
        //        categoryScrollView.topAnchor.constraint(equalTo: monthView.bottomAnchor,
        //                                                constant: 100).isActive = true
    }
    
    
    func setupCalendarView(){
        contentView.addSubview(calendarView)
        calendarView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 200).isActive=true
        calendarView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -12).isActive=true
        calendarView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 12).isActive=true
        calendarView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 100).isActive = true
        calendarView.heightAnchor.constraint(equalToConstant: 2000).isActive = true
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
