//
//  Extensions.swift
//  NewsFeed
//
//  Created by Данік on 10/08/2023.
//

import Foundation
import UIKit

protocol HasApply { }

extension HasApply {
    func apply(closure:(Self) -> ()) -> Self {
        closure(self)
        return self
    }
}

extension NSObject: HasApply { }


extension UINavigationBar {

    func hideNavBarSeparator() {
        let image = UIImage()
        shadowImage = image
        setBackgroundImage(image, for: UIBarMetrics.default)
    }

    func showNavBarSeparator() {
        let img = UIImage.pixelImageWithColor(color: UIColor.red)
        shadowImage = img
    }
}

extension UIImage {
    class func pixelImageWithColor(color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 5)
        UIGraphicsBeginImageContext(rect.size)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        context.setFillColor(color.cgColor)
        context.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }
}
