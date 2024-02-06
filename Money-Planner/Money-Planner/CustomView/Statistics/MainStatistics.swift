//
//  MainStatistics.swift
//  Money-Planner
//
//  Created by seonwoo on 2024/01/22.
//

import Foundation
import UIKit

class MainStatisticsView : UIView {
    // 게이지의 진행도 (0.0 ~ 1.0)
    
    var goal : Goal? = nil {
        didSet{
            setupView()
        }
    }
    var progress: CGFloat = 0.0 {
        didSet{
            setNeedsDisplay()
        }
    }
    
    
    let useAmountLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hexCode: "#979797")
        label.font = UIFont.mpFont16B()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "사용 금액"
        return label
    }()
    
    let remainAmountLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hexCode: "#979797")
        label.font = UIFont.mpFont14B()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "남은 금액"
        return label
    }()
    
    let useAmount: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.mpBlack
        label.font = UIFont.mpFont26B()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0원"
        return label
    }()
    
    let totalAmount: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hexCode: "#979797")
        label.font = UIFont.mpFont16M()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "/ 0원"
        return label
    }()
    
    let remainAmount: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.mpMainColor
        label.font = UIFont.mpFont14B()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0원"
        return label
    }()
    
    
    let stackView : UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layoutMargins = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
        view.isLayoutMarginsRelativeArrangement = true
        view.layer.cornerRadius = 7
        view.backgroundColor = .mpWhite
        
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupView() {
        backgroundColor = UIColor.clear
        if(goal != nil){
            useAmount.text = goal!.totalCost!.formattedWithSeparator()+"원"
            totalAmount.text = "/ "+goal!.goalBudget!.formattedWithSeparator() + "원"
            remainAmount.text = (goal!.goalBudget!-goal!.totalCost!).formattedWithSeparator() +  "원"
        }
        
        addSubview(useAmountLabel)
        addSubview(useAmount)
        addSubview(totalAmount)
        
        stackView.addArrangedSubview(remainAmountLabel)
        stackView.addArrangedSubview(remainAmount)
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            useAmountLabel.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            useAmountLabel.leftAnchor.constraint(equalTo: leftAnchor),
            useAmount.topAnchor.constraint(equalTo: useAmountLabel.bottomAnchor, constant: 4),
            useAmount.leftAnchor.constraint(equalTo: leftAnchor),
            totalAmount.topAnchor.constraint(equalTo: useAmount.bottomAnchor, constant: 0),
            totalAmount.leftAnchor.constraint(equalTo: leftAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            stackView.leftAnchor.constraint(equalTo: leftAnchor),
        ])
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawDonutChart()
    }
    
    private func drawDonutChart() {
        //        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        let center = CGPoint(x: bounds.width - 75, y: 75)
        //        let radius = min(bounds.width, bounds.height) / 2 - 20 // 게이지의 반지름
        let radius = CGFloat(150 / 2 - 10) // 게이지의 반지름
        let lineWidth: CGFloat = 18 // 게이지의 두께
        
        let startAngle: CGFloat = -.pi / 2
        let endAngle: CGFloat = startAngle + (2 * .pi * progress)
        
        // 회색 배경 도넛
        let emptyPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: startAngle + (2 * .pi), clockwise: true)
        emptyPath.lineWidth = lineWidth
        UIColor(hexCode: "#E3E3E3").setStroke()
        emptyPath.stroke()
        
        // 게이지 도넛
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        path.lineWidth = lineWidth
        path.lineCapStyle = .round
        UIColor.mpMainColor.setStroke()
        path.stroke()
    }
}
