import Foundation

struct Video{
    let videoId : NSString
    let publishedDateString : NSString
    let videoTitle : NSString
    let videoDescription : NSString
    let imageUrlString : NSString
}

func parseVideos(json: AnyObject) -> [Video]{
    var videos : [Video] = []
    
    if let items = json["items"] as? [[NSString : AnyObject]]{
        for item in items{
            if let video = parseVideo(item){
                videos.append(video)
            }
        }
    }
    return videos
}

func parseVideo(dict : [NSString : AnyObject]) -> Video?{
    if let snippet = dict["snippet"] as? [NSString : AnyObject]{
        if let publishedDateString = snippet["publishedAt"] as? NSString{
            if let videoTitle = snippet["title"] as? NSString{
                if let videoDescription = snippet["description"] as? NSString{
                    let objDictionary = snippet as NSDictionary
                    let resourceObj = snippet["resourceId"] as NSDictionary
                    if let videoId = resourceObj["videoId"] as? NSString{
                        if let imageUrlString = objDictionary.valueForKeyPath("thumbnails.medium.url") as? NSString{
                            print("video: \(videoId) \(videoTitle)")
                            return Video(videoId: videoId,publishedDateString: publishedDateString,videoTitle: videoTitle, videoDescription: videoDescription, imageUrlString: imageUrlString)
                        }
                    }
                }
            }
            
        }
    }
    return nil
}