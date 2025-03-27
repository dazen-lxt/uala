//
//  CityCellView.swift
//  Uala
//
//  Created by Carlos Mario Muñoz on 26/03/25.
//

import SwiftUI

struct CityCellView: View {
    
    @Binding var city: City
    @Binding var isFavorite: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(city.searchKey)
                    .font(.headline)
                Text("Lat: \(city.coord.lat), Lon: \(city.coord.lon)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Button(action: {
                isFavorite.toggle()
            }) {
                Image(systemName: isFavorite ? "star.fill" : "star")
                    .foregroundColor(isFavorite ? .yellow : .gray)
                    .animation(.easeInOut(duration: 0.2), value: isFavorite)
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 6)
    }
}
