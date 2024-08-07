import UIKit
import SnapKit
import SDWebImage
import MapKit

protocol UpdateProfileViewDelegate: AnyObject {
    func didTapUpdatePicture()
    func didTapUpdateCoverPicture()
    func didTapSaveButton() // Added to handle save button tap
}

class ProfileUpdateView: UIView, MKMapViewDelegate {
    weak var delegate: UpdateProfileViewDelegate?
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    // UI Elements
    private let profileImageView = UIImageView()
    private let coverImageView = UIImageView()
    private let bioTextField = UITextField()
    private let locationMapView = MKMapView()
    
    // Property to hold the stack view
    private var profilePictureLabelStackView: UIStackView?
    private var coverPictureLabelStackView: UIStackView?
    private var locationLabelStackView: UIStackView?
    private var bioLabel: UILabel?
    
    private let photoIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .gray
        imageView.isHidden = true
        return imageView
    }()
    
    private let addCoverLabel: UILabel = {
        let label = UILabel()
        label.text = "Add Your Cover"
        label.textColor = .gray
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.isHidden = true
        return label
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.backgroundColor = .systemIndigo
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .white
        
        setupScrollView()
        profilePictureLabelView()
        setupProfileImageView()
        coverPictureLabelView()
        setupCoverImageView()
        bioLabelView()
        setupBioTextField()
        locationLabelView()
        setupLocationView()
        setupSaveButton() // Ensure this is called
    }
    
    // Scroll view =========================
    private func setupScrollView() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
    }
    
    // Profile label =============================
    private func profilePictureLabelView() {
        let label = UILabel()
        label.text = "Profile picture"
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .black
        
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "plus.app.fill")
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        
        let stackView = UIStackView(arrangedSubviews: [label, imageView])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        
        contentView.addSubview(stackView)
        
        profilePictureLabelStackView = stackView
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(-30)
            make.leading.equalTo(contentView).offset(16)
            make.trailing.equalTo(contentView).offset(-16)
        }
    }
    
    // Profile picture =============================
    private func setupProfileImageView() {
        profileImageView.layer.cornerRadius = 75
        profileImageView.backgroundColor = .white
        profileImageView.clipsToBounds = true
        profileImageView.layer.borderWidth = 3
        profileImageView.layer.borderColor = UIColor.gray.cgColor
        contentView.addSubview(profileImageView)
        
        guard let profilePictureLabelStackView = profilePictureLabelStackView else { return }

        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(profilePictureLabelStackView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(150)
        }
    }
  
    // Cover label =============================
    private func coverPictureLabelView() {
        let label = UILabel()
        label.text = "Cover picture"
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .black
        
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "plus.app.fill")
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        
        let stackView = UIStackView(arrangedSubviews: [label, imageView])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        
        contentView.addSubview(stackView)
        
        coverPictureLabelStackView = stackView
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(16)
            make.leading.equalTo(contentView).offset(16)
            make.trailing.equalTo(contentView).offset(-16)
        }
    }
    
    // Cover picture =============================
    private func setupCoverImageView() {
        coverImageView.contentMode = .scaleAspectFill
        coverImageView.clipsToBounds = true
        contentView.addSubview(coverImageView)
        
        coverImageView.snp.makeConstraints { make in
            make.top.equalTo(coverPictureLabelStackView!.snp.bottom).offset(16)
            make.left.right.equalToSuperview()
            make.height.equalTo(200)
        }
        
        coverImageView.addSubview(photoIconImageView)
        coverImageView.addSubview(addCoverLabel)
        
        photoIconImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(50)
        }
        
        addCoverLabel.snp.makeConstraints { make in
            make.top.equalTo(photoIconImageView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
    }
    
    // Bio label =============================
    private func bioLabelView() {
        let label = UILabel()
        label.text = "Bio"
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .black
        
        contentView.addSubview(label)
        
        // Save reference to the label
        bioLabel = label
        
        label.snp.makeConstraints { make in
            make.top.equalTo(coverImageView.snp.bottom).offset(16)
            make.leading.equalTo(contentView).offset(16)
            make.trailing.equalTo(contentView).offset(-16)
        }
    }
    
    // Setup Bio text field =============================
    private func setupBioTextField() {
        bioTextField.borderStyle = .roundedRect
        contentView.addSubview(bioTextField)
        
        guard let bioLabel = bioLabel else { return }

        bioTextField.snp.makeConstraints { make in
            make.top.equalTo(bioLabel.snp.bottom).offset(8)
            make.leading.equalTo(contentView).offset(16)
            make.trailing.equalTo(contentView).offset(-16)
            make.height.equalTo(40)
        }
    }
    
    // Location label =============================
    private func locationLabelView() {
        let label = UILabel()
        label.text = "Set your location"
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .black
        
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "mappin.and.ellipse")
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        
        let stackView = UIStackView(arrangedSubviews: [label, imageView])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        
        contentView.addSubview(stackView)
        
        locationLabelStackView = stackView
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(bioTextField.snp.bottom).offset(16)
            make.leading.equalTo(contentView).offset(16)
            make.trailing.equalTo(contentView).offset(-16)
        }
    }
    
    // Setup Location Map View =============================
    private func setupLocationView() {
        contentView.addSubview(locationMapView)
        
        locationMapView.snp.makeConstraints { make in
            make.top.equalTo(locationLabelStackView!.snp.bottom).offset(16)
            make.leading.equalTo(contentView).offset(16)
            make.trailing.equalTo(contentView).offset(-16)
            make.height.equalTo(200)
        }
    }

    
    // Save button =============================
    private func setupSaveButton() {
        contentView.addSubview(saveButton)
        
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(locationMapView.snp.bottom).offset(16)
            make.leading.equalTo(contentView).offset(16)
            make.trailing.equalTo(contentView).offset(-16)
            make.height.equalTo(50) // Set the height to 50
            make.bottom.equalTo(contentView).offset(-16) 
        }
    }
    
    @objc private func didTapSaveButton() {
        delegate?.didTapSaveButton()
        
        print("Update button tapped")
    }

    func updateProfile(with userInfo: UserInfo) {
        updateProfileImage(with: userInfo.profilePhoto)
        updateCoverImage(with: userInfo.coverPhoto)
        
        bioTextField.text = userInfo.bio
        
//        if let location = userInfo.location {
//            let coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
//            let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
//            locationMapView.setRegion(region, animated: true)
//        }
    }

    private func updateProfileImage(with urlString: String) {
        if let profileUrl = URL(string: urlString) {
            profileImageView.sd_setImage(with: profileUrl, placeholderImage: UIImage(systemName: "person.crop.circle.fill"))
        } else {
            profileImageView.image = UIImage(systemName: "person.crop.circle.fill")
        }
        
        profileImageView.tintColor = .gray
    }

    private func updateCoverImage(with urlString: String) {
        if let coverUrl = URL(string: urlString) {
            coverImageView.sd_setImage(with: coverUrl) { [weak self] image, error, _, _ in
                if image == nil || error != nil {
                    self?.showPlaceholderOnCoverImageView()
                } else {
                    self?.hidePlaceholderOnCoverImageView()
                }
            }
        } else {
            showPlaceholderOnCoverImageView()
        }
    }

    private func showPlaceholderOnCoverImageView() {
        coverImageView.backgroundColor = .systemGray6
        photoIconImageView.isHidden = false
        addCoverLabel.isHidden = false
    }

    private func hidePlaceholderOnCoverImageView() {
        coverImageView.backgroundColor = .clear
        photoIconImageView.isHidden = true
        addCoverLabel.isHidden = true
    }
}
