//
//  SettingsTableView.swift
//  Incognito AI
//
//  Created by Daniel Husiuk on 17.12.2025.
//

import UIKit

enum TableCellPosition {
    case single
    case first
    case middle
    case last
}

class SettingsTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    let tableViewModel = SettingsModel()
    let tableViewCellHeight: CGFloat = 48
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: .insetGrouped)
        tableViewSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        tableViewSetup()
    }
    
    // MARK: - Updates
    
    func updatePreferences() {
        //update user preferences
    }
    
    func resetPreferences() {
        //reset user preferences
    }
    
    
    // MARK: - Table View Setup
    
    func tableViewSetup() {
        delegate = self
        dataSource = self
        register(SettingsTableCell.self, forCellReuseIdentifier: "settingsCell")
        
        indicatorStyle = .default
        backgroundColor = .clear
        contentMode = .scaleAspectFit
        separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        scrollsToTop = true
        alwaysBounceVertical = true
        translatesAutoresizingMaskIntoConstraints = false
        
        sectionHeaderHeight = UITableView.automaticDimension
        estimatedSectionHeaderHeight = 440
        sectionFooterHeight = UITableView.automaticDimension
        estimatedSectionFooterHeight = 40
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewModel.cells.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionModel = tableViewModel.cells[section]
        if sectionModel.cells.isEmpty {
            return 1
        } else {
            return 1 + sectionModel.cells.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableViewCellHeight
    }
    
    //    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    //        let sectionModel = tableViewModel.cells[section]
    //        if sectionModel.header != "" {
    //            return 30
    //        } else {
    //            return 20
    //        }
    //    }
    //
    //    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    //        let sectionModel = tableViewModel.cells[section]
    //        if sectionModel.footer != "" {
    //            return 30
    //        } else {
    //            return 20
    //        }
    //    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerText = tableViewModel.cells[section].header else { return nil }
        if headerText.isEmpty {
            return nil
        } else {
            return cellHeaderView(text: headerText)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footerText = tableViewModel.cells[section].footer else { return nil}
        if footerText.isEmpty {
            return nil
        } else {
            if tableViewModel.cells[section].id == 11 {
                return cellFooterView(text: footerText, alignment: .center)
            } else {
                return cellFooterView(text: footerText, alignment: .left)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as? SettingsTableCell else {
            return UITableViewCell()
        }
        let sectionModel = tableViewModel.cells[indexPath.section]
        let rowModel: SettingsCell
        
        if indexPath.row == 0 {
            rowModel = sectionModel
        } else {
            rowModel = sectionModel.cells[indexPath.row - 1]
        }
        
        let position = cell.cellPosition(in: tableView, at: indexPath)
        cell.applyCornerMask(to: cell, position: position)
        
        let isLast =
            indexPath.section == tableView.numberOfSections - 1 &&
            indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1
        cell.configure(title: rowModel.title, image: rowModel.titleImage, accessory: rowModel.accessoryImage, centered: isLast)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        return
    }
    
    
    //MARK: - Header & Footer View
    
    func cellHeaderView(text: String?) -> UIView {
        let headerView = UIView()
        let headerText = UILabel()
        
        headerView.backgroundColor = .clear
        headerText.textColor = .secondaryLabel
        headerText.textAlignment = .left
        headerText.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        headerText.translatesAutoresizingMaskIntoConstraints = false
        headerText.text = text
        
        if headerText.superview == nil {
            headerView.addSubview(headerText)
        }
        
        NSLayoutConstraint.activate([
            headerText.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 18),
            headerText.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -18),
            headerText.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 14),
            headerText.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -4)
        ])
        return headerView
    }
    
    func cellFooterView(text: String?, alignment: NSTextAlignment) -> UIView {
        let footerView = UIView()
        let footerText = UILabel()
        
        footerView.backgroundColor = .clear
        footerText.textColor = .tertiaryLabel
        footerText.textAlignment = alignment
        footerText.font = UIFont.systemFont(ofSize: 14)
        footerText.translatesAutoresizingMaskIntoConstraints = false
        footerText.text = text
        footerText.numberOfLines = 0
        footerText.lineBreakMode = .byWordWrapping
        
        if footerText.superview == nil {
            footerView.addSubview(footerText)
        }
        
        NSLayoutConstraint.activate([
            footerText.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 18),
            footerText.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -18),
            footerText.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 4),
            footerText.bottomAnchor.constraint(equalTo: footerView.bottomAnchor, constant: -4)
        ])
        return footerView
    }
    
}


