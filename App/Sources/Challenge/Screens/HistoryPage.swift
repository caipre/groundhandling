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

class HistoryPage: UIViewController {
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private let exercise: Exercise
  private let records: [Record]

  init(exercise: Exercise, records: [Record]) {
    self.exercise = exercise
    self.records = records
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

    tableView = UITableView(frame: .zero, style: .plain)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 80
    tableView.allowsSelection = false
    contentv.addSubviews(tableView)

    let frame = scrollv.frameLayoutGuide
    let layout = contentv.layoutMarginsGuide

    NSLayoutConstraint.activate([
      contentv.widthAnchor.constraint(equalTo: scrollv.widthAnchor),

      tableView.topAnchor.constraint(equalTo: layout.topAnchor),
      tableView.leadingAnchor.constraint(equalTo: layout.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: layout.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: layout.bottomAnchor),
    ])

    tableHeight = tableView.heightAnchor.constraint(equalToConstant: 0)
    tableHeight.isActive = true

    self.view = view
  }

  override func viewDidLoad() {
    tableView.dataSource = self
    //    tableView.delegate = self
  }

  override func viewDidLayoutSubviews() {
    super.updateViewConstraints()
    tableHeight.constant = tableView.contentSize.height
  }
}

extension HistoryPage: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return records.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let record = records[indexPath.row]
    let cell =
      tableView.dequeueReusableCell(withIdentifier: RecordRow.reuseId) as? RecordRow
      ?? RecordRow(frame: .zero)
    cell.bind(to: record)
    return cell
  }
}

class RecordRow: UITableViewCell {
  static let reuseId = "\(RecordRow.self)"

  func bind(to record: Record) {
    let location = Kite.title(text: "Location placeholder")
    let date = Kite.subhead(
      text: DateFormatter.localizedString(from: record.date, dateStyle: .short, timeStyle: .short)
    )
    let windLabel = Kite.caption(text: "challenge.history.wind".l)
    let wind = Kite.subhead(text: "0,0 m/s")
    let wingLabel = Kite.caption(text: "challenge.history.wing".l)
    windLabel.text = wingLabel.text?.uppercased()
    let wing = Kite.subhead(text: record.wing)
    let map = Kite.views.placeholder(name: "map")
    let comments = Kite.views.placeholder(name: "comments")
    backgroundColor = Kite.color.background
    contentView.addSubviews(location, date, windLabel, wind, wingLabel, wing, map, comments)
    let layout = contentView.layoutMarginsGuide
    NSLayoutConstraint.activate([
      location.topAnchor.constraint(equalTo: layout.topAnchor),
      location.leadingAnchor.constraint(equalTo: layout.leadingAnchor),
      location.trailingAnchor.constraint(equalTo: layout.centerXAnchor),

      date.topAnchor.constraint(equalTo: location.bottomAnchor),
      date.leadingAnchor.constraint(equalTo: layout.leadingAnchor),
      date.trailingAnchor.constraint(equalTo: layout.centerXAnchor),

      windLabel.bottomAnchor.constraint(equalTo: wind.topAnchor, constant: -Kite.space.xsmall),
      windLabel.leadingAnchor.constraint(
        equalTo: layout.centerXAnchor,
        constant: Kite.space.xsmall
      ),
      windLabel.trailingAnchor.constraint(equalTo: layout.trailingAnchor),
      wind.leadingAnchor.constraint(equalTo: windLabel.leadingAnchor),
      wind.lastBaselineAnchor.constraint(equalTo: date.lastBaselineAnchor),
      //      wind.trailingAnchor.constraint(equalTo: wingLabel.leadingAnchor),

      wingLabel.bottomAnchor.constraint(equalTo: wind.topAnchor, constant: -Kite.space.xsmall),
      wingLabel.leadingAnchor.constraint(equalTo: wind.trailingAnchor, constant: Kite.space.small),
      wing.leadingAnchor.constraint(equalTo: wingLabel.leadingAnchor),
      wing.lastBaselineAnchor.constraint(equalTo: date.lastBaselineAnchor),

      map.topAnchor.constraint(equalTo: date.bottomAnchor, constant: Kite.space.xsmall),
      map.leadingAnchor.constraint(equalTo: layout.leadingAnchor),
      map.trailingAnchor.constraint(equalTo: layout.trailingAnchor),
      map.heightAnchor.constraint(equalToConstant: 80),

      comments.topAnchor.constraint(equalTo: map.bottomAnchor, constant: Kite.space.xsmall),
      comments.leadingAnchor.constraint(equalTo: layout.leadingAnchor),
      comments.trailingAnchor.constraint(equalTo: layout.trailingAnchor),
      comments.bottomAnchor.constraint(equalTo: layout.bottomAnchor),
      comments.heightAnchor.constraint(equalToConstant: 80),
    ])
  }
}
