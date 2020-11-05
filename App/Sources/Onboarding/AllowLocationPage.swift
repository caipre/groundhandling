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

import Combine
import Kite
import UIKit

final class AllowLocationPage: UIViewController, Paged {
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public var pager: Pager?
  private let location: LocationService

  init(location: LocationService) {
    self.location = location
    super.init(nibName: nil, bundle: nil)
  }

  override func loadView() {
    let view = Kite.views.background()
    view.directionalLayoutMargins = Kite.margins.directional

    let titleLabel = Kite.title1(text: "onboarding.location.title".l)
    let textLabel = Kite.body(text: "onboarding.location.text".l)
    let nextButton = Kite.views.button(
      title: "onboarding.location.button".l,
      target: self,
      selector: #selector(requestAuth)
    )
    view.addSubviews(titleLabel, textLabel, nextButton)

    let layout = view.layoutMarginsGuide
    let readable = view.readableContentGuide

    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(
        equalTo: layout.topAnchor,
        constant: Kite.space.xlarge
      ),
      titleLabel.centerXAnchor.constraint(equalTo: layout.centerXAnchor),

      textLabel.topAnchor.constraint(
        equalTo: titleLabel.bottomAnchor,
        constant: Kite.space.large
      ),
      textLabel.centerXAnchor.constraint(
        equalTo: layout.centerXAnchor
      ),
      textLabel.widthAnchor.constraint(
        equalTo: readable.widthAnchor
      ),

      nextButton.bottomAnchor.constraint(
        equalTo: layout.bottomAnchor,
        constant: -Kite.space.medium
      ),
      nextButton.centerXAnchor.constraint(equalTo: layout.centerXAnchor),
    ])

    self.view = view
  }

  private var cancellable: Cancellable?
  override func viewDidLoad() {
    cancellable = location.$authorizationStatus
      .sink { status in
        guard status != .notDetermined else { return }
        self.nextPage()
      }
  }

  @objc func requestAuth() {
    location.requestAuth()
  }

  @objc func nextPage() {
    pager?.next(sender: self)
  }
}
