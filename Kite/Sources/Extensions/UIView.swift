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

import Foundation
import UIKit

extension UIView {
  public func addSubviews(_ views: UIView...) {
    for view in views {
      self.addSubview(view)
    }
  }

  public func pin(to view: UIView) {
    view.addSubview(self)
    translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      topAnchor.constraint(equalTo: view.topAnchor),
      leadingAnchor.constraint(equalTo: view.leadingAnchor),
      trailingAnchor.constraint(equalTo: view.trailingAnchor),
      bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])
  }

  public func pin(to view: UIView, guide: UILayoutGuide) {
    view.addSubview(self)
    translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      topAnchor.constraint(equalTo: guide.topAnchor),
      leadingAnchor.constraint(equalTo: guide.leadingAnchor),
      trailingAnchor.constraint(equalTo: guide.trailingAnchor),
      bottomAnchor.constraint(equalTo: guide.bottomAnchor),
    ])
  }

  public func center(in view: UIView) {
    view.addSubview(self)
    translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      centerXAnchor.constraint(equalTo: view.centerXAnchor),
      centerYAnchor.constraint(equalTo: view.centerYAnchor),
    ])
  }

  public func showGuides() {
    backgroundColor = UIColor.systemBlue.withAlphaComponent(0.3)
    let lmg = UIView(frame: .zero)
    lmg.backgroundColor = UIColor.systemYellow.withAlphaComponent(0.3)
    lmg.pin(to: self, guide: layoutMarginsGuide)
    let rcg = UIView(frame: .zero)
    rcg.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.3)
    rcg.pin(to: self, guide: readableContentGuide)
  }

  public func rounded() -> UIView {
    layer.cornerRadius = 4
    return self
  }
}
