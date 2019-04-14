import Foundation
import HalfFive

protocol TestRetrievalService {
    typealias DownloadResult = ResultTing<TestGithubRemoteDTO, TestRetrievalServiceError>
    
    func downloadGithubTest() -> Conveyor<DownloadResult, SchedulingUnknown, HotnessHot>
}

enum TestRetrievalServiceError {
    case download(FileDownloaderServiceError)
    case parsing(Error)
}

class TestRetrievalServiceImpl: TestRetrievalService {
    let fileDownloader: FileDownloaderService
    
    init(fileDownloader: FileDownloaderService) {
        self.fileDownloader = fileDownloader
    }
    
    func downloadGithubTest() -> Conveyor<DownloadResult, SchedulingUnknown, HotnessHot> {
        let url = URL(string: "http://github.com/isaac-weisberg/HalfFive/test")!
        
        return fileDownloader
            .download(contentsOf: url)
            .map { res in
                res
                    .catch { .failure(TestRetrievalServiceError.download($0)) }
                    .then { data in
                        do {
                            return .success(try JSONDecoder().decode(TestGithubRemoteDTO.self, from: data))
                        } catch {
                            return .failure(.parsing(error))
                        }
                    }
            }
    }
}
