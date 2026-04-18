//
//  CellButtonManager.swift
//  Incognito AI
//
//  Created by Daniel Husiuk on 15.04.2026.
//

import UIKit

class CellButtonManager: UIButton {
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard let superview = self.superview else {
            return super.point(inside: point, with: event)
        }
        let pointInSuperview = self.convert(point, to: superview)
        return superview.bounds.contains(pointInSuperview)
    }
    
    var onHighlightChanged: ((Bool) -> Void)?
    
    override var isHighlighted: Bool {
        didSet {
            onHighlightChanged?(isHighlighted)
            var parentView: UIView? = self.superview
            while let view = parentView {
                if let cell = view as? SettingsTableCell {
                    cell.setHighlighted(self.isHighlighted, animated: false)
                    if isHighlighted {
                        cell.customCellView.backgroundColor = .cellBackground
                        UIView.animate(withDuration: 0.15, delay: 0.1, options: .curveEaseInOut, animations: {
                            cell.customCellView.backgroundColor = .secondarySystemGroupedBackground
                        })
                    }
                    break
                }
                parentView = view.superview
            }
        }
    }
}

