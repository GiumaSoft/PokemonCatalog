import SwiftUI

// MARK: - ViewModel

struct PokemonCatalogView {
    @EnvironmentObject var navModel: NavigationModel
    @State var catalogItems = [PokemonCatalogItemView]()
}

// MARK: - Logic

extension PokemonCatalogView {
    private func fetchDataIfNeeded() async {
        if let resourceList = await service.getResourceList() {
            catalogItems.append(contentsOf:
                resourceList.results.map {
                    PokemonCatalogItemView(
                        id: catalogItems.count,
                        name: $0.name,
                        cardBackgroundColor: .random
                    )
                }
            )
        }
    }

    private var service: PokeApiService { PokeApiService.shared }
}

// MARK: - View

extension PokemonCatalogView: View {
    var body: some View {
        LazyVScrollView(nearBottomMargin: .spacing5x) {
            LazyVStack(alignment: .center, spacing: .spacing2x) {
                ForEach(catalogItems, id: \.self) { catalogItem in
                    catalogItem
                }
            }
            .padding()
            .task {
                await fetchDataIfNeeded()
            }
        } onNearBottom: {
            Task {
                await fetchDataIfNeeded()
            }
        }
        .padding(.top)
        .navigationDestination(for: NavigationDestination.self) { destination in
            navModel.route(destination)
        }
    }
}
