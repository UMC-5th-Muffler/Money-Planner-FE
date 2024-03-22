//
//  HomeMoreModal.swift
//  Money-Planner
//
//  Created by seonwoo on 2024/02/13.
//

import Foundation
import UIKit

protocol HomeMoreModalDelegate : AnyObject {
    func selectPage ( index : Int )
}


class HomeMoreModalViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    weak var delegate: HomeMoreModalDelegate?
    private let pages = [
        "카테고리 편집",
        "반복소비 관리"
    ]
    private let modalBar : UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.backgroundColor = .mpLightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let titleLabel : MPLabel = {
        let label = MPLabel()
        label.text = "더보기"
        label.font = .mpFont20B()
        label.textColor = .mpBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .singleLine
        return tableView
    }()
    
    private let customModal: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 25
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private var selectedIndexPath: IndexPath?
    private var selectedReason: String?
    
    private var iconViewList : [UIImageView] = []
    
    let categoryIconView : UIImageView = {
           let v = UIImageView()
           v.image = UIImage(named: "home_folder")
           v.tintColor = .mpDarkGray
           v.translatesAutoresizingMaskIntoConstraints = false
           v.isUserInteractionEnabled = true
           return v
    }()
    
    let manageIconView : UIImageView = {
           let v = UIImageView()
           v.image = UIImage(named: "home_repeat")
           v.tintColor = .mpDarkGray
           v.translatesAutoresizingMaskIntoConstraints = false
           v.isUserInteractionEnabled = true
           return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(IconTableViewCell.self, forCellReuseIdentifier: "IconCell")
        
        iconViewList = [
            categoryIconView,
            manageIconView
        ]
        
        view.addSubview(customModal)
        customModal.addSubview(modalBar)
        customModal.addSubview(titleLabel)
        customModal.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            customModal.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            customModal.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -36),
            customModal.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -64),
            customModal.heightAnchor.constraint(equalToConstant: 256),
            
            modalBar.widthAnchor.constraint(equalToConstant: 49),
            modalBar.heightAnchor.constraint(equalToConstant: 4),
            modalBar.topAnchor.constraint(equalTo: customModal.topAnchor, constant: 12),
            modalBar.centerXAnchor.constraint(equalTo: customModal.centerXAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: modalBar.topAnchor, constant: 28),
            titleLabel.leadingAnchor.constraint(equalTo: customModal.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: customModal.trailingAnchor, constant: -24),
            titleLabel.heightAnchor.constraint(equalToConstant: 28),
            
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: customModal.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: customModal.trailingAnchor, constant: -24),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -36)
        ])
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    @objc private func closeModal(index : Int = -1) {
        dismiss(animated: true, completion: nil)
        if(index != -1){
            delegate?.selectPage(index: index)
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pages.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0 // Change the cell height as needed
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "IconCell", for: indexPath) as! IconTableViewCell
          
          // 아이콘 및 텍스트 설정
        cell.iconImageView.image = iconViewList[indexPath.row].image
        cell.titleLabel.text = pages[indexPath.row]
        cell.selectionStyle = .none
          
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Unselect the previously selected cell
        if let selectedIndexPath = selectedIndexPath {
            tableView.cellForRow(at: selectedIndexPath)?.accessoryType = .none
        }
        
        closeModal(index: indexPath.row)
    }
}


class IconTableViewCell: UITableViewCell {
    var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .mpDarkGray
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .mpFont18M()
        label.textColor = .mpBlack

        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(iconImageView)
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 22),
            iconImageView.heightAnchor.constraint(equalToConstant: 22),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
