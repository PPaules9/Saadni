//
//  CarouselCard.swift
//  GoodShift
//
//  Created by Pavly Paules on 12/03/2026.
//
import SwiftUI
import Kingfisher


struct CarouselCard: View {
	let title: String
	let subtitle: String
	let provider: String
	let carouselImage: ServiceImage
	let price: String
	let colorBanner: Color
	let onTapAction: () -> Void
	
	var body: some View {
		ZStack {
			Color(.black.opacity(0.6))
			
			VStack(alignment: .leading, spacing: 12) {
				HStack {
					VStack(alignment: .leading, spacing: 8) {
						HStack(spacing: 4) {
							
							Image(systemName: "star.fill")
								.font(.title3)
								.foregroundStyle(colorBanner.opacity(0.8))
							
							Text(title)
								.font(.title)
								.foregroundStyle(.white)
								.bold()
								.kerning(-2)
								.fontDesign(.monospaced)
								.lineLimit(1)
							
						}
						
						Text(subtitle)
							.font(.subheadline)
							.foregroundStyle(colorBanner.opacity(0.8))
							.fontDesign(.monospaced)
							.kerning(-0.3)
						Spacer()
						
					}
					
					Spacer()
					
				}
				
				Spacer()
				
				HStack {
					VStack(spacing: 4){
						Spacer()
							.frame(height: 20)
						HStack{
							Text("Learn more")
								.font(.subheadline)
								.foregroundStyle(.white)
								.fontDesign(.monospaced)
								.kerning(-1)
							
							
							Image(systemName: "arrow.right")
								.font(.subheadline)
								.foregroundStyle(.white)
						}
					}
					Spacer()
					
					VStack(alignment: .trailing, spacing: 4) {
						
						Text(provider)
							.font(.caption)
							.foregroundStyle(.white.opacity(0.8))
							.fontDesign(.monospaced)
							.kerning(-1)
						
						HStack{
							Text(price)
								.font(.title2)
							
						}
						.foregroundStyle(.white)
						.bold()
						.kerning(-1)
						.fontDesign(.monospaced)
						
						
					}
				}
			}
			.padding(16)
		}
		.frame(height: 220)
		.background {
			Group {
				if let remoteURL = carouselImage.remoteURL, let url = URL(string: remoteURL), !remoteURL.isEmpty {
					KFImage(url)
						.resizable()
				} else if let localImage = carouselImage.localImage {
					Image(uiImage: localImage)
						.resizable()
				} else if let assetName = carouselImage.assetName {
					Image(assetName)
						.resizable()
				} else {
					Rectangle()
						.fill(Color(.systemGray5))
						.overlay(
							Image(systemName: "briefcase.fill")
								.font(.system(size: 40))
								.foregroundStyle(.gray.opacity(0.3))
						)
				}
			}
			.scaledToFill()
			.clipped()
		}
		.cornerRadius(16)
		.onTapGesture(perform: onTapAction)
	}
}


#Preview {
	CarouselCard(title: "Cashier at a mall", subtitle: "Featured Services", provider: "Up to 10%", carouselImage: ServiceImage(assetName: "airConditioner"), price: "4398", colorBanner: .yellow, onTapAction: {})
}
