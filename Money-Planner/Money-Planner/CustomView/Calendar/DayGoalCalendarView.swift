

import Foundation
import UIKit


class DayGoalCalendarView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    // 0인덱스를 없애기 위해 처리
    var numOfDaysInMonth = [-1,31,28,31,30,31,30,31,31,30,31,30,31]
    
    // 현재 보여주고 있는 달력의 월, 년도
    var currentMonth: Int = 0
    var currentYear: Int = 0
    
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
        firstWeekDayOfMonth=self.getFirstWeekDay()
        
        //for leap years, make february month of 29 days
        if currentMonth == 2 && currentYear % 4 == 0 {
            numOfDaysInMonth[currentMonth] = 29
        }
        //end
        
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
        myCollectionView.register(dayGoalDateCVCell.self, forCellWithReuseIdentifier: "Cell")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getDateCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! dayGoalDateCVCell
        cell.backgroundColor=UIColor.clear
        cell.lbl.text = ""
        
        // 이번달 달력 시작 인덱스
        let startMonthIndex = firstWeekDayOfMonth - 1
        var calcDate : Int
        
        if indexPath.item < startMonthIndex {
            // 이전달 부분
            
            let previousMonth = (currentMonth == 1) ? 12 : currentMonth - 1
            
            calcDate = numOfDaysInMonth[previousMonth] - ((startMonthIndex-1) - indexPath.item)
            cell.isHidden = false
            cell.lbl.text="\(calcDate)"
            
            cell.isUserInteractionEnabled=true
            cell.lbl.textColor = UIColor.mpBlack
            
            let usingMonth = currentMonth == 1 ? 12 : currentMonth - 1
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateString = "\(currentYear)-\(String(format: "%02d", usingMonth))-\(String(format: "%02d", calcDate))"
            if let date = dateFormatter.date(from: dateString), let startDate = self.startDate, let endDate = self.endDate {
                if date >= startDate && date <= endDate { // 기간 안에 있는 경우
                    cell.imageView.image = UIImage(named: "btn_date_off")
                }else{
                    cell.imageView.image = nil
                }
            }
            
        } else {
            calcDate = indexPath.row-firstWeekDayOfMonth+2
            if(calcDate > numOfDaysInMonth[currentMonth]){
                calcDate = calcDate - numOfDaysInMonth[currentMonth]
            }
            cell.isHidden=false
            cell.lbl.text="\(calcDate)"
            
            cell.isUserInteractionEnabled=true
            cell.lbl.textColor = UIColor.mpBlack
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateString = "\(currentYear)-\(String(format: "%02d", currentMonth))-\(String(format: "%02d", calcDate))"
            
            if let date = dateFormatter.date(from: dateString), let startDate = self.startDate, let endDate = self.endDate {
                if date >= startDate && date <= endDate { // 기간 안에 있는 경우
                    cell.imageView.image = UIImage(named: "btn_date_off")
                }else{
                    cell.imageView.image = nil
                }
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell=collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = UIColor.mpMainColor
        let lbl = cell?.subviews[1] as! UILabel
        lbl.textColor=UIColor.white
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
        myCollectionView.reloadData()
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
    
    //GoalDailyVC에서 쓰기 위해 추가
    var startDate: Date?
    var endDate: Date?
    
    //startDate와 endDate 설정후 반영
    func setPeriod(startDate: Date?, endDate: Date?) {
        self.startDate = startDate
        self.endDate = endDate
        self.myCollectionView.reloadData()
    }
}

class dayGoalDateCVCell: UICollectionViewCell {
    let lbl: UILabel = {
        let label = UILabel()
        label.text = "00"
        label.textAlignment = .center
        label.font=UIFont.mpFont16B()
        label.textColor = UIColor.mpBlack
        label.translatesAutoresizingMaskIntoConstraints=false
        return label
    }()
    
    let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = nil
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let dayGoalAmount : UILabel = {
        let label = UILabel()
        label.text = "21,400"
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
            dayGoalAmount.heightAnchor.constraint(equalToConstant: 10),
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
