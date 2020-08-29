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

extension Kite {
  static func view() -> UIView {
    let view = UIView(frame: .zero)
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }

  static func title(text: String) -> UILabel {
    let label = UILabel(frame: .zero)
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.preferredFont(forTextStyle: .largeTitle).bold
    label.adjustsFontForContentSizeCategory = true
    label.text = text
    return label
  }

  static func headline(text: String) -> UILabel {
    let label = UILabel(frame: .zero)
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = .preferredFont(forTextStyle: .headline)
    label.adjustsFontForContentSizeCategory = true
    label.text = text
    return label
  }

  static func subhead(text: String) -> UILabel {
    let label = UILabel(frame: .zero)
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = .preferredFont(forTextStyle: .subheadline)
    label.adjustsFontForContentSizeCategory = true
    label.textColor = .secondaryLabel
    label.text = text
    return label
  }

  static func body(text: String) -> UILabel {
    let label = UILabel(frame: .zero)
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = .preferredFont(forTextStyle: .body)
    label.adjustsFontForContentSizeCategory = true
    label.text = text
    return label
  }

  static func caption(text: String) -> UILabel {
    let label = UILabel(frame: .zero)
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = .preferredFont(forTextStyle: .caption1)
    label.adjustsFontForContentSizeCategory = true
    label.text = text
    return label
  }
}
