import UIKit

class CustomRefreshControl: UIView {

    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    private let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .clear

        addSubview(activityIndicator)
        addSubview(label)

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 8),
            label.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])

        label.text = "Pull to refresh"
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
    }
    
    func startAnimating() {
        activityIndicator.startAnimating()
        isHidden = false
    }
    
    func stopAnimating() {
        activityIndicator.stopAnimating()
        isHidden = true
    }
}
