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

  //  Type sizes (default)
  //  https://developer.apple.com/design/human-interface-guidelines/ios/visual-design/typography#dynamic-type-sizes
  //  -------------------------
  //  Large Title Regular    34
  //  Title 1     Regular    28
  //  Title 2     Regular    22
  //  Title 3     Regular    20
  //  Headline    Semi-Bold  17
  //  Body        Regular    17
  //  Callout     Regular    16
  //  Subhead     Regular    15
  //  Footnote    Regular    13
  //  Caption 1   Regular    12
  //  Caption 2   Regular    12

  public static func largeTitle(text: String) -> UILabel {
    let label = Kite.label(text, style: .largeTitle)
    label.font = Kite.font(size: 48).bold
    label.numberOfLines = 0
    label.text = text
    return label
  }

  public static func title(text: String) -> UILabel {
    return Kite.label(text, style: .title2)
  }

  public static func headline(text: String) -> UILabel {
    return Kite.label(text, style: .headline)
  }

  public static func label(text: String) -> UILabel {
    return Kite.label(text, style: .body, color: Kite.color.secondary)
  }

  public static func body(text: String) -> UITextView {
    let view = UITextView(frame: .zero)
    view.translatesAutoresizingMaskIntoConstraints = false
    view.adjustsFontForContentSizeCategory = true
    view.backgroundColor = Kite.color.background
    view.isScrollEnabled = false
    view.isEditable = false
    view.textContainerInset = .zero
    view.textContainer.lineFragmentPadding = 0
    view.font = Kite.font(style: .body)
    view.textColor = Kite.color.primary
    view.text = text
    return view
  }

  public static func caption(text: String) -> UILabel {
    return Kite.label(text, style: .caption1, color: Kite.color.secondary)
  }

  fileprivate static func label(
    _ text: String,
    style: UIFont.TextStyle,
    color: UIColor = Kite.color.primary
  ) -> UILabel {
    let label = UILabel(frame: .zero)
    label.translatesAutoresizingMaskIntoConstraints = false
    label.adjustsFontForContentSizeCategory = true
    label.font = .preferredFont(forTextStyle: style)
    label.textColor = color
    label.text = text
    return label
  }
}
