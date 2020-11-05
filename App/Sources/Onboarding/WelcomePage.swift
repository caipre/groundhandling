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

final class WelcomePage: UIViewController, Paged {
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public var pager: Pager?

  init() {
    super.init(nibName: nil, bundle: nil)
  }

  override func loadView() {
    let view = Kite.views.background()
    view.directionalLayoutMargins = Kite.margins.directional

    let titleLabel = Kite.title1(text: "onboarding.welcome.title".l)
    let nextButton = Kite.views.button(
      title: "onboarding.welcome.button".l,
      target: self,
      selector: #selector(nextPage)
    )
    view.addSubviews(titleLabel, nextButton)

    let layout = view.layoutMarginsGuide

    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(
        equalTo: layout.topAnchor,
        constant: Kite.space.xlarge
      ),
      titleLabel.centerXAnchor.constraint(equalTo: layout.centerXAnchor),

      nextButton.bottomAnchor.constraint(
        equalTo: layout.bottomAnchor,
        constant: -Kite.space.medium
      ),
      nextButton.centerXAnchor.constraint(equalTo: layout.centerXAnchor),
    ])

    self.view = view
  }

  @objc func nextPage() {
    pager?.next(sender: self)
  }
}
