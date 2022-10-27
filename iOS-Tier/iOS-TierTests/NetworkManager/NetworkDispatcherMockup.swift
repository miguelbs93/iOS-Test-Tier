//
//  NetworkDispatcherMockup.swift
//  iOS-TierTests
//
//  Created by Miguel Bou Sleiman on 27.10.22.
//

@testable import iOS_Tier
import Foundation

struct NetworkDispatcherMockup: Dispatcher {
    private let filename: String
    
    init(filename: String) {
        self.filename = filename
    }
    
    func fetchData(with request: Request, completion: @escaping (Data?, NetworkError?) -> Void) {
        guard let data = JSONReader.getData(name: filename) else {
            completion(nil, .noData)
            return
        }
        completion(data, nil)
    }
}


//MARK: JSON File Reader
class JSONReader {
    class func getData(name: String, withExtension: String = "json") -> Data? {
        let bundle = Bundle.main
        guard let fileUrl = bundle.url(forResource: name, withExtension: withExtension) else { return nil }
        let data = try? Data(contentsOf: fileUrl)
        return data
    }
}
