//
//  SongViewController.swift
//  ITunes Clone
//
//  Created by Руслан Адигамов on 05.01.2023.
//

import UIKit

class SongViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let imageView = UIImageView()
    let tableview = UITableView()
    let tableContent: [String: String]
    
    private var song: Results
    
    init(song: Results) {
        self.song = song
        
        var cont: [String: String] = [:]
        cont["Track name"] = song.trackName
        cont["Album name"] = song.collectionName
        cont["Artist name"] = song.artistName
        if let price = song.trackPrice, let currency = song.currency {
            cont["Price"] = "\(price) \(currency)"
            
        }
        tableContent = cont
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        title = "More Info"
        setup()
    }
    private func setup() {
        if let url = song.artworkUrl100 {
            loadImage(url: url)
        }
        
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.heightAnchor.constraint(equalToConstant: 100)
        ])
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        
        tableview.delegate = self
        tableview.dataSource = self
        view.addSubview(tableview)
        tableview.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableview.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            tableview.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableview.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tableview.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
    }
    private func loadImage(url: String) {
        Task {
            var imageData = await LocalDataService().getImage(by: url)
            if imageData == nil {
                imageData = try? await NetworkController.loadImage(url: url)
                if let data = imageData {
                    LocalDataService().saveImage(data: data, from: url)
//                    DatabaseController.shared.setImage(data: data, url: url)
                }
            }
            guard let imageData = imageData else {
                print("No image")
                return
            }
            DispatchQueue.main.async {
                if let image = UIImage(data: imageData) {
                    self.imageView.image = image
                } else {
                    self.imageView.image = UIImage(systemName: "xmark.diamond.fill")
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableContent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        var contentConfiguration = UIListContentConfiguration.valueCell()
        let key = Array(tableContent.keys)[indexPath.row]
        contentConfiguration.text = key
        contentConfiguration.secondaryText = tableContent[key]
        cell.contentConfiguration = contentConfiguration
        return cell
    }
}


