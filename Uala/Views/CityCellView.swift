//
//  CityCellView.swift
//  Uala
//
//  Created by Carlos Mario Muñoz on 26/03/25.
//

import SwiftUI

struct CityCellView: View {
    
    @Binding var city: City
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(city.name)
                    .font(.headline)
                Text("Lat: \(city.coord.lat), Lon: \(city.coord.lon)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Button(action: {
            }) {
                Image(systemName:"star.fill")
                    .foregroundColor(.yellow)
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 6)
    }
}
