import UIKit

class VoiceCardCell: UICollectionViewCell {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Тестовая\nЗапись 1"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 28, weight: .semibold)
        label.textColor = .white
        label.numberOfLines = 0
        
        return label
    }()
    
    let gradientLayer = CAGradientLayer()
    var shouldAddGradient = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupView()
        setupConstraints()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        if shouldAddGradient {
            updateGradient()
            shouldAddGradient = false
        }
    }

    private func updateGradient() {
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.locations = [0.05,  0.95]
        gradientLayer.frame = bounds
        
        gradientLayer.cornerRadius = 24
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func setupView() {
        backgroundColor = .white
        layer.cornerRadius = 24
        layer.cornerCurve = .continuous
        
        contentView.addSubview(titleLabel)
    }
    
    private func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let containerConstraints = [
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            titleLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 36 - 36),
            titleLabel.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/1.7)
        ]
        
        
        
        NSLayoutConstraint.activate(containerConstraints)
    }
}
