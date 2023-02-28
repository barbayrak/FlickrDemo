//
//  FlickrPhotoService.swift
//  FlickrDemo
//
//  Created by CH Kaan on 27/02/2023.
//

import Foundation
import Combine

class FlickrPhotoService : FlickrPhotoServiceType {
    
    var session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func getSearchResults(query : String, page : Int = 1) -> AnyPublisher<[FlickrPhoto], Error> {
        guard let url = buildSearchResultUrl(text: query,page: page) else {
            return Fail(error: APIError.invalidUrl).eraseToAnyPublisher()
        }
        
        print(url.absoluteString)
        return URLSession.shared.dataTaskPublisher(for: url)
            .mapError { error -> Error in
                return APIError.networkError
            }
            .tryMap{ (data: Data, response: URLResponse) in
                let decoder = JSONDecoder()
                let searchResult = try decoder.decode(FlickrPhotoSearchResult.self, from: data)
                
                //Flickr API Error Handling
                if(searchResult.stat == "fail"){
                    switch(searchResult.code){
                    case 10:
                        throw APIError.apiNotAvailable
                    case 100:
                        throw APIError.invalidApiKey
                    case 105:
                        throw APIError.serviceUnavailable
                    case 116:
                        throw APIError.invalidUrl
                    default:
                        throw APIError.customError
                    }
                }
                
                return searchResult.photos?.photo ?? [FlickrPhoto]()
            }
            .eraseToAnyPublisher()
    }
    
    private func buildSearchResultUrl(text: String,page: Int = 1) -> URL? {
        var urlComponent = URLComponents()
        urlComponent.scheme = Configurations.FlickrAPI.scheme
        urlComponent.host = Configurations.FlickrAPI.host
        urlComponent.path = Configurations.FlickrAPI.searchPath
        
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: "method", value: Configurations.FlickrAPI.searchMethod))
        queryItems.append(URLQueryItem(name: "api_key", value: Configurations.FlickrAPI.apiKey))
        queryItems.append(URLQueryItem(name: "format", value: Configurations.FlickrAPI.responseFormat))
        queryItems.append(URLQueryItem(name: "nojsoncallback", value: Configurations.FlickrAPI.noJsonCallback))
        queryItems.append(URLQueryItem(name: "per_page", value: Configurations.FlickrAPI.itemPerPage.description))
        queryItems.append(URLQueryItem(name: "page", value: page.description))
        queryItems.append(URLQueryItem(name: "text", value: text))
        
        urlComponent.queryItems = queryItems
        
        return urlComponent.url
    }
    
}
