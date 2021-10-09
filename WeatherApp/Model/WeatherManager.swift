

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didupdateweather(_ weatherManagwer:WeatherMAnager,weather: WeatherModel)
    func didfailedwitherror(error: Error)
}
struct WeatherMAnager {
    let weatherURL="https://api.openweathermap.org/data/2.5/weather?units=metric&appid=686dabf47546a90dce715170e8a856d5"
    var delegate: WeatherManagerDelegate?
    func fetchWeather(cityName: String){
        let urlString="\(weatherURL)&q=\(cityName)"
        performerequest(with: urlString)
        
        
        
    }
    
    func fetchweather(latitude: CLLocationDegrees , longitude:CLLocationDegrees  ){
        let urlString="\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        print("foiii")
        performerequest(with: urlString)
        
    }
       
    func performerequest(with urlString: String){
        //1. create URL
        if let url=URL(string: urlString){
            //2 create url session
            let session=URLSession(configuration: .default)
            
            //3 give the session a task
            let task=session.dataTask(with: url) { data, URLResponse, error in//closure aula, 150
                if error != nil{
                    self.delegate?.didfailedwitherror(error: error!)
                    return
                }
                if let safeData=data{
                    if  let weather=self.parseJSON(safeData){
                        self.delegate?.didupdateweather(self, weather:weather)
                    }
                    
                }
            }
            //start the task
            task.resume()
        }
        
        
    }
    func parseJSON(_ weatherData: Data)->WeatherModel?{//optional to be able to return nil
        let decoder=JSONDecoder()
        do{
            let decodedData=try decoder.decode(WeatherData.self, from: weatherData)
            let id=decodedData.weather[0].id
            let temp=decodedData.main.temp
            let name=decodedData.name
            let weather=WeatherModel(conditionid: id, cityname: name, temperature: temp)
            return weather
        }catch{
            delegate?.didfailedwitherror(error: error)
            return nil
        }
    }
    func pickSound(cond:Int)->String{
        if cond<800{
            return "rain"
        }else{
            return "sunny"
        }
        
    }
    
}





