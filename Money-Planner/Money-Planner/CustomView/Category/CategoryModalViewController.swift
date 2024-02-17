//
//  CategoryModalViewController.swift
//  Money-Planner
//
//  Created by p_kxn_g on 1/25/24.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol CategorySelectionDelegate: AnyObject {
    func didSelectCategory(id:Int64, category: String, iconName : String)
    func AddCategory()
}

// 카테고리 선택 뷰 
class CategoryModalViewController : UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    var addCatName : String = ""
    var addCatIconName : String = ""
    let disposeBag = DisposeBag()
    let viewModel = MufflerViewModel()
 
    
    weak var delegate: CategorySelectionDelegate?
    
    
    var categories : [CategoryDTO]
            
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
        label.text = "카테고리를 선택해주세요"
        label.textAlignment = .center
        label.font = UIFont.mpFont20B()
        return label
    }()
    
    
    init(categories : [CategoryDTO]){
        self.categories = categories
        self.categories.append(CategoryDTO(categoryId: 0, name: "직접 추가", icon: "add-btn"))
        super.init(nibName: nil, bundle: nil)
    }
   
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
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
        
        // 카테고리 셀의 높이를 계산
        let cellHeight: CGFloat = 84 // 셀의 높이 예시
        let numberOfItems = CGFloat(categories.count)/3
        let totalCellHeight = numberOfItems * cellHeight
        var modalHeight = totalCellHeight + 48 + 48 + 44
        // 카테고리가 너무 많으면 모달의 높이는 최대 664로 조정함.
        if modalHeight >= 664 {
                modalHeight = 664
        }
        NSLayoutConstraint.activate([
                customModal.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
                customModal.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                customModal.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                customModal.heightAnchor.constraint(equalToConstant: modalHeight)
                
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
        let categoryCollectionView: UICollectionView = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            let numberOfItemsPerRow: CGFloat = 3
            let spacingBetweenItems: CGFloat = 8
            let itemWidth = (UIScreen.main.bounds.width - ((numberOfItemsPerRow - 1) * spacingBetweenItems) - 95) / numberOfItemsPerRow
            layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 0.84)
            layout.minimumLineSpacing = spacingBetweenItems
            
            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: "CategoryCell")
            collectionView.backgroundColor = .clear
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            return collectionView
        }()
        
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
        return categories.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as? CategoryCell else {
            return UICollectionViewCell()
        }

        // Configure your cell with data
        cell.configure(with: categories[indexPath.item])

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedId = categories[indexPath.item].categoryId
        let selectedCategory = categories[indexPath.item].name
        let selectedIcon = categories[indexPath.item].icon
        print("Selected Category: \(selectedCategory)")
        dismiss(animated: true, completion: nil )
        if selectedCategory == "직접 추가"{
            // 직접 추가인 경우 카테고리 추가 화면으로 이동
            print("직접 추가를 선택했습니다")
            delegate?.AddCategory() // 카테고리 추가 화면으로 이동
        }
        else{
            delegate?.didSelectCategory(id: selectedId, category: selectedCategory, iconName: selectedIcon)

        }
        
        
        
        // You can perform additional actions or notify your view controller about the selected category he
    }
    
    
}



