//
//  MainMonthView.swift
//  Money-Planner
//
//  Created by seonwoo on 2024/01/20.
//

import Foundation
import UIKit

protocol MainMonthViewDelegate{
    func didChangeMonth(monthIndex: Int, year: Int)
}

class MainMonthView: UIView {
    var currentYear : Int = 0
    var currentMonth : Int = 0
    var delegate : MainMonthViewDelegate?
    
    //    var yearAndMonth: String = "0000.00" {
    //        didSet {
    //            let year = yearAndMonth.split (separator: ".") [0]
    //            var month = yearAndMonth.split(separator: ".") [1]
    //            if Int(month)! < 10 {
    //                month = "O" + month
    //            }
    //            yearAndMonth = String(year + "." + month)
    //            monthLabel.text = yearAndMonth
    //        }
    //    }
    
    var monthLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = UIColor.black
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont (ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let btnRight: UIButton = {
        let btn=UIButton()
        btn.setTitle(">", for: .normal)
        btn.setTitleColor(UIColor.mpBlack, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints=false
        btn.addTarget(self, action: #selector(btnLeftRightAction(sender:)), for: .touchUpInside)
        return btn
    }()
    
    let btnLeft: UIButton = {
        let btn=UIButton()
        btn.setTitle("<", for: .normal)
        btn.setTitleColor(UIColor.mpBlack, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints=false
        btn.addTarget(self, action: #selector(btnLeftRightAction(sender:)), for: .touchUpInside)
        btn.setTitleColor(UIColor.lightGray, for: .disabled)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        currentYear = Calendar.current.component (.year, from: Date())
        currentMonth = Calendar.current.component (.month, from: Date ())
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpViews() {
        self.addSubview(monthLabel)
        monthLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        monthLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        monthLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 28).isActive = true
        monthLabel.widthAnchor.constraint(equalToConstant:200).isActive=true
        monthLabel.text = "\(currentYear)년 \(currentMonth)월"
        
        self.addSubview(btnRight)
        btnRight.topAnchor.constraint(equalTo: topAnchor).isActive=true
        btnRight.rightAnchor.constraint(equalTo: rightAnchor).isActive=true
        btnRight.widthAnchor.constraint(equalToConstant: 50).isActive=true
        btnRight.heightAnchor.constraint(equalTo: heightAnchor).isActive=true
        
        self.addSubview(btnLeft)
        btnLeft.topAnchor.constraint(equalTo: topAnchor).isActive=true
        btnLeft.leftAnchor.constraint(equalTo: leftAnchor).isActive=true
        btnLeft.widthAnchor.constraint(equalToConstant: 50).isActive=true
        btnLeft.heightAnchor.constraint(equalTo: heightAnchor).isActive=true
    }
    
    @objc func btnLeftRightAction(sender: UIButton) {
        if sender == btnRight {
            currentMonth += 1
            if currentMonth > 12 {
                currentMonth = 1
                currentYear += 1
            }
        } else {
            currentMonth -= 1
            if currentMonth < 1 {
                currentMonth = 12
                currentYear -= 1
            }
        }
        monthLabel.text="\(currentYear)년 \(currentMonth)월"
        delegate?.didChangeMonth(monthIndex: currentMonth, year: currentYear)
    }
    
    //    func updateYearAndMonth (to date: Date) {
    //        let year = date.year
    //        let month = date.month
    //        yearAndMonth = "\(year).\(month)"
    //    }
    
}
