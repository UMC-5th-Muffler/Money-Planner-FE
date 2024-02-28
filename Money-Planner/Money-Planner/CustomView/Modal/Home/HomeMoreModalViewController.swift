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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            titleLabel.leadingAnchor.constraint(equalTo: customModal.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: customModal.trailingAnchor, constant: -16),
            titleLabel.heightAnchor.constraint(equalToConstant: 28),
            
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: customModal.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: customModal.trailingAnchor, constant: -24),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -36)
        ])
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = pages[indexPath.row]
        cell.textLabel?.font = .mpFont18M()
        cell.textLabel?.textColor = .mpBlack
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
