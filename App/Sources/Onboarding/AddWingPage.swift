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

protocol AddWingHandler {
  func receive(wing: Wing)
}

final class AddWingPage: UIViewController, Paged {
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public var pager: Pager?
  public var handler: AddWingHandler

  init(handler: AddWingHandler) {
    self.handler = handler
    super.init(nibName: nil, bundle: nil)
  }

  private var wingBrandField: UITextField!
  private var wingNameField: UITextField!
  private var nextButton: UIButton!

  override func loadView() {
    let view = Kite.views.background()
    view.directionalLayoutMargins = Kite.margins.directional

    let layout = view.layoutMarginsGuide

    let titleLabel = Kite.title(text: "onboarding.addwing.title".l)
    view.addSubviews(titleLabel)

    let wingBrandLabel = Kite.body(text: "onboarding.addwing.text".l)
    wingBrandField = UITextField(frame: .zero)
    wingBrandField.translatesAutoresizingMaskIntoConstraints = false
    wingBrandField.placeholder = "onboarding.addwing.brand.placeholder".l
    view.addSubviews(wingBrandLabel, wingBrandField)

    let wingNameLabel = Kite.body(text: "onboarding.addwing.text".l)
    wingNameField = UITextField(frame: .zero)
    wingNameField.translatesAutoresizingMaskIntoConstraints = false
    wingNameField.placeholder = "onboarding.addwing.name.placeholder".l
    view.addSubviews(wingNameLabel, wingNameField)

    nextButton = Kite.views.button(
      title: "onboarding.addwing.next".l,
      target: self,
      selector: #selector(nextPage)
    )
    nextButton.isEnabled = false
    view.addSubviews(nextButton)

    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: layout.topAnchor),
      titleLabel.centerXAnchor.constraint(equalTo: layout.centerXAnchor),

      wingBrandLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
      wingBrandLabel.centerXAnchor.constraint(equalTo: layout.centerXAnchor),
      wingBrandField.topAnchor.constraint(equalTo: wingBrandLabel.bottomAnchor),
      wingBrandField.centerXAnchor.constraint(equalTo: layout.centerXAnchor),

      wingNameLabel.topAnchor.constraint(equalTo: wingBrandField.bottomAnchor),
      wingNameLabel.centerXAnchor.constraint(equalTo: layout.centerXAnchor),
      wingNameField.topAnchor.constraint(equalTo: wingNameLabel.bottomAnchor),
      wingNameField.centerXAnchor.constraint(equalTo: layout.centerXAnchor),

      nextButton.topAnchor.constraint(equalTo: wingNameField.bottomAnchor),
      nextButton.centerXAnchor.constraint(equalTo: layout.centerXAnchor),
    ])

    self.view = view
  }

  override func viewDidLoad() {
    wingBrandField.delegate = self
    wingNameField.delegate = self
    wingBrandField.becomeFirstResponder()
  }

  @objc func nextPage() {
    let wing = Wing(brand: wingBrandField.text!, name: wingNameField.text!)
    handler.receive(wing: wing)
    pager?.next(sender: self)
  }
}

// MARK: - UITextFieldDelegate
extension AddWingPage: UITextFieldDelegate {
  func textField(
    _ textField: UITextField,
    shouldChangeCharactersIn range: NSRange,
    replacementString string: String
  ) -> Bool {
    nextButton.isEnabled =
      (!(wingBrandField.text?.isEmpty ?? false) && !(wingNameField.text?.isEmpty ?? false))
    return true
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if nextButton.isEnabled { nextPage() }
    return true
  }
}
