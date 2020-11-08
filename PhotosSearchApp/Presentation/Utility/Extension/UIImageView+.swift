//
//  UIImageView+.swift
//  PhotosSearchApp
//
//  Created by okudera on 2020/11/03.
//

import Nuke
import UIKit

// MARK: - Load image from URLString
extension UIImageView {

    func loadImage(urlString: String?, loadingBackgroundColor: UIColor? = nil, defaultImage: UIImage? = nil) {

        guard let urlString = urlString, !urlString.isEmpty, let url = URL(string: urlString) else {
            self.image = defaultImage
            return
        }
        ImagePipeline.Configuration.isAnimatedImageDataEnabled = true
        let prevBackgroundColor = self.backgroundColor
        self.backgroundColor = loadingBackgroundColor

        let imageRequest = ImageRequest(url: url)
        let options = ImageLoadingOptions(transition: .fadeIn(duration: 0.3))
        Nuke.loadImage(with: imageRequest, options: options, into: self, completion: { [weak self] result in
            switch result {
            case .success(_):
                break
            case .failure(let error):
                log?.error("Image load error: \(error)")
                self?.image = defaultImage
            }
            self?.backgroundColor = prevBackgroundColor
        })
    }
}
