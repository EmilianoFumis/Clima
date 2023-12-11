//
//  ViewController.swift
//  Clima
//



import UIKit
import CoreLocation

class WeatherViewController: UIViewController{

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()  //creación variable de tipo struct WeatherManager
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self//La clase actual WeatherViewController como el delegado de CLLocationManager() para poder implementar sus métodos en extensión.
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
       
        weatherManager.delegate = self
        searchTextField.delegate = self
        // Do any additional setup after loading the view.
    }
    
   
    
}

//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate{
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true) //cuando se termina de escribir se oculta el teclado.
        
        
    }
    
    //Cuadro de texto
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        searchTextField.endEditing(true)  //cuando se termina de escribir se oculta el teclado.
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
    if textField.text != ""{
        return true
    }else{
        textField.placeholder = "Escribe algo aquí"
        return false
    }
    
    }
    
    
    // Cuando termina de escribir y presiona Intro, se borra la palabra del cuadro de búsqueda.
    
   func textFieldDidEndEditing(_ textField: UITextField) {
       
       if let city = searchTextField.text{
           
           weatherManager.fetchWeather(cityName: city)
       }
       
        //usar searchtextfield.text para obtener el nombre de ciudad que ingresa el usuario.
        searchTextField.text = ""
    }
}


//MARK: - WeatherManagerDelegte

extension WeatherViewController: WeatherManegerDelegate{
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel){ //Llamada, implementación del método. Los nombres de constantes tienen que ser exactamente igual a cómo se encuentran en el protocol 'WeatherManegerDelegate
        
        DispatchQueue.main.async {
            //obtención de valores
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        
        }
    }
    
    func didFailWithError(error: Error) {  //Implementación del método
        print(error)
    }
    
}

//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate{
    
    
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            locationManager.stopUpdatingLocation() //cuando obtiene ubicación se detiene.
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}
