//
//  UIView+TestHelpers.swift
//  EssentialAppTests
//
//  Created by Marko Vukušić on 03.02.2023..
//

import UIKit

extension UIView {
    func enforceLayoutCycle() {
        layoutIfNeeded()
        RunLoop.current.run(until: Date())
    }
}
