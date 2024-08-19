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
    
    var seeMoreOptionsUtilize: SeeMoreOptionsUtilize?
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 7.5
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.numberOfLines = 1
        return label
    }()
    
    let locationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.numberOfLines = 1
        return label
    }()
    
    let bedroomsAndbathroomsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    
    let propertyTypeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    let heartIcon: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        button.tintColor = .darkGray
        button.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        button.layer.cornerRadius = 20
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let moreIcon: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.tintColor = .darkGray
        button.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        button.layer.cornerRadius = 20
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemGray6
        contentView.layer.cornerRadius = 15
        
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(locationLabel)
        contentView.addSubview(bedroomsAndbathroomsLabel)
        contentView.addSubview(propertyTypeLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(heartIcon)
        contentView.addSubview(moreIcon)
        
        moreIcon.addTarget(self, action: #selector(moreIconTapped(_:)), for: .touchUpInside)
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
        
        let iconSize: CGFloat = 35
        let padding: CGFloat = 10
        
        heartIcon.frame = CGRect(
            x: contentView.frame.size.width - iconSize - padding,
            y: padding,
            width: iconSize,
            height: iconSize
        )
        
        moreIcon.frame = CGRect(
            x: contentView.frame.size.width - iconSize - padding,
            y: contentView.frame.size.height - iconSize - padding,
            width: iconSize,
            height: iconSize
        )
    }
    
    public func configure(with favorite: Favorite) {
        if let firstImageURL = favorite.post.images.first {
            imageView.loadImage(from: firstImageURL)
        }
        titleLabel.text = favorite.post.title
        priceLabel.text = "$\(favorite.post.price)"
        locationLabel.text = "\(favorite.post.propertyType) • \(favorite.post.location)"
        bedroomsAndbathroomsLabel.text = "Bedrooms: \(favorite.post.bedrooms) • Bathrooms: \(favorite.post.bathrooms)"
    }
    
    @objc private func moreIconTapped(_ sender: UIButton) {
        seeMoreOptionsUtilize?.showOptions(from: sender)
    }
}
