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

class AboutPage: UIViewController {
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  init() {
    super.init(nibName: nil, bundle: nil)
  }

  private var tableView: UITableView!

  override func loadView() {
    let view = Kite.views.background()
    view.directionalLayoutMargins = Kite.margins.directional

    let icon = Kite.views.placeholder(name: "app icon")
    icon.contentMode = .scaleAspectFit
    let version = Kite.subhead(text: AppContext.shared.release.version)
    version.font = .monospacedSystemFont(ofSize: 12, weight: .bold)
    let commit = Kite.subhead(text: AppContext.shared.release.commit)
    commit.font = .monospacedSystemFont(ofSize: 12, weight: .regular)
    view.addSubviews(icon, version, commit)

    let concept1 = Kite.headline(text: "Concept")
    concept1.font = concept1.font.bold
    let concept2 = Kite.subhead(text: "Andre Bandarra")
    let concept3 = Kite.subhead(text: "https://andrebandarra.com")
    view.addSubviews(concept1, concept2, concept3)

    let develop1 = Kite.headline(text: "Development")
    develop1.font = develop1.font.bold
    let develop2 = Kite.subhead(text: "Nick Platt")
    let develop3 = Kite.subhead(text: "https://nickp.co")
    view.addSubviews(develop1, develop2, develop3)

    let acknow = Kite.headline(text: "Acknowledgements")
    acknow.font = acknow.font.bold
    tableView = Kite.views.table()
    tableView.rowHeight = 80

    view.addSubviews(acknow, tableView)

    let layout = view.layoutMarginsGuide

    NSLayoutConstraint.activate([
      icon.topAnchor.constraint(equalTo: layout.topAnchor),
      icon.heightAnchor.constraint(equalTo: icon.widthAnchor),
      icon.widthAnchor.constraint(equalToConstant: 100),
      icon.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      version.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: Kite.space.xsmall),
      version.trailingAnchor.constraint(equalTo: icon.trailingAnchor),
      commit.topAnchor.constraint(equalTo: version.bottomAnchor),
      commit.trailingAnchor.constraint(equalTo: icon.trailingAnchor),

      concept1.topAnchor.constraint(equalTo: commit.bottomAnchor, constant: Kite.space.large),
      concept1.leadingAnchor.constraint(equalTo: layout.leadingAnchor),
      concept1.trailingAnchor.constraint(equalTo: layout.trailingAnchor),
      concept2.topAnchor.constraint(equalTo: concept1.bottomAnchor),
      concept2.leadingAnchor.constraint(equalTo: layout.leadingAnchor),
      concept2.trailingAnchor.constraint(equalTo: layout.trailingAnchor),
      concept3.topAnchor.constraint(equalTo: concept2.bottomAnchor),
      concept3.leadingAnchor.constraint(equalTo: layout.leadingAnchor),
      concept3.trailingAnchor.constraint(equalTo: layout.trailingAnchor),

      develop1.topAnchor.constraint(equalTo: concept3.bottomAnchor, constant: Kite.space.medium),
      develop1.leadingAnchor.constraint(equalTo: layout.leadingAnchor),
      develop1.trailingAnchor.constraint(equalTo: layout.trailingAnchor),
      develop2.topAnchor.constraint(equalTo: develop1.bottomAnchor),
      develop2.leadingAnchor.constraint(equalTo: layout.leadingAnchor),
      develop2.trailingAnchor.constraint(equalTo: layout.trailingAnchor),
      develop3.topAnchor.constraint(equalTo: develop2.bottomAnchor),
      develop3.leadingAnchor.constraint(equalTo: layout.leadingAnchor),
      develop3.trailingAnchor.constraint(equalTo: layout.trailingAnchor),

      acknow.topAnchor.constraint(equalTo: develop3.bottomAnchor, constant: Kite.space.large),
      acknow.leadingAnchor.constraint(equalTo: layout.leadingAnchor),
      acknow.trailingAnchor.constraint(equalTo: layout.trailingAnchor),
      tableView.topAnchor.constraint(equalTo: acknow.bottomAnchor),
      tableView.leadingAnchor.constraint(equalTo: layout.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: layout.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: layout.bottomAnchor),
    ])

    self.view = view
  }

  override func viewDidLoad() {
    tableView.dataSource = self
    tableView.delegate = self
  }
}

extension AboutPage: UITableViewDataSource {
  var reuseId: String { "acknowledgements" }
  var acknowledgements: [String] { ["Open source", "Unsplash"] }
  func numberOfSections(in tableView: UITableView) -> Int {
    1
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    2
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let resource = acknowledgements[indexPath.row]
    let cell =
      tableView.dequeueReusableCell(withIdentifier: reuseId)
      ?? UITableViewCell(style: .default, reuseIdentifier: reuseId)
    let text = Kite.headline(text: resource)
    cell.backgroundColor = Kite.color.background
    cell.contentView.addSubview(text)
    cell.accessoryType = .disclosureIndicator
    text.pin(to: cell.contentView)
    return cell
  }
}

extension AboutPage: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch indexPath.row {
    case 0:
      show(LicensesPage(licenses: AppContext.shared.licenses), sender: self)
    case 1:
      show(UnsplashPage(photos: AppContext.shared.photos), sender: self)
    default:
      fatalError()
    }
    tableView.deselectRow(at: indexPath, animated: false)
  }
}

struct ReleaseInfo: Codable {
  let version: String
  let commit: String
}
