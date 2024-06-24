////
////  HomeViewModel.swift
////  Ghost Chain
////
////  Created by Temisan Taire on 5/15/24.
////
//
//import Foundation
//import Combine
//
//@MainActor
//class HomeViewModel: ObservableObject {
//    @Published var allCoins: [CoinModel] = []
//    @Published var portfolioCoins: [CoinModel] = []
//    
//    //    private let dataService = CoinDataService()
//    private var cancellables = Set<AnyCancellable>()
//    
//    init() {
////        Task {
////            await storeCoins()
////        } //         addSubscribers()
//    }
//    func getCoins() async throws -> [CoinModel] {
//        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&ids=bitcoin&order=market_cap_desc&per_page=1&page=1&sparkline=true&price_change_percentage=24h")
//        else { throw URLError(.badURL) }
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        request.timeoutInterval = 10
//        request.allHTTPHeaderFields = [
//            "accept": "application/json",
//            "x-cg-demo-api-key": "CG-Svc57aLtuMHtyUXtbJEnR5zM"
//        ]
//        
//        let (data, response) = try await URLSession.shared.data(for: request)
//        guard let response = response as? HTTPURLResponse,response.statusCode >= 200 && response.statusCode < 300
//        else {  throw URLError(.badServerResponse) }
//        
////        do {
////        let decoder =  JSONDecoder()
//        let coins = try? JSONDecoder().decode([CoinModel].self, from: data)
//        if (coins != nil) {
//            DispatchQueue.main.async {
//                self.allCoins.append(contentsOf: coins ?? [])
//            }
//        } else {
//            print("bleurgh \(GHError.invalidData)")
//            print(String(data: data, encoding: .utf8) ?? "No data")
//        }
////            return try decoder.decode([CoinModel].self, from: data)
////        } catch {
////            throw GHError.invalidData
////        }
//        return allCoins
//    }
//    
////     func storeCoins() async {
////        do {
////            let coins = try await getCoins()
////            DispatchQueue.main.async {
////                self.allCoins.append(contentsOf: coins)
////            }
////        } catch {
////            print("Sorry bro. \(GHError.error)")
////        }
////    }
////    
//    enum GHError: Error {
//        case invalidData
//        case error
//    }
//}
//

import Foundation
import Combine

@MainActor
class HomeViewModel: ObservableObject {
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
//    @Published var data: Data = Data()
    
    @Published var searchText: String = ""
    
    private var cancellables = Set<AnyCancellable>()
    private let dataService = CoinDataService()
    
    init() {
//        Task {
//            await fetchCoins()
//        }
        addSubscribers()
    }

//    func fetchCoins() async {
//        do {
//            let coins = try await getCoins()
//            DispatchQueue.main.async {
//                self.allCoins = coins // Reset and update allCoins
//            }
//        } catch {
//            print("Error fetching coins: \(error.localizedDescription)")
//        }
//    }
//
//    func getCoins() async throws -> [CoinModel] {
//        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h")
//        else { throw URLError(.badURL) }
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        request.timeoutInterval = 10
//        request.allHTTPHeaderFields = [
//            "accept": "application/json",
//            "x-cg-demo-api-key": "CG-Svc57aLtuMHtyUXtbJEnR5zM"
//        ]
//        
//        let (data, response) = try await URLSession.shared.data(for: request)
//        guard let response = response as? HTTPURLResponse, response.statusCode >= 200 && response.statusCode < 300 else {
//            throw URLError(.badServerResponse)
//        }
////        let coins = try? JSONDecoder().decode([CoinModel].self, from: data)
//        return try JSONDecoder().decode([CoinModel].self, from: data)
//    }
//    
    enum GHError: Error {
        case invalidData
        case error
    }
    
    func addSubscribers()  {
//        dataService.$allCoins
//            .sink { [weak self] (returnedCoins) in
//                self?.allCoins = returnedCoins
//            }
//            .store(in: &cancellables) // removed because when the $searchText runs, it does the function of this before doing its own
        
        $searchText
            .combineLatest(dataService.$allCoins) // subscribes this to the datService.$allCoins subscriber
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main) // does not run the rest of the code till user stops typing for 0.5 seconds 
            .map { (text, startingCoins) -> [CoinModel] in
                guard !text.isEmpty else {
                    return startingCoins
                }
                
                let lowercasedText = text.lowercased()
                return startingCoins.filter { (coin) -> Bool in
                    return coin.name.lowercased().contains(lowercasedText) ||
                    coin.symbol.lowercased().contains(lowercasedText) ||
                    coin.id.lowercased().contains(lowercasedText)
                }
            }
            .sink { [weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)
    }
}
