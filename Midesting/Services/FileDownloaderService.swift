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
}
