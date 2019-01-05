import UIKit

class EmptyOverviewCell: BaseTableViewCell {
    
    let icon = UIImageView(image: #imageLiteral(resourceName: "summaryLarge").withRenderingMode(.alwaysTemplate))
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .drBlack
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    fileprivate func setupImageView() {
        icon.translatesAutoresizingMaskIntoConstraints = false
        addSubview(icon)
        centerX(item: icon)
        centerY(item: icon, constant: 0)
        icon.tintColor = .drBlack
    }
    
    fileprivate func setupTextLabel() {
        addSubview(descriptionLabel)
        descriptionLabel.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 20).isActive = true
        addConstraintsWithFormat(format: "H:|-20-[v0]-20-|", views: descriptionLabel)
        let atttributedText = NSMutableAttributedString(attributedString: NSAttributedString(string: "You have no history to generate an overview\n", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .semibold)]))
        atttributedText.append(NSAttributedString(string: "\n", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 4, weight: .regular)]))
        atttributedText.append(NSAttributedString(string: "It looks like you have not paid or been paid yet. Create a transaction and then you can see the overview here.", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: .regular)]))
        descriptionLabel.attributedText = atttributedText
    }
    
    override func setup() {
        backgroundColor = .white
        setupImageView()
        setupTextLabel()
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(false, animated: animated)
    }
}
