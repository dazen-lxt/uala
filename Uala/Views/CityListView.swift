//
//  ContentView.swift
//  Uala
//
//  Created by Carlos Mario Muñoz on 21/03/25.
//

import SwiftUI

struct CityListView: View {
    
    // MARK: - Properties
    @ObservedObject private var cityListViewModel: CityListViewModel
    @State private var isLandscape: Bool = UIDevice.current.orientation.isLandscape
    
    // MARK: - Initializer
    init(cityListViewModel: CityListViewModel) {
        self.cityListViewModel = cityListViewModel
    }
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            ZStack {
                Group {
                    if isLandscape {
                        HStack(spacing: 0) {
                            cityList
                                .frame(maxWidth: 350)
                            Divider()
                            if let city = cityListViewModel.selectedCity {
                                CityMapView(city: city)
                                    .id(city.id)
                                    .frame(maxWidth: .infinity)
                                    .transition(.opacity)
                                    .animation(.easeInOut(duration: 0.25), value: city.id)
                            } else {
                                Text("Select a city")
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .background(Color(.systemGroupedBackground))
                            }
                        }
                    } else {
                        cityList
                    }
                }
            }
            .searchable(text: $cityListViewModel.filterTerm, prompt: "Search")
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                isLandscape = UIDevice.current.orientation.isLandscape
            }
            .task {
                await cityListViewModel.loadFavorites()
                await cityListViewModel.loadCities(reset: false)
            }
            .navigationTitle("Cities")
        }
    }
    
    var cityList: some View {
        ZStack {
            List {
                ForEach(cityListViewModel.cities.indices, id: \.self) { index in
                    let city = $cityListViewModel.cities[index]
                    let cell = CityCellView(
                        city: city,
                        isFavorite: Binding(
                            get: { cityListViewModel.favorites.contains(city.id) },
                            set: { _ in
                                Task { await cityListViewModel.toggleFavorite(for: city.id) }
                            }
                        )
                    )
                    
                    Group {
                        if isLandscape {
                            cell
                                .contentShape(Rectangle())
                                .listRowBackground(
                                   cityListViewModel.selectedCity?.id == city.id ?
                                   Color.blue.opacity(0.1) : Color.clear
                                )
                                .onTapGesture {
                                    cityListViewModel.selectedCity = city.wrappedValue
                                }
                        } else {
                            NavigationLink(destination: CityMapView(city: city.wrappedValue)) {
                                cell
                            }
                        }
                    }
                    .onAppear {
                        Task {
                            await cityListViewModel.loadMoreIfNeeded(for: index)
                        }
                    }

                    
                }
            }
            if cityListViewModel.isFetching {
                ProgressView().padding()
            } else if cityListViewModel.cities.isEmpty {
                Spacer()
                Text("No cities found")
                    .foregroundColor(.secondary)
                    .font(.headline)
                Spacer()
            }
        }
    }
}

#Preview {
    let cityRepostiory = MockCityRepository(totalCities: 200)
    let cityListViewModel = CityListViewModel(cityRepostiory: cityRepostiory)
    CityListView(cityListViewModel: cityListViewModel)
}
