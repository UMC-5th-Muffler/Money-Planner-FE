//
//  HomeViewController.swift
//  Money-Planner
//
//  Created by 유철민 on 1/6/24.
//

import Foundation
import UIKit

class HomeViewController : UIViewController, MainMonthViewDelegate {
    
    let viewModel = HomeViewModel()
    
    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        
        
        return collectionView
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
    
    let toggleButton : CustomToggleButton = {
        let v = CustomToggleButton()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let consumeView : HomeConsumeView = {
        let v = HomeConsumeView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    lazy var titleLabel : MPLabel = {
        let label = MPLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "목표를 선택해주세요"
        label.textAlignment = .center
        label.font = UIFont.mpFont18M()
        label.isUserInteractionEnabled = true
        
        return label
    }()
    
    var nowGoal : Goal?
    var dailyList : [CalendarDaily?] = []
    
    override func viewDidLoad(){
        fetchData()
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
            
            
            contentView.topAnchor.constraint(equalTo: contentScrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: contentScrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: contentScrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: contentScrollView.contentLayoutGuide.bottomAnchor),
            
            contentView.widthAnchor.constraint(equalTo: contentScrollView.widthAnchor),
        ])
        
        let contentViewHeight = contentView.heightAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor)
        contentViewHeight.priority = .defaultLow
        contentViewHeight.isActive = true
        
        setupMonthAndCategoryView()
        setupCollectionView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        calendarView.myCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    // MainMonthView의 delegate
    func didChangeMonth(monthIndex: Int, year: Int) {
        // 값 있을 때는 넘겨주고 없으면 초기화 하기
        calendarView.changeMonth(monthIndex: monthIndex, year: year)
    }
    
}


extension HomeViewController{
    
    func fetchData(){
        HomeRepository.shared.getHomeNow{
            (result) in
            switch result{
            case .success(let data):
                // 아예 골이 없는 경우
                
                let goal : Goal? = data?.goalInfo
                
                self.nowGoal = goal
                
                if(data?.dailyList != nil){
                    self.dailyList = data!.dailyList!
                }
                
                DispatchQueue.main.async {
                    self.reloadUI()
                }
                
                
            case .failure(.failure(message: let message)):
                print(message)
            case .failure(.networkFail(let error)):
                print(error)
                print("networkFail in loginWithSocialAPI")
            }
        }
    }
    
    func reloadUI(){
        setupHeader()
        setupMonthAndCategoryView()
        
        // calendarView
        if(self.nowGoal != nil){
            statisticsView.goal = self.nowGoal
            
            statisticsView.progress = getProgress(numerator: self.nowGoal!.totalCost!, denominator: self.nowGoal!.goalBudget!)
        }else{
            statisticsView.progress = 0.0
        }
        
        if(!self.dailyList.isEmpty){
            calendarView.dailyList = getDailyList(rawData: self.dailyList)
        }
    }
    
    func setupHeader(){
        
        // 검색 버튼 추가
        let searchButton = UIButton(type: .system)
        searchButton.setImage(UIImage(named: "search"), for: .normal)
        searchButton.tintColor = .mpGray
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        
        let search = UIBarButtonItem(customView: searchButton)
        
        let bellButton = UIButton(type: .system)
        bellButton.setImage(UIImage(named: "bell"), for: .normal)
        bellButton.tintColor = .mpGray
        bellButton.addTarget(self, action: #selector(bellButtonTapped), for: .touchUpInside)
        
        
        let bell = UIBarButtonItem(customView: bellButton)
        
        let menuButton = UIButton(type: .system)
        menuButton.setImage(UIImage(named: "menu"), for: .normal)
        menuButton.tintColor = .mpGray
        menuButton.addTarget(self, action: #selector(menuButtonTapped), for: .touchUpInside)
        
        let menu = UIBarButtonItem(customView: menuButton)
        
        navigationItem.rightBarButtonItems = [menu,bell,search]
        navigationController?.navigationBar.barTintColor = .mpWhite
        navigationController?.navigationBar.shadowImage = UIImage()
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        // 제목 레이블 추가
        
        var goalText = self.nowGoal?.goalTitle
        
        if (goalText != nil && goalText != ""){
            titleLabel.text = goalText
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(monthViewTapped))
        titleLabel.addGestureRecognizer(tapGesture)
        
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
        toggleButton.addTarget(self, action: #selector(customToggleButtonTapped), for: .touchUpInside)
        
        monthView.delegate=self
        contentView.addSubview(monthView)
        contentView.addSubview(toggleButton)
        
        categoryScrollView.categories = viewModel.categories
        
        contentView.addSubview(categoryScrollView)
        
        NSLayoutConstraint.activate([
            monthView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            monthView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            monthView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            monthView.heightAnchor.constraint(equalToConstant: 46),
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
    
    func setupCollectionView(){
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "PagingCell")
        
        contentView.addSubview(collectionView)
        
        let collectionViewHeight =
        collectionView.heightAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor)
        collectionViewHeight.priority = .defaultLow
        collectionViewHeight.isActive = true
        
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: categoryScrollView.bottomAnchor, constant: 36),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    
    func setupCalendarView(cell : UICollectionViewCell){
        
        if(self.nowGoal != nil){
            statisticsView.progress = getProgress(numerator: self.nowGoal!.totalCost!, denominator: self.nowGoal!.goalBudget!)
        }else{
            statisticsView.progress = 0.0
        }
        
        cell.contentView.addSubview(statisticsView)
        
        calendarView.backgroundColor = UIColor.mpWhite
        cell.contentView.addSubview(calendarView)
        
        NSLayoutConstraint.activate([
            statisticsView.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
            statisticsView.rightAnchor.constraint(equalTo: cell.contentView.rightAnchor, constant: -24),
            statisticsView.leftAnchor.constraint(equalTo: cell.contentView.leftAnchor, constant: 24),
            statisticsView.heightAnchor.constraint(equalToConstant: 150),
            
            calendarView.topAnchor.constraint(equalTo: statisticsView.bottomAnchor, constant: 36),
            calendarView.rightAnchor.constraint(equalTo: cell.contentView.rightAnchor),
            calendarView.leftAnchor.constraint(equalTo: cell.contentView.leftAnchor),
            calendarView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: 0),
        ])
    }
    
    func setUpConsumeView(cell : UICollectionViewCell){
        consumeView.data = [
            DailyConsume(date: "1월 17일", dailyTotalCost: 3000, expenseDetailList: [ConsumeDetail(expenseId: 0, title: "아메리카노", cost: 1000, categoryIcon: "1"), ConsumeDetail(expenseId: 1, title: "카페라떼", cost: 1000, categoryIcon: "1"), ConsumeDetail(expenseId: 2, title: "맛있는거", cost: 1000, categoryIcon: "1")]),
            DailyConsume(date: "1월 16일", dailyTotalCost: 3000, expenseDetailList: [ConsumeDetail(expenseId: 0, title: "아메리카노", cost: 1000, categoryIcon: "1"), ConsumeDetail(expenseId: 1, title: "카페라떼", cost: 1000, categoryIcon: "1"), ConsumeDetail(expenseId: 2, title: "맛있는거", cost: 1000, categoryIcon: "1")]),
            DailyConsume(date: "1월 15일", dailyTotalCost: 3000, expenseDetailList: [ConsumeDetail(expenseId: 0, title: "아메리카노", cost: 1000, categoryIcon: "1"), ConsumeDetail(expenseId: 1, title: "카페라떼", cost: 1000, categoryIcon: "1"), ConsumeDetail(expenseId: 2, title: "맛있는거", cost: 1000, categoryIcon: "1")]),
            DailyConsume(date: "1월 14일", dailyTotalCost: 3000, expenseDetailList: [ConsumeDetail(expenseId: 0, title: "아메리카노", cost: 1000, categoryIcon: "1"), ConsumeDetail(expenseId: 1, title: "카페라떼", cost: 1000, categoryIcon: "1"), ConsumeDetail(expenseId: 2, title: "맛있는거", cost: 1000, categoryIcon: "1")])
            
        ]
        
        cell.contentView.addSubview(consumeView)
        
        NSLayoutConstraint.activate([
            consumeView.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
            consumeView.leftAnchor.constraint(equalTo: cell.contentView.leftAnchor, constant: 0),
            consumeView.rightAnchor.constraint(equalTo: cell.contentView.rightAnchor, constant: 0),
            consumeView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: 0),
        ])
    }
    
    
    @objc func customToggleButtonTapped() {
        // 버튼을 탭했을 때 수행할 동작 추가
        if(collectionView.currentPage == 0){
            let indexPath = IndexPath(item: 1, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
        
        if(collectionView.currentPage == 1){
            let indexPath = IndexPath(item: 0, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    
    @objc func searchButtonTapped() {
        //        let vc = SearchConsumeViewController()
        //        vc.hidesBottomBarWhenPushed = true
        //        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func bellButtonTapped() {
        //        let vc = NotificationViewController()
        //        vc.hidesBottomBarWhenPushed = true
        //        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func menuButtonTapped() {
        //        let vc = CategoryEditViewController()
        //        vc.hidesBottomBarWhenPushed = true
        //        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func monthViewTapped(){
        let goalListModalVC = GoalListModalViewController()
        goalListModalVC.delegate = self
        present(goalListModalVC, animated: true)
    }
    
    func getDailyList(rawData : [CalendarDaily?]) -> [CalendarDaily?]{
        var result : [CalendarDaily?] = [CalendarDaily?](repeating: nil, count: calendarView.getDateCount())
        
        for dailyData in rawData {
            let index = calculateIndex(for: dailyData!.date)
            
            result[index] = dailyData
        }
        
        return result
    }
    
    func calculateIndex(for dateString: String) -> Int {
        // 날짜에 해당하는 인덱스 구하기
        
        var index : Int = -1
        
        // 이번달 달력 시작 인덱스(1일)
        let calendarMonth = calendarView.currentMonth
        let numOfDaysInMonth = calendarView.numOfDaysInMonth
        let startMonthIndex = calendarView.firstWeekDayOfMonth - 1
        
        let previousMonth = (calendarMonth == 1) ? 12 : calendarMonth - 1
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: dateString) else {
            return -1
        }
        
        
        let calendar = Calendar.current
        let nowMonth = calendar.component(.month, from: date)
        let nowDay = calendar.component(.day, from: date)
        
        if(previousMonth == nowMonth){
            // 이전달
            index = (startMonthIndex-1) - (numOfDaysInMonth[previousMonth] - nowDay)
            
        }else if(calendarMonth == nowMonth){
            // 이번달
            index = startMonthIndex + nowDay - 1
        }else{
            // 다음달
            index = startMonthIndex + numOfDaysInMonth[calendarMonth] + nowDay - 1
        }
        
        return index
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PagingCell", for: indexPath)
        
        // Remove previous subviews
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        
        if(indexPath.item == 0){
            setupCalendarView(cell: cell)
        }
        
        if(indexPath.item == 1){
            setUpConsumeView(cell: cell)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
}

extension HomeViewController : GoalListModalViewDelegate{
    func changeGoal(category: Category) {
        print("hi")
    }
}

//extension HomeViewController: PopUpModalDelegate {
//    func didTapPresent() {
//            PopUpModalViewController.present(
//                initialView: self,
//                delegate: self)
//        }
//
//    func didTapCancel() {
//        self.dismiss(animated: true)
//    }
//
//    func didTapAccept(){
//
//    }
//}
