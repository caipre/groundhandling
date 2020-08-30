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

class HistoryPage: UIViewController {
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  init() {
    super.init(nibName: nil, bundle: nil)
  }

  override func loadView() {
    let view = Kite.views.background()

    let scrollv = UIScrollView(frame: .zero)
    scrollv.pin(to: view)

    let contentv = UIView(frame: .zero)
    contentv.directionalLayoutMargins = Kite.margins.directional
    contentv.pin(to: scrollv)

    let history = Kite.views.placeholder(name: "history")
    contentv.addSubviews(history)

    let layout = contentv.layoutMarginsGuide

    NSLayoutConstraint.activate([
      contentv.widthAnchor.constraint(equalTo: scrollv.widthAnchor),

      history.heightAnchor.constraint(equalToConstant: 80),
      history.topAnchor.constraint(equalTo: layout.topAnchor),
      history.leadingAnchor.constraint(equalTo: layout.leadingAnchor),
      history.trailingAnchor.constraint(equalTo: layout.trailingAnchor),
      history.bottomAnchor.constraint(equalTo: layout.bottomAnchor),
    ])

    self.view = view
  }
}
