//
//  PhotoListViewModel.swift
//  FlickrDemo
//
//  Created by CH Kaan on 28/02/2023.
//

import Foundation
import Combine


class PhotoListViewModel: ObservableObject,PhotoListViewModelType {

    @Published var searchQuery = ""
    @Published var photos = [FlickrPhoto]()
    @Published var previousSearchQueries = [String]()
    
    var currentPage = 1
    var totalPage = 1
    var isLoading = false
    
    private let flickrService: FlickrPhotoServiceType
    private let outputEvents : PassthroughSubject<PhotoListViewModelOutput,Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
    init(flickrService : FlickrPhotoServiceType = FlickrPhotoService()){
        self.flickrService = flickrService
        self.loadPreviousSearchQueries()
    }
    
    func transform(input : AnyPublisher<PhotoListViewModelInput, Never>) -> AnyPublisher<PhotoListViewModelOutput, Never> {
        //Free up cancellables
        cancellables.forEach({ $0.cancel() })
        cancellables.removeAll()
        
        input
            .sink { [weak self] input in
                switch(input){
                case .viewDidAppear:
                    break
                case .searchChanged(let query):
                    if(query.count < 2){
                        self?.outputEvents.send(.showQueryHistory)
                    }else{
                        self?.currentPage = 1
                        self?.searchQuery = query
                    }
                case .pageFinished:
                    self?.getNextPage()
                case .searchTapped(let query):
                    self?.currentPage = 1
                    self?.searchQuery = query
                    self?.outputEvents.send(.showSearchQuery)
                }
            }
            .store(in: &cancellables)
        
        $searchQuery
            .debounce(for: 0.7, scheduler: DispatchQueue.main)
            .removeDuplicates()
            .filter({ $0.count >= 2 })
            .sink(receiveValue: { [weak self] receivedQuery in
                self?.photos.removeAll()
                self?.queryPhotos(query: receivedQuery, page: self?.currentPage ?? 1)
            })
            .store(in: &cancellables)
        
        return outputEvents.eraseToAnyPublisher()
    }
    
    func queryPhotos(query : String,page : Int){
        isLoading = true
        addSearchQueryIfNotExists(query: query)
        flickrService.getSearchResults(query: query,page: page)
            .sink { [weak self] completion in
                switch(completion){
                case .finished:
                    self?.outputEvents.send(.showSearchQuery)
                case .failure(let error):
                    self?.outputEvents.send(.searchQueryFailed(error: error))
                }
                self?.isLoading = false
            } receiveValue: { [weak self] (page,queryResult) in
                self?.totalPage = page
                self?.photos.append(contentsOf: queryResult)
            }
            .store(in: &cancellables)
    }
    
    func getNextPage(){
        //Check if we are already requesting new page and if we are at the end of the available pages
        if(!isLoading && (currentPage < totalPage)){
            isLoading = true
            currentPage += 1
            queryPhotos(query: searchQuery, page: currentPage)
        }
    }
    
}

//Previous Search Queries
extension PhotoListViewModel {
    
    func loadPreviousSearchQueries(){
        previousSearchQueries = UserDefaults.standard.stringArray(forKey: "searchQueries") ?? [String]()
    }
    
    func addSearchQueryIfNotExists(query : String) {
        previousSearchQueries = UserDefaults.standard.stringArray(forKey: "searchQueries") ?? [String]()
        if(!previousSearchQueries.contains(query)){
            previousSearchQueries.insert(query, at: 0)
            UserDefaults.standard.set(previousSearchQueries, forKey: "searchQueries")
        }
    }
    
    func removeAllQueries(){
        previousSearchQueries.removeAll()
        UserDefaults.standard.removeObject(forKey: "searchQueries")
    }
    
}
