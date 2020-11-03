//
//  CellExtension.swift
//  PhotosSearchApp
//
//  Created by okudera on 2020/11/03.
//

import UIKit

/// UICollectionViewCellとUITableViewCell共通のプロトコル
protocol CellExtension {
    static var identifier: String { get }
}

extension CellExtension {
    static var identifier: String {
        return String(describing: self)
    }
}

// MARK: - UICollectionViewCell
extension UICollectionViewCell: CellExtension {}

// MARK: - UITableViewCell
extension UITableViewCell: CellExtension {}
