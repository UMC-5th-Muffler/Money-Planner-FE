//
//  NotificationSettingViewController.swift
//  Money-Planner
//
//  Created by Jini on 2024/02/13.
//

import Foundation
import UIKit

class NotificationSettingViewController : UIViewController {
    
    let cellSpacingHeight: CGFloat = 1
    
    let titleLabel : MPLabel = {
        let label = MPLabel()
        label.text = "알림 설정"
        label.font = UIFont.mpFont26B()
        label.textColor = UIColor(named:"black")
        
        return label
    }()
    
    let settingTableView = UITableView()
    
    let controlswitch1: UISwitch = {
        let s = UISwitch()
        s.setOn(false, animated: true)
        return s
    }()
    
    let controlswitch2: UISwitch = {
        let s = UISwitch()
        s.setOn(false, animated: true)
        return s
    }()
    
    let controlswitch3: UISwitch = {
        let s = UISwitch()
        s.setOn(false, animated: true)
        return s
    }()
    
    let controlswitch4: UISwitch = {
        let s = UISwitch()
        s.setOn(false, animated: true)
        return s
    }()
    
    let settingCellData: [(name: String, description: String)] = [
        ("당일 목표금액 리마인드", "매일 아침 그날의 목표 금액을 알려드릴게요.\n리마인드를 통해 내 목표를 계속 상기시켜요."),
        ("당일 소비내역 기록", "하루종일 소비내역을 기록하지 않으면 당일\n밤에 다시 리마인드 해드릴게요."),
        ("전 날 소비내역 기록", "소비내역을 기록하지 않으면 다음날 아침\n다시 리마인드 해드릴게요."),
        ("목표 종료 시점", "목표 종료 시, 소비 목표를 분석한 소비리포트를\n바로 확인할 수 있도록 도와드릴게요."),
    ]
    
    override func viewDidLoad(){
        view.backgroundColor = UIColor.mpWhite
        
        setupNavigationBar()
        setupTitle()
        setupTableView()
        
        settingTableView.delegate = self
        settingTableView.dataSource = self
        settingTableView.register(settingCell.self, forCellReuseIdentifier: settingCell.cellId)
 
    }
    
    
}


extension NotificationSettingViewController : UITableViewDelegate, UITableViewDataSource {
    
    func setupNavigationBar() {
        self.navigationItem.title = ""
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.mpBlack, NSAttributedString.Key.font: UIFont.mpFont18B()]
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
    }
    
    func setupTitle() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 28),
            titleLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            titleLabel.heightAnchor.constraint(equalToConstant: 36)
        ])
    }
    
    func setupTableView() {
        settingTableView.translatesAutoresizingMaskIntoConstraints = false

        settingTableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        settingTableView.separatorStyle = .singleLine
        settingTableView.separatorColor = UIColor.mpLightGray
        settingTableView.isScrollEnabled = false
        
        view.addSubview(settingTableView)
        
        NSLayoutConstraint.activate([
            settingTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            settingTableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            settingTableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            settingTableView.heightAnchor.constraint(equalToConstant: 510)
        ])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
         return 4
     }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: settingCell.cellId, for: indexPath) as! settingCell
        let data = settingCellData[indexPath.section]

        // 각 셀에 해당 switch를 추가
        switch indexPath.section {
        case 0:
            cell.addSubview(controlswitch1)
            controlswitch1.translatesAutoresizingMaskIntoConstraints = false
            controlswitch1.onTintColor = UIColor.mpMainColor
            NSLayoutConstraint.activate([
                controlswitch1.topAnchor.constraint(equalTo: cell.topAnchor, constant: 24),
                controlswitch1.rightAnchor.constraint(equalTo: cell.rightAnchor),
                controlswitch1.heightAnchor.constraint(equalToConstant: 31),
                controlswitch1.widthAnchor.constraint(equalToConstant: 51)
                
            ])
            controlswitch1.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
        case 1:
            cell.addSubview(controlswitch2)
            controlswitch2.translatesAutoresizingMaskIntoConstraints = false
            controlswitch2.onTintColor = UIColor.mpMainColor
            NSLayoutConstraint.activate([
                controlswitch2.topAnchor.constraint(equalTo: cell.topAnchor, constant: 24),
                controlswitch2.rightAnchor.constraint(equalTo: cell.rightAnchor),
                controlswitch2.heightAnchor.constraint(equalToConstant: 31),
                controlswitch2.widthAnchor.constraint(equalToConstant: 51)
                
            ])
            controlswitch2.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
        case 2:
            cell.addSubview(controlswitch3)
            controlswitch3.translatesAutoresizingMaskIntoConstraints = false
            controlswitch3.onTintColor = UIColor.mpMainColor
            NSLayoutConstraint.activate([
                controlswitch3.topAnchor.constraint(equalTo: cell.topAnchor, constant: 24),
                controlswitch3.rightAnchor.constraint(equalTo: cell.rightAnchor),
                controlswitch3.heightAnchor.constraint(equalToConstant: 31),
                controlswitch3.widthAnchor.constraint(equalToConstant: 51)
                
            ])
            controlswitch3.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
        case 3:
            cell.addSubview(controlswitch4)
            controlswitch4.translatesAutoresizingMaskIntoConstraints = false
            controlswitch4.onTintColor = UIColor.mpMainColor
            NSLayoutConstraint.activate([
                controlswitch4.topAnchor.constraint(equalTo: cell.topAnchor, constant: 24),
                controlswitch4.rightAnchor.constraint(equalTo: cell.rightAnchor),
                controlswitch4.heightAnchor.constraint(equalToConstant: 31),
                controlswitch4.widthAnchor.constraint(equalToConstant: 51)
                
            ])
            controlswitch4.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
        default:
            break
        }
        

        
        
        cell.nameLabel.text = data.name
        cell.descLabel.text = data.description
    
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 128
    }
    
    @objc func switchValueChanged() {
        
        if controlswitch1.isOn {
            print("1on")
        } else {
            print("1off")
        }

        if controlswitch2.isOn {
            print("2on")
        } else {
            print("2off")
        }

        if controlswitch3.isOn {
            print("3on")
        } else {
            print("3off")
        }

        if controlswitch4.isOn {
            print("4on")
        } else {
            print("4off")
        }
 
    }
    
//    func performDeleteToken() {
//        NotificationRepository.shared.deleteToken { result in
//             switch result {
//             case .success(let data):
//                 print("삭제 성공")
//             case .failure(let error):
//                 print("삭제 실패")
//             }
//         }
//    }
    
//    func performPatchToken() {
//        NotificationRepository.shared.patchToken(token: token) { result in //토큰 받아올거...
//             switch result {
//             case .success(let data):
//                 print("패치 성공")
//             case .failure(let error):
//                 print("패치 실패")
//             }
//         }
//    }
    
}


class settingCell : UITableViewCell {
    static let cellId = "CellId"
    
    let nameLabel : MPLabel = {
        let label = MPLabel()
        label.text = "당일 목표금액 리마인드"
        
        return label
    }()
    
    let descLabel : MPLabel = {
        let label = MPLabel()
        label.text = "매일 아침 그날의 목표 금액을 알려드릴게요.\n리마인드를 통해 내 목표를 계속 상기시켜요."
        
        return label
    }()
    

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setlayout()
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setlayout() {
        nameLabel.font = UIFont.mpFont18M()
        nameLabel.textColor = UIColor.mpBlack
        
        descLabel.font = UIFont.mpFont14R()
        descLabel.textColor = UIColor.mpDarkGray
        
        self.addSubview(nameLabel)
        self.addSubview(descLabel)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        descLabel.translatesAutoresizingMaskIntoConstraints = false

        
        descLabel.numberOfLines = 0
        descLabel.lineBreakMode = .byWordWrapping
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3
        
        let attrString = NSMutableAttributedString(string: descLabel.text ?? "")
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        descLabel.attributedText = attrString
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            nameLabel.leftAnchor.constraint(equalTo: leftAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 23),
            
            descLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            descLabel.leftAnchor.constraint(equalTo: leftAnchor),
            descLabel.heightAnchor.constraint(equalToConstant: 46),
            descLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24)
            
        ])
        
    }
    

}
