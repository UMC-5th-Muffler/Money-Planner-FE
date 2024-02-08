//
//  File.swift
//  Money-Planner
//
//  Created by p_kxn_g on 1/25/24.
//

import Foundation
import UIKit

protocol CategorySelectionDelegate: AnyObject {
    func didSelectCategory(_ category: String, iconName : String)
    func AddCategory()
}

class CategoryModalViewController : UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    var addCatName : String = ""
    var addCatIconName : String = ""

 
    
    weak var delegate: CategorySelectionDelegate?
    struct Category {
        let name: String
        let imageName: String // Use this to set the image in the future if needed
    }
    let categories = [
            Category(name: "식사", imageName: "pencil"),
            Category(name: "카페/간식", imageName: "pencil"),
            Category(name: "술/유흥", imageName: "pencil"),
            Category(name: "생활", imageName: "pencil"),
            Category(name: "패션/쇼핑", imageName: "pencil"),
            Category(name: "뷰티/미용", imageName: "pencil"),
            Category(name: "교통", imageName: "pencil"),
            Category(name: "의료/건강", imageName: "pencil"),
            Category(name: "주거/통신", imageName: "pencil"),
            Category(name: "금융", imageName: "pencil"),
            Category(name: "문화/여가", imageName: "pencil"),
            Category(name: "여행/숙박", imageName: "pencil"),
            Category(name: "교육/학습", imageName: "pencil"),
            Category(name: "경조/선물", imageName: "pencil"),
            Category(name: "반려동물", imageName: "pencil"),
            Category(name: "저축/투자", imageName: "pencil"),
            Category(name: "기타", imageName: "pencil"),
            Category(name: "직접 추가", imageName: "pencil"),
            
        ]

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "카테고리를 선택해주세요"
        label.textAlignment = .center
        label.font = UIFont.mpFont20B()
        return label
    }()
    let customModal = UIView(frame: CGRect(x: 0, y: 0, width: 361, height: 664))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presentCustomModal()
        setupBackground()
        setuptitleLabel()
        setupCategoryCellContainerView()
    }
    func presentCustomModal() {
        // Instantiate your custom modal view
        customModal.backgroundColor = UIColor.mpWhite
        view.addSubview(customModal)
        customModal.center = view.center
        
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
            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            layout.scrollDirection = .vertical
            let numberOfItemsPerRow: CGFloat = 3
            let spacingBetweenItems: CGFloat = 10
            let itemWidth = (customModal.frame.width - ((numberOfItemsPerRow - 1) * spacingBetweenItems) - 48) / numberOfItemsPerRow
            print(customModal.frame.width)
            print(itemWidth)
            let itemSize = CGSize(width: Int(itemWidth), height: Int(itemWidth*0.84))
            layout.itemSize = itemSize
            layout.minimumLineSpacing = 10
            
            //collectionView.backgroundColor = UIColor.green
            collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: "CategoryCell")
            return collectionView
        }()
        
        //categoryCollectionView.backgroundColor = UIColor.systemPink
        customModal.addSubview(categoryCollectionView)
        
        categoryCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            categoryCollectionView.leadingAnchor.constraint(equalTo: customModal.leadingAnchor, constant: 24),
            categoryCollectionView.trailingAnchor.constraint(equalTo: customModal.trailingAnchor, constant: -24),
            categoryCollectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            categoryCollectionView.bottomAnchor.constraint(equalTo: customModal.bottomAnchor, constant: -24)
        ])

        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
        categoryCollectionView.isUserInteractionEnabled = true
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
        let selectedCategory = categories[indexPath.item].name
        let selectedIcon = categories[indexPath.item].imageName
        print("Selected Category: \(selectedCategory)")
        dismiss(animated: true, completion: nil )
        if selectedCategory == "직접 추가"{
            // 직접 추가인 경우 카테고리 추가 화면으로 이동
            print("직접 추가를 선택했습니다")
            delegate?.AddCategory() // 카테고리 추가 화면으로 이동
        }
        else{
            delegate?.didSelectCategory(selectedCategory, iconName: selectedIcon)

        }
        
        
        
        // You can perform additional actions or notify your view controller about the selected category he
    }
    
    
}



