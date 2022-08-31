//
//  CityVC.swift
//  UdemyWeatherApp
//
//  Created by Kwame Agyenim - Boateng on 23/08/2022.
//

import UIKit
import Combine


protocol CitySelectionDelegate {
    func selectCity(city: String)
}

class CityVC: UIViewController {

    private var cityService: CityService = CityService()
    private var searchedCity = [City](){
        didSet{
            self.cityListView.reloadData()
        }
    }
    private var isSearching: Bool = false
    private var cities = [City](){
        didSet{
            self.cityListView.reloadData()
        }
    }
    private var cancellables : AnyCancellable?
    
    var selectCity: CitySelectionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
        configureNavBar()
        cityListView.dataSource = self
        cityListView.delegate = self
        citytextField.delegate = self
        cityListView.register(CityTableViewCell.self, forCellReuseIdentifier: CityTableViewCell.reuseableID)
        getCities()
        self.cityListView.separatorColor = UIColor.clear
    }
    
    var cityListView: UITableView = {
       let tb = UITableView()
        tb.translatesAutoresizingMaskIntoConstraints = false
        tb.isHidden = true
        return tb
    }()
    var citytextField = CustomTextField(frame: .zero)
    var loader: UIActivityIndicatorView = {
       let l = UIActivityIndicatorView()
        l.style  = .large
        l.translatesAutoresizingMaskIntoConstraints = false
        l.tintColor = .systemGray
        l.startAnimating()
        return l
    }()
    func setupViews(){
        [cityListView,loader,citytextField].forEach { item in
            view.addSubview(item)
        }
    }
    func getCities(){
        self.cancellables = cityService.fetchCity()
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] response in
                guard let self = self else { return }
                if (!response.data.isEmpty){
                    self.loader.stopAnimating()
                    self.cityListView.isHidden = false
                    print("cities: \(response.data.count)")
                    self.cities = response.data
                }
            })
    }

}

extension CityVC: UINavigationBarDelegate, UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return searchedCity.count
        }else {
            return cities.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CityTableViewCell.reuseableID, for: indexPath) as! CityTableViewCell
        let item: City
        if isSearching {
            item = searchedCity[indexPath.row]
        }else{
            item = cities[indexPath.row]
        }
        cell.setup(for: item)
        cell.layoutMargins = UIEdgeInsets.zero
        cell.separatorInset = UIEdgeInsets.zero
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 63.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item: City
        if isSearching {
            item = searchedCity[indexPath.row]
            if let city = item.city{
                print(city)
                selectCity?.selectCity(city: city)
                closeVC()
            }
        }else{
            item = cities[indexPath.row]
            if let city = item.city{
                print(city)
                selectCity?.selectCity(city: city)
                closeVC()
            }
        }
    }
    func textFieldDidChangeSelection(_ textField: UITextField) {
           if let keyword = textField.text {
            print(keyword)
            if !keyword.isEmpty{
                isSearching = true
                searchedCity = cities.filter({ data in
                    data.city!.lowercased().prefix(keyword.count) == keyword.lowercased()
                })
                cityListView.reloadData()
            }else {
                isSearching = false
            }
        }
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            
            citytextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 80),
            citytextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            citytextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            citytextField.heightAnchor.constraint(equalToConstant: 52),
            
            cityListView.topAnchor.constraint(equalTo: citytextField.bottomAnchor,constant: 20),
            cityListView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
            cityListView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20),
            cityListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            loader.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loader.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    func configureNavBar(){
        let height: CGFloat = 75.0
        let navbar = UINavigationBar(frame: CGRect(x: 0, y: 20, width: UIScreen.main.bounds.width, height: height))
        navbar.barTintColor = .white
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont(name: "Avenir-Heavy", size: 17)!]
        navbar.titleTextAttributes = titleTextAttributes
        navbar.delegate = self
        let navbarItem = UINavigationItem()
        navbarItem.title = "Select City"
        
        let exitButton = UIButton(frame: CGRect(x: 0, y: 0, width: 16, height: 16))
        exitButton.setBackgroundImage(UIImage(systemName: "xmark")?.withTintColor(.black), for: .normal)
        exitButton.tintColor = .black
        exitButton.addTarget(self, action: #selector(closeVC), for: .touchUpInside)
        exitButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        navbarItem.leftBarButtonItem = UIBarButtonItem(customView: exitButton)
          
        navbar.items = [navbarItem]
        view.addSubview(navbar)
        self.view.frame = CGRect(x: 0, y: height, width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.height - height))
        
        navbar.setBackgroundImage(UIImage(), for: .default)
        navbar.shadowImage = UIImage()
        navbar.isTranslucent = true
    }
    @objc func closeVC(){
        self.dismiss(animated: true, completion: nil)
    }
    
}
