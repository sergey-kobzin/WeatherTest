//
//  SearchViewController.swift
//  WeatherTest
//
//  Created by Sergey Kobzin on 26.01.2018.
//  Copyright © 2018 Sergey Kobzin. All rights reserved.
//

import UIKit

protocol SearchViewControllerDelegate {
    
    func searchViewControllerDidSelect(city: City)
    
}

class SearchViewController: UITableViewController {
    
    var delegate: SearchViewControllerDelegate?
    var cities = [City]()
    
    var searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        let searchBar = searchController.searchBar
        searchBar.delegate = self
        searchBar.tintColor = .white
        searchBar.barTintColor = Colors.searchBarColor
        tableView.tableHeaderView = searchBar
        tableView.tableFooterView = UIView()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = cities.count
        return count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        let city = cities[index]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath)
        cell.backgroundColor = index % 2 == 0 ? .white : Colors.cellColor
        cell.textLabel?.text = city.name + ", " + city.country
        cell.detailTextLabel?.text = "Geo coords: [" + city.latitude + ", " + city.longitude + "]"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        let city = cities[index]
        delegate?.searchViewControllerDidSelect(city: city)
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Custom functions
    
    func getCities(withName name: String) {
        NetworkManager.getCities(withName: name, completionHandler: { (cities, error) in
            guard error == nil, let cities = cities else { return }
            self.cities = cities
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
    
}

// MARK: - Search bar delegate

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        if searchText.isEmpty { return }
        getCities(withName: searchText)
    }
    
}
