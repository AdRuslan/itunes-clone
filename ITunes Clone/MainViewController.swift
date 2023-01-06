//
//  MainViewController.swift
//  ITunes Clone
//
//  Created by Руслан Адигамов on 05.01.2023.
//

import UIKit

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    let tableView = UITableView()
    let searchBar = UISearchBar()
    
    private var serverData: ServerResponce?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Music"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemBackground
        addSearchBar()
        addTableView()
    }
    
    private func addTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.keyboardDismissMode = .onDrag
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    private func addSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Search Music"
        searchBar.returnKeyType = .search
        
        view.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    //MARK: SearchBar
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        search()
    }
    
    private func search() {
        guard let text = searchBar.text else {return}
        Task {
            serverData = try await NetworkController.loadMusic(song: text)
            tableView.reloadData()
        }
    }
    
    @objc private func endEditing() {
        self.searchBar.endEditing(true)
    }
    
    //MARK: table view
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        serverData?.results.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = serverData?.results[indexPath.row].trackName
        contentConfiguration.secondaryText = serverData?.results[indexPath.row].artistName
        cell.contentConfiguration = contentConfiguration
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let song = serverData?.results[indexPath.row] {
            navigationController?.pushViewController(
                SongViewController(song: song),
                animated: true
            )
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
