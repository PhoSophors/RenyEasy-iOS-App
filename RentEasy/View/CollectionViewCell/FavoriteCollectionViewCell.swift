//
//  FavoriteCollectionViewCell.swift
//  RentEasy
//
//  Created by Apple on 13/8/24.
//

import Foundation
import UIKit

struct Property {
    let imageName: String
    let title: String
    let location: String
    let bedrooms: String
    let bathrooms: String
    let propertyType: String
    let price: String
}

class FavoriteCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "FavoriteCollectionViewCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.numberOfLines = 1
        return label
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11, weight: .regular)
        label.numberOfLines = 1
        return label
    }()
    
    private let bedroomsAndbathroomsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    
    private let propertyTypeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    private let heartIcon: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        return button
    }()
    
    private let moreIcon: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 10
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.1
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowRadius = 5
        
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(locationLabel)
        contentView.addSubview(bedroomsAndbathroomsLabel)
        contentView.addSubview(propertyTypeLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(heartIcon)
        contentView.addSubview(moreIcon)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageWidth = contentView.frame.size.height - 20
        imageView.frame = CGRect(x: 10, y: 10, width: imageWidth, height: imageWidth)
        let labelHeight = contentView.frame.size.height / 6
        
        titleLabel.frame = CGRect(x: imageWidth + 20, y: 5, width: contentView.frame.size.width - imageWidth - 60, height: labelHeight)
        locationLabel.frame = CGRect(x: imageWidth + 20, y: 5 + labelHeight, width: contentView.frame.size.width - imageWidth - 60, height: labelHeight)
        bedroomsAndbathroomsLabel.frame = CGRect(x: imageWidth + 20, y: 5 + labelHeight * 2, width: contentView.frame.size.width - imageWidth - 60, height: labelHeight)
        propertyTypeLabel.frame = CGRect(x: imageWidth + 20, y: 5 + labelHeight * 3, width: contentView.frame.size.width - imageWidth - 60, height: labelHeight)
        priceLabel.frame = CGRect(x: imageWidth + 20, y: 5 + labelHeight * 4, width: contentView.frame.size.width - imageWidth - 60, height: labelHeight)
        
        let iconSize = labelHeight
        let rightPadding: CGFloat = 10
        heartIcon.frame = CGRect(x: contentView.frame.size.width - iconSize - rightPadding, y: 10, width: iconSize, height: iconSize)
        moreIcon.frame = CGRect(x: contentView.frame.size.width - iconSize - rightPadding, y: contentView.frame.size.height - iconSize - 10, width: iconSize, height: iconSize)
    }
    
    public func configure(with model: Property) {
        imageView.image = UIImage(named: model.imageName)
        titleLabel.text = model.title
        locationLabel.text = model.location
        bedroomsAndbathroomsLabel.text = "Bedrooms: \(model.bedrooms) • Bathrooms: \(model.bathrooms)"
        propertyTypeLabel.text = model.propertyType
        priceLabel.text = "\(model.price)"
    }
}
