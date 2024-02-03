//
//  ReasonModalViewController.swift
//  Money-Planner
//
//  Created by p_kxn_g on 2/3/24.
//

import UIKit
protocol ReasonModalDelegate : AnyObject {
    func reasonChecked (_ reason : String )
}


class ReasonModalViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    weak var delegate: ReasonModalDelegate?
    private let withdrawalReasons = [
        "서비스 이용이 불편해서",
        "목표 달성에 도움이 되지 않아서",
        "소비내역 관리에 효과가 없어서",
        "개인정보 및 보안 우려",
        "타 서비스로 이동"
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
        label.text = "탈퇴 사유를 알려주세요"
        label.font = .mpFont20B()
        label.textColor = .mpBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none // Set separator style to none
        
        return tableView
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("완료", for: .normal)
        button.titleLabel?.font = .mpFont16B()
        button.backgroundColor = .mpGypsumGray
        button.setTitleColor(.mpGray, for: .normal) // Adjust color as needed
        button.layer.cornerRadius = 10
        button.isEnabled = false
        return button
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
        customModal.addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            customModal.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            customModal.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
            customModal.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -32),
            customModal.heightAnchor.constraint(equalToConstant: 460),
            
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
            tableView.trailingAnchor.constraint(equalTo: customModal.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: closeButton.topAnchor),
            
            closeButton.leadingAnchor.constraint(equalTo: customModal.leadingAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: customModal.trailingAnchor, constant: -16),
            closeButton.bottomAnchor.constraint(equalTo: customModal.bottomAnchor,constant: -16),
            closeButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        closeButton.addTarget(self, action: #selector(closeModal), for: .touchUpInside)
    }
    
    @objc private func closeModal() {
        delegate?.reasonChecked(selectedReason!)
        dismiss(animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return withdrawalReasons.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0 // Change the cell height as needed
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = withdrawalReasons[indexPath.row]
        cell.textLabel?.font = .mpFont16M()
        cell.textLabel?.textColor = .mpDarkGray
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            // Unselect the previously selected cell
            if let selectedIndexPath = selectedIndexPath {
                tableView.cellForRow(at: selectedIndexPath)?.accessoryType = .none
            }

            // Select the current cell
            if let cell = tableView.cellForRow(at: indexPath) {
                cell.accessoryType = .checkmark
                cell.tintColor = .mpMainColor // Change the color of the checkmark
                closeButton.isEnabled = true
                closeButton.backgroundColor = .mpMainColor
                closeButton.setTitleColor(.mpWhite, for: .normal)
                selectedReason = withdrawalReasons[indexPath.row]

            }

            selectedIndexPath = indexPath

            tableView.deselectRow(at: indexPath, animated: true)
        }
}
