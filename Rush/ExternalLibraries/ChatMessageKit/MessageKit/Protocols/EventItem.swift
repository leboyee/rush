import Foundation
import UIKit

/// A protocol used to represent the data for a media message.
public protocol EventItem {

    /// The url where the media is located.
    var url: URL? { get }

    /// The image.
    var eventImageURL: URL? { get }

    /// A placeholder image for when the image is obtained asychronously.
    var placeholderImage: UIImage { get }

    /// The size of the media item.
    var size: CGSize { get }
    
    var time: Date? { get }
    
    var eventTitle: String? { get }
    
    var desc: String? { get }
    
    var eventId: String? { get }
    
    var eventDate: String? { get }
    
    var eventMonth: String? { get }
    
    var eventDay: String? { get }

    var eventTime: String? { get }

}
