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
  public let navc: UINavigationController
  private var coordinator: Coordinator!

  init(navc: UINavigationController) {
    self.navc = navc
  }

  func start() {
    let vc = MainPage()
    vc.delegate = self
    navc.setViewControllers([vc], animated: true)
  }
}

// MARK: - MainPageDelegate
extension MainCoordinator: MainPageDelegate {
  func show(page: PageId.About) {
    switch page {
    case .about:
      coordinator = AboutCoordinator(navc: navc)
      coordinator.start()
    default:
      fatalError()  // invalid navigation
    }
  }

  func show(page: PageId.Challenge) {
    switch page {
    case .exercises(let level):
      coordinator = LevelCoordinator(navc: navc, level: level)
      coordinator.start()
    default:
      fatalError()  // invalid navigation
    }
  }
}
