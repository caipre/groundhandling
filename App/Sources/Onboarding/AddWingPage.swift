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

final class AddWingPage: UIViewController, OnboardingPage {
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public var pager: Pager?

  init() {
    super.init(nibName: nil, bundle: nil)

  }

  private var titleLabelConstraint: NSLayoutConstraint!

  override func loadView() {
    let view = Kite.views.background()
    view.directionalLayoutMargins = Kite.margins.directional

    let layout = view.layoutMarginsGuide

    let titleLabel = Kite.title(text: "onboarding.addwing.title".l)
    let textLabel = Kite.body(text: "onboarding.addwing.text".l)
    let addWingField = UITextField(frame: .zero)
    addWingField.translatesAutoresizingMaskIntoConstraints = false
    addWingField.placeholder = "onboarding.addwing.field".l
    let nextLabel = Kite.headline(text: "onboarding.addwing.next".l)
    nextLabel.isUserInteractionEnabled = true
    nextLabel.addGestureRecognizer(
      UITapGestureRecognizer(target: self, action: #selector(nextPage))
    )

    view.addSubviews(titleLabel, textLabel, nextLabel, addWingField)

    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: layout.topAnchor),
      titleLabel.centerXAnchor.constraint(equalTo: layout.centerXAnchor),

      textLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
      textLabel.centerXAnchor.constraint(equalTo: layout.centerXAnchor),

      addWingField.topAnchor.constraint(equalTo: textLabel.bottomAnchor),
      addWingField.centerXAnchor.constraint(equalTo: layout.centerXAnchor),

      nextLabel.topAnchor.constraint(equalTo: addWingField.bottomAnchor),
      nextLabel.centerXAnchor.constraint(equalTo: layout.centerXAnchor),
    ])

    self.view = view
  }

  @objc func nextPage() {
    pager?.next(sender: self)
  }
}
