//
//  SettingsTableCell.swift
//  Incognito AI
//
//  Created by Daniel Husiuk on 18.12.2025.
//

import UIKit

class SettingsTableCell: UITableViewCell {
    
    let customCellView = UIView()
    let tableViewCellHeight = SettingsTableView().tableViewCellHeight
    
    var titleLabelLeadingConstraint: NSLayoutConstraint!
    var titleLabelCenterConstraint: NSLayoutConstraint!
    
    private var titleImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.tintColor = .label
        return image
    }()
    
    private var accessoryImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.tintColor = .label
        return image
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCellUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCellUI()
    }
    
    
    //MARK: - Setup
    
    func setupCellUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none
        
        customCellSetup()
        titleImageSetup()
        accessoryImageSetup()
        titleLabelSetup()
    }
    
    func customCellSetup() {
        customCellView.translatesAutoresizingMaskIntoConstraints = false
        customCellView.backgroundColor = .secondarySystemGroupedBackground
        customCellView.layer.cornerRadius = tableViewCellHeight / 2
        customCellView.layer.masksToBounds = true
        contentView.addSubview(customCellView)
        
        NSLayoutConstraint.activate([
            customCellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            customCellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            customCellView.topAnchor.constraint(equalTo: contentView.topAnchor),
            customCellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            customCellView.heightAnchor.constraint(greaterThanOrEqualToConstant: tableViewCellHeight)
        ])
    }
    
    func titleImageSetup() {
        customCellView.addSubview(titleImageView)
        NSLayoutConstraint.activate([
            titleImageView.leadingAnchor.constraint(equalTo: customCellView.leadingAnchor, constant: 16),
            titleImageView.centerYAnchor.constraint(equalTo: customCellView.centerYAnchor)
        ])
    }
    
    func accessoryImageSetup() {
        customCellView.addSubview(accessoryImageView)
        NSLayoutConstraint.activate([
            accessoryImageView.heightAnchor.constraint(equalToConstant: 18),
            accessoryImageView.widthAnchor.constraint(equalToConstant: 18),
            accessoryImageView.trailingAnchor.constraint(equalTo: customCellView.trailingAnchor, constant: -16),
            accessoryImageView.centerYAnchor.constraint(equalTo: customCellView.centerYAnchor)
        ])
    }
    
    func titleLabelSetup() {
        customCellView.addSubview(titleLabel)
        titleLabelLeadingConstraint = titleLabel.leadingAnchor.constraint(equalTo: customCellView.leadingAnchor, constant: 50)
        titleLabelCenterConstraint = titleLabel.centerXAnchor.constraint(equalTo: customCellView.centerXAnchor)
                
        NSLayoutConstraint.activate([
            titleLabelLeadingConstraint,
            titleLabel.centerYAnchor.constraint(equalTo: customCellView.centerYAnchor)
        ])
    }
    
    
    //MARK: - Configuration
    
    func configure(title text: String, image titleImage: UIImage, accessory accessoryImage: UIImage?, centered: Bool) {
        titleLabel.text = text
        titleImageView.image = titleImage
        accessoryImageView.image = accessoryImage
        
        titleLabelCenterConstraint.isActive = centered
        titleLabelLeadingConstraint.isActive = !centered
    }
    
    func cellPosition(in tableView: UITableView, at indexPath: IndexPath) -> TableCellPosition {
        let rows = tableView.numberOfRows(inSection: indexPath.section)
        
        if rows == 1 {
            return .single
        } else if indexPath.row == 0 {
            return .first
        } else if indexPath.row == rows - 1 {
            return .last
        } else {
            return .middle
        }
    }
    
    func applyCornerMask(to cell: UITableViewCell, position: TableCellPosition) {
        let corners: CACornerMask
        
        switch position {
        case .single:
            corners = [ .layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        case .first:
            corners = [ .layerMinXMinYCorner, .layerMaxXMinYCorner]
        case .last:
            corners = [ .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        default:
            corners = []
        }
        customCellView.layer.maskedCorners = corners
    }
    
    
    //MARK: - Cell Touch Logic
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut, animations: {
            self.customCellView.backgroundColor = .cellBackground
        })
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        UIView.animate(withDuration: 0.15, delay: 0.1, options: .curveEaseInOut, animations: {
            self.customCellView.backgroundColor = .secondarySystemGroupedBackground
        })
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        UIView.animate(withDuration: 0.15, delay: 0.1, options: .curveEaseInOut, animations: {
            self.customCellView.backgroundColor = .secondarySystemGroupedBackground
        })
    }
    
}
