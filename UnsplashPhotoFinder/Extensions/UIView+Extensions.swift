//
//  UIView+Extensions.swift
//  UnsplashPhotoFinder
//
//  Created by Christelle Lorin on 2/13/20.
//  Copyright © 2020 Christelle Lorin. All rights reserved.
//

import UIKit

extension UIView {
    
    func addEmbeddedSubview(_ subview: UIView, edgeInsets: UIEdgeInsets = .zero) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        
        subview.frame = bounds
        addSubview(subview)
        
        applyEmbedConstraints(to: subview, edgeInsets: edgeInsets)
    }
    
    @discardableResult func applyEmbedConstraints(to view: UIView, edgeInsets: UIEdgeInsets = UIEdgeInsets.zero) -> [NSLayoutConstraint] {
        guard view.isDescendant(of: self) else { return [] }
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let newConstraints = [
            view.topAnchor.constraint(equalTo: topAnchor, constant: edgeInsets.top),
            view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: edgeInsets.left),
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: edgeInsets.bottom),
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: edgeInsets.right)
        ]
        
        newConstraints.forEach {
            $0.isActive = true
        }
        
        return newConstraints
    }
}
