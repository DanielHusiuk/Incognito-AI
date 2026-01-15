//
//  MessagesCollectionView.swift
//  Incognito AI
//
//  Created by Daniel Husiuk on 02.11.2025.
//

import UIKit

class MessagesCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    weak var externalScrollDelegate: UIScrollViewDelegate?
    let layout = UICollectionViewFlowLayout()
    
    var messages: [ChatMessage] = []
    
    convenience init() {
        self.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    init(frame: CGRect) {
        super.init(frame: frame, collectionViewLayout: layout)
        collectionViewSetup()
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        collectionViewSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionViewSetup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        for cell in visibleCells {
            if let messageCell = cell as? MessageCollectionViewCell {
                messageCell.updateBubbleWidth(maxWidth: bounds.width * 0.8)
            }
        }
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        super.delegate = self
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        externalScrollDelegate?.scrollViewDidScroll?(scrollView)
    }
    
    
    //MARK: - Setup
    
    func collectionViewSetup() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        register(MessageCollectionViewCell.self, forCellWithReuseIdentifier: "MessageCell")
        dataSource = self
        
        indicatorStyle = .default
        backgroundColor = .clear
        contentMode = .scaleAspectFit
        
        scrollsToTop = true
        alwaysBounceVertical = true
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MessageCell", for: indexPath) as? MessageCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let message = messages[indexPath.section]
        cell.configure(with: message.content, role: message.role)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let message = messages[indexPath.section].content as NSString
        let maxWidth = collectionView.bounds.width * 0.8
        
        let tempTextView = UITextView()
        tempTextView.font = UIFont.systemFont(ofSize: 16)
        tempTextView.text = message as String
        tempTextView.textContainerInset = .zero
        tempTextView.textContainer.lineFragmentPadding = 0
        
        let textSize = tempTextView.sizeThatFits(CGSize(width: maxWidth - 28, height: .greatestFiniteMagnitude))
        let height = ceil(textSize.height) + 20
        return CGSize(width: collectionView.bounds.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        guard let cell = collectionView.cellForItem(at: indexPath) as? MessageCollectionViewCell else { return nil }
        let pointInCell = collectionView.convert(point, to: cell)
        if !cell.bubbleView.frame.contains(pointInCell) {
            return nil
        }
        return configureContextMenu(indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        guard
            let indexPath = configuration.identifier as? IndexPath,
            let cell = collectionView.cellForItem(at: indexPath) as? MessageCollectionViewCell
        else { return nil }
        return UITargetedPreview(view: cell.bubbleView, parameters: UIPreviewParameters())
    }
    
    func collectionView(_ collectionView: UICollectionView, previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        guard
            let indexPath = configuration.identifier as? IndexPath,
            let cell = collectionView.cellForItem(at: indexPath) as? MessageCollectionViewCell
        else { return nil }
        return UITargetedPreview(view: cell.bubbleView, parameters: UIPreviewParameters())
    }
    
    func configureContextMenu(indexPath: IndexPath) -> UIContextMenuConfiguration {
        return UIContextMenuConfiguration(identifier: indexPath as NSCopying, previewProvider: nil) { _ in
            let copy = UIAction(title: "Copy", image: UIImage(systemName: "doc.on.doc")) { _ in
                UIPasteboard.general.string = self.messages[indexPath.section].content
            }
            return UIMenu(title: "", children: [copy])
        }
    }
    
}
