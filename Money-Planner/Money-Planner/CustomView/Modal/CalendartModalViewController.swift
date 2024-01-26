//
//  CalendarModalViewController.swift
//  Money-Planner
//
//  Created by p_kxn_g on 1/26/24.
//

import Foundation

import UIKit


class CalendartModalViewController : UIViewController {
   

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "소비 날짜를 선택해주세요"
        label.textAlignment = .center
        label.font = UIFont.mpFont20B()
        return label
    }()
    let customModal = UIView(frame: CGRect(x: 0, y: 0, width: 361, height: 548))
    
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
        customModal.backgroundColor = .white
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

    }

    
    
    
    
    
    
}

