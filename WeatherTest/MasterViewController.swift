//
//  MasterViewController.swift
//  WeatherTest
//
//  Created by Sergey Kobzin on 26.01.2018.
//  Copyright © 2018 Sergey Kobzin. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {
    
    var cities = [City]()
    var filteredCities = [City]()
    
    var searchController = UISearchController(searchResultsController: nil)
    
    var isFilterActive: Bool {
        guard let searchText = searchController.searchBar.text else { return false }
        let active = searchController.isActive && !searchText.isEmpty
        return active
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        definesPresentationContext = true
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        let searchBar = searchController.searchBar
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
        let count = isFilterActive ? filteredCities.count : cities.count
        return count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        let city = isFilterActive ? filteredCities[index] : cities[index]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath)
        cell.backgroundColor = index % 2 == 0 ? .white : Colors.cellColor
        cell.textLabel?.text = city.name + ", " + city.country
        cell.detailTextLabel?.text = "Geo coords: [" + city.latitude + ", " + city.longitude + "]"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let index = indexPath.row
            if isFilterActive {
                let removedCity = filteredCities.remove(at: index)
                cities = cities.filter({ $0 != removedCity })
            } else {
                cities.remove(at: index)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        switch identifier {
        case "ShowSearchViewController":
            guard let destinationViewController = segue.destination as? SearchViewController else { return }
            destinationViewController.delegate = self
        case "ShowWeatherViewController":
            guard let destinationViewController = segue.destination as? WeatherViewController, let index = tableView.indexPathForSelectedRow?.row else { return }
            destinationViewController.city = isFilterActive ? filteredCities[index] : cities[index]
        default:
            break
        }
    }
    
    // MARK: - Custom functions
    
    func filterCities(withSearchText searchText: String) {
        filteredCities = cities.filter({ $0.name.lowercased().contains(searchText) })
    }
    
}

// MARK: - Search results updater delegate

extension MasterViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }
        filterCities(withSearchText: searchText)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}

// MARK: - Search view controller delegate

extension MasterViewController: SearchViewControllerDelegate {
    
    func searchViewControllerDidSelect(city: City) {
        cities.append(city)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}
