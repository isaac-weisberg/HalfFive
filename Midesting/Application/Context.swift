protocol VoidServiceContext {
    
}

protocol FileDownloaderServiceContext {
    var fileDownloader: FileDownloaderService { get }
}

protocol TestRetrievalServiceContext {
    var testRetriever: TestRetrievalService { get }
}

typealias AppcontextProtocol = VoidServiceContext &
    FileDownloaderServiceContext &
    TestRetrievalServiceContext

class AppContext: AppcontextProtocol {
    let testRetriever: TestRetrievalService
    let fileDownloader: FileDownloaderService
    
    init() {
        fileDownloader = FileDownloaderServiceImpl()
        testRetriever = TestRetrievalServiceImpl(fileDownloader: fileDownloader)
    }
}
