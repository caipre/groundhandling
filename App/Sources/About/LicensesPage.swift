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

class LicensesPage: UITableViewController {
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private let licenses: [License]

  init(licenses: [License]) {
    self.licenses = licenses
    super.init(style: .plain)
    view.backgroundColor = Kite.color.background
    tableView.tableHeaderView = Thanks()
    tableView.estimatedRowHeight = 200
    tableView.rowHeight = UITableView.automaticDimension
    tableView.dataSource = self
    tableView.allowsSelection = false
  }

  // MARK: UITableViewDataSource

  override func numberOfSections(in tableView: UITableView) -> Int {
    1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    licenses.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
    -> UITableViewCell
  {
    let license = licenses[indexPath.row]
    let cell =
      tableView.dequeueReusableCell(withIdentifier: LicenseRow.reuseId) as? LicenseRow
      ?? LicenseRow(frame: .zero)
    cell.bind(to: license)
    return cell
  }
}

class Thanks: UIView {
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  init() {
    super.init(frame: .zero)
    backgroundColor = Kite.color.background
    let thanks = Kite.title(text: "about.thanks".l)
    thanks.font = thanks.font.bold
    addSubview(thanks)
    thanks.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    frame.size.height = thanks.intrinsicContentSize.height
  }
}

class LicenseRow: UITableViewCell, UITextViewDelegate {
  static let reuseId = "\(LicenseRow.self)"

  private var license: License!

  func bind(to license: License) {
    self.license = license
    let name = Kite.headline(text: license.name)
    let url = Kite.body(text: license.url)
    url.attributedText = NSAttributedString(string: license.url, attributes: [.link: license.url])
    url.delegate = self
    let license = Kite.body(text: license.license)
    license.font = .monospacedSystemFont(ofSize: 7, weight: .regular)
    backgroundColor = Kite.color.background
    contentView.addSubviews(name, url, license)
    let layout = contentView.layoutMarginsGuide
    NSLayoutConstraint.activate([
      name.topAnchor.constraint(equalTo: layout.topAnchor, constant: Kite.space.xsmall),
      name.leadingAnchor.constraint(equalTo: layout.leadingAnchor),
      name.trailingAnchor.constraint(equalTo: layout.trailingAnchor),
      url.topAnchor.constraint(equalTo: name.bottomAnchor),
      url.leadingAnchor.constraint(equalTo: layout.leadingAnchor),
      url.trailingAnchor.constraint(equalTo: layout.trailingAnchor),
      license.topAnchor.constraint(equalTo: url.bottomAnchor, constant: Kite.space.small),
      license.leadingAnchor.constraint(equalTo: layout.leadingAnchor),
      license.trailingAnchor.constraint(equalTo: layout.trailingAnchor),
      license.bottomAnchor.constraint(equalTo: layout.bottomAnchor, constant: -Kite.space.xsmall),
    ])
  }

  func textView(
    _ textView: UITextView,
    shouldInteractWith URL: URL,
    in characterRange: NSRange,
    interaction: UITextItemInteraction
  ) -> Bool {
    return URL.absoluteString == license.url
  }
}

struct License: Codable {
  let name: String
  let url: String
  let spdx: String
  let license: String
}
