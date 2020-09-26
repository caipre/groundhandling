//  Copyright (C) 2020 Nick Platt <platt.nicholas@gmail.com>
//
//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation; either version 2 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.

import UIKit

class AppViewController: UINavigationController {
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  init(onboarding: Bool = false) {
    let main: UIViewController
    if onboarding {
      main = AddWingPage { LocationPage { MainPage() } }
    } else {
      main = MainPage()
    }
    super.init(rootViewController: main)
    navigationBar.standardAppearance.configureWithTransparentBackground()
    navigationBar.tintColor = Kite.color.secondary
  }
}
