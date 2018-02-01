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
    
    var searchText = ""
    
    var searchController = UISearchController(searchResultsController: nil)
    
    var isFilterActive: Bool {
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getCities()
    }

    // MARK: - Table view data source

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
            let city = isFilterActive ? filteredCities[index] : cities[index]
            DatabaseManager.removeCity(city: city, completionHandler: { (success) in
                getCities()
            })
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        if identifier == "ShowWeatherViewController" {
            guard let destinationViewController = segue.destination as? WeatherViewController, let index = tableView.indexPathForSelectedRow?.row else { return }
            destinationViewController.city = isFilterActive ? filteredCities[index] : cities[index]
        }
    }
    
    // MARK: - Custom functions
    
    func getCities() {
        DatabaseManager.getCities(completionHandler: { (cities) in
            guard let cities = cities else {
                AlertManager.showAlert(withTitle: "Error", withMessage: "Error getting data from the database", inViewController: self)
                return
            }
            self.cities = cities
            getFilteredCities()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
    
    func getFilteredCities() {
        filteredCities = isFilterActive ? cities.filter({ $0.name.lowercased().contains(searchText) }) : cities
    }
    
}

// MARK: - Search results updater delegate

extension MasterViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }
        self.searchText = searchText
        getFilteredCities()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}
