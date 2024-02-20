
import Foundation
import UIKit

protocol OrderModalDelegate : AnyObject {
    func changeOrder(order : SortType)
}


class OrderModalViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    weak var delegate: OrderModalDelegate?
    private let sortName = [
        "최신순",
        "오래된순"
    ]
    
    private let sortTypeArray = [
        SortType.descending,
        SortType.ascending
    ]
    
    var selectedSortType : SortType = SortType.descending
    
    private let modalBar : UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.backgroundColor = .mpLightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let titleLabel : MPLabel = {
        let label = MPLabel()
        label.text = "정렬"
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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    @objc private func closeModal() {
        dismiss(animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortName.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0 // Change the cell height as needed
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = sortName[indexPath.row]
        cell.textLabel?.font = .mpFont16M()
        cell.textLabel?.textColor = .mpDarkGray
        cell.selectionStyle = .none
        
        if(selectedSortType == sortTypeArray[indexPath.row]){
            cell.accessoryType = .checkmark
            cell.tintColor = .mpMainColor // Change the color of the checkmark
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Unselect the previously selected cell
        if let selectedIndexPath = selectedIndexPath {
            tableView.cellForRow(at: selectedIndexPath)?.accessoryType = .none
        }
                
        selectedSortType = sortTypeArray[indexPath.row]
        delegate?.changeOrder(order: selectedSortType)
        closeModal()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

