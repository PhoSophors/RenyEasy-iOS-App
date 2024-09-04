import UIKit
import SnapKit

protocol PostViewDelegate: AnyObject {
    func didTapCreatePostButton()
}

class PostView: UIView, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate {
    weak var delegate: PostViewDelegate?
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    let photoCollectionView: UICollectionView
    let addPhotoButton = UIButton(type: .system)
    let addCreateButton = UIButton(type: .system)
    var addCreateButtonBottomConstraint: NSLayoutConstraint?
    
    lazy var titleTextField: UITextField = createStyledTextField(placeholder: "Enter title")
    lazy var bedroomTextField: UITextField = createStyledTextFieldForNumpad(placeholder: "Enter number of bedrooms", inputType: .numberPad)
    lazy var bathroomTextField: UITextField = createStyledTextFieldForNumpad(placeholder: "Enter number of bathrooms", inputType: .numberPad)
    lazy var priceTextField: UITextField = createStyledTextFieldForNumpad(placeholder: "Enter price", inputType: .numberPad)
    lazy var contactTextField: UITextField = createStyledTextFieldForNumpad(placeholder: "Enter phone number", inputType: .numberPad)
    
    let propertyTypes = ["house", "apartment", "hotel", "villa", "condo", "townhouse", "room"]
    let locationTypes = ["Phnom Penh", "Kandal", "Kompong Som", "Kompong Spue"]
    
    lazy var propertyTypeTextField: UITextField = {
        let textField = createStyledTextField(placeholder: "Select property type")
        textField.inputView = propertyTypePickerView
        textField.inputAccessoryView = toolbar
        textField.tintColor = .clear
        return textField
    }()
    
    lazy var locationTypeTextField: UITextField = {
        let textField = createStyledTextField(placeholder: "Select location")
        textField.inputView = locationTypePickerView
        textField.inputAccessoryView = toolbar
        textField.tintColor = .clear
        return textField
    }()
    
    lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.placeholder = "Enter description"
        textView.backgroundColor = ColorManagerUtilize.shared.lightGray
        textView.layer.borderColor = UIColor.clear.cgColor
        textView.layer.borderWidth = 1.0
        textView.layer.cornerRadius = 10
        textView.textColor = .darkGray
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.delegate = self
        return textView
    }()
    
    lazy var propertyTypePickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()

    lazy var locationTypePickerView: UIPickerView = {
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
    
    private func createStyledTextField(placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.backgroundColor = ColorManagerUtilize.shared.lightGray
        textField.layer.borderColor = UIColor.clear.cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 10
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        return textField
    }
    
    private func createStyledTextFieldForNumpad(placeholder: String, inputType: UIKeyboardType = .default) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.backgroundColor = ColorManagerUtilize.shared.lightGray
        textField.layer.borderColor = UIColor.clear.cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 10
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.keyboardType = inputType
        return textField
    }
    
    override init(frame: CGRect) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        
        layout.collectionView?.backgroundColor = .red
        
        photoCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        photoCollectionView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        photoCollectionView.layer.borderWidth = 0.5
        photoCollectionView.layer.cornerRadius = 5
        photoCollectionView.backgroundColor = ColorManagerUtilize.shared.lightGray
        
        super.init(frame: frame)
        
        titleTextField.delegate = self
        bedroomTextField.delegate = self
        bathroomTextField.delegate = self
        priceTextField.delegate = self
        contactTextField.delegate = self
        propertyTypeTextField.delegate = self
        locationTypeTextField.delegate = self
        
        descriptionTextView.delegate = self

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
        addPhotoButton.backgroundColor = ColorManagerUtilize.shared.deepCharcoal
        addPhotoButton.setTitleColor(.white, for: .normal)
        
        if let addPhotoImage = UIImage(systemName: "photo") {
            let whiteImage = addPhotoImage.withTintColor(.white, renderingMode: .alwaysOriginal)
            addPhotoButton.setImage(whiteImage, for: .normal)
        }
        
        addPhotoButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        addPhotoButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)
        
        addPhotoButton.layer.cornerRadius = 10
        addPhotoButton.clipsToBounds = true
    }
    
    private func setupCreatePostButton() {
        addCreateButton.setTitle("Create Post", for: .normal)
        addCreateButton.backgroundColor = ColorManagerUtilize.shared.darkGreenTeal
        addCreateButton.setTitleColor(.white, for: .normal)
        addCreateButton.layer.cornerRadius = 10
        addCreateButton.clipsToBounds = true
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
            make.height.equalTo(44)
            make.leading.trailing.equalTo(contentView).inset(10)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(addPhotoButton.snp.bottom).offset(20)
            make.leading.trailing.equalTo(contentView).inset(10)
            make.height.equalTo(44)
        }
        
        bedroomTextField.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(10)
            make.leading.trailing.equalTo(contentView).inset(10)
            make.height.equalTo(44)
        }
        
        bathroomTextField.snp.makeConstraints { make in
            make.top.equalTo(bedroomTextField.snp.bottom).offset(10)
            make.leading.trailing.equalTo(contentView).inset(10)
            make.height.equalTo(44)
        }
        
        priceTextField.snp.makeConstraints { make in
            make.top.equalTo(bathroomTextField.snp.bottom).offset(10)
            make.leading.trailing.equalTo(contentView).inset(10)
            make.height.equalTo(44)
        }
        
        propertyTypeTextField.snp.makeConstraints { make in
            make.top.equalTo(priceTextField.snp.bottom).offset(10)
            make.leading.trailing.equalTo(contentView).inset(10)
            make.height.equalTo(44)
        }
        
        locationTypeTextField.snp.makeConstraints { make in
            make.top.equalTo(propertyTypeTextField.snp.bottom).offset(10)
            make.leading.trailing.equalTo(contentView).inset(10)
            make.height.equalTo(40)
        }
        
        contactTextField.snp.makeConstraints { make in
            make.top.equalTo(locationTypeTextField.snp.bottom).offset(10)
            make.leading.trailing.equalTo(contentView).inset(10)
            make.height.equalTo(44)
        }
        
        descriptionTextView.snp.makeConstraints { make in
            make.top.equalTo(contactTextField.snp.bottom).offset(10)
            make.leading.trailing.equalTo(contentView).inset(10)
            make.height.equalTo(150)
        }
        
        addCreateButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionTextView.snp.bottom).offset(20)
            make.leading.trailing.equalTo(contentView).inset(10)
            make.height.equalTo(50)
            make.bottom.equalTo(contentView.snp.bottom).offset(-20)
        }
    }

    // MARK: - UITextFieldDelegate methods
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
       textField.layer.borderColor = ColorManagerUtilize.shared.deepGreen.cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.clear.cgColor
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.layer.borderColor = ColorManagerUtilize.shared.deepGreen.cgColor
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        textView.layer.borderColor = UIColor.clear.cgColor
    }
    
    // MARK: - UIPickerViewDataSource & UIPickerViewDelegate
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == propertyTypePickerView {
            return propertyTypes.count
        } else if pickerView == locationTypePickerView {
            return locationTypes.count
        }
        return 0
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == propertyTypePickerView {
            return propertyTypes[row]
        } else if pickerView == locationTypePickerView {
            return locationTypes[row]
        }
        return nil
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == propertyTypePickerView {
            propertyTypeTextField.text = propertyTypes[row]
        } else if pickerView == locationTypePickerView {
            locationTypeTextField.text = locationTypes[row]
        }
    }
    
    // MARK: - Action method
    
    @objc private func doneButtonTapped() {
        endEditing(true)
    }

    @objc private func createPostButtonTapped() {
        delegate?.didTapCreatePostButton()
    }
    
}
