//
//  FeedViewController.swift
//  Prototype
//
//  Created by José Daniel Fernández Sotelo on 12/7/23.
//

import UIKit

final class FeedViewController: UITableViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.dequeueReusableCell(withIdentifier: "FeedImageCell")!
    }
}
