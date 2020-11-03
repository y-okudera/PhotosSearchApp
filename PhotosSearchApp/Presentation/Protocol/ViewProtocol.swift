//
//  ViewProtocol.swift
//  PhotosSearchApp
//
//  Created by okudera on 2020/11/03.
//

import UIKit

protocol ViewProtocol: UIViewController {
    associatedtype ViewModel = ViewModelProtocol
    var viewModel: ViewModel! { get set }
}
