//
//  HomeViewController.swift
//  Money-Planner
//
//  Created by 유철민 on 1/6/24.
//

import Foundation
import UIKit

class HomeViewController : UIViewController, MainMonthViewDelegate {
    
    lazy var pageViewController: UIPageViewController = {
        let vc = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        
        return vc
    }()
    
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
        view.backgroundColor = UIColor(hexCode: "F5F6FA")
        return view
    }()
    
    let headerView = UIView()
    
    let monthView: MainMonthView = {
        let v = MainMonthView()
        v.translatesAutoresizingMaskIntoConstraints=false
        return v
    }()
    
    var categoryScrollView : CategoryButtonsScrollView = {
        let v = CategoryButtonsScrollView()
        v.translatesAutoresizingMaskIntoConstraints=false
        return v
    }()
    
    
    var statisticsView : MainStatisticsView = {
        let v = MainStatisticsView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let calendarView : MainCalendarView = {
        let v = MainCalendarView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let toggleButton : ToggleButton = {
        let v = ToggleButton()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let consumeView : HomeConsumeView = {
        let v = HomeConsumeView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    override func viewDidLoad(){
        view.backgroundColor = UIColor.mpWhite
        view.addSubview(contentScrollView)
        contentScrollView.addSubview(contentView)
        
        setupHeader()
        
        // 스크롤 뷰 작업
        NSLayoutConstraint.activate([
            contentScrollView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 12),
            contentScrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            contentScrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            contentScrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: contentScrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: contentScrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: contentScrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: contentScrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: contentScrollView.widthAnchor)
        ])
        
        setupMonthAndCategoryView()
        
                                setupCalendarView()
        //        setUpConsumeView()
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
        navigationController?.navigationBar.barTintColor = .mpWhite
        navigationController?.navigationBar.shadowImage = UIImage()
        
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
            headerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 4),
            
            headerView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            headerView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            headerView.heightAnchor.constraint(equalToConstant: 25),
            
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
        ])
    }
    
    func setupMonthAndCategoryView(){
        monthView.delegate=self
        contentView.addSubview(monthView)
        contentView.addSubview(toggleButton)
        
        categoryScrollView.categories = [Category(id: 0, name: "전체"), Category(id: 1, name: "식사"), Category(id: 2, name: "카페"), Category(id: 3, name: "교통"), Category(id: 4, name: "쇼핑")]
        
        contentView.addSubview(categoryScrollView)
        
        NSLayoutConstraint.activate([
            monthView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            monthView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            monthView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            monthView.heightAnchor.constraint(equalToConstant: 35),
            monthView.centerYAnchor.constraint(equalTo: toggleButton.centerYAnchor),
            
            toggleButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            toggleButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            toggleButton.widthAnchor.constraint(equalToConstant: 154),
            toggleButton.heightAnchor.constraint(equalToConstant: 46),
            
            categoryScrollView.topAnchor.constraint(equalTo: monthView.bottomAnchor,
                                                    constant: 24),
            categoryScrollView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            categoryScrollView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            categoryScrollView.heightAnchor.constraint(equalToConstant: 37)
            
        ])
    }
    
    
    func setupCalendarView(){
        
        statisticsView.progress = 0.7
        view.addSubview(statisticsView)
        
        calendarView.backgroundColor = UIColor.mpWhite
        contentView.addSubview(calendarView)
        
        
        NSLayoutConstraint.activate([
            statisticsView.topAnchor.constraint(equalTo: categoryScrollView.bottomAnchor, constant: 36),
            statisticsView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -24),
            statisticsView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 24),
            statisticsView.heightAnchor.constraint(equalToConstant: 150),
            
            calendarView.topAnchor.constraint(equalTo: statisticsView.bottomAnchor, constant: 36),
            calendarView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            calendarView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            calendarView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            calendarView.heightAnchor.constraint(equalToConstant: 1000)
        ])
    }
    
    func setUpConsumeView(){
        
        consumeView.data = [
            DailyConsume(date: "1월 17일", dailyTotalCost: 3000, expenseDetailList: [ConsumeDetail(expenseId: 0, title: "아메리카노", cost: 1000, categoryIcon: "1"), ConsumeDetail(expenseId: 1, title: "카페라떼", cost: 1000, categoryIcon: "1"), ConsumeDetail(expenseId: 2, title: "맛있는거", cost: 1000, categoryIcon: "1")]),
            DailyConsume(date: "1월 16일", dailyTotalCost: 3000, expenseDetailList: [ConsumeDetail(expenseId: 0, title: "아메리카노", cost: 1000, categoryIcon: "1"), ConsumeDetail(expenseId: 1, title: "카페라떼", cost: 1000, categoryIcon: "1"), ConsumeDetail(expenseId: 2, title: "맛있는거", cost: 1000, categoryIcon: "1")]),
            DailyConsume(date: "1월 15일", dailyTotalCost: 3000, expenseDetailList: [ConsumeDetail(expenseId: 0, title: "아메리카노", cost: 1000, categoryIcon: "1"), ConsumeDetail(expenseId: 1, title: "카페라떼", cost: 1000, categoryIcon: "1"), ConsumeDetail(expenseId: 2, title: "맛있는거", cost: 1000, categoryIcon: "1")]),
            DailyConsume(date: "1월 14일", dailyTotalCost: 3000, expenseDetailList: [ConsumeDetail(expenseId: 0, title: "아메리카노", cost: 1000, categoryIcon: "1"), ConsumeDetail(expenseId: 1, title: "카페라떼", cost: 1000, categoryIcon: "1"), ConsumeDetail(expenseId: 2, title: "맛있는거", cost: 1000, categoryIcon: "1")])
            
        ]
        
        contentView.addSubview(consumeView)
        
        NSLayoutConstraint.activate([
            consumeView.topAnchor.constraint(equalTo: categoryScrollView.bottomAnchor, constant: 24),
            consumeView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0),
            consumeView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0),
            consumeView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            consumeView.heightAnchor.constraint(equalToConstant: 1000)
            
        ])
    }
    
    
//    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
//        // 페이지 이동 전 호출
//        guard let index = pageViewController.viewControllers?.first?.view.tag else { return nil }
//
//        let previousIndex = index - 1
//
//        if previousIndex < 0 || viewControllerList.count <= previousIndex {
//            return nil
//        }
//
//        return viewControllerList[previousIndex]
//    }
//
//
//
//    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
//        // 페이지 이동 후 호출
//        guard let index = pageViewController.viewControllers?.first?.view.tag else { return nil }
//
//        let nextIndex = index + 1
//
//        if viewControllerList.count <= nextIndex {
//            return nil
//        }
//
//        return viewControllerList[nextIndex]
//    }
    
    
    
    
    @objc func searchButtonTapped() {
        // 왼쪽 버튼이 탭되었을 때의 동작
        print("Search button tapped")
    }
    
    @objc func plusButtonTapped() {
        // 오른쪽 버튼이 탭되었을 때의 동작
        print("Plus button tapped")
    }
}
