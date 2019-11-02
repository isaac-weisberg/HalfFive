import Foundation

enum DownloadError {
    case networking(Swift.Error)
    case statusCode(Int)
}

func download(from url: URL) -> Single<Data, DownloadError> { return .never() }

func parse<Target: Decodable>(json data: Data) -> Single<Target, Swift.Error> { return .never() }

enum DownloadJsonError {
    case download(DownloadError)
    case parsing(Swift.Error)
}

func downloadJson<Target: Decodable>(from url: URL) -> Single<Target, DownloadJsonError> {
    return download(from: url)
        .mapError { error in
            DownloadJsonError.download(error)
        }
        .flatMap { data in
            parse(json: data)
                .mapError { error in
                    DownloadJsonError.parsing(error)
                }
        }
}
