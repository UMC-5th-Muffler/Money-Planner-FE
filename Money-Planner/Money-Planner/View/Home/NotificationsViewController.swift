//
//  NotificationsViewController.swift
//  Money-Planner
//
//  Created by Jini on 2024/02/10.
//

import Foundation
import UIKit

class NotificationViewController : UIViewController {
    
    let notificationList = AlarmData.data
    let cellSpacingHeight: CGFloat = 1
    
    lazy var settingButton : UIBarButtonItem = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "gearshape"), for: .normal)
        button.tintColor = .mpBlack
        button.addTarget(self, action: #selector(settingButtonTapped), for: .touchUpInside)
        
        return UIBarButtonItem(customView: button)
    }()
    
    let notificationTableView = UITableView()
    
    let textLabel = MPLabel()
    
    override func viewDidLoad(){
        view.backgroundColor = .mpWhite
        
        setupNavigationBar()
        setupNotificationTable()
        setupLabel()
        
        notificationTableView.delegate = self
        notificationTableView.dataSource = self
        notificationTableView.register(notificationCell.self, forCellReuseIdentifier: notificationCell.cellId)
    }
    
}

extension NotificationViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return notificationList.count
     }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: notificationCell.cellId, for: indexPath) as! notificationCell
        
        let alarm = notificationList[indexPath.section]
        cell.title.text = alarm.title
        cell.content.text = alarm.content
        cell.time.text = alarm.received
        
        switch alarm.category {
        case "remind", "end":
            cell.backgroundColor = UIColor(hexCode: "#DFF2F1")
        case "record":
            cell.backgroundColor = UIColor.white
        default:
            break
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 124
    }
    
    
    @objc func settingButtonTapped() {
        print("setting button tapped")
        let vc = NotificationSettingViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setupNavigationBar() {
        self.navigationItem.title = "알림"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.mpBlack, NSAttributedString.Key.font: UIFont.mpFont18B()]
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        self.navigationItem.rightBarButtonItem = settingButton
    }
    
    func setupNotificationTable() {
        notificationTableView.translatesAutoresizingMaskIntoConstraints = false
        
        notificationTableView.separatorStyle = .none
        
        view.addSubview(notificationTableView)
        
        NSLayoutConstraint.activate([
            notificationTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 5),
            notificationTableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            notificationTableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            notificationTableView.heightAnchor.constraint(equalToConstant: 1000)
        ])
    }
    
    func setupLabel() { //이후에 위치 재조정 예정
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(textLabel)
        
        textLabel.text = "알림은 30일동안\n보관해드려요."
        textLabel.numberOfLines = 0
        textLabel.textColor = UIColor(hexCode: "#9FAAB0")
        textLabel.font = UIFont.mpFont14M()
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3
        
        let attrString = NSMutableAttributedString(string: textLabel.text ?? "")
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        textLabel.attributedText = attrString
        textLabel.textAlignment = .center
        
        NSLayoutConstraint.activate([
            textLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80),
            textLabel.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
}


class notificationCell : UITableViewCell {
    static let cellId = "CellId"
    
    let icon = UIImageView(image: UIImage(named: "btn_evaluation_red_on"))
    let title = MPLabel()
    let content : MPLabel = {
        let label = MPLabel()
        label.text = "temp"
        
        return label
    }()
    let time = MPLabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //setbackground()
        setlayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setlayout() {
        title.font = UIFont.mpFont14M()
        title.textColor = UIColor.mpDarkGray
        
        content.font = UIFont.mpFont16M()
        content.textColor = UIColor.mpCharcoal
        
        time.font = UIFont.mpFont14M()
        time.textColor = UIColor.mpDarkGray
        
        self.addSubview(icon)
        self.addSubview(title)
        self.addSubview(content)
        self.addSubview(time)
        
        content.numberOfLines = 0
        content.lineBreakMode = .byCharWrapping
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 7
        
        let attrString = NSMutableAttributedString(string: content.text ?? "")
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        content.attributedText = attrString
        
        icon.translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false
        content.translatesAutoresizingMaskIntoConstraints = false
        time.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            icon.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            icon.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            icon.heightAnchor.constraint(equalToConstant: 20),
            icon.widthAnchor.constraint(equalToConstant: 20),
            
            title.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            title.leftAnchor.constraint(equalTo: icon.rightAnchor, constant: 8),
            title.heightAnchor.constraint(equalToConstant: 23),
            
            content.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 5),
            content.leftAnchor.constraint(equalTo: icon.rightAnchor, constant: 8),
            content.rightAnchor.constraint(equalTo: rightAnchor, constant: -25),
            content.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            content.heightAnchor.constraint(equalToConstant: 56),

            time.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            time.rightAnchor.constraint(equalTo: rightAnchor, constant: -25),
            time.heightAnchor.constraint(equalToConstant: 23)
        
        ])
        
    }
}


//Alarm struct 임시로 설정
struct AlarmData {
    let category: String
    let title: String
    let content: String
    let received: String
}

extension AlarmData {
    static var data = [
        AlarmData(category: "remind", title: "당일 목표금액 리마인드", content: "오늘의 소비 목표는 15,000원이에요! 오늘도 혜원님의 알뜰한 하루를 응원해요", received: "1월 12일"),
        AlarmData(category: "record", title: "소비내역 기록", content: "어제 등록된 소비내역이 없어요. 0원 소비를 하셨더라도 체크해주세요!", received: "1월 13일"),
        AlarmData(category: "end", title: "목표 종료", content: "'목표이름' 목표가 종료되었어요. 목표 기간 동안의 소비를 분석해드렸어요!", received: "1월 15일")
    ]
}
