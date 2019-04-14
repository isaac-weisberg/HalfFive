import Foundation
import HalfFive

enum FileDownloaderServiceError {
    case download(Error)
}

protocol FileDownloaderService {
    typealias DownloadResult = ResultTing<Data, FileDownloaderServiceError>
    
    func download(contentsOf url: URL) -> Conveyor<DownloadResult, SchedulingUnknown, HotnessHot>
}

class FileDownloaderServiceImpl: FileDownloaderService {
    init() { }
    
    func download(contentsOf url: URL) -> Conveyor<DownloadResult, SchedulingUnknown, HotnessHot> {
        return Conveyors.sync {
            let data: Data
            do {
                data = try Data(contentsOf: url)
            } catch {
                return Conveyors.just(.failure(FileDownloaderServiceError.download(error)))
            }
            return Conveyors.just(.success(data))
        }
    }
    
    func wrong() -> Conveyor<Void, SchedulingUnknown, HotnessCold> {
        return Conveyors.async { handler in
            handler(())
            handler(())
            return TrashVoid()
        }
    }
    
    func right() -> Conveyor<Void, SchedulingUnknown, HotnessHot> {
        return Conveyors.sync {
            return Conveyors.from(array: [(), ()])
        }
    }
    
    typealias HTTPDownloadResult = ResultTing<(HTTPURLResponse, Data?), Error>
    
    func download(request: URLRequest) -> Conveyor<HTTPDownloadResult, SchedulingUnknown, HotnessCold> {
        return Conveyors.async { handler in
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    handler(.failure(error))
                    return
                }
                
                let res = response as! HTTPURLResponse
                handler(.success((res, data)))
            }
            
            task.resume()
            
            return TrashAbstract {
                task.cancel()
            }
        }
    }
}
