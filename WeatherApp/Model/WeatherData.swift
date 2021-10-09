
import Foundation
import UIKit

struct WeatherData: Codable{
    let name: String
    let main: main
    let weather: [Weather]
    
}
struct main: Codable{
    let temp: Double
    let humidity: Int
}
struct Weather: Codable {
    let id: Int

}
