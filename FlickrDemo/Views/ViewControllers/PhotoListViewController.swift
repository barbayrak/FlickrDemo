//
//  PhotoListViewController.swift
//  FlickrDemo
//
//  Created by CH Kaan on 27/02/2023.
//

import UIKit
import Combine

class PhotoListViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let imageService = ImageService()
    private let viewModel = PhotoListViewModel()
    private let eventInput: PassthroughSubject<PhotoListViewModelInput, Never> = .init()
    private var listState: CurrentValueSubject<PhotoListViewState,Never> = .init(.SearchHistory)
    private var cancellables = Set<AnyCancellable>()
    
    var collectionViewDataSource : UICollectionViewDiffableDataSource<Int,AnyHashable>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDiffableDataSource()
        setupBinder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        eventInput.send(.viewDidAppear)
    }
    
    private func setupDiffableDataSource(){
        collectionViewDataSource = UICollectionViewDiffableDataSource<Int,AnyHashable>(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            if let photo = item as? FlickrPhoto {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath)
                guard let photoCell = cell as? PhotoCollectionViewCell else {
                    return cell
                }
                photoCell.photoTitleLabel.text = photo.title
                guard let imageUrl = photo.smallSizePhotoUrl() else { return cell }
                photoCell.cancellable = self.imageService.getImageFromUrl(url: imageUrl)
                    .receive(on: DispatchQueue.main)
                    .sink { image in
                        photoCell.photoImageView.image = image
                    }
                return photoCell
            }else if let searchQuery = item as? String {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.identifier, for: indexPath)
                guard let searchCell = cell as? SearchCollectionViewCell else {
                    return cell
                }
                searchCell.searchLabel.text = searchQuery
                return searchCell
            }else{
                return UICollectionViewCell()
            }
        })
    }
    
    private func setupBinder(){
        let eventOutput = viewModel.transform(input: eventInput.eraseToAnyPublisher())
        eventOutput
            .receive(on: DispatchQueue.main)
            .sink { [weak self] outputEvent in
                switch(outputEvent){
                case .showQueryHistory:
                    self?.listState.send(.SearchHistory)
                    self?.applySearchQueriesToSnapshot(searchQueries: self?.viewModel.previousSearchQueries ?? [String]())
                case .searchQueryFailed(let error):
                    let alert = UIAlertController(title: "Query Failed", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self?.present(alert, animated: true)
                case .showSearchQuery:
                    self?.listState.send(.PhotoResults)
                    self?.applyPhotosToSnapshot(photos: self?.viewModel.photos ?? [FlickrPhoto]())
                }
            }
            .store(in: &cancellables)
    }
    
    private func applyPhotosToSnapshot(photos: [FlickrPhoto]){
        var snapshot = NSDiffableDataSourceSnapshot<Int,AnyHashable>()
        snapshot.appendSections([0])
        snapshot.appendItems(photos,toSection: 0)
        collectionViewDataSource.apply(snapshot)
    }
    
    private func applySearchQueriesToSnapshot(searchQueries : [String]){
        var snapshot = NSDiffableDataSourceSnapshot<Int,AnyHashable>()
        snapshot.appendSections([0])
        snapshot.appendItems(searchQueries,toSection: 0)
        collectionViewDataSource.apply(snapshot)
    }

}

extension PhotoListViewController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        eventInput.send(.searchChanged(query: searchText))
    }
    
}

extension PhotoListViewController : UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch(listState.value){
        case .PhotoResults:
            return viewModel.photos.count
        case .SearchHistory:
            return viewModel.previousSearchQueries.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch(listState.value){
        case .PhotoResults:
            // 2/3 Ratio
            let width = view.frame.width / 2
            let height = width * 1.5
            return CGSize(width: width ,height: height)
        case .SearchHistory:
            return CGSize(width: view.frame.width, height: 40)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        if maximumOffset - contentOffset <= 10 {
            eventInput.send(.pageFinished)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch(listState.value){
        case .PhotoResults:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath)
            guard let photoCell = cell as? PhotoCollectionViewCell else {
                return cell
            }
            let photo = viewModel.photos[indexPath.row]
            photoCell.photoTitleLabel.text = photo.title
            guard let imageUrl = photo.smallSizePhotoUrl() else { return cell }
            imageService.getImageFromUrl(url: imageUrl)
                .receive(on: DispatchQueue.main)
                .sink { image in
                    photoCell.photoImageView.image = image
                }
                .store(in: &cancellables)
            return photoCell
        case .SearchHistory:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.identifier, for: indexPath)
            guard let searchCell = cell as? SearchCollectionViewCell else {
                return cell
            }
            let searchQuery = viewModel.previousSearchQueries[indexPath.row]
            searchCell.searchLabel.text = searchQuery
            return searchCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch(listState.value){
        case .PhotoResults:
            let photo = viewModel.photos[indexPath.row]
            let photoDetailVC = PhotoDetailViewController.initWith(photo: photo)
            photoDetailVC.modalPresentationStyle = .automatic
            self.present(photoDetailVC, animated: true)
        case .SearchHistory:
            let searchQuery = viewModel.previousSearchQueries[indexPath.row]
            searchBar.text = searchQuery
            eventInput.send(.searchTapped(query: searchQuery))
        }
    }
    
}
