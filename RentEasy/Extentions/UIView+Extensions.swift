import UIKit

extension UIView {
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

// Image Loading Extension
extension UIImageView {
    func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data, let image = UIImage(data: data) else {
                return
            }
            
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
    
    // New method with completion handler
    func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            
            DispatchQueue.main.async {
                self.image = image
                completion(image)
            }
        }.resume()
    }
}

extension UITextView: UITextViewDelegate {
    
    private struct AssociatedKeys {
        static var placeholderKey = "placeholderKey"
    }
    
    var placeholder: String? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.placeholderKey) as? String
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.placeholderKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            configurePlaceholder()
        }
    }
    
    private var placeholderLabel: UILabel {
        let label = UILabel()
        label.tag = 100
        label.font = self.font ?? UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGray
        label.numberOfLines = 0
        return label
    }
    
    private func configurePlaceholder() {
        if let placeholderText = placeholder {
            if let existingLabel = viewWithTag(100) as? UILabel {
                existingLabel.text = placeholderText
                existingLabel.sizeToFit()
                existingLabel.isHidden = !self.text.isEmpty
            } else {
                let label = placeholderLabel
                label.text = placeholderText
                addSubview(label)
                label.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    label.topAnchor.constraint(equalTo: self.topAnchor, constant: self.textContainerInset.top),
                    label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: self.textContainer.lineFragmentPadding),
                    label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -self.textContainer.lineFragmentPadding)
                ])
                self.delegate = self
                updatePlaceholderVisibility()
            }
        } else {
            viewWithTag(100)?.removeFromSuperview()
        }
    }
    
    private func updatePlaceholderVisibility() {
        if let placeholderLabel = viewWithTag(100) as? UILabel {
            print("Updating placeholder visibility")
            placeholderLabel.isHidden = !self.text.isEmpty
        }
    }
    
    // UITextViewDelegate method
    public func textViewDidChange(_ textView: UITextView) {
        updatePlaceholderVisibility()
    }
}
