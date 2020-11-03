//
//  PhotoCollectionViewCell.swift
//  PhotosSearchApp
//
//  Created by okudera on 2020/11/01.
//

import UIKit

final class PhotoCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var thumbnailImageView: UIImageView!

    var photo: PhotosSearchModel.Photo? {
        didSet {
            guard let photo = photo else { return }
            self.thumbnailImageView.loadImage(urlString: photo.imageUrlString)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.thumbnailImageView.image = nil
    }
}

extension PhotoCollectionViewCell {
    static func size(collectionViewWidth: CGFloat,
                     itemPerRow: Int = 2,
                     spacing: CGFloat = 8,
                     sideMargin: CGFloat = 8 * 2) -> CGSize {

        let spacings = spacing * CGFloat(itemPerRow - 1)
        let width = floor((collectionViewWidth - sideMargin - spacings) / CGFloat(itemPerRow))

        // 1:1
        let height = width
        return CGSize(width: width, height: height)
    }
}
