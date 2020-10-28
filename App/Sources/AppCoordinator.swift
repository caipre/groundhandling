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

import Kite
import UIKit

class AppCoordinator: Coordinator {
  public let navc: UINavigationController
  private var coordinator: Coordinator!
  private let onboarded: Bool

  init(onboarded: Bool) {
    self.onboarded = onboarded
    navc = UINavigationController()
    navc.navigationBar.standardAppearance.configureWithTransparentBackground()
    navc.navigationBar.tintColor = Kite.color.secondary
  }

  func start() {
    if onboarded {
      coordinator = MainCoordinator(navc: navc)
    } else {
      coordinator = OnboardingCoordinator(navc: navc) {
        Current.repository.setOnboarded(to: true)
        self.coordinator = MainCoordinator(navc: self.navc)
        self.coordinator.start()
      }
    }
    coordinator.start()
  }
}
