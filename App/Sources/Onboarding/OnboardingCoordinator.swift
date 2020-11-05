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

class OnboardingCoordinator: Coordinator {
  public let navc: UINavigationController
  private let finished: (Repository) -> Void

  private var wing: Wing?

  // note: reverse ordered for peformance reasons
  private lazy var pages: [Provider<UIViewController & Paged>] = {
    [
      Provider { AddWingPage(handler: self) },
      Provider { AllowLocationPage(location: Current.location) },
    ]
  }()

  init(
    navc: UINavigationController,
    finished: @escaping (Repository) -> Void
  ) {
    self.navc = navc
    self.finished = finished
  }

  func start() {
    let page = WelcomePage()
    page.pager = self
    navc.navigationBar.isHidden = true
    navc.pushViewController(page, animated: false)
  }
}

extension OnboardingCoordinator: AddWingHandler {
  func receive(wing: Wing) {
    self.wing = wing
  }
}

extension OnboardingCoordinator: Pager {
  func next(sender: UIViewController) {
    guard let provider = pages.popLast() else {
      guard let wing = wing else { fatalError() }
      let repository = Current.makeRepository(wing: wing)
      finished(repository)
      return
    }
    var page = provider.get()
    page.pager = self
    navc.pushViewController(page, animated: true)
  }
}
