
import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager:WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    
    // формируем URL
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=e149425106b7d1452926ba2c08701f84&units=metric"     // URL без города
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        // Получили City в контроллере и там же запустили наш метод 
        //func textFieldDidEndEditing(_ textField: UITextField) {
        
        //        if let city = searchTextField.text{
        //            weatherManager.fetchWeather(cityName: city)
        
        perfomReequest(with: urlString)
    }
    
    func perfomReequest(with urlstring: String) {
        
        if let url = URL(string: urlstring) {                                                                   // 1. Create a URL
                                                                                                                //форматируем URL в нормальный вид для URLSession
            let session = URLSession(configuration: .default)                                                   // 2. Create a URLSession
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)          // report to ViewController
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
        
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    
    
}

