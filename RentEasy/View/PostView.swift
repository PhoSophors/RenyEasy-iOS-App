import UIKit
import SnapKit

class PostView: UIView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private var selectedImages: [UIImage]?
    
    let photoCollectionView: UICollectionView
    let addPhotoButton = UIButton(type: .system)
    let addCreateButton = UIButton(type: .system)
    
    private lazy var titleTextField: UITextField = createTextField(placeholder: "Enter title")
    private lazy var bedroomTextField: UITextField = createTextField(placeholder: "Enter number of bedrooms")
    private lazy var bathroomTextField: UITextField = createTextField(placeholder: "Enter number of bathrooms")
    private lazy var priceTextField: UITextField = createTextField(placeholder: "Enter price")
    
//    private let propertyTypes = ["House", "Apartment", "hotel", "Villa", "Condo", "Townhouse", "Room"]
//    private let propertyTypeValues = ["house", "apartment", "hotel", "villa", "condo", "townhouse", "room"]
//    private let locationTypes = ["Phnom Penh", "Kandal", "Kompong Som", "Kompong Spue"]
//    
    private let propertyTypes = ["house", "apartment", "hotel", "villa", "condo", "townhouse", "room"]
    private let locationTypes = ["Phnom Penh", "Kandal", "Kompong Som", "Kompong Spue"]
        
    
    private lazy var propertyTypeTextField: UITextField = {
        let textField = createTextField(placeholder: "Select property type")
        textField.inputView = propertyTypePickerView
        textField.inputAccessoryView = toolbar
        textField.tintColor = .clear
        return textField
    }()
    
    private lazy var locationTypeTextField: UITextField = {
        let textField = createTextField(placeholder: "Select location")
        textField.inputView = locationTypePickerView
        textField.inputAccessoryView = toolbar
        textField.tintColor = .clear
        return textField
    }()
    
    private lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        textView.layer.borderWidth = 1.0
        textView.layer.cornerRadius = 5
        textView.textColor = .darkGray
        textView.text = "Enter description"
        textView.font = UIFont.systemFont(ofSize: 16)
        return textView
    }()
    
    private lazy var propertyTypePickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    private lazy var locationTypePickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    private lazy var toolbar: UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
        toolbar.setItems([flexSpace, doneButton], animated: false)
        return toolbar
    }()
    
    private lazy var contactTextField: UITextField = createTextField(placeholder: "Enter phone number")
    
    private func createTextField(placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .white
        textField.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 5
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        return textField
    }
    
    private func setupCreatePostButton() {
        addCreateButton.setTitle("Create Post", for: .normal)
        addCreateButton.backgroundColor = UIColor.systemGreen
        addCreateButton.setTitleColor(.white, for: .normal)
        addCreateButton.layer.cornerRadius = 5
        addCreateButton.clipsToBounds = true
    }
    
    override init(frame: CGRect) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        
        photoCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        photoCollectionView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        photoCollectionView.layer.borderWidth = 0.5
        photoCollectionView.layer.cornerRadius = 5
        photoCollectionView.backgroundColor = UIColor.lightGray
        
        super.init(frame: frame)
        
        setupViewAndConstraints()
        setupAddPhotoButton()
        setupCreatePostButton()
        
        addCreateButton.addTarget(self, action: #selector(createPostButtonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupAddPhotoButton() {
        addPhotoButton.setTitle("Add Photo", for: .normal)
        addPhotoButton.backgroundColor = UIColor.lightGray
        addPhotoButton.setTitleColor(UIColor.darkGray, for: .normal)
        addPhotoButton.layer.cornerRadius = 5
        addPhotoButton.clipsToBounds = true
    }
    
    private func setupViewAndConstraints() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(photoCollectionView)
        contentView.addSubview(addPhotoButton)
        
        contentView.addSubview(titleTextField)
        contentView.addSubview(bedroomTextField)
        contentView.addSubview(bathroomTextField)
        contentView.addSubview(priceTextField)
        contentView.addSubview(propertyTypeTextField)
        contentView.addSubview(locationTypeTextField)
        contentView.addSubview(contactTextField)
        contentView.addSubview(descriptionTextView)
        contentView.addSubview(addCreateButton)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
        }
        
        photoCollectionView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(20)
            make.leading.trailing.equalTo(contentView).inset(10)
            make.height.equalTo(photoCollectionView.snp.width).multipliedBy(0.66)
        }
        
        addPhotoButton.snp.makeConstraints { make in
            make.top.equalTo(photoCollectionView.snp.bottom).offset(20)
            make.centerX.equalTo(contentView)
            make.height.equalTo(50)
            make.leading.trailing.equalTo(contentView).inset(10)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(addPhotoButton.snp.bottom).offset(20)
            make.leading.trailing.equalTo(contentView).inset(10)
            make.height.equalTo(40)
        }
        
        bedroomTextField.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(10)
            make.leading.trailing.equalTo(contentView).inset(10)
            make.height.equalTo(40)
        }
        
        bathroomTextField.snp.makeConstraints { make in
            make.top.equalTo(bedroomTextField.snp.bottom).offset(10)
            make.leading.trailing.equalTo(contentView).inset(10)
            make.height.equalTo(40)
        }
        
        priceTextField.snp.makeConstraints { make in
            make.top.equalTo(bathroomTextField.snp.bottom).offset(10)
            make.leading.trailing.equalTo(contentView).inset(10)
            make.height.equalTo(40)
        }
        
        propertyTypeTextField.snp.makeConstraints { make in
            make.top.equalTo(priceTextField.snp.bottom).offset(20)
            make.leading.trailing.equalTo(contentView).inset(10)
            make.height.equalTo(40)
        }
        
        locationTypeTextField.snp.makeConstraints { make in
            make.top.equalTo(propertyTypeTextField.snp.bottom).offset(20)
            make.leading.trailing.equalTo(contentView).inset(10)
            make.height.equalTo(40)
        }
        
        contactTextField.snp.makeConstraints { make in
            make.top.equalTo(locationTypeTextField.snp.bottom).offset(20)
            make.leading.trailing.equalTo(contentView).inset(10)
            make.height.equalTo(40)
        }
        
        descriptionTextView.snp.makeConstraints { make in
            make.top.equalTo(contactTextField.snp.bottom).offset(20)
            make.leading.trailing.equalTo(contentView).inset(10)
            make.height.equalTo(100)
        }
        
        addCreateButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionTextView.snp.bottom).offset(20)
            make.centerX.equalTo(contentView)
            make.height.equalTo(50)
            make.leading.trailing.equalTo(contentView).inset(10)
            make.bottom.equalTo(contentView.snp.bottom).inset(20)
        }
    }
    
    @objc private func doneButtonTapped() {
        if propertyTypeTextField.isFirstResponder {
            propertyTypeTextField.resignFirstResponder()
        }
        if locationTypeTextField.isFirstResponder {
            locationTypeTextField.resignFirstResponder()
        }
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerView == propertyTypePickerView ? propertyTypes.count : locationTypes.count
    }
    
    // MARK: - UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerView == propertyTypePickerView ? propertyTypes[row] : locationTypes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == propertyTypePickerView {
            propertyTypeTextField.text = propertyTypes[row]
        } else {
            locationTypeTextField.text = locationTypes[row]
        }
    }
    
    @objc private func createPostButtonTapped() {
        
//        // Check if images are selected
//          guard let images = selectedImages, !images.isEmpty else {
//              print("Please select at least one image")
//              return
//          }
//          
//          // Convert UIImage array to data or other required format if necessary
//          let imageDataArray = images.map { $0.pngData() ?? Data() }
        
        
        guard let title = titleTextField.text, !title.isEmpty,
              let bedroomText = bedroomTextField.text, let bedrooms = Int(bedroomText),
              let bathroomText = bathroomTextField.text, let bathrooms = Int(bathroomText),
              let priceText = priceTextField.text, let price = Int(priceText),
              let propertyType = propertyTypeTextField.text, !propertyType.isEmpty,
              let location = locationTypeTextField.text, !location.isEmpty else {
            // Handle missing required information
            print("Please fill out all required fields correctly")
            print("Title: \(titleTextField.text ?? "nil")")
            print("Bedrooms: \(bedroomTextField.text ?? "nil")")
            print("Bathrooms: \(bathroomTextField.text ?? "nil")")
            print("Price: \(priceTextField.text ?? "nil")")
            print("Property Type: \(propertyTypeTextField.text ?? "nil")")
            print("Location: \(locationTypeTextField.text ?? "nil")")
            return
        }
        
        // Optional fields
        let contact = contactTextField.text
        let description = descriptionTextView.text
        
        
        print("All required fields are valid:")
        print("Title: \(title)")
        print("Bedrooms: \(bedrooms)")
        print("Bathrooms: \(bathrooms)")
        print("Price: \(price)")
        print("Property Type: \(propertyType)")
        print("Location: \(location)")
        print("Contact: \(contact ?? "N/A")")
        print("Description: \(description ?? "N/A")")
        
        let post = RentPost(
            id: "",
            user: [], // Make sure to provide actual user data if needed
            title: title,
            content: description ?? "", // Use default value if description is nil
            images: [], // Provide actual images if needed
            contact: contact ?? "", // Use default value if contact is nil
            location: location,
            price: price,
            bedrooms: bedrooms,
            bathrooms: bathrooms,
            propertyType: propertyType,
            createdAt: "",
            version: 0
        )
        
        APICaller.createNewPost(postData: post) { result in
            switch result {
            case .success(let response):
                print("Post created successfully: \(response)")
                // Handle success (e.g., show a success message or navigate back)
            case .failure(let error):
                print("Failed to create post: \(error)")
                // Handle error (e.g., show an error message)
            }
        }

        
        
        // Optionally use these indexes if needed
        let propertyTypeIndex = propertyTypes.firstIndex(of: propertyType) ?? 0
        let locationIndex = locationTypes.firstIndex(of: location) ?? 0
    }

   

}
