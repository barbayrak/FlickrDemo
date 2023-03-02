//
//  SearchCollectionViewCell.swift
//  FlickrDemo
//
//  Created by CH Kaan on 02/03/2023.
//

import UIKit

class SearchCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "searchCellId"
    
    @IBOutlet weak var searchLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        searchLabel.text = ""
    }
    
}
