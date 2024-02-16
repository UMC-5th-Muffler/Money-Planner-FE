//
//  CategoryIconSelectionViewController.swift
//  Money-Planner
//
//  Created by p_kxn_g on 2/16/24.
//

import Foundation
import UIKit

protocol CategoryIconSelectionDelegate: AnyObject {
//    func didSelectCategory(_ category: String, iconName : String)
//    func AddCategory()
}

// 카테고리 선택 뷰
class CategoryIconSelectionViewController : UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    var addCatName : String = ""
    var addCatIconName : String = ""

 
    
    weak var delegate: CategorySelectionDelegate?
    struct Category {
        let name: String
        let imageName: String // Use this to set the image in the future if needed
    }
   
    let icons: [UIImage?] = [UIImage(named: "add-01"),
                             UIImage(named: "add-02"),
                             UIImage(named: "add-03"),
                             UIImage(named: "add-04"),
                             UIImage(named: "add-05"),
                             UIImage(named: "add-06"),
                             UIImage(named: "add-07"),
                             UIImage(named: "add-08"),
                             UIImage(named: "add-09"),
                             UIImage(named: "add-10"),]

    
    // 모달의 메인 컨테이너 뷰
    private let customModal: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 40
        view.backgroundColor = .mpWhite
        view.layer.cornerRadius = 25
        view.layer.masksToBounds = true
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "아이콘을 선택해주세요"
        label.textAlignment = .center
        label.font = UIFont.mpFont20B()
        return label
    }()
    // 컬렉션뷰
    lazy var categoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 16
        
//        let numberOfItemsPerRow: CGFloat = 5
//        let spacingBetweenItems: CGFloat = 2
//        let itemWidth = (UIScreen.main.bounds.width - ((numberOfItemsPerRow - 1) * spacingBetweenItems) - 95) / numberOfItemsPerRow
//        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
//        layout.minimumLineSpacing = spacingBetweenItems
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CategoryIconCell.self, forCellWithReuseIdentifier: "CategoryIconCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupBackground()
        setuptitleLabel()
        setupCategoryCellContainerView()
        presentCustomModal()

    }
    func presentCustomModal() {
        view.addSubview(customModal)
        customModal.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
                customModal.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
                customModal.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                customModal.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                customModal.heightAnchor.constraint(equalToConstant: 368)
                
            ])
    }
    private func setupBackground() {
        customModal.layer.cornerRadius = 25
        customModal.layer.masksToBounds = true
    }

    private func setuptitleLabel() {
        let modalBar = UIView()
        modalBar.layer.cornerRadius = 8
        modalBar.backgroundColor = .mpLightGray
        
        customModal.addSubview(modalBar)
        customModal.addSubview(titleLabel)
        modalBar.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
       
        NSLayoutConstraint.activate([
            modalBar.widthAnchor.constraint(equalToConstant: 49),
            modalBar.heightAnchor.constraint(equalToConstant: 4),
            modalBar.topAnchor.constraint(equalTo: customModal.topAnchor, constant: 12),
            modalBar.centerXAnchor.constraint(equalTo: customModal.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: modalBar.bottomAnchor, constant: 28),
            titleLabel.centerXAnchor.constraint(equalTo: customModal.centerXAnchor),
            ])
            
    }

    private func setupCategoryCellContainerView() {
        customModal.addSubview(categoryCollectionView)
        
        NSLayoutConstraint.activate([
            categoryCollectionView.leadingAnchor.constraint(equalTo: customModal.leadingAnchor, constant: 24),
            categoryCollectionView.trailingAnchor.constraint(equalTo: customModal.trailingAnchor, constant: -24),
            categoryCollectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            categoryCollectionView.bottomAnchor.constraint(equalTo: customModal.bottomAnchor, constant: -24)
        ])
    }

    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Return the number of items in your collection view
        return icons.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryIconCell", for: indexPath) as? CategoryIconCell else {
            return UICollectionViewCell()
        }

        // Configure your cell with data
        cell.configure(with: icons[indexPath.item])

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedIcon = icons[indexPath.item]?.cgImage
        print("Selected Category: \(String(describing: selectedIcon))")
        
        
        // You can perform additional actions or notify your view controller about the selected category he
    }
    // MARK: UICollectionViewDelegateFlowLayout
       
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           let padding: CGFloat = 10
           let collectionViewSize = collectionView.frame.size.width - padding
           return CGSize(width: collectionViewSize/2, height: collectionViewSize/2)
       }
    
    
}

