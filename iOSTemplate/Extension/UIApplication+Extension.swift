//
//  UIApplication+Extension.swift
//  iOSTemplate
//
//  Created by Thắng Tô on 15/08/2023.
//

import UIKit

extension UIApplication {
    var keyWindowInConnectedScenes: UIWindow? {
        return windows.first(where: { $0.isKeyWindow })
    }
}
