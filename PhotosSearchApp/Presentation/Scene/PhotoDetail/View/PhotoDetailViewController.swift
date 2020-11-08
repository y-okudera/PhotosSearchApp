//
//  PhotoDetailViewController.swift
//  PhotosSearchApp
//
//  Created by okudera on 2020/11/04.
//

import UIKit
import RxCocoa
import RxSwift

final class PhotoDetailViewController: UIViewController, ViewProtocol {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var descriptionTextView: UITextView!
    @IBOutlet private weak var closeButton: UIButton!
    
    var viewModel: PhotoDetailViewModelType!
    private var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindInput()
        self.bindOutput()
    }

    func bindInput() {

        self.rx.viewWillAppear
            .map { _ in }
            .bind(to: self.viewModel.input.viewWillAppear)
            .disposed(by: self.disposeBag)

        self.closeButton.rx.tap
            .bind(to: self.viewModel.input.tappedClose)
            .disposed(by: self.disposeBag)
    }

    func bindOutput() {

        self.viewModel.output.photo
            .bind(onNext: { [weak self] photo in
                self?.titleLabel.text = photo.title
                self?.descriptionTextView.text = photo.description
                self?.imageView.loadImage(urlString: photo.imageUrlString)
            })
            .disposed(by: self.disposeBag)
    }
}
