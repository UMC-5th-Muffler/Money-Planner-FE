//
//  CategoryIconSelectionViewController.swift
//  Money-Planner
//
//  Created by p_kxn_g on 2/16/24.
//

import Foundation
import UIKit
protocol CategoryIconSelectionDelegate: AnyObject {
    func didSelectCategoryIcon(_ icon: Int?)
}

class CategoryIconSelectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    var selectedIndexPath: IndexPath? = nil // Track selected cell index path

    weak var delegate: CategoryIconSelectionDelegate?
    let icons: [UIImage?] = [
        UIImage(named: "add-01"),
        UIImage(named: "add-02"),
        UIImage(named: "add-03"),
        UIImage(named: "add-04"),
        UIImage(named: "add-05"),
        UIImage(named: "add-06"),
        UIImage(named: "add-07"),
        UIImage(named: "add-08"),
        UIImage(named: "add-09"),
        UIImage(named: "add-10"),
    ]

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
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CategoryIconCell.self, forCellWithReuseIdentifier: "CategoryIconCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()

    private let closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("완료", for: .normal)
        button.titleLabel?.font = .mpFont16B()
        button.backgroundColor = .mpGypsumGray
        button.setTitleColor(.mpGray, for: .normal) // Adjust color as needed
        button.layer.cornerRadius = 10
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setuptitleLabel()
        setupCategoryCellContainerView()
        presentCustomModal()
        setupCloseButton()
        updateCloseButtonState()

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
            categoryCollectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 48),
            categoryCollectionView.bottomAnchor.constraint(equalTo: customModal.bottomAnchor, constant: -24)
        ])
    }

    private func setupCloseButton() {
        customModal.addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.leadingAnchor.constraint(equalTo: customModal.leadingAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: customModal.trailingAnchor, constant: -16),
            closeButton.bottomAnchor.constraint(equalTo: customModal.bottomAnchor, constant: -16),
            closeButton.heightAnchor.constraint(equalToConstant: 56)
        ])
        closeButton.addTarget(self, action: #selector(closeModal), for: .touchUpInside)
    }

    @objc private func closeModal() {
        delegate?.didSelectCategoryIcon(selectedIndexPath!.item)
        dismiss(animated: true, completion: nil)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return icons.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryIconCell", for: indexPath) as? CategoryIconCell else {
            return UICollectionViewCell()
        }

        cell.configure(with: icons[indexPath.item])

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Update selected index path
        if selectedIndexPath != indexPath {
            selectedIndexPath = indexPath
            print(indexPath.item+1)
            collectionView.reloadData()
        }
        else{
            // 다시 클릭하면 선택 취소
            selectedIndexPath = nil
        }
        
        updateCloseButtonState()
    }
    
    // 완료 버튼 활성화 함수
    func updateCloseButtonState() {
        print(selectedIndexPath)
           if let selectedIndexPath = selectedIndexPath {
               print("활성화")
               closeButton.isEnabled = true
               closeButton.backgroundColor = .mpMainColor
               closeButton.setTitleColor(.mpWhite, for: .normal)
               print(closeButton.isEnabled)
           } else {
               print("비활성화")
               closeButton.isEnabled = false
               closeButton.backgroundColor = .mpGypsumGray
               closeButton.setTitleColor(.mpGray, for: .normal) // Adjust color as needed
           }
       }
    // MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = 50
        return CGSize(width: itemWidth, height: itemWidth)
    }
}
