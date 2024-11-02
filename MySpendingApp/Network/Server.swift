enum Server {
    case production
    case test

    var baseUrl: URL {
        switch self {
        case .production:
            return URL(string: BaseUrl.url.rawValue)!
        case .test:
            return URL(string: TestUrl.url.rawValue)!
        }
    }
}

enum BaseUrl: String {
    case url = "https://production.com"
}

enum TestUrl: String {
    case url = "http://localhost:1234"
}
