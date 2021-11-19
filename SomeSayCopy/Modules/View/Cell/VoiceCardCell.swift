import UIKit

class VoiceCardCell: UICollectionViewCell {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 28, weight: .semibold)
        label.textColor = .white
        label.numberOfLines = 0
        
        return label
    }()
    
    let durationLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white.withAlphaComponent(0.5)
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textAlignment = .center
        
        return label
    }()
    
    let soundLineBackView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        
        return view
    }()
    
    let soundLineView: UIView = {
        let view = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 0, height: 30)))
        view.backgroundColor = .white

        return view
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
        contentView.addSubview(durationLabel)
        contentView.addSubview(soundLineBackView)
        
        soundLineBackView.addSubview(soundLineView)
    }
    
    private func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        soundLineBackView.translatesAutoresizingMaskIntoConstraints = false
        
        var constraints = [NSLayoutConstraint]()
        
        let titleConstraints = [
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            titleLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 36 - 36),
            titleLabel.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/1.7)
        ]

        let durationConstraints = [
            durationLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            durationLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            durationLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
        ]
        
        let soundLineBackConstraint = [
            soundLineBackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 24),
            soundLineBackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -24),
            soundLineBackView.bottomAnchor.constraint(equalTo: durationLabel.topAnchor, constant: -24),
            soundLineBackView.heightAnchor.constraint(equalToConstant: 30)
        ]
        
        constraints.append(contentsOf: titleConstraints)
        constraints.append(contentsOf: durationConstraints)
        constraints.append(contentsOf: soundLineBackConstraint)
        
        NSLayoutConstraint.activate(constraints)
    }
}
