
import Foundation
import UIKit

protocol WhichAddModalDelegate : AnyObject {
    func moveToView(index : Int)
}


class WhichAddModalViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    var delegate : WhichAddModalDelegate?
    
    private let todo = [
        "소비내역 추가하기",
        "하루평가 추가하기"
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
        label.text = "무엇을 추가할까요?"
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
    
    private let customModal: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 25
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private var selectedIndexPath: IndexPath?
    
    private var iconViewList : [UIImageView] = []
    
    let addIconView : UIImageView = {
           let v = UIImageView()
           v.image = UIImage(named: "home_add")
           v.tintColor = .mpDarkGray
           v.translatesAutoresizingMaskIntoConstraints = false
           v.isUserInteractionEnabled = true
           return v
    }()
    
    let smileIconView : UIImageView = {
           let v = UIImageView()
           v.image = UIImage(named: "home_today")
           v.tintColor = .mpDarkGray
           v.translatesAutoresizingMaskIntoConstraints = false
           v.isUserInteractionEnabled = true
           return v
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        iconViewList = [
            addIconView,
            smileIconView
        ]
        
        tableView.register(IconTableViewCell.self, forCellReuseIdentifier: "WhichIconCell")
                
        view.addSubview(customModal)
        customModal.addSubview(modalBar)
        customModal.addSubview(titleLabel)
        customModal.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            customModal.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            customModal.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -36),
            customModal.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -64),
            customModal.heightAnchor.constraint(equalToConstant: 228),
            
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
            tableView.bottomAnchor.constraint(equalTo: customModal.bottomAnchor,constant: -16)
        ])
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @objc private func closeModal() {
        dismiss(animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todo.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0 // Change the cell height as needed
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WhichIconCell", for: indexPath) as! IconTableViewCell
          
          // 아이콘 및 텍스트 설정
        cell.iconImageView.image = iconViewList[indexPath.row].image
        cell.titleLabel.text = todo[indexPath.row]
        cell.selectionStyle = .none
          
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Unselect the previously selected cell
        if let selectedIndexPath = selectedIndexPath {
            tableView.cellForRow(at: selectedIndexPath)?.accessoryType = .none
        }
        closeModal()
        delegate?.moveToView(index: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}

