//
//  ServerResponce.swift
//  ITunes Clone
//
//  Created by Руслан Адигамов on 05.01.2023.
//

import Foundation

struct ServerResponce: Codable {
    let resultCount: Int?
    let results: [Results]
}

struct Results: Codable {
    let wrapperType, kind: String
    let artistId, collectionId, trackId: Int?
    let trackName, artistName: String
    let collectionName, collectionCensoredName: String?
    let trackCensoredName: String?
    let artistViewUrl, collectionViewUrl, trackViewUrl: String?
    let previewUrl: String?
    let artworkUrl30, artworkUrl60, artworkUrl100: String?
    let collectionPrice, trackPrice: Double?
    let releaseDate: Date?
    let collectionExplicitness, trackExplicitness: String
    let discCount, discNumber, trackCount, trackNumber: Int?
    let trackTimeMillis: Int?
    let country, currency: String?
    let primaryGenreName: String?
    let isStreamable: Bool?
    let collectionArtistId: Int?
    let collectionArtistName, contentAdvisoryRating: String?
}
