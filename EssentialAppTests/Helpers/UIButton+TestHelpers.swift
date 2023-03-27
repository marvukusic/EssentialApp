//
//  UIButton+TestHelpers.swift
//  EssentialFeediOSTests
//
//  Created by Marko Vukušić on 28.09.2022.
//

import UIKit

extension UIButton {
    func simulateTap() {
        simulate(event: .touchUpInside)
    }
}
