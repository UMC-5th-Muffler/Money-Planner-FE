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
        if let originalImage = UIImage(named: "btn_date_next") {
            let flippedImage = UIImage(cgImage: originalImage.cgImage!, scale: originalImage.scale, orientation: .upMirrored)
            // 뒤집어진 이미지 사용
            btn.setImage(flippedImage, for: .normal)
        }
        btn.tintColor = .mpBlack
        btn.translatesAutoresizingMaskIntoConstraints=false
        btn.addTarget(self, action: #selector(btnLeftRightAction(sender:)), for: .touchUpInside)
        return btn
    }()
    
    let btnLeft: UIButton = {
        let btn=UIButton()
        btn.setImage(UIImage(named: "btn_date_next"), for: .normal)
        btn.tintColor = .mpBlack
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
        monthLabel.text = "\(currentYear)년 \(currentMonth)월"
        monthLabel.font = UIFont.mpFont20B()
        
        self.addSubview(btnLeft)
        btnLeft.topAnchor.constraint(equalTo: topAnchor).isActive=true
        btnLeft.rightAnchor.constraint(equalTo: monthLabel.leftAnchor, constant: -10).isActive = true
        
        btnLeft.heightAnchor.constraint(equalTo: monthLabel.heightAnchor, constant: -3).isActive=true
    
        
        self.addSubview(btnRight)
        btnRight.topAnchor.constraint(equalTo: topAnchor).isActive=true
        btnRight.leftAnchor.constraint(equalTo: monthLabel.rightAnchor, constant: 10).isActive = true
        btnRight.heightAnchor.constraint(equalTo: monthLabel.heightAnchor, constant: -3).isActive=true
        
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
    
    func updateYearAndMonth (to date: Date) {
        let calendar = Calendar.current

        let year = calendar.component(.year, from: date) // 년도 추출
        let month = calendar.component(.month, from: date) // 월 추출
        self.currentYear = year
        self.currentMonth = month
        
        monthLabel.text="\(currentYear)년 \(currentMonth)월"
    }
    
}
