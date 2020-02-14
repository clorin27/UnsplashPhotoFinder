//
//  UIViewController+Extensions.swift
//  UnsplashPhotoFinder
//
//  Created by Christelle Lorin on 2/13/20.
//  Copyright © 2020 Christelle Lorin. All rights reserved.
//

import UIKit

extension UIViewController {

    func embedViewController(_ viewController: UIViewController, in view: UIView, edgeInsets: UIEdgeInsets = .zero) {
        viewController.willMove(toParent: self)
        addChild(viewController)

        viewController.beginAppearanceTransition(true, animated: false)
        view.addEmbeddedSubview(viewController.view)
        viewController.endAppearanceTransition()

        viewController.didMove(toParent: self)
    }

    func unembedViewController(_ viewController: UIViewController) {
        viewController.willMove(toParent: nil)
        viewController.removeFromParent()

        viewController.beginAppearanceTransition(false, animated: false)
        viewController.view.removeFromSuperview()
        viewController.endAppearanceTransition()

        viewController.didMove(toParent: nil)
    }
}
