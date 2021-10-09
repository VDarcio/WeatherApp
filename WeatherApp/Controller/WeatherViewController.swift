
import UIKit
import CoreLocation
import AVFoundation

class WeatherViewController: UIViewController{

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTxtField: UITextField!
    var player: AVAudioPlayer!
    var weathermanager=WeatherMAnager()
    let locationManager=CLLocationManager()
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate=self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        weathermanager.delegate=self
        searchTxtField.delegate=self
        
        
    }
    
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
        
    }
    
    }
//MARK:-UItextfielddelegate
extension WeatherViewController: UITextFieldDelegate{
    @IBAction func serachPressed(_ sender: UIButton) {
        searchTxtField.endEditing(true)
        print(searchTxtField.text!)
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(searchTxtField.text!)
        searchTxtField.endEditing(true)
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != ""{
            return true
        }else{
            textField.placeholder="Type something"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city=searchTxtField.text{
            weathermanager.fetchWeather(cityName: city)
        }
        searchTxtField.text=""
        
        
        
    }
}
//MARK:-weathermaanager

extension WeatherViewController: WeatherManagerDelegate{
    func didupdateweather(_ weatherManagwer:WeatherMAnager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text=weather.temperatureString
            self.conditionImageView.image=UIImage(systemName: weather.conditionNAme)
            self.cityLabel.text=weather.cityname
          
        }
        let condicoes=weather.conditionid
        let soundName=weathermanager.pickSound(cond: condicoes)
        //playSound(som: soundName)
        
  
    
    }
    func didfailedwitherror(error: Error) {
        print(error)
    }
    
}
//MARK:-LocationManagerDelegate


extension WeatherViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location=locations.first{
            locationManager.stopUpdatingLocation()
           let lat=location.coordinate.latitude
            let lon=location.coordinate.longitude
            print(lat)
            print(lon)
            weathermanager.fetchweather(latitude: lat, longitude: lon)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}
//MARK:-SoundManager
//extension WeatherViewController{
   // func playSound(som : String) {
    //    let url = Bundle.main.url(forResource: som, withExtension: "wav")
     //   player = try! AVAudioPlayer(contentsOf: url!)
     //   player.play()
                
   // }
//}
