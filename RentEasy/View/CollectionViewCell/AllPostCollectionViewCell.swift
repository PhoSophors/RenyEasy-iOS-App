//
//  AllPostCollectionViewCell.swift
//  RentEasy
//
//  Created by Apple on 17/8/24.
//

import Foundation
import UIKit
import SnapKit

class AllPostCollectionViewCell: UICollectionViewCell {
    static let identifier = "AllPostCollectionViewCell"

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    private let postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let heartButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
        return button
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 1
        label.textColor = .white
        return label
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    private let propertyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .center
        label.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        return label
    }()
    
    private let gradientLabelView: UIView = {
        let view = UIView()
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.7).cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        view.layer.insertSublayer(gradient, at: 0)
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(containerView)
        containerView.addSubview(postImageView)
        containerView.addSubview(heartButton)
        containerView.addSubview(gradientLabelView)
        gradientLabelView.addSubview(titleLabel)
        gradientLabelView.addSubview(locationLabel)
        
        // Layout using SnapKit
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(0)
        }
        
        postImageView.snp.makeConstraints { make in
            make.edges.equalTo(containerView)
        }
        
        heartButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.width.height.equalTo(30)
        }
        
        gradientLabelView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(60)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.bottom.equalTo(locationLabel.snp.top).offset(-5)
        }
        
        locationLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        // Adjust gradient layer frame after layout
        gradientLabelView.layer.sublayers?.first?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 60)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Configure the cell with data
    
    func configure(with imageUrl: String?, title: String, location: String, property: String, price: Int) {
        titleLabel.text = title
        locationLabel.text = "\(property) • $\(price) • \(location)"
        propertyLabel.text = property
        
        if let imageUrl = imageUrl {
            postImageView.loadImage(from: imageUrl)
        } else {
            postImageView.image = UIImage(named: "placeholder")
        }
    }
}

