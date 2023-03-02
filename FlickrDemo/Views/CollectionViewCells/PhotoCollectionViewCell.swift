//
//  PhotoCollectionViewCell.swift
//  FlickrDemo
//
//  Created by CH Kaan on 02/03/2023.
//

import UIKit
import Combine

class PhotoCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "photoCellId"
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var photoTitleLabel: UILabel!
    var cancellable: Cancellable?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
        photoTitleLabel.text = ""
    }
    
}
