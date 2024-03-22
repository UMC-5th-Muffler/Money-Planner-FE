//
//  MainCalendarView.swift
//  Money-Planner
//
//  Created by seonwoo on 2024/01/20.
//

import Foundation
import UIKit


class MainCalendarView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var dailyList : [CalendarDaily?] = []{
        didSet{
            myCollectionView.reloadData()
        }
    }
    
    var navigationController: UINavigationController?
    
    var goal : Goal?
    
    // 0인덱스를 없애기 위해 처리
    var numOfDaysInMonth = [-1,31,28,31,30,31,30,31,31,30,31,30,31]
    
    // 현재 보여주고 있는 달력의 월, 년도
    var currentMonth: Int = 0
    var currentYear: Int = 0
    
    // 실제 오늘 날짜
    var presentMonth = 0
    var presentYear = 0
    var todaysDate = 0
    var firstWeekDayOfMonth = 0   //(Sunday-Saturday 1-7)
    
    let weekdaysView: MainWeekDayView = {
        let v = MainWeekDayView()
        v.translatesAutoresizingMaskIntoConstraints=false
        return v
    }()
    
    let myCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let myCollectionView=UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        myCollectionView.showsHorizontalScrollIndicator = false
        myCollectionView.translatesAutoresizingMaskIntoConstraints=false
        myCollectionView.backgroundColor=UIColor.clear
        myCollectionView.allowsMultipleSelection=false
        myCollectionView.isScrollEnabled = false
        return myCollectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        currentMonth = Calendar.current.component(.month, from: Date())
        currentYear = Calendar.current.component(.year, from: Date())
        todaysDate = Calendar.current.component(.day, from: Date())
        firstWeekDayOfMonth=self.getFirstWeekDay()
        
        //for leap years, make february month of 29 days
        if currentMonth == 2 && currentYear % 4 == 0 {
            numOfDaysInMonth[currentMonth] = 29
        }
        //end
        
        presentMonth=currentMonth
        presentYear=currentYear
        
        dailyList = [CalendarDaily?](repeating: nil, count: getDateCount())
        initializeView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 적용하고자 하는 둥근 모서리의 크기
        let cornerRadius: CGFloat = 20.0
        
        // UIBezierPath를 사용하여 상단 부분에만 둥근 모서리를 생성
        let maskPath = UIBezierPath(roundedRect: bounds,
                                    byRoundingCorners: [.topLeft, .topRight],
                                    cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        
        // CAShapeLayer를 생성하고 mask로 사용
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        layer.mask = maskLayer
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func initializeView() {
        setupViews()
        
        myCollectionView.delegate=self
        myCollectionView.dataSource=self
        myCollectionView.register(dateCVCell.self, forCellWithReuseIdentifier: "Cell")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getDateCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! dateCVCell
        cell.backgroundColor=UIColor.clear
        cell.dayGoalAmount.text = ""
        cell.dayConsumeAmount.text = ""
        cell.imageView.image = UIImage(named: "btn_date_off")
        cell.lbl.text = ""
        cell.dayConsumeAmount.textColor = UIColor.mpDarkGray
        
        // 이번달 달력 시작 인덱스
        let startMonthIndex = firstWeekDayOfMonth - 1
        
        if indexPath.item < startMonthIndex {
            // 이전달 부분
            
//            let previousMonth = (currentMonth == 1) ? 12 : currentMonth - 1
//            
//            let calcDate = numOfDaysInMonth[previousMonth] - ((startMonthIndex-1) - indexPath.item)
//            cell.isHidden=false
//            cell.lbl.text="\(calcDate)"
//            
//            cell.isUserInteractionEnabled=true
//            cell.lbl.textColor = UIColor.mpBlack
//            cell.imageView.image = nil
            cell.isHidden = true
            
        } else {
            var calcDate = indexPath.row-firstWeekDayOfMonth+2
            if(calcDate > numOfDaysInMonth[currentMonth]){
                // 다음달 부분
                calcDate = calcDate - numOfDaysInMonth[currentMonth]
                cell.isHidden = true
            }else{
                cell.isHidden=false
            }
            cell.lbl.text="\(calcDate)"
            
            cell.isUserInteractionEnabled=true
            cell.lbl.textColor = UIColor.mpBlack
        }
        
        let daily = dailyList[indexPath.item]
        
        if(daily != nil){
            if(self.goal != nil && daily!.date.toDate!.isInRange(startDate: self.goal!.startDate!.toDate!, endDate: self.goal!.endDate!.toDate!)){
                // 목표가 있고 목표 안의 범위 일 경우
                               
                // 평가 이미지
                if(daily!.dailyRate == "HIGH"){
                    cell.imageView.image = UIImage(named: "btn_date_green")
                    
                    if let zeroday = daily!.isZeroDay, zeroday{
                        cell.imageView.image = UIImage(named: "btn_date_zero_green")
                    }
                }else if(daily!.dailyRate == "MEDIUM"){
                    cell.imageView.image = UIImage(named: "btn_date_yellow")
                    
                    if let zeroday = daily!.isZeroDay, zeroday{
                        cell.imageView.image = UIImage(named: "btn_date_zero_yellow")
                    }
                }else if(daily!.dailyRate == "LOW"){
                    cell.imageView.image = UIImage(named: "btn_date_red")
                    
                    if let zeroday = daily!.isZeroDay, zeroday{
                        cell.imageView.image = UIImage(named: "btn_date_zero_red")
                    }
                }else{
                    cell.imageView.image = UIImage(named: "btn_date_on")
                    if let zeroday = daily!.isZeroDay, zeroday{
                        cell.imageView.image = UIImage(named: "btn_date_zero_grey")
                        cell.lbl.text = ""
                    }
                }
                
                if(daily!.dailyTotalCost != nil){
                    cell.dayConsumeAmount.text = daily!.dailyTotalCost?.formattedWithSeparator()
                }
                
                if(daily!.dailyBudget != nil){
                    cell.dayGoalAmount.text = daily!.dailyBudget?.formattedWithSeparator()
                }
                
                // 예산
                if(daily!.dailyBudget != nil){
                    cell.dayGoalAmount.text = daily!.dailyBudget?.formattedWithSeparator()
                    
                    if(daily!.dailyTotalCost != nil){
                        // 예산과 소비액 둘다 있을 경우 색상 처리
                        if(daily!.dailyBudget! >= daily!.dailyTotalCost!){
                            cell.dayConsumeAmount.textColor = .mpMainColor
                        }else{
                            cell.dayConsumeAmount.textColor = .mpRed
                        }
                        
                    }
                }
                
                // 소비액
                if(daily!.dailyTotalCost != nil){
                    cell.dayConsumeAmount.text = daily!.dailyTotalCost?.formattedWithSeparator()
                }
                
                
            }else{
                // 목표 밖의 범위 이지만 daily가 있는 경우
                
                // 평가 이미지
                if(daily!.dailyRate == "HIGH"){
                    cell.imageView.image = UIImage(named: "btn_date_green_off")
                }else if(daily!.dailyRate == "MEDIUM"){
                    cell.imageView.image = UIImage(named: "btn_date_yellow_off")
                }else if(daily!.dailyRate == "LOW"){
                    cell.imageView.image = UIImage(named: "btn_date_red_off")
                }else{
                    cell.imageView.image = UIImage(named: "btn_date_goal-yes_off")
                    cell.lbl.textColor = .mpGray
                }
                
                
            }
            
            if(daily!.dailyRate != nil){
                cell.lbl.text = ""
            }
            
        }else{
            cell.imageView.image = UIImage(named: "btn_date_off")
            cell.lbl.textColor = .mpGray
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("각각의 cell 클릭")
        let daily = dailyList[indexPath.item]
        
        if(daily != nil){
            let cell=collectionView.cellForItem(at: indexPath)
            
            //각 셀을 누르면 해당 날짜의 소비내역 화면으로 이동
            let vc = DailyConsumeViewController()
            vc.hidesBottomBarWhenPushed = true
            vc.dateText = daily!.date
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell=collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor=UIColor.clear
        let lbl = cell?.subviews[1] as! UILabel
        lbl.textColor = UIColor.mpBlack
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width/7 - 8
        let height: CGFloat = width + 30
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func getFirstWeekDay() -> Int {
        let day = ("\(currentYear)-\(currentMonth)-01".toDate?.firstDayOfTheMonth.weekday)!
        //return day == 7 ? 1 : day
        return day
    }
    
    func changeMonth(monthIndex: Int, year: Int) {
        currentMonth=monthIndex
        currentYear = year
        
        if monthIndex == 2 {
            if currentYear % 4 == 0 {
                numOfDaysInMonth[monthIndex] = 29
            } else {
                numOfDaysInMonth[monthIndex] = 28
            }
        }
        //end
        
        firstWeekDayOfMonth=getFirstWeekDay()
        // 데이터 변경은 HomeViewController의 fetchChangeMonthData에서 함
    }
    
    func setupViews() {
        
        addSubview(weekdaysView)
        weekdaysView.topAnchor.constraint(equalTo: topAnchor).isActive=true
        weekdaysView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive=true
        weekdaysView.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive=true
        weekdaysView.heightAnchor.constraint(equalToConstant: 28 + 23).isActive=true
        
        addSubview(myCollectionView)
        myCollectionView.topAnchor.constraint(equalTo: weekdaysView.bottomAnchor, constant: 12).isActive=true
        myCollectionView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive=true
        myCollectionView.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive=true
        myCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive=true
    }
    
    func getDateCount() -> Int{
        let cellCount = numOfDaysInMonth[currentMonth] + firstWeekDayOfMonth - 1
        // 7의 배수여야 한다.
        let dateCount = cellCount % 7 == 0 ? cellCount : cellCount + (7 - cellCount % 7)
        return dateCount
    }
}

class dateCVCell: UICollectionViewCell {
    let lbl: UILabel = {
        let label = UILabel()
        label.text = "00"
        label.textAlignment = .center
        label.font=UIFont.mpFont16M()
        label.textColor = UIColor.mpBlack
        label.translatesAutoresizingMaskIntoConstraints=false
        return label
    }()
    
    let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "btn_date_off")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let dayGoalAmount : UILabel = {
        let label = UILabel()
        label.text = nil
        label.textAlignment = .center
        label.font=UIFont.mpFont10R()
        label.textColor = UIColor.mpDarkGray
        label.translatesAutoresizingMaskIntoConstraints=false
        return label
    }()
    
    let dayConsumeAmount : UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .center
        label.font=UIFont.mpFont10R()
        label.textColor = UIColor.mpDarkGray
        label.translatesAutoresizingMaskIntoConstraints=false
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor=UIColor.clear
        layer.cornerRadius=5
        layer.masksToBounds=true
        
        setupViews()
    }
    
    func setupViews() {
        addSubview(imageView)
        addSubview(lbl)
        addSubview(dayGoalAmount)
        addSubview(dayConsumeAmount)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leftAnchor.constraint(equalTo: leftAnchor),
            imageView.rightAnchor.constraint(equalTo: rightAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            
            lbl.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            lbl.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            lbl.heightAnchor.constraint(equalToConstant: 16),
            
            dayGoalAmount.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            dayGoalAmount.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            
            dayConsumeAmount.topAnchor.constraint(equalTo: dayGoalAmount.bottomAnchor, constant: 2),
            dayConsumeAmount.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            dayConsumeAmount.heightAnchor.constraint(equalToConstant: 10),
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
