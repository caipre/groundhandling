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

class MainPage: UIViewController {
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private let exercises: [Exercise]
  private lazy var levels = [
    Level(id: "A", desc: "Fledgling", count: 4),
    Level(id: "B", desc: "Beginner", count: 4),
    Level(id: "C", desc: "Intermediate", count: 10),
    Level(id: "D", desc: "Expert", count: 9),
    Level(id: "E", desc: "Acro Legend", count: 5),
  ]

  init(exercises: [Exercise]) {
    self.exercises = exercises
    super.init(nibName: nil, bundle: nil)
  }

  private var tableView: UITableView!
  private var tableHeight: NSLayoutConstraint!

  override func loadView() {
    let view = Kite.views.background()

    let scrollv = UIScrollView(frame: .zero)
    scrollv.pin(to: view)

    let contentv = UIView(frame: .zero)
    contentv.directionalLayoutMargins = Kite.margins.directional
    contentv.pin(to: scrollv)

    let image = Kite.views.image(named: "Nxn8Nm2yx0I")
    tableView = UITableView(frame: .zero, style: .plain)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 80
    tableView.isScrollEnabled = false
    contentv.addSubviews(image, tableView)

    let frame = scrollv.frameLayoutGuide
    let readable = contentv.readableContentGuide

    NSLayoutConstraint.activate([
      contentv.widthAnchor.constraint(equalTo: scrollv.widthAnchor),

      image.topAnchor.constraint(equalTo: contentv.topAnchor),
      image.trailingAnchor.constraint(equalTo: frame.trailingAnchor),
      image.heightAnchor.constraint(equalTo: image.widthAnchor),
      image.widthAnchor.constraint(equalTo: readable.widthAnchor, constant: -Kite.space.medium),

      tableView.topAnchor.constraint(equalTo: image.bottomAnchor, constant: Kite.space.medium),
      tableView.leadingAnchor.constraint(equalTo: readable.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: readable.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: contentv.bottomAnchor),
    ])

    tableHeight = tableView.heightAnchor.constraint(equalToConstant: 0)
    tableHeight.isActive = true

    self.view = view
  }

  override func viewDidLoad() {
    tableView.dataSource = self
    tableView.delegate = self
  }

  override func viewDidLayoutSubviews() {
    super.updateViewConstraints()
    tableHeight.constant = tableView.contentSize.height
  }
}

extension MainPage: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return levels.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let level = levels[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: LevelRow.reuseId) as? LevelRow ?? LevelRow(frame: .zero)
    cell.accessoryType = .disclosureIndicator
    cell.bind(to: level)
    return cell
  }
}

extension MainPage: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let level = levels[indexPath.row]
    let vc = ExercisesPage(level: level, exercises: exercises.filter { $0.level == level.id })
    show(vc, sender: self)
  }
}

class LevelRow: UITableViewCell {
  static let reuseId = "\(LevelRow.self)"

  private var id: UILabel!
  private var desc: UILabel!
  private var count: UILabel!

  func bind(to level: Level) {
    id = Kite.largeTitle(text: level.id)
    desc = Kite.title(text: level.desc)
    count = Kite.subhead(text: "\(level.count) exercises")
    backgroundColor = Kite.color.background
    contentView.addSubviews(id, desc, count)
    NSLayoutConstraint.activate([
      id.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      id.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
      desc.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Kite.space.small),
      desc.leadingAnchor.constraint(equalTo: id.trailingAnchor, constant: Kite.space.medium),
      count.topAnchor.constraint(equalTo: desc.lastBaselineAnchor),
      count.leadingAnchor.constraint(equalTo: desc.leadingAnchor),
      count.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Kite.space.small),
    ])
  }
}
