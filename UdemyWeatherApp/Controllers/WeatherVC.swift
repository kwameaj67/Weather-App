//
//  ViewController.swift
//  UdemyWeatherApp
//
//  Created by Kwame Agyenim - Boateng on 21/08/2022.
//

import UIKit
import Combine

class WeatherVC: UIViewController {

    private var cancellable: AnyCancellable?
    private let weatherService: WeatherService = WeatherService()
    private var selectedCity: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "Accra, Ghana"
        setupViews()
        setupConstraints()
        setupNavBar()
        getDate()
        setupPublishers()
    }
    let container: UIStackView = {
        let sv = UIStackView(frame: .zero)
        sv.distribution = .equalCentering
        sv.axis = .vertical
        sv.spacing = 10.0
        return sv
    }()
    let todayDate: UILabel = {
        let lb = UILabel(frame: .zero)
        lb.textColor = .black.withAlphaComponent(0.8)
        lb.font = UIFont(name: "Avenir-Medium", size: 15)
        lb.textColor = .systemGray
        lb.numberOfLines = 0
        return lb
    }()
    var templabel: UILabel = {
        let lb = UILabel(frame: .zero)
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont(name: "Avenir-Black", size: 55)
        lb.text = "--"
        lb.textColor = .black.withAlphaComponent(0.8)
        lb.numberOfLines = 0
        lb.textAlignment = .center
        return lb
    }()
    var humiditylabel: UILabel = {
        let lb = UILabel(frame: .zero)
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont(name: "Avenir-Medium", size: 18)
        lb.textColor = .systemGray
        lb.numberOfLines = 0
        return lb
    }()
    var pressurelabel: UILabel = {
        let lb = UILabel(frame: .zero)
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont(name: "Avenir-Medium", size: 18)
        lb.textColor = .black.withAlphaComponent(0.9)
        lb.numberOfLines = 0
        return lb
    }()
    var windlabel: UILabel = {
        let lb = UILabel(frame: .zero)
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont(name: "Avenir-Medium", size: 18)
        lb.textColor = .black.withAlphaComponent(0.9)
        lb.textColor = .systemGray
        lb.numberOfLines = 0
        return lb
    }()
    var infolabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont(name: "Avenir-Medium", size: 18)
        lb.textColor = .black.withAlphaComponent(0.9)
        lb.numberOfLines = 0
        return lb
    }()
    var citytextField = CustomTextField(frame: .zero)
    var descLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont(name: "Avenir-Medium", size: 18)
        lb.text = "--"
        lb.textColor = .systemGray
        lb.textAlignment = .center
        lb.numberOfLines = 0
        return lb
    }()
    var border: UIView = {
        let b = UIView(frame: .zero)
        b.backgroundColor = .systemGray6
        b.isHidden = true
        return b
    }()
    let weatherImage : UIImageView = {
        var iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }()
    
    func setupViews(){
        
        [templabel,humiditylabel,pressurelabel,citytextField,descLabel,windlabel,infolabel,container,border,todayDate,weatherImage].forEach { item in
            view.addSubview(item)
            item.translatesAutoresizingMaskIntoConstraints = false
        }
        container.addArrangedSubview(weatherImage)
        container.addArrangedSubview(templabel)
        container.addArrangedSubview(descLabel)
    }
    func getDate(){
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, d MMMM YYYY"
        todayDate.text =  dateFormatter.string(from: date)
    }
    
    func getWeatherConditionImage(condition: String) -> UIImage {
        return (UIImage(named: "\(condition)")?.withRenderingMode(.alwaysOriginal))!
    }
    
    private func setupPublishers(){
        // publishes events as soon as we type into textField
        let inputPublisher = NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: self.citytextField)
        
        self.cancellable = inputPublisher.compactMap { ($0.object as! UITextField).text?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) }
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .flatMap { city in
                return self.weatherService.fetchWeather(city: self.selectedCity.isEmpty ? city : self.selectedCity)
                    .catch { _ in
                        Just(WeatherResponse.placeholder)
                    }
                    .map{ $0 }
            }
            .sink { [self] response in
                print(response)
                if let temp = response.main?.temp {
                    self.templabel.text = "\(Int(temp.rounded(.toNearestOrEven)))℃"
                    self.border.isHidden = false
                }else{
                    self.templabel.text = "--"
                    self.humiditylabel.text = ""
                    self.pressurelabel.text = ""
                    self.windlabel.text = ""
                    self.infolabel.text = ""
                    self.border.isHidden = true
                    self.weatherImage.image = nil
                }
                if let desc = response.weather?[0].description {
                    self.descLabel.text = "It's \(desc)"
                }else{
                    guard let text = citytextField.text else { return }
                    if text.isEmpty {
                        self.descLabel.text = "Oops 🙊 Cannot get weather"
                    }else{
                        self.descLabel.text = "Oops 🙊 Cannot get weather for \(String(describing:citytextField.text!))"
                    }
                   
                }
                guard let humid = response.main?.humidity else { return }
                guard let pressure = response.main?.pressure else { return }
                guard let wind = response.wind?.speed else { return }
                guard let desc = response.weather?[0].main else { return }
                self.humiditylabel.text = "\(Int(humid.rounded(.toNearestOrEven)))% Precipitation"
                self.pressurelabel.text = "\(Int(pressure)) hPa"
                self.windlabel.text = "\(Int(wind))m/s Wind"
                self.infolabel.text = "\(desc)"
                self.weatherImage.image = self.getWeatherConditionImage(condition: "\(desc.lowercased())")
            }
    }
    
    @objc func onTapPlusButton(){
        let vc = CityVC()
        self.present(vc, animated: true, completion: nil)
        vc.modalPresentationStyle = .fullScreen
        vc.selectCity = self
      
    }

}


extension WeatherVC: CitySelectionDelegate {
    func selectCity(city: String) {
        citytextField.text = city
        self.cancellable = weatherService.fetchWeather(city: city)
                 .catch { _ in
                     Just(WeatherResponse.placeholder)
                 }
                 .sink { response in
                     print(response)
                     if let temp = response.main?.temp {
                         self.templabel.text = "\(temp)℃"
                     }else{
                         self.templabel.text = "Error getting weather"
                     }
                     guard let humid = response.main?.humidity else { return }
                     guard let pressure = response.main?.pressure else { return }
                     guard let wind = response.wind?.speed else { return }
                     guard let desc = response.weather?[0].main else { return }
                     self.humiditylabel.text = "\(Int(humid.rounded(.toNearestOrEven)))% Precipitation"
                     self.pressurelabel.text = "\(Int(pressure)) hPa"
                     self.windlabel.text = "\(Int(wind))m/s Wind"
                     self.infolabel.text = "\(desc)"
                 }
    }
    
    
    private class TextField: UITextField{
        override func editingRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.insetBy(dx: 24, dy: 0)
        }
        override func textRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.insetBy(dx: 24, dy: 0)
        }
    }
    func setupNavBar(){
         navigationController?.navigationBar.barTintColor = .white
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont(name: "Avenir-Heavy", size: 17)!]
        navigationController?.navigationBar.titleTextAttributes = titleTextAttributes
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        let plusButton = UIButton(frame: CGRect(x: 0, y: 0, width: 16, height: 16))
        plusButton.setBackgroundImage(UIImage(systemName: "plus")?.withTintColor(.black), for: .normal)
        plusButton.tintColor = .black
        plusButton.addTarget(self, action: #selector(onTapPlusButton), for: .touchUpInside)
        plusButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: plusButton)
        
    }
    
    
    func setupConstraints(){
       
        NSLayoutConstraint.activate([
            citytextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            citytextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            citytextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            citytextField.heightAnchor.constraint(equalToConstant: 52),
            
            todayDate.topAnchor.constraint(equalTo: citytextField.bottomAnchor, constant: 15),
            todayDate.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            weatherImage.widthAnchor.constraint(equalToConstant: 180),
            weatherImage.heightAnchor.constraint(equalToConstant: 180),
            
            container.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            container.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            container.heightAnchor.constraint(equalToConstant: 300.0),
            
            border.bottomAnchor.constraint(equalTo: pressurelabel.topAnchor,constant: -20),
            border.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            border.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            border.heightAnchor.constraint(equalToConstant: 1.8),
            
            pressurelabel.bottomAnchor.constraint(equalTo: windlabel.topAnchor, constant: -30),
            pressurelabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
           
            windlabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            windlabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            infolabel.bottomAnchor.constraint(equalTo: humiditylabel.topAnchor, constant: -20),
            infolabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            
            humiditylabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            humiditylabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
        ])
    }
}
