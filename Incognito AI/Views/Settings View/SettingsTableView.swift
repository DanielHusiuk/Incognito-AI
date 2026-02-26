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
    let switchTrailingConstant: CGFloat = -12
    let chevronTrailingConstant: CGFloat = -20
    
    let keyboardOnLaunchSwitch = UISwitch()
    let hideKeyboardSwitch = UISwitch()
    
    let swipeGesturesButton = UIButton()
    let confirmChatSwitch = UISwitch()
    
    let appearanceButton = UIButton()
    let accentColorButton = UIButton()
    let landscapeModeSwitch = UISwitch()
    let backgroundAnimationSwitch = UISwitch()
    
    let hapticSwitch = UISwitch()
    let appLanguageButton = UIButton()

    
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
        separatorInset = UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18)
        
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let sectionModel = tableViewModel.cells[section]
        if sectionModel.header != "" {
            return 40
        } else {
            return 20
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let sectionModel = tableViewModel.cells[section]
        if sectionModel.footer != "" {
            return 40
        } else {
            return 20
        }
    }
    
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
            if (tableViewModel.cells.last != nil) {
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
        
        let shouldHighlight = self.tableView(tableView, shouldHighlightRowAt: indexPath)
        cell.isHighlightable = shouldHighlight
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                keyboardOnLaunchSwitch(in: cell)
            case 1:
                hideKeyboardSwitch(in: cell)
            default:
                return cell
            }
        case 1:
            switch indexPath.row {
            case 0:
                return cell
            case 1:
                confirmChatSwitch(in: cell)
            default:
                return cell
            }
        case 2:
            switch indexPath.row {
            case 0:
                return cell
            case 1:
                return cell
            case 2:
                landscapeModeSwitch(in: cell)
            case 3:
                backgroundAnimationSwitch(in: cell)
            default:
                return cell
            }
        case 3:
            switch indexPath.row {
            case 0:
                hapticSwitch(in: cell)
            case 1:
                return cell
            default:
                return cell
            }
        case 4:
            switch indexPath.row {
            case 0:
                chevronImageView(in: cell)
            case 1:
                chevronImageView(in: cell)
            default:
                return cell
            }
        default:
            return cell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.section {
        case 2:
            switch indexPath.row {
            case 0:
                print("appearance")
            case 1:
                print("1")
            case 3:
                print("3")
            default:
                return
            }
        case 3:
            switch indexPath.row {
            case 1:
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            default:
                return
            }
        case 4:
            switch indexPath.row {
            case 0:
                print("send feedback")
            case 1:
                print("report a bug")
            default:
                return
            }
        case 5:
            developerGitAlert()
        default:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        switch indexPath.section {
        case 0:
            return false
        case 1:
            switch indexPath.row {
            case 0:
                return true
            case 1:
                return false
            default:
                return true
            }
        case 2:
            switch indexPath.row {
            case 0, 1:
                return true
            case 2, 3:
                return false
            default:
                return true
            }
        case 3:
            switch indexPath.row {
            case 0:
                return false
            case 1:
                return true
            default:
                return true
            }
        default:
            return true
        }
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
            headerText.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -4)
        ])
        return headerView
    }
    
    func cellFooterView(text: String?, alignment: NSTextAlignment) -> UIView {
        let footerView = UIView()
        let footerText = UILabel()
        
        footerView.backgroundColor = .clear
        footerText.textColor = .cellAccessory
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
            footerText.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 4)
        ])
        return footerView
    }
    
    
    //MARK: - Keyboard Section
    
    func keyboardOnLaunchSwitch(in cell: UITableViewCell) {
        if let selectedTintColor = UserDefaults.standard.color(forKey: "buttonTintColor") {
            keyboardOnLaunchSwitch.onTintColor = selectedTintColor
        }
        keyboardOnLaunchSwitch.translatesAutoresizingMaskIntoConstraints = false
        keyboardOnLaunchSwitch.isOn = UserDefaults.standard.bool(forKey: "keyboardOnLaunchSwitchState")
        keyboardOnLaunchSwitch.addTarget(self, action: #selector(keyboardOnLaunchSwitchChanged(_:)), for: .valueChanged)
        
        cell.addSubview(keyboardOnLaunchSwitch)
        NSLayoutConstraint.activate([
            keyboardOnLaunchSwitch.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: switchTrailingConstant),
            keyboardOnLaunchSwitch.centerYAnchor.constraint(equalTo: cell.centerYAnchor)
        ])
    }
    
    @objc func keyboardOnLaunchSwitchChanged(_ sender: UISwitch) {
        if sender.isOn {
            print("kol on")
        } else {
            print("kol off")
        }
    }
    
    //
    func hideKeyboardSwitch(in cell: UITableViewCell) {
        if let selectedTintColor = UserDefaults.standard.color(forKey: "buttonTintColor") {
            hideKeyboardSwitch.onTintColor = selectedTintColor
        }
        hideKeyboardSwitch.translatesAutoresizingMaskIntoConstraints = false
        hideKeyboardSwitch.isOn = UserDefaults.standard.bool(forKey: "hideKeyboardSwitchState")
        hideKeyboardSwitch.addTarget(self, action: #selector(hideKeyboardSwitchChanged(_:)), for: .valueChanged)
        
        cell.addSubview(hideKeyboardSwitch)
        NSLayoutConstraint.activate([
            hideKeyboardSwitch.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: switchTrailingConstant),
            hideKeyboardSwitch.centerYAnchor.constraint(equalTo: cell.centerYAnchor)
        ])
    }
    
    @objc func hideKeyboardSwitchChanged(_ sender: UISwitch) {
        if sender.isOn {
            print("hkb on")
        } else {
            print("hkb off")
        }
    }
    
    
    //MARK: - Productivity Section
    
    func confirmChatSwitch(in cell: UITableViewCell) {
        if let selectedTintColor = UserDefaults.standard.color(forKey: "buttonTintColor") {
            confirmChatSwitch.onTintColor = selectedTintColor
        }
        confirmChatSwitch.translatesAutoresizingMaskIntoConstraints = false
        confirmChatSwitch.isOn = UserDefaults.standard.bool(forKey: "confirmChatSwitchState")
        confirmChatSwitch.addTarget(self, action: #selector(confirmChatSwitchChanged(_:)), for: .valueChanged)
        
        cell.addSubview(confirmChatSwitch)
        NSLayoutConstraint.activate([
            confirmChatSwitch.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: switchTrailingConstant),
            confirmChatSwitch.centerYAnchor.constraint(equalTo: cell.centerYAnchor)
        ])
    }
    
    @objc func confirmChatSwitchChanged(_ sender: UISwitch) {
        if sender.isOn {
            print("cnc on")
        } else {
            print("cnc off")
        }
    }
    
    
    //MARK: - Customisation Section
    
    func landscapeModeSwitch(in cell: UITableViewCell) {
        if let selectedTintColor = UserDefaults.standard.color(forKey: "buttonTintColor") {
            landscapeModeSwitch.onTintColor = selectedTintColor
        }
        landscapeModeSwitch.translatesAutoresizingMaskIntoConstraints = false
        landscapeModeSwitch.isOn = UserDefaults.standard.bool(forKey: "landscapeModeSwitchState")
        landscapeModeSwitch.addTarget(self, action: #selector(landscapeModeSwitchChanged(_:)), for: .valueChanged)
        
        cell.addSubview(landscapeModeSwitch)
        NSLayoutConstraint.activate([
            landscapeModeSwitch.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: switchTrailingConstant),
            landscapeModeSwitch.centerYAnchor.constraint(equalTo: cell.centerYAnchor)
        ])
    }
    
    @objc func landscapeModeSwitchChanged(_ sender: UISwitch) {
        if sender.isOn {
            print("lm on")
        } else {
            print("lm off")
        }
    }
    
    //
    func backgroundAnimationSwitch(in cell: UITableViewCell) {
        if let selectedTintColor = UserDefaults.standard.color(forKey: "buttonTintColor") {
            backgroundAnimationSwitch.onTintColor = selectedTintColor
        }
        backgroundAnimationSwitch.translatesAutoresizingMaskIntoConstraints = false
        backgroundAnimationSwitch.isOn = UserDefaults.standard.bool(forKey: "landscapeModeSwitchState")
        backgroundAnimationSwitch.addTarget(self, action: #selector(backgroundAnimationSwitchChanged(_:)), for: .valueChanged)
        
        cell.addSubview(backgroundAnimationSwitch)
        NSLayoutConstraint.activate([
            backgroundAnimationSwitch.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: switchTrailingConstant),
            backgroundAnimationSwitch.centerYAnchor.constraint(equalTo: cell.centerYAnchor)
        ])
    }
    
    @objc func backgroundAnimationSwitchChanged(_ sender: UISwitch) {
        if sender.isOn {
            print("ba on")
        } else {
            print("ba off")
        }
    }
    
    
    //MARK: - Preferences Section
    
    func hapticSwitch(in cell: UITableViewCell) {
        if let selectedTintColor = UserDefaults.standard.color(forKey: "buttonTintColor") {
            hapticSwitch.onTintColor = selectedTintColor
        }
        hapticSwitch.translatesAutoresizingMaskIntoConstraints = false
        hapticSwitch.isOn = UserDefaults.standard.bool(forKey: "HapticSwitchState")
        hapticSwitch.addTarget(self, action: #selector(hapticSwitchChanged(_:)), for: .valueChanged)
        
        cell.addSubview(hapticSwitch)
        NSLayoutConstraint.activate([
            hapticSwitch.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: switchTrailingConstant),
            hapticSwitch.centerYAnchor.constraint(equalTo: cell.centerYAnchor)
        ])
    }
    
    @objc func hapticSwitchChanged(_ sender: UISwitch) {
        if sender.isOn {
            print("hf on")
        } else {
            print("hf off")
        }
    }
    
    
    //MARK: - Other Section
    
    func chevronImageView(in cell: UITableViewCell) {
        let chevronImage = UIImageView()
        chevronImage.translatesAutoresizingMaskIntoConstraints = false
        chevronImage.image = UIImage(systemName: "chevron.right", withConfiguration: UIImage.SymbolConfiguration(pointSize: 15, weight: .bold))
        chevronImage.tintColor = .cellAccessory
        
        cell.addSubview(chevronImage)
        NSLayoutConstraint.activate([
            chevronImage.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: chevronTrailingConstant),
            chevronImage.centerYAnchor.constraint(equalTo: cell.centerYAnchor)
        ])
    }
    
    
    //MARK: - Author Section
    
    func developerGitAlert() {
        let selectedTintColor = UserDefaults.standard.color(forKey: "buttonTintColor")
        let gitAlert = UIAlertController(title: "Open developer's Git Hub?", message: "https://github.com/DanielHusiuk", preferredStyle: .alert)
        gitAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        let confirmAction = UIAlertAction(title: "Confirm", style: .default, handler: { [weak self] (action: UIAlertAction!) in
            guard self != nil else { return }
            
            if let gitURL = URL(string: "https://github.com/DanielHusiuk") {
                UIApplication.shared.open(gitURL, options: [:], completionHandler: nil)
            }
        })
        confirmAction.setValue(selectedTintColor, forKey: "titleTextColor")
        gitAlert.addAction(confirmAction)
        //        self.present(gitAlert, animated: true, completion: nil)
    }
    
}


