//
//  HomeViewController.swift
//  Money-Planner
//
//  Created by 유철민 on 1/6/24.
//

import Foundation
import UIKit

class HomeViewController : UIViewController, MainMonthViewDelegate, HomeConsumeViewDelegate, OrderModalDelegate {

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
        label.font = UIFont.mpFont18B()
        label.isUserInteractionEnabled = true
        
        return label
    }()
    
    let arrow_small : UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.image = UIImage(named: "btn_arrow_small")
        return img
    }()
    
    var nowGoal : Goal?
    var dailyList : [CalendarDaily?] = []
    var categoryList : [Category] = [Category(id: -1, name: "전체")]
    var consumeList : [DailyConsume] = []
    
    var statisticsData : Statistics?
        
    var hasNext : Bool = false
    var loading : Bool = false
    
    override func viewDidLoad(){
        contentScrollView.delegate = self
        categoryScrollView.delegate = self
        
        fetchCalendarData()
        fetchCategoryList()
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
        
        setupMonthView()
        setupCategoryView()
        setupCollectionView()
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        calendarView.myCollectionView.collectionViewLayout.invalidateLayout()
        calendarView.navigationController = self.navigationController
    }
    
    // MainMonthView의 delegate
    func didChangeMonth(monthIndex: Int, year: Int) {
        // 값 있을 때는 넘겨주고 없으면 초기화 하기
        calendarView.changeMonth(monthIndex: monthIndex, year: year)
        
        if(collectionView.currentPage == 0){
            fetchChangeMonthCalendarData()
        }else{
            self.consumeList = []
            fetchConsumeData(order: nil, lastDate: nil, lastExpenseId: nil, categoryId: nil)
        }

    }
    
    // HomeConsumeView의 delegate
    func onTapOrder() {
        let vc = OrderModalViewController()
        vc.delegate = self
        present(vc, animated: true)
    }
    
    // OrderModal의 delegate
    func changeOrder(order : String) {
        print("hi")
    }
    
    // ConsumeRecordCell의 delegate
    func didTapCell(_ cell: ConsumeRecordCell) {
        print("소비 내역으로 이동")
        // Create an instance of the detail view controller
        let detailViewController = ConsumeViewController() // Replace with your actual detail view controller clas
        // Push the detail view controller onto the navigation stack
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}



extension HomeViewController{
    
    // 첫번째에만 호출
    func fetchCalendarData(){
        HomeRepository.shared.getHomeNow{
            (result) in
            switch result{
            case .success(let data):
                // 아예 골이 없는 경우
                
                let goal : Goal? = data?.calendarInfo
                
                if(goal != nil){
                    self.nowGoal = goal
                    self.statisticsData = Statistics(totalCost: goal!.totalCost!, goalBudget: goal!.goalBudget!)
                }
                
                
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
    
    // 달력 데이터 가져오기
    func fetchChangeMonthCalendarData(){
        let currentYear = monthView.currentYear
        let currentMonth = monthView.currentMonth
        
        var yearMonthStr = ""
        if(currentMonth >= 10){
            yearMonthStr = "\(currentYear)-\(currentMonth)"
        }else{
            yearMonthStr = "\(currentYear)-0\(currentMonth)"
        }
        
        
        if(self.nowGoal != nil){
            // 목표가 있는 경우
            HomeRepository.shared.getCalendarListWithGoal(goalId: self.nowGoal!.goalID, yearMonth: yearMonthStr){
                (result) in
                switch result{
                case .success(let data):
                    let goal : Goal? = data?.calendarInfo
                    
                    if(goal != nil){
                        self.nowGoal = goal
                    }
                    
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
            
        }else{
            // 목표가 없는 경우
            HomeRepository.shared.getCalendarListWithDate(yearMonth: yearMonthStr){
                (result) in
                switch result{
                case .success(let data):
                    // 아예 골이 없는 경우
                    
                    let goal : Goal? = data?.calendarInfo
                    
                    if(goal != nil){
                        self.nowGoal = goal
                    }
                    
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
    }
    
    func fetchCalendarDataWithCategory(categoryId : Int){
        
        let currentYear = monthView.currentYear
        let currentMonth = monthView.currentMonth
        
        var yearMonthStr = ""
        if(currentMonth >= 10){
            yearMonthStr = "\(currentYear)-\(currentMonth)"
        }else{
            yearMonthStr = "\(currentYear)-0\(currentMonth)"
        }
        
        HomeRepository.shared.getCalendarListWithCategory(goalId: self.nowGoal!.goalID, categoryId: categoryId, yearMonth: yearMonthStr){
            (result) in
            switch result{
            case .success(let data):
                let categoryInfo : Category? = data?.calendarInfo
                if(categoryInfo != nil){
                    self.statisticsData = Statistics(totalCost: categoryInfo!.categoryTotalCost!, goalBudget: categoryInfo!.categoryBudget!)
                }
             
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
    
    func fetchCategoryList(){
        CategoryRepository.shared.getCategoryFilteredList{
            (result) in
            switch result{
            case .success(let data):
                var categoryList = data
                categoryList?.insert(Category(id: -1, name: "전체"), at: 0)
                self.categoryList = categoryList!
                DispatchQueue.main.async {
                    self.setupCategoryView()
                }
                
                
            case .failure(.failure(message: let message)):
                print(message)
            case .failure(.networkFail(let error)):
                print(error)
                print("networkFail in loginWithSocialAPI")
            }
        }
    }
    
    // 목표 리스트에서 목표 바꿨을때
    func fetchChangeGoalData(goalId : Int){
        self.loading = true
        
        HomeRepository.shared.getCalendarListWithGoal(goalId: goalId, yearMonth: nil){
            (result) in
            switch result{
            case .success(let data):
                // 아예 골이 없는 경우
                let goal : Goal? = data?.calendarInfo
                
                if(goal != nil){
                    self.nowGoal = goal
                    
                    self.statisticsData = Statistics(totalCost: goal!.totalCost!, goalBudget: goal!.goalBudget!)
                    
                    self.monthView.updateYearAndMonth(to: self.nowGoal!.startDate!.toDate!)
                    
                    self.calendarView.changeMonth(monthIndex: self.monthView.currentMonth, year: self.monthView.currentYear)
                }
                
                if(data?.dailyList != nil){
                    self.dailyList = data!.dailyList!
                }
                
                DispatchQueue.main.async {
                    self.reloadUI()
                }
                
                self.loading = false
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
    
    // 소비 데이터 불러오기
    func fetchConsumeData(order : String?, lastDate: String?, lastExpenseId: Int?, categoryId: Int?){
        self.loading = true
        
        let dateStr = (monthView.currentMonth >= 10) ? "\(monthView.currentYear)-\(monthView.currentMonth)" : "\(monthView.currentYear)-0\(monthView.currentMonth)"
        
        HomeRepository.shared.getExpenseList(yearMonth: dateStr, size: nil, goalId: self.nowGoal?.goalID, order: order, lastDate: lastDate, lastExpenseId: lastExpenseId, categoryId: categoryId){
            (result) in
            switch result{
            case .success(let data):
                
                self.hasNext = data!.hasNext
                let consumeList = data?.dailyExpenseList ?? []
                self.consumeList = consumeList
                
                DispatchQueue.main.async {
                    self.consumeView.data = self.consumeList
                }
                self.loading = false
                
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
    
    func reloadUI(){
        setupHeader()
        setupMonthView()
        
        // calendarView
        if(self.nowGoal != nil){
            statisticsView.statistics = statisticsData
            calendarView.goal = self.nowGoal
            
            statisticsView.progress = getProgress(numerator: self.statisticsData!.totalCost, denominator: self.statisticsData!.goalBudget)
        }else{
            statisticsView.progress = 0.0
        }
        
        calendarView.dailyList = getDailyList(rawData: self.dailyList)
        
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
        
        let goalText = self.nowGoal?.goalTitle
        
        if (goalText != nil && goalText != ""){
            titleLabel.text = goalText
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(monthViewTapped))
        titleLabel.addGestureRecognizer(tapGesture)
        
        headerView.addSubview(titleLabel)
        headerView.addSubview(arrow_small)
        
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
            
            arrow_small.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 4),
            arrow_small.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])
    }
    
    func setupMonthView(){
        toggleButton.addTarget(self, action: #selector(customToggleButtonTapped), for: .touchUpInside)
        
        monthView.delegate=self
        contentView.addSubview(monthView)
        contentView.addSubview(toggleButton)
        
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
        ])
    }
    
    func setupCategoryView(){
        categoryScrollView.categories = self.categoryList
        contentView.addSubview(categoryScrollView)
        
        NSLayoutConstraint.activate([
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
        categoryScrollView.changeSelectedButton(index: -1)
        
        if(collectionView.currentPage == 0){
            let indexPath = IndexPath(item: 1, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            fetchConsumeData(order: nil, lastDate: nil, lastExpenseId: nil, categoryId: nil)
        }
        
        if(collectionView.currentPage == 1){
            let indexPath = IndexPath(item: 0, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            self.consumeList.removeAll()
            fetchChangeMonthCalendarData()
        }
    }
    
    
    @objc func searchButtonTapped() {
                let vc = SearchConsumeViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func bellButtonTapped() {
                let vc = NotificationViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func menuButtonTapped() {
              let vc = HomeMoreModalViewController()
              vc.delegate = self
              present(vc, animated: true)
    }
    
    @objc func monthViewTapped(){
        let goalListModalVC = GoalListModalViewController()
        goalListModalVC.selectedGoal = nowGoal
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if(collectionView.currentPage == 0 || self.loading){
            return
        }
        
        if scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.bounds.height {
            if self.hasNext {
                fetchConsumeData(order: nil, lastDate: self.consumeList.last?.date, lastExpenseId: self.consumeList.last?.expenseDetailList?.last?.expenseId, categoryId: nil)
            }
        }
    }
}

extension HomeViewController : GoalListModalViewDelegate{
    func changeGoal(goalId: Int) {
        if(collectionView.currentPage == 1){
            let indexPath = IndexPath(item: 0, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            toggleButton.isRight.toggle()
        }
        categoryScrollView.changeSelectedButton(index: -1)
        fetchChangeGoalData(goalId: goalId)
    }
}

extension HomeViewController : CategoryButtonScrollDelegate{
    func onTapChangeCategory(categoryId: Int) {
        
        if(collectionView.currentPage == 0){
            if(categoryId == -1){
               // 전체 일때
                fetchChangeMonthCalendarData()
            }else{
              // 카테고리 일때
                fetchCalendarDataWithCategory(categoryId: categoryId)
            }
        }
        
        if(collectionView.currentPage == 1){
            if(categoryId == -1){
               // 전체 일때
                fetchConsumeData(order: nil, lastDate: nil, lastExpenseId: nil, categoryId: nil)
            }else{
              // 카테고리 일때
                fetchConsumeData(order: nil, lastDate: nil, lastExpenseId: nil, categoryId: categoryId)
            }
        }

    }
}

extension HomeViewController : HomeMoreModalDelegate{
    func selectPage(index: Int) {
        if(index == 0){
            let vc = CategoryEditViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        if(index == 1){
            let vc = RepeatConsumeViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
