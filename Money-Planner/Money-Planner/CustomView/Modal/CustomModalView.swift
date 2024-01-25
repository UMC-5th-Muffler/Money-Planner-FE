//import Foundation
//import UIKit
//
//class CustomModalView:  UIView {
//    struct Category {
//        let name: String
//        let imageName: String // Use this to set the image in the future if needed
//    }
//    let categories = [
//            Category(name: "식사", imageName: "pencil"),
//            Category(name: "카페/간식", imageName: "pencil"),
//            Category(name: "술/유흥", imageName: "pencil"),
//            Category(name: "생활", imageName: "pencil"),
//            Category(name: "패션/쇼핑", imageName: "pencil"),
//            Category(name: "교통", imageName: "pencil"),
//            Category(name: "의료/건강", imageName: "pencil"),
//            Category(name: "주거/통신", imageName: "pencil"),
//            Category(name: "금융", imageName: "pencil"),
//            Category(name: "문화/여가", imageName: "pencil"),
//            Category(name: "여행/숙박", imageName: "pencil"),
//            Category(name: "교육/학습", imageName: "pencil"),
//            Category(name: "경조/선물", imageName: "pencil"),
//            Category(name: "반려동물", imageName: "pencil"),
//            Category(name: "저축/투자", imageName: "pencil"),
//            Category(name: "기타", imageName: "pencil"),
//            Category(name: "직접 추가", imageName: "pencil"),
//            
//        ]
//
//    let titleLabel: UILabel = {
//        let label = UILabel()
//        label.text = "카테고리를 선택해주세요"
//        label.textAlignment = .center
//        label.font = UIFont.boldSystemFont(ofSize: 18)
//        return label
//    }()
//    
//    
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupUI()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    private func setupUI() {
//        self.isUserInteractionEnabled = true
//        setupBackground()
//        setuptitleLabel()
//        setupCategoryCellContainerView()
//        
//    }
//    
//    private func setupBackground() {
//        backgroundColor = .white
//        layer.cornerRadius = 25
//        layer.masksToBounds = true
//    }
//
//    private func setuptitleLabel() {
//        addSubview(titleLabel)
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//       
//        NSLayoutConstraint.activate([
//            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 44), // 314
//            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
//            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
//        ])
//    }
//
//    private func setupCategoryCellContainerView() {
//        
//        
//        let categoryCollectionView: UICollectionView = {
//            let layout = UICollectionViewFlowLayout()
//            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//            layout.scrollDirection = .vertical
//            let numberOfItemsPerRow: CGFloat = 3
//            let spacingBetweenItems: CGFloat = 10
//            let itemWidth = (frame.width - ((numberOfItemsPerRow - 1) * spacingBetweenItems) - 48) / numberOfItemsPerRow
//            print(frame.width)
//            print(itemWidth)
//            let itemSize = CGSize(width: Int(itemWidth), height: Int(itemWidth*0.84))
//            layout.itemSize = itemSize
//            layout.minimumLineSpacing = 6
//            
//            //collectionView.backgroundColor = UIColor.green
//            collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: "CategoryCell")
//            return collectionView
//        }()
//        
//        //categoryCollectionView.backgroundColor = UIColor.systemPink
//        addSubview(categoryCollectionView)
//        
//        categoryCollectionView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            categoryCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
//            categoryCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
//            categoryCollectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
//            categoryCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24)
//        ])
//
//        categoryCollectionView.dataSource = self
//        categoryCollectionView.delegate = self
//        categoryCollectionView.isUserInteractionEnabled = true
//    }
//
//    
//}
//
//// MARK: - UICollectionViewDataSource
//
//extension CustomModalView: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        // Return the number of items in your collection view
//        return categories.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as? CategoryCell else {
//            return UICollectionViewCell()
//        }
//
//        // Configure your cell with data
//        cell.configure(with: categories[indexPath.item])
//
//        return cell
//    }
//}
//
//// MARK: - UICollectionViewDelegate
//
//extension CustomModalView: UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//            let selectedCategory = categories[indexPath.item]
//            print("Selected Category: \(selectedCategory.name)")
//            
//            // You can perform additional actions or notify your view controller about the selected category here
//        }
//
//}
