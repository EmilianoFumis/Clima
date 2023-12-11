//
//  WeatherManager.swift
//  Clima
//
//  Created by Emiliano Fumis on 28/12/2022.
//

import Foundation
import CoreLocation

protocol WeatherManegerDelegate{
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) //declaración de función
    func didFailWithError(error: Error)
}

struct WeatherManager{
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=c4d1518de9f76048b7f071fd28f2a2de&units=metric"
    //LLamada a API utilizando KEY, también las unidades deben ser en metric
    
    var delegate: WeatherManegerDelegate?  //Clase delegada
    
    func fetchWeather(cityName: String){
        
        let urlString = "\(weatherURL)&q=\(cityName)"
        
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String){
        
        //Networking, recupearar datos del navegador
        //1. Create a URL
        
        
        if let url = URL(string: urlString) { //Struct URL, se inicializa y se pasa parámetro urlString
            
            //2. Create a URLSession
            
            let session = URLSession(configuration: .default)
            
            //3. Dar a la tarea una sesión
            
            let task = session.dataTask(with: url) { (data, response, error) in
                
                if error != nil{   //si el error es distinto de vacío, entonces existe error
                    
                    self.delegate?.didFailWithError(error: error!)
                    return //salir de la función
                }
                
                if let safeData = data {  //si existe data, si se da la asignación
                    if let weather = self.parseJSON(safeData){
                        self.delegate?.didUpdateWeather(self, weather: weather) //se invoca la función declarada, asignando valores.
                        
                    }
                    
                }
            }
            
            //completionHandler: Es un método porque no retorna nada, void = vacío
            //4. Iniciar la tarea
            task.resume()
        }
        
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        
        do{
            
            let decodeData = try decoder.decode(WeatherData.self, from: weatherData) //WeatherData es struct, se usa .self para poder pasarla como un objeto.
            let id = decodeData.weather[0].id
            let temp = decodeData.main.temp
            let name = decodeData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
           
    
        }catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
    }

}
