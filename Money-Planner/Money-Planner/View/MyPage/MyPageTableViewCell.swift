//
//  cell.swift
//  Money-Planner
//
//  Created by p_kxn_g on 1/30/24.
//

import Foundation
import UIKit
class MyPageTableViewCell: UITableViewCell {
    let container : UIView = {
        let view = UIView()
        //view.backgroundColor = .red
        return view
    }()
    // 셀에 추가할 이미지 뷰
    let cellImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName:"chevron.forward")
        imageView.tintColor = .mpDarkGray

        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    let optionalLabel : MPLabel = {
        let label = MPLabel()
        label.font = UIFont.mpFont16M()
        label.textColor = .mpDarkGray
        label.text = ""
        return label
    }()

    let userName : MPLabel = {
        let label = MPLabel()
        label.font = UIFont.mpFont20B()
        label.textColor = .mpBlack
        return label
    }()
    let userImage : UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .mpGypsumGray
        imageView.layer.cornerRadius = 32 //지름 64
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        //imageView.image = UIImage(systemName: "pencil")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
        }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        // 셀에 이미지 뷰를 추가
        addSubview(container)
        container.addSubview(cellImageView)
        container.addSubview(optionalLabel)
        container.translatesAutoresizingMaskIntoConstraints = false
        cellImageView.translatesAutoresizingMaskIntoConstraints = false
        optionalLabel.translatesAutoresizingMaskIntoConstraints = false

        //addSubview(alarmSettingLabel)
        // 이미지 뷰에 대한 제약 조건 설정
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: topAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor,constant:-25),
            container.bottomAnchor.constraint(equalTo: bottomAnchor),
            container.widthAnchor.constraint(equalToConstant: 89),
            cellImageView.topAnchor.constraint(equalTo: container.topAnchor),
            cellImageView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            cellImageView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            cellImageView.widthAnchor.constraint(equalToConstant: 8),// 이미지 뷰의 폭 조정
            optionalLabel.topAnchor.constraint(equalTo: container.topAnchor),
            optionalLabel.trailingAnchor.constraint(equalTo: cellImageView.leadingAnchor, constant: -13),
            optionalLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            //alarmSettingLabel.heightAnchor.constraint(equalToConstant: 22),
            //larmSettingLabel.trailingAnchor.constraint(equalTo: cellImageView.leadingAnchor,constant:13),
            //alarmSettingLabel.widthAnchor.constraint(equalToConstant: 24) // 이미지 뷰의 폭 조정
            
        ])
    }
    func addProfile (_ name : String, image : UIImage?){
        let blank : UIView = {
            let view = UIView()
            view.backgroundColor = .mpGypsumGray
            return view
        }()
        userName.text = "\(name)님"
        userImage.image = image
        
        container.addSubview(userImage)
        container.addSubview(userName)
        container.addSubview(blank)

        userImage.translatesAutoresizingMaskIntoConstraints = false
        userName.translatesAutoresizingMaskIntoConstraints = false
        blank.translatesAutoresizingMaskIntoConstraints = false

        
        NSLayoutConstraint.activate([
            userImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            userImage.leadingAnchor.constraint(equalTo: leadingAnchor,constant:16),
            userImage.widthAnchor.constraint(equalToConstant: 64),
            userImage.heightAnchor.constraint(equalToConstant: 64),
        // 유저 네임에 해당하는 라벨 오른쪽으로 옮기기
            userName.centerYAnchor.constraint(equalTo: centerYAnchor),
            userName.leadingAnchor.constraint(equalTo:userImage.trailingAnchor,constant:24),
            blank.leadingAnchor.constraint(equalTo: leadingAnchor),
            blank.trailingAnchor.constraint(equalTo: trailingAnchor),
            blank.heightAnchor.constraint(equalToConstant: 8),
            blank.bottomAnchor.constraint(equalTo: bottomAnchor),

        ])
        
    }
    func setUserName(_ name: String) { // 사용자 이름 업데이트
           userName.text = "\(name)님"
       }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
