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

class UnsplashPage: UITableViewController {
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private let photos: [Photo]

  init(photos: [Photo]) {
    self.photos = photos
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
    photos.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
    -> UITableViewCell
  {
    let photo = photos[indexPath.row]
    let cell =
      tableView.dequeueReusableCell(withIdentifier: PhotoRow.reuseId) as? PhotoRow
      ?? PhotoRow(frame: .zero)
    cell.bind(to: photo)
    return cell
  }
}

class PhotoRow: UITableViewCell, UITextViewDelegate {
  static let reuseId = "\(PhotoRow.self)"

  private var photo: Photo!

  func bind(to photo: Photo) {
    self.photo = photo
    let image = Kite.views.image(named: photo.name)
    image.contentMode = .scaleAspectFit
    let credit = Kite.body(text: photo.url)
    let str = String(format: "unsplash.credit".l, photo.user)
    credit.attributedText = NSAttributedString(string: str, attributes: [.link: photo.url])
    credit.delegate = self

    backgroundColor = Kite.color.background
    contentView.addSubviews(image, credit)
    let layout = contentView.layoutMarginsGuide
    NSLayoutConstraint.activate([
      image.topAnchor.constraint(equalTo: layout.topAnchor, constant: Kite.space.xsmall),
      image.leadingAnchor.constraint(equalTo: layout.leadingAnchor),
      image.trailingAnchor.constraint(equalTo: layout.trailingAnchor),
      credit.topAnchor.constraint(equalTo: image.bottomAnchor),
      credit.leadingAnchor.constraint(equalTo: layout.leadingAnchor),
      credit.trailingAnchor.constraint(equalTo: layout.trailingAnchor),
      credit.bottomAnchor.constraint(equalTo: layout.bottomAnchor, constant: -Kite.space.xsmall),
    ])
  }

  func textView(
    _ textView: UITextView,
    shouldInteractWith URL: URL,
    in characterRange: NSRange,
    interaction: UITextItemInteraction
  ) -> Bool {
    return URL.absoluteString == photo.url
  }
}

struct Photo: Codable {
  let name: String
  let user: String
  let url: String
}
