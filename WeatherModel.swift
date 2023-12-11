//
//  WeatherModel.swift
//  Clima
//
//  Created by Emiliano Fumis on 05/02/2023.

//

import Foundation

struct WeatherModel{
    let conditionId: Int
    let cityName: String
    let temperature: Double
    
    var temperatureString: String{                     //Variable calculada con retorno
        return String(format: "%.1f", temperature)
        
        }
        
    
    var conditionName: String{
        switch conditionId {
        
        case 200...232:
            return "cloud.bolt"
            
        case 701...781:
            return "cloud.fog"
            
        case 800:
            return "sun.max"

        default:
            return "cloud"
        }
        
    }
    
}


