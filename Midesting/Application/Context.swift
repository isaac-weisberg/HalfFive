protocol VoidServiceContext {
    
}

protocol FileDownloaderServiceContext {
    var fileDownloader: FileDownloaderService { get }
}

typealias AppcontextProtocol = VoidServiceContext & FileDownloaderServiceContext

class AppContext: AppcontextProtocol {
    let fileDownloader: FileDownloaderService
    
    init() {
        fileDownloader = FileDownloaderServiceImpl()
    }
}
