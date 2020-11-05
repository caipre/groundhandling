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

  private var wingNameField: UITextField!
  private var nextButton: UIButton!
  private var nextButtonConstraint: NSLayoutConstraint!

  override func loadView() {
    let view = Kite.views.background()
    view.directionalLayoutMargins = Kite.margins.directional

    let titleLabel = Kite.title1(text: "onboarding.addwing.title".l)
    view.addSubviews(titleLabel)

    let wingNameLabel = Kite.body(text: "onboarding.addwing.name".l)
    wingNameField = UITextField(frame: .zero)
    wingNameField.font = .preferredFont(forTextStyle: .title1)
    wingNameField.translatesAutoresizingMaskIntoConstraints = false
    wingNameField.placeholder = "onboarding.addwing.name.placeholder".l
    view.addSubviews(wingNameLabel, wingNameField)

    nextButton = Kite.views.button(
      title: "onboarding.addwing.button".l,
      target: self,
      selector: #selector(nextPage)
    )
    nextButton.isEnabled = false
    view.addSubviews(nextButton)

    let layout = view.layoutMarginsGuide

    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(
        equalTo: layout.topAnchor,
        constant: Kite.space.xlarge
      ),
      titleLabel.centerXAnchor.constraint(equalTo: layout.centerXAnchor),

      wingNameLabel.topAnchor.constraint(
        equalTo: titleLabel.bottomAnchor,
        constant: Kite.space.large
      ),
      wingNameLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
      wingNameField.topAnchor.constraint(
        equalTo: wingNameLabel.bottomAnchor,
        constant: Kite.space.xsmall
      ),
      wingNameField.leadingAnchor.constraint(equalTo: wingNameLabel.leadingAnchor),


      nextButton.centerXAnchor.constraint(equalTo: layout.centerXAnchor),
      nextButton.widthAnchor.constraint(equalTo: layout.widthAnchor, multiplier: 0.8),
    ])

    nextButtonConstraint = nextButton.bottomAnchor.constraint(
      equalTo: layout.bottomAnchor,
      constant: -Kite.space.small
    )
    nextButtonConstraint.isActive = true

    self.view = view
  }

  override func viewDidLoad() {
    wingNameField.delegate = self
    wingNameField.becomeFirstResponder()
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillShow),
      name: UIResponder.keyboardWillShowNotification,
      object: nil
    )
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillHide),
      name: UIResponder.keyboardWillHideNotification,
      object: nil
    )
  }

  @objc func nextPage() {
    let wing = Wing(name: wingNameField.text!)
    handler.receive(wing: wing)
    pager?.next(sender: self)
  }

  @objc func keyboardWillShow(notification: NSNotification) {
    guard
      let keyboardSize =
        (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
    else { return }
    nextButtonConstraint.constant -= keyboardSize.height
    view.layoutIfNeeded()
  }

  @objc func keyboardWillHide(notification: NSNotification) {
    nextButtonConstraint.constant = -Kite.space.small
    view.layoutIfNeeded()
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
      !(wingNameField.text?.isEmpty ?? false)
    return true
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if nextButton.isEnabled { nextPage() }
    return true
  }
}
