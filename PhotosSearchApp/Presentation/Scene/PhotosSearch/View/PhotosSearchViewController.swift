//
//  PhotosSearchViewController.swift
//  PhotosSearchApp
//
//  Created by okudera on 2020/11/01.
//

import UIKit
import RxCocoa
import RxSwift

final class PhotosSearchViewController: UIViewController, ViewProtocol, ErrorAlert {

    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var collectionView: UICollectionView! {
        willSet {
            newValue.registerNib(cellType: PhotoCollectionViewCell.self)
        }
    }

    var viewModel: PhotosSearchViewModelType!
    private var disposeBag = DisposeBag()
    private var photos = [PhotosSearchModel.Photo]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindInput()
        self.bindOutput()
    }

    func bindInput() {
        self.searchBar.rx.searchButtonClicked
            .map { _ in self.searchBar.text }
            .filterNil()
            .bind(onNext: { [weak self] searchText in
                self?.viewModel.input.searchButtonTapped(searchText)
                self?.searchBar.endEditing(true)
            })
            .disposed(by: self.disposeBag)

        self.collectionView.rx.reachedBottom()
            .bind(onNext: { [weak self] in
                self?.viewModel.input.reachedBottom(())
                self?.searchBar.endEditing(true)
            })
            .disposed(by: self.disposeBag)
    }

    func bindOutput() {

        self.collectionView.rx.itemSelected
            .map { self.viewModel.output.photos.value[$0.row] }
            .bind(to: self.viewModel.input.selectedPhoto)
            .disposed(by: self.disposeBag)

        self.viewModel.output.needsScrollingToTop
            .filter { $0 }
            .bind(onNext: { [weak self] _ in
                self?.collectionView.scrollToTop(animated: false)
            })
            .disposed(by: self.disposeBag)

        self.viewModel.output.photos
            .skip(1)
            .bind(onNext: { [weak self] photos in
                guard let `self` = self else { return }
                self.photos = photos
                let isInitialRequest = self.viewModel.output.currentPage.value < 2
                self.reloadList(needsScrollingToTop: isInitialRequest)
            })
            .disposed(by: self.disposeBag)

        self.viewModel.output.initialRequestError
            .map { AppError(error: $0) }
            .bind(onNext: { [weak self] error in
                if error.isRetryable {
                    self?.showRetryableErrorAlert(error, retryAction: { [weak self] _ in
                        guard let `self` = self, let searchText = self.searchBar.text else {
                            return
                        }
                        self.viewModel.input.searchButtonTapped(searchText)
                        self.searchBar.endEditing(true)
                    })
                } else {
                    self?.showErrorAlert(error)
                }

            })
            .disposed(by: self.disposeBag)

        self.viewModel.output.additionalRequestError
            .map { AppError(error: $0) }
            .bind(onNext: { [weak self] error in
                if error.isRetryable {
                    self?.showRetryableErrorAlert(error, retryAction: { [weak self] _ in
                        self?.viewModel.input.reachedBottom(())
                        self?.searchBar.endEditing(true)
                    })
                } else {
                    self?.showErrorAlert(error)
                }
            })
            .disposed(by: self.disposeBag)
    }

    private func reloadList(needsScrollingToTop: Bool) {

        if needsScrollingToTop {
            self.collectionView.scrollToTop(animated: true) { [weak self] in
                self?.collectionView.reloadData()
            }
        } else {
            self.collectionView.reloadData()
        }
    }
}

extension PhotosSearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as! PhotoCollectionViewCell
        cell.photo = self.photos[indexPath.row]
        return cell
    }
}

extension PhotosSearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.photos.isEmpty {
            return collectionView.bounds.size
        } else {
            return PhotoCollectionViewCell.size(collectionViewWidth: collectionView.bounds.width)
        }
    }
}

extension PhotosSearchViewController: UIAdaptivePresentationControllerDelegate {

    func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
        print("PhotosSearchViewController.presentationControllerWillDismiss")
    }

    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        print("PhotosSearchViewController.presentationControllerDidDismiss")
    }
}
