import Foundation

class CGDownloader {
    let url:NSURL
    
    //Instantiate NSUrlSessionConfiguration object and NSURLSession when needed
    lazy var config = NSURLSessionConfiguration.defaultSessionConfiguration()
    lazy var session : NSURLSession = NSURLSession(configuration: self.config)
    
    
    typealias DownloaderCompletion = (AnyObject?) -> ()
    
    init(_ url:NSURL){
        self.url = url
    }
    
    
    func downloadJSON(completion: DownloaderCompletion){
        let task = session.dataTaskWithURL(self.url, completionHandler: { (data:NSData!, response:NSURLResponse!, error:NSError!) in
            // Cast response to NSHTTPURLResponse if you need statusCode
            if let httpResponse = response as? NSHTTPURLResponse{
                if(httpResponse.statusCode == 200){
                    self.parseJSON(data, completion: completion)
                }else{
                    completion(nil)
                }
            }
        })
        task.resume()
    }
    
    func parseJSON(data: NSData, completion: DownloaderCompletion){
        var error : NSError?
        if let json:AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments, error: &error){
            let jsoncast = json as? NSDictionary
            completion(json)
        }
    }
    
    func downloadUrl(completion: DownloaderCompletion){
        let task = session.downloadTaskWithURL(self.url, completionHandler: { (location:NSURL!, response:NSURLResponse!, error: NSError?) -> Void in
            if(error == nil){
                completion(location)
            }else{
                completion(nil)
            }
        })
        task.resume()
    }
}