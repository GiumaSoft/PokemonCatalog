import SwiftUI

struct PokemonCatalogList: AsyncSequence {
    typealias Element = PokemonCatalogItemView

    var names: [String]

    struct AsyncIterator: AsyncIteratorProtocol {
        private let names: [String]
        private var index: Int

        init(names: [String]) {
            self.names = names
            self.index = names.startIndex
        }

        mutating func next() async -> Element? {
            guard
                index < names.count,
                let pokemon = await service.getPokemon(name: names[index])
            else { return nil }

            return PokemonCatalogItemView(id: pokemon.id, name: pokemon.name, cardBackgroundColor: .random)
        }

        private var service: PokeApiService { PokeApiService.shared }
    }

    func makeAsyncIterator() -> AsyncIterator {
        AsyncIterator(names: names)
    }
}
