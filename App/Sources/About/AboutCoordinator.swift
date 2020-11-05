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

class AboutCoordinator: Coordinator {
  public let navc: UINavigationController

  init(navc: UINavigationController) {
    self.navc = navc
  }

  func start() {
    let vc = AboutPage(releaseInfo: Current.releaseInfo)
    navc.show(vc, sender: self)
    vc.delegate = self
  }
}

// MARK: - AboutPageDelegate

extension AboutCoordinator: AboutPageDelegate {
  func show(page: PageId.About) {
    switch page {
    case .licenses:
      let vc = LicensesPage(licenses: Current.licenses)
      navc.show(vc, sender: self)
    case .unsplash:
      let vc = UnsplashPage(photos: [])
      navc.show(vc, sender: self)
    default:
      fatalError()  // invalid navigation
    }
  }
}
