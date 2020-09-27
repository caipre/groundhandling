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

class MainCoordinator: Coordinator {
  public var root: UIViewController { navc }
  private let navc: UINavigationController
  private var coordinator: Coordinator?
  init() {
    let vc = MainPage()
    navc = UINavigationController(rootViewController: vc)
    navc.navigationBar.standardAppearance.configureWithTransparentBackground()
    navc.navigationBar.tintColor = Kite.color.secondary
    vc.delegate = self
  }
}

// MARK: - MainPageDelegate
extension MainCoordinator: MainPageDelegate {
  func show(page: PageId.About) {
    switch page {
    case .about:
      let coordinator = AboutCoordinator(navc: navc)
      self.coordinator = coordinator
    default:
      fatalError()  // invalid navigation
    }
  }

  func show(page: PageId.Challenge) {
    switch page {
    case .exercises(let level):
      self.coordinator = LevelCoordinator(navc: navc, level: level)
    default:
      fatalError()  // invalid navigation
    }
  }
}
