import Foundation
import HalfFive

protocol TestRetrievalService {
    typealias DownloadResult = ResultTing<TestModel, TestRetrievalServiceError>
    
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
        let url = URL(string: "https://raw.githubusercontent.com/isaac-weisberg/HalfFive/master/Extras/testYouWillSeeOnGithub.json")!
        
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
                    .then(TestModel.init(github:))
            }
    }
}
