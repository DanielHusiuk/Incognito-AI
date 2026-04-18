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
    
    override func tintColorDidChange() {
        super.tintColorDidChange()
        updateTintColor()
    }
    
    func updatePreferences() {
        keyboardOnLaunchSwitch.isOn = UserDefaults.standard.bool(forKey: "keyboardOnLaunchSwitch")
        hideKeyboardSwitch.isOn = UserDefaults.standard.bool(forKey: "hideKeyboardSwitch")
        
        confirmChatSwitch.isOn = UserDefaults.standard.bool(forKey: "confirmChatSwitch")
        
        landscapeModeSwitch.isOn = UserDefaults.standard.bool(forKey: "landscapeModeSwitch")
        backgroundAnimationSwitch.isOn = UserDefaults.standard.bool(forKey: "backgroundAnimationSwitch")
        
        hapticSwitch.isOn = UserDefaults.standard.bool(forKey: "hapticSwitch")
    }
    
    func resetPreferences() {
        keyboardOnLaunchSwitch.isOn = false
        UserDefaults.standard.set(false, forKey: "keyboardOnLaunchSwitch")
        hideKeyboardSwitch.isOn = true
        UserDefaults.standard.setValue(true, forKey: "hideKeyboardSwitch")
        
        confirmChatSwitch.isOn = false
        UserDefaults.standard.setValue(false, forKey: "confirmChatSwitch")
        
        landscapeModeSwitch.isOn = false
        UserDefaults.standard.setValue(false, forKey: "landscapeModeSwitch")
        backgroundAnimationSwitch.isOn = true
        UserDefaults.standard.setValue(true, forKey: "backgroundAnimationSwitch")
        
        hapticSwitch.isOn = true
        UserDefaults.standard.setValue(true, forKey: "hapticSwitch")
    }
    
    func updateTintColor() {
        let selectedTintColor = UserDefaults.standard.color(forKey: "buttonTintColor")
        let switches = [keyboardOnLaunchSwitch, hideKeyboardSwitch, confirmChatSwitch, landscapeModeSwitch, backgroundAnimationSwitch, hapticSwitch]
        switches.forEach {
            $0.onTintColor = selectedTintColor
        }
    }
    
    
    // MARK: - Table View Setup
    
    func tableViewSetup() {
        delegate = self
        dataSource = self
        register(SettingsTableCell.self, forCellReuseIdentifier: "settingsCell")
        updateTintColor()
        
        keyboardOnLaunchSwitch.tag = 100
        hideKeyboardSwitch.tag = 100
        swipeGesturesButton.tag = 100
        confirmChatSwitch.tag = 100
        appearanceButton.tag = 100
        accentColorButton.tag = 100
        landscapeModeSwitch.tag = 100
        backgroundAnimationSwitch.tag = 100
        hapticSwitch.tag = 100
        appLanguageButton.tag = 100
        
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
        
        cell.subviews.filter { $0.tag == 100 }.forEach { $0.removeFromSuperview() }
        cell.contentView.subviews.filter { $0.tag == 100 }.forEach { $0.removeFromSuperview() }
        
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
                swipeGesturesButton(in: cell)
            case 1:
                confirmChatSwitch(in: cell)
            default:
                return cell
            }
        case 2:
            switch indexPath.row {
            case 0:
                appearanceButton(in: cell)
            case 1:
                accentColorButton(in: cell)
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
                appLanguageButton(in: cell)
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
                NotificationCenter.default.post(name: Notification.Name("sendFeedback"), object: nil)
            case 1:
                NotificationCenter.default.post(name: Notification.Name("reportBug"), object: nil)
            default:
                return
            }
        case 5:
            NotificationCenter.default.post(name: Notification.Name("showGitAlert"), object: nil)
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
            UserDefaults.standard.set(true, forKey: "keyboardOnLaunchSwitch")
            NotificationCenter.default.post(name: Notification.Name("keyboardOnLaunchNotification"), object: nil)
        } else {
            UserDefaults.standard.set(false, forKey: "keyboardOnLaunchSwitch")
            NotificationCenter.default.post(name: Notification.Name("keyboardOnLaunchNotification"), object: nil)
        }
    }
    
    //
    func hideKeyboardSwitch(in cell: UITableViewCell) {
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
            UserDefaults.standard.set(true, forKey: "hideKeyboardSwitch")
            NotificationCenter.default.post(name: Notification.Name("hideKeyboardNotification"), object: nil)
        } else {
            UserDefaults.standard.set(false, forKey: "hideKeyboardSwitch")
            NotificationCenter.default.post(name: Notification.Name("hideKeyboardNotification"), object: nil)
        }
    }
    
    
    //MARK: - Productivity Section
    
    var swipeGesturesButtonMenuItem0 = UIAction(title: "None", image: UIImage(systemName: "xmark"), handler: { _ in
        UserDefaults.standard.set(0, forKey: "swipeGestureOption")
    })
    var swipeGesturesButtonMenuItem1 = UIAction(title: "Left & Right", image: UIImage(systemName: "arrow.left.arrow.right"), state: .on, handler: { _ in
        UserDefaults.standard.set(1, forKey: "swipeGestureOption")
    })
    var swipeGesturesButtonMenuItem2 = UIAction(title: "Only Left", image: UIImage(systemName: "arrow.left"), handler: { _ in
        UserDefaults.standard.set(2, forKey: "swipeGestureOption")
    })
    var swipeGesturesButtonMenuItem3 = UIAction(title: "Only Right", image: UIImage(systemName: "arrow.right"), handler: { _ in
        UserDefaults.standard.set(3, forKey: "swipeGestureOption")
    })
    
    func swipeGesturesButton(in cell: UITableViewCell) {
        swipeGesturesButton.translatesAutoresizingMaskIntoConstraints = false
        swipeGesturesButton.isUserInteractionEnabled = false
        swipeGesturesButton.showsMenuAsPrimaryAction = true
        
        var config = UIButton.Configuration.plain()
        var languageTitle = AttributedString("Left & Right")
        languageTitle.font = .systemFont(ofSize: 16, weight: .medium)
        config.attributedTitle = languageTitle
        
        config.image = UIImage(systemName: "chevron.right")
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 15, weight: .semibold, scale: .medium)
        config.imagePlacement = .trailing
        config.imagePadding = 4
        config.baseForegroundColor = .cellAccessory
        swipeGesturesButton.configuration = config
        swipeGesturesButton.addTarget(self, action: #selector(swipeGesturesButtonTouchUp), for: .touchUpInside)
        
        cell.contentView.addSubview(swipeGesturesButton)
        NSLayoutConstraint.activate([
            swipeGesturesButton.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -8),
            swipeGesturesButton.centerYAnchor.constraint(equalTo: cell.centerYAnchor)
        ])
        
        let swipesMenu = UIMenu(title: "Choose swipe gestures:", options: .singleSelection, children: [
            UIMenu(title: "", options: .displayInline, children: [swipeGesturesButtonMenuItem0]),
            swipeGesturesButtonMenuItem1,
            swipeGesturesButtonMenuItem2,
            swipeGesturesButtonMenuItem3
        ])
        
        let invisibleMenuTrigger = CellButtonManager(type: .custom)
        invisibleMenuTrigger.translatesAutoresizingMaskIntoConstraints = false
        invisibleMenuTrigger.showsMenuAsPrimaryAction = true
        invisibleMenuTrigger.menu = swipesMenu
        
        cell.contentView.addSubview(invisibleMenuTrigger)
        NSLayoutConstraint.activate([
            invisibleMenuTrigger.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -8),
            invisibleMenuTrigger.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            invisibleMenuTrigger.widthAnchor.constraint(equalToConstant: 44),
            invisibleMenuTrigger.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        invisibleMenuTrigger.onHighlightChanged = {[weak self] isHighlighted in
            let targetAlpha: CGFloat = isHighlighted ? 0.5 : 1.0
            self?.swipeGesturesButton.alpha = targetAlpha
        }
    }
    
    @objc func swipeGesturesButtonTouchUp() {
        print("Ui menu")
    }
    
    func confirmChatSwitch(in cell: UITableViewCell) {
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
            UserDefaults.standard.set(true, forKey: "confirmChatSwitch")
        } else {
            UserDefaults.standard.set(false, forKey: "confirmChatSwitch")
        }
    }
    
    
    //MARK: - Customisation Section
    
    var appearanceButtonMenuItem0 = UIAction(title: "System", image: UIImage(systemName: "gear"), state: .on, handler: { _ in
        UserDefaults.standard.set(0, forKey: "appearanceOption")
    })
    var appearanceButtonMenuItem1 = UIAction(title: "Light", image: UIImage(systemName: "sun.max"), handler: { _ in
        UserDefaults.standard.set(1, forKey: "appearanceOption")
    })
    var appearanceButtonMenuItem2 = UIAction(title: "Dark", image: UIImage(systemName: "moon"), handler: { _ in
        UserDefaults.standard.set(2, forKey: "appearanceOption")
    })
    
    func appearanceButton(in cell: UITableViewCell) {
        appearanceButton.translatesAutoresizingMaskIntoConstraints = false
        appearanceButton.isUserInteractionEnabled = false
        
        var config = UIButton.Configuration.plain()
        var languageTitle = AttributedString("System")
        languageTitle.font = .systemFont(ofSize: 16, weight: .medium)
        config.attributedTitle = languageTitle
        
        config.image = UIImage(systemName: "chevron.right")
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 15, weight: .semibold, scale: .medium)
        config.imagePlacement = .trailing
        config.imagePadding = 4
        config.baseForegroundColor = .cellAccessory
        appearanceButton.configuration = config
        
        cell.contentView.addSubview(appearanceButton)
        NSLayoutConstraint.activate([
            appearanceButton.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -8),
            appearanceButton.centerYAnchor.constraint(equalTo: cell.centerYAnchor)
        ])
        
        let appearanceMenu = UIMenu(title: "Choose app appearance:", options: .singleSelection, children: [
            UIMenu(title: "", options: .displayInline, children: [appearanceButtonMenuItem0]),
            appearanceButtonMenuItem1,
            appearanceButtonMenuItem2
        ])
        
        let invisibleMenuTrigger = CellButtonManager(type: .custom)
        invisibleMenuTrigger.translatesAutoresizingMaskIntoConstraints = false
        invisibleMenuTrigger.showsMenuAsPrimaryAction = true
        invisibleMenuTrigger.menu = appearanceMenu
        
        cell.contentView.addSubview(invisibleMenuTrigger)
        NSLayoutConstraint.activate([
            invisibleMenuTrigger.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -8),
            invisibleMenuTrigger.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            invisibleMenuTrigger.widthAnchor.constraint(equalToConstant: 44),
            invisibleMenuTrigger.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        invisibleMenuTrigger.onHighlightChanged = {[weak self] isHighlighted in
            let targetAlpha: CGFloat = isHighlighted ? 0.5 : 1.0
            self?.appearanceButton.alpha = targetAlpha
        }
    }
    
    var accentColorButtonMenuItem0 = UIAction(title: "System", image: UIImage(systemName: "gear"), handler: { _ in
        UserDefaults.standard.set(0, forKey: "accentColorOption")
    })
    var accentColorButtonMenuItem1 = UIAction(title: "Automatic", image: UIImage(systemName: "sparkle"), state: .on, handler: { _ in
        UserDefaults.standard.set(1, forKey: "accentColorOption")
    })
    var accentColorButtonMenuItem2 = UIAction(title: "Green", image: UIImage(named: "1.circle.fill"), handler: { _ in
        UserDefaults.standard.set(2, forKey: "accentColorOption")
    })
    var accentColorButtonMenuItem3 = UIAction(title: "Orange", image: UIImage(named: "2.circle.fill"), handler: { _ in
        UserDefaults.standard.set(3, forKey: "accentColorOption")
    })
    var accentColorButtonMenuItem4 = UIAction(title: "Purple", image: UIImage(named: "3.circle.fill"), handler: { _ in
        UserDefaults.standard.set(4, forKey: "accentColorOption")
    })
    var accentColorButtonMenuItem5 = UIAction(title: "Red", image: UIImage(named: "4.circle.fill"), handler: { _ in
        UserDefaults.standard.set(5, forKey: "accentColorOption")
    })
    var accentColorButtonMenuItem6 = UIAction(title: "Blue", image: UIImage(named: "5.circle.fill"), handler: { _ in
        UserDefaults.standard.set(6, forKey: "accentColorOption")
    })
    
    func accentColorButton(in cell: UITableViewCell) {
        accentColorButton.translatesAutoresizingMaskIntoConstraints = false
        accentColorButton.isUserInteractionEnabled = false
        
        var config = UIButton.Configuration.plain()
        var languageTitle = AttributedString("Automatic")
        languageTitle.font = .systemFont(ofSize: 16, weight: .medium)
        config.attributedTitle = languageTitle
        
        config.image = UIImage(systemName: "chevron.right")
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 15, weight: .semibold, scale: .medium)
        config.imagePlacement = .trailing
        config.imagePadding = 4
        config.baseForegroundColor = .cellAccessory
        accentColorButton.configuration = config
                
        cell.contentView.addSubview(accentColorButton)
        NSLayoutConstraint.activate([
            accentColorButton.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -8),
            accentColorButton.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor)
        ])
        
        let colorMenu = UIMenu(title: "Choose accent color:", options: .singleSelection, children: [
            UIMenu(title: "", options: .displayInline, children: [accentColorButtonMenuItem0, accentColorButtonMenuItem1]),
            accentColorButtonMenuItem2,
            accentColorButtonMenuItem3,
            accentColorButtonMenuItem4,
            accentColorButtonMenuItem5,
            accentColorButtonMenuItem6
        ])
        
        let invisibleMenuTrigger = CellButtonManager(type: .custom)
        invisibleMenuTrigger.translatesAutoresizingMaskIntoConstraints = false
        invisibleMenuTrigger.showsMenuAsPrimaryAction = true
        invisibleMenuTrigger.menu = colorMenu
        
        cell.contentView.addSubview(invisibleMenuTrigger)
        NSLayoutConstraint.activate([
            invisibleMenuTrigger.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -8),
            invisibleMenuTrigger.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            invisibleMenuTrigger.widthAnchor.constraint(equalToConstant: 44),
            invisibleMenuTrigger.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        invisibleMenuTrigger.onHighlightChanged = {[weak self] isHighlighted in
            let targetAlpha: CGFloat = isHighlighted ? 0.5 : 1.0
            self?.accentColorButton.alpha = targetAlpha
        }
    }
    
    func landscapeModeSwitch(in cell: UITableViewCell) {
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
            UserDefaults.standard.set(true, forKey: "landscapeModeSwitch")
        } else {
            UserDefaults.standard.set(false, forKey: "landscapeModeSwitch")
        }
    }
    
    //
    func backgroundAnimationSwitch(in cell: UITableViewCell) {
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
            UserDefaults.standard.set(true, forKey: "backgroundAnimationSwitch")
        } else {
            UserDefaults.standard.set(false, forKey: "backgroundAnimationSwitch")
        }
    }
    
    
    //MARK: - Preferences Section
    
    func hapticSwitch(in cell: UITableViewCell) {
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
            UserDefaults.standard.set(true, forKey: "hapticSwitch")
        } else {
            UserDefaults.standard.set(false, forKey: "hapticSwitch")
        }
    }
    
    func appLanguageButton(in cell: UITableViewCell) {
        appLanguageButton.translatesAutoresizingMaskIntoConstraints = false
        appLanguageButton.isUserInteractionEnabled = false
        
        var config = UIButton.Configuration.plain()
        var languageTitle = AttributedString("English")
        languageTitle.font = .systemFont(ofSize: 16, weight: .medium)
        config.attributedTitle = languageTitle
        
        config.image = UIImage(systemName: "chevron.right")
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 15, weight: .semibold, scale: .medium)
        config.imagePlacement = .trailing
        config.imagePadding = 4
        config.baseForegroundColor = .cellAccessory
        appLanguageButton.configuration = config
        
        cell.contentView.addSubview(appLanguageButton)
        NSLayoutConstraint.activate([
            appLanguageButton.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -8),
            appLanguageButton.centerYAnchor.constraint(equalTo: cell.centerYAnchor)
        ])
    }
    
    
    //MARK: - Other Section
    
    func chevronImageView(in cell: UITableViewCell) {
        let chevronImage = UIImageView()
        chevronImage.tag = 100
        chevronImage.translatesAutoresizingMaskIntoConstraints = false
        chevronImage.image = UIImage(systemName: "chevron.right", withConfiguration: UIImage.SymbolConfiguration(pointSize: 15, weight: .semibold))
        chevronImage.tintColor = .cellAccessory
        
        cell.addSubview(chevronImage)
        NSLayoutConstraint.activate([
            chevronImage.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: chevronTrailingConstant),
            chevronImage.centerYAnchor.constraint(equalTo: cell.centerYAnchor)
        ])
    }
    
}


