//
//  CityTableViewCell.swift
//  UdemyWeatherApp
//
//  Created by Kwame Agyenim - Boateng on 23/08/2022.
//

import UIKit

class CityTableViewCell: UITableViewCell {
    static let reuseableID = "cityCell"
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: CityTableViewCell.reuseableID)
        [cityLabel,countryLabel].forEach { item in
            contentView.addSubview(item)
            item.translatesAutoresizingMaskIntoConstraints = false
        }
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let cityLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont(name: "Avenir-Light", size: 16)
        lb.textColor = .systemGray2
        lb.numberOfLines = 0
        return lb
    }()
    let countryLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont(name: "Avenir-Medium", size: 16)
        lb.textColor = .black.withAlphaComponent(0.8)
        lb.numberOfLines = 0
        return lb
    }()
    
    func setup(for item: City){
        guard let city = item.city , let country = item.country else { return }
            cityLabel.text = "\(city), "
            countryLabel.text = country
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            cityLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            cityLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            cityLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            countryLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            countryLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            countryLabel.leadingAnchor.constraint(equalTo: cityLabel.trailingAnchor, constant: 6),
            countryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 20)
        ])
    }

}
