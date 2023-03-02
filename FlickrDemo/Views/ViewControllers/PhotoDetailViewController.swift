//
//  PhotoDetailViewController.swift
//  FlickrDemo
//
//  Created by CH Kaan on 01/03/2023.
//

import UIKit
import Combine

class PhotoDetailViewController: UIViewController {

    private let imageService = ImageService()
    private var cancellables = Set<AnyCancellable>()
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    
    private let viewModel = PhotoDetailViewModel()
    
    static func initWith(photo : FlickrPhoto) -> UIViewController {
        let viewController = UIStoryboard(name: "PhotoDetail", bundle: nil).instantiateViewController(withIdentifier: "DetailVC")
        guard let photoDetailViewController = viewController as? PhotoDetailViewController else {
            return viewController
        }
        photoDetailViewController.viewModel.setPhoto(photo: photo)
        return photoDetailViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI(){
        titleLabel.text = viewModel.photo.title
        guard let imageUrl = viewModel.photo.bigSizePhotoUrl() else { return }
        imageService.getImageFromUrl(url: imageUrl)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                self?.photoImageView.image = image
            }
            .store(in: &cancellables)
    }

    @IBAction func closeTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }

}
