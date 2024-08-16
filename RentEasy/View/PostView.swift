import UIKit
import SnapKit
import PhotosUI

class PostView: UIView, UIPickerViewDelegate, UIPickerViewDataSource {

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    let imagesContainer = UIView()
    let uploadPhotoButton = UIButton()
    let titleTextField = UITextField()
    let bedroomsTextField = UITextField()
    let bathroomsTextField = UITextField()
    let propertytypeTextField = UITextField()
    let priceTextField = UITextField()
    let priceTypeSegmentedControl = UISegmentedControl(items: ["$"])
    let descriptionTextView = UITextView()
    let locationTextField = UITextField()
    let postButton = UIButton()

    private let propertyPickerView = UIPickerView()
    private let locationPickerView = UIPickerView()
    
    private let propertys = ["house", "villa", "apartment", "hotel", "condo", "townhouse", "room"]
    private let locations = ["Banteay Meanchey", "Battambang", "Kampong Cham", "Kampong Chhnang", "Kampong Speu", "Kampong Thom", "Kampot", "Kandal", "Kep", "Koh Kong", "Kratié", "Mondulkiri", "Oddar Meanchey", "Pailin", "Phnom Penh", "Preah Sihanouk", "Preah Vihear", "Prey Veng", "Pursat", "Ratanakiri", "Siem Reap", "Stung Treng", "Svay Rieng", "Takéo", "Tboung Khmum"]

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        backgroundColor = .white
        
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(imagesContainer)
        contentView.addSubview(uploadPhotoButton)
        contentView.addSubview(titleTextField)
        contentView.addSubview(bedroomsTextField)
        contentView.addSubview(bathroomsTextField)
        contentView.addSubview(propertytypeTextField)
        contentView.addSubview(priceTextField)
        contentView.addSubview(priceTypeSegmentedControl)
        contentView.addSubview(descriptionTextView)
        contentView.addSubview(locationTextField)
        contentView.addSubview(postButton)

        // Set up Pickers
        propertyPickerView.delegate = self
        propertyPickerView.dataSource = self
        propertytypeTextField.inputView = propertyPickerView
        
        locationPickerView.delegate = self
        locationPickerView.dataSource = self
        locationTextField.inputView = locationPickerView

        addDoneButtonToPicker()

        // Set up Upload Photo Button
        uploadPhotoButton.setTitle("Upload Photos", for: .normal)
        uploadPhotoButton.setTitleColor(.gray, for: .normal)
        uploadPhotoButton.setImage(UIImage(systemName: "photo.on.rectangle.angled"), for: .normal)
        uploadPhotoButton.contentHorizontalAlignment = .center
        uploadPhotoButton.addTarget(self, action: #selector(uploadPhotoButtonTapped), for: .touchUpInside)

        // Layout constraints
        setupConstraints()
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        imagesContainer.backgroundColor = .white
        imagesContainer.layer.cornerRadius = 8
        imagesContainer.layer.borderColor = UIColor.lightGray.cgColor
        imagesContainer.layer.borderWidth = 1
        imagesContainer.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(16)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(150)
        }

        uploadPhotoButton.snp.makeConstraints { make in
            make.center.equalTo(imagesContainer)
            make.height.equalTo(40)
        }

        titleTextField.placeholder = "Title"
        titleTextField.borderStyle = .roundedRect
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(imagesContainer.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(44)
        }
        
        bedroomsTextField.placeholder = "Bedrooms"
        bedroomsTextField.borderStyle = .roundedRect
        bedroomsTextField.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(44)
        }
        
        bathroomsTextField.placeholder = "Bathrooms"
        bathroomsTextField.borderStyle = .roundedRect
        bathroomsTextField.snp.makeConstraints { make in
            make.top.equalTo(bedroomsTextField.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(44)
        }
        
        propertytypeTextField.placeholder = "Property"
        propertytypeTextField.borderStyle = .roundedRect
        propertytypeTextField.snp.makeConstraints { make in
            make.top.equalTo(bathroomsTextField.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(44)
        }

        priceTextField.placeholder = "Price"
        priceTextField.borderStyle = .roundedRect
        priceTextField.keyboardType = .decimalPad
        priceTextField.snp.makeConstraints { make in
            make.top.equalTo(propertytypeTextField.snp.bottom).offset(16)
            make.left.equalToSuperview().inset(16)
            make.right.equalToSuperview().inset(100)
            make.height.equalTo(44)
        }

        priceTypeSegmentedControl.selectedSegmentIndex = 0
        priceTypeSegmentedControl.snp.makeConstraints { make in
            make.top.equalTo(priceTextField)
            make.left.equalTo(priceTextField.snp.right).offset(8)
            make.right.equalToSuperview().inset(16)
        }

        descriptionTextView.text = "Description"
        descriptionTextView.layer.borderColor = UIColor.lightGray.cgColor
        descriptionTextView.layer.borderWidth = 1
        descriptionTextView.layer.cornerRadius = 8
        descriptionTextView.snp.makeConstraints { make in
            make.top.equalTo(priceTextField.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(100)
        }
        
        locationTextField.placeholder = "Location"
        locationTextField.borderStyle = .roundedRect
        locationTextField.snp.makeConstraints { make in
            make.top.equalTo(descriptionTextView.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(44)
        }
        
        postButton.setTitle("Post", for: .normal)
        postButton.backgroundColor = .systemBlue
        postButton.setTitleColor(.white, for: .normal)
        postButton.layer.cornerRadius = 8
        postButton.snp.makeConstraints { make in
            make.top.equalTo(locationTextField.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(44)
            make.bottom.equalToSuperview().inset(20)
        }
    }

    @objc private func uploadPhotoButtonTapped() {
        // Implementation for uploading photos
    }
    
    private func displaySelectedImages(_ images: [UIImage]) {
        for subview in imagesContainer.subviews {
            subview.removeFromSuperview()
        }

        var previousView: UIImageView? = nil

        for (index, image) in images.enumerated() {
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imagesContainer.addSubview(imageView)

            imageView.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(8)
                make.height.equalTo(150)
                make.width.equalTo(150)
                if let previous = previousView {
                    make.left.equalTo(previous.snp.right).offset(8)
                } else {
                    make.left.equalToSuperview().offset(8)
                }
                if index == images.count - 1 {
                    make.right.equalToSuperview().inset(8)
                }
            }
            
            previousView = imageView
        }
    }

    private func addDoneButtonToPicker() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        toolbar.setItems([doneButton], animated: false)

        propertytypeTextField.inputAccessoryView = toolbar
        locationTextField.inputAccessoryView = toolbar
    }

    @objc private func doneButtonTapped() {
        endEditing(true)
    }

    // MARK: - UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == propertyPickerView {
            return propertys.count
        } else {
            return locations.count
        }
    }
    
    // MARK: - UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == propertyPickerView {
            return propertys[row]
        } else {
            return locations[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == propertyPickerView {
            propertytypeTextField.text = propertys[row]
        } else {
            locationTextField.text = locations[row]
        }
    }
}
