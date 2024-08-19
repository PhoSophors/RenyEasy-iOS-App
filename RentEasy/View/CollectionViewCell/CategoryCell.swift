////
////  CategoryCell.swift
////  RentEasy
////
////  Created by Apple on 14/8/24.
////
//
//import Foundation
//import UIKit
//
//class CategoryCell: UICollectionViewCell {
//    static let identifier = "CategoryCell"
//    
//    private let categoryLabel: UILabel = {
//        let label = UILabel()
//        label.textAlignment = .center
//        label.font = .systemFont(ofSize: 16, weight: .medium)
//        label.textColor = .gray
//        return label
//    }()
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        contentView.addSubview(categoryLabel)
//        contentView.backgroundColor = .systemGray6
//        contentView.layer.cornerRadius = 8
//        contentView.layer.masksToBounds = true
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        categoryLabel.frame = contentView.bounds
//    }
//    
//    func configure(with category: String) {
//        categoryLabel.text = category
//    }
//}
