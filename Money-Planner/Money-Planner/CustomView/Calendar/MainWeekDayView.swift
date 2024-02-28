//
//  MainWeekDayView.swift
//  Money-Planner
//
//  Created by seonwoo on 2024/01/20.
//

import Foundation
import UIKit

class MainWeekDayView: UIView {
    var weekdayArray: [String] = ["일", "월", "화", "수", "목", "금", "토"]
    
    override init(frame: CGRect) {
        super.init (frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Do Not Use on Storyboard")
    }
    
    private func setupViews() {
        addSubview(weekdayCollectionView)
        weekdayCollectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        weekdayCollectionView.bottomAnchor.constraint(equalTo:bottomAnchor).isActive=true 
        weekdayCollectionView.leftAnchor.constraint(equalTo:leftAnchor).isActive=true 
        weekdayCollectionView.rightAnchor.constraint(equalTo:rightAnchor).isActive=true
    }
    
    lazy var weekdayCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout ()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.showsVerticalScrollIndicator=false 
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.allowsSelection = false
        collectionView.isScrollEnabled = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(WeekdayCVCell.self,forCellWithReuseIdentifier:WeekdayCVCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints=false
        return collectionView
    }()
}


extension MainWeekDayView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection numberOfItemsInSectionsection: Int) -> Int {
        return 7
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:WeekdayCVCell.identifier,for:indexPath)
                as? WeekdayCVCell else { return UICollectionViewCell() }
        cell.configureWeekday(to: weekdayArray [indexPath.row])
        return cell
    }   
}

extension MainWeekDayView : UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 32) / 7
        let height: CGFloat = 11
        return CGSize(width: width, height: height)
    }
}

class WeekdayCVCell: UICollectionViewCell {
    static let identifier: String = "WeekdayCVCell"

    let weekdayLabel: UILabel = {
        var label = UILabel()
        label.text = "MON"
        label.textAlignment = .center
        label.textColor = UIColor(hexCode: "979797")
        label.font = UIFont.mpFont14B()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init (frame: frame)
        setUpView()
    }

    private func setUpView() {
        addSubview(weekdayLabel)
        weekdayLabel.topAnchor.constraint(equalTo: topAnchor, constant: 28).isActive = true
        weekdayLabel.heightAnchor.constraint(equalToConstant: 23).isActive = true
        weekdayLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        weekdayLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }

    func configureWeekday(to week: String) {
        weekdayLabel.text = week
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
