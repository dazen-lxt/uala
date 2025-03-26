//
//  CityViewModel.swift
//  Uala
//
//  Created by Carlos Mario Muñoz on 21/03/25.
//

import Combine
import Foundation

final class CityListViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var cities: [City] = []
    @Published var isFetching: Bool = false
    @Published var filterTerm: String = ""
    
    // MARK: - Private Properties
    private let cityRepostiory: CityRepositoryProtocol
    private var nextPage = 0
    private let pageSize = 20
    private let preloadOffset = 5
    private var allDataLoaded: Bool = false
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initializer
    init(cityRepostiory: CityRepositoryProtocol) {
        self.cityRepostiory = cityRepostiory
        self.setupBindings()
    }
    
    private func setupBindings() {
        $filterTerm
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] value in
                Task {
                    await self?.loadCities(reset: true)
                }
            }
            .store(in: &cancellables)
        
    }
    
    // MARK: - Internal Methods
    @MainActor
    func loadCities(reset: Bool) async {
        if reset {
            nextPage = 0
            allDataLoaded = false
            self.cities = []
        }
        guard !isFetching, !allDataLoaded else { return }
        isFetching = true
        defer { isFetching = false }
        do {
            let data = try await cityRepostiory.fetchCities(prefix: filterTerm, page: nextPage, pageSize: pageSize)
            if data.isEmpty {
                allDataLoaded = true
                return
            }
            nextPage += 1
            self.cities.append(contentsOf: data)
        } catch {
            print("❌ Error fetching cities: \(error.localizedDescription)")
        }
    }
    
    func loadMoreIfNeeded(for index: Int) async {
        guard !isFetching, !allDataLoaded else { return }
        if index >= cities.count - preloadOffset {
            Task {
                await loadCities(reset: false)
            }
        }
    }
}
