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

import Cleanse
import Kite
import UIKit

protocol OnboardingPage {
  var pager: Pager? { get set }
}

class OnboardingCoordinator: Coordinator {
  public var root: UIViewController { navc }
  private let navc: UINavigationController
  private var coordinator: Coordinator?
  private var pages: [Provider<OnboardingPage & UIViewController>] = [
    Provider { WarningPage() },
    Provider { LocationPage() },
    Provider { AddWingPage() },
  ]
  init() {
    let vc = WelcomePage()
    navc = UINavigationController(rootViewController: vc)
    navc.navigationBar.standardAppearance.configureWithTransparentBackground()
    navc.navigationBar.tintColor = Kite.color.secondary
    vc.pager = self
  }
}

extension OnboardingCoordinator: Pager {
  func next(sender: UIViewController) {
    var next = pages.remove(at: 0).get()
    next.pager = self
    navc.show(next, sender: self)
  }
}
