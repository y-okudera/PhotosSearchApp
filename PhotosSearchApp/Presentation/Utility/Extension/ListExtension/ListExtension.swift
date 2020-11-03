//
//  ListExtension.swift
//  PhotosSearchApp
//
//  Created by okudera on 2020/11/03.
//

import UIKit

/// UICollectionViewとUITableView共通のプロトコル
private protocol ListExtension: UIScrollView & UIDataSourceTranslating {
    associatedtype Cell: UIView

    /// Nibを登録する
    func registerNib(cellType: Cell.Type)

    /// 指定IndexPathにアイテムがあるかどうか
    func hasItem(at indexPath: IndexPath) -> Bool

    /// 指定IndexPathにスクロールする
    func scrollIfPossible(at indexPath: IndexPath, animated: Bool, completion: (() -> Void)?)

    /// トップにスクロールする
    func scrollToTop(animated: Bool, completion: (() -> Void)?)
}

// MARK: - UICollectionView
extension UICollectionView: ListExtension {

    func registerNib(cellType: UICollectionViewCell.Type) {
        let nib = UINib(nibName: cellType.identifier, bundle: nil)
        self.register(nib, forCellWithReuseIdentifier: cellType.identifier)
    }

    func hasItem(at indexPath: IndexPath) -> Bool {
        return indexPath.section < self.numberOfSections && indexPath.row < self.numberOfItems(inSection: indexPath.section)
    }

    func scrollIfPossible(at indexPath: IndexPath, animated: Bool, completion: (() -> Void)?) {
        if self.hasItem(at: indexPath) {
            UIView.animate(withDuration: .zero) { [weak self] in
                self?.scrollToItem(at: indexPath, at: .top, animated: animated)
            } completion: { _ in
                completion?()
            }
        } else {
            completion?()
        }
    }

    func scrollToTop(animated: Bool, completion: (() -> Void)? = nil) {
        let topIndex: IndexPath = [0, 0]
        self.scrollIfPossible(at: topIndex, animated: animated, completion: completion)
    }
}

// MARK: - UITableView
extension UITableView: ListExtension {

    func registerNib(cellType: UITableViewCell.Type) {
        let nib = UINib(nibName: cellType.identifier, bundle: nil)
        self.register(nib, forCellReuseIdentifier: cellType.identifier)
    }

    func hasItem(at indexPath: IndexPath) -> Bool {
        return indexPath.section < self.numberOfSections && indexPath.row < self.numberOfRows(inSection: indexPath.section)
    }

    func scrollIfPossible(at indexPath: IndexPath, animated: Bool, completion: (() -> Void)?) {
        if self.hasItem(at: indexPath) {
            UIView.animate(withDuration: .zero) { [weak self] in
                self?.scrollToRow(at: indexPath, at: .top, animated: animated)
            } completion: { _ in
                completion?()
            }
        } else {
            completion?()
        }
    }

    func scrollToTop(animated: Bool, completion: (() -> Void)? = nil) {
        let topIndex: IndexPath = [0, 0]
        self.scrollIfPossible(at: topIndex, animated: animated, completion: completion)
    }
}
