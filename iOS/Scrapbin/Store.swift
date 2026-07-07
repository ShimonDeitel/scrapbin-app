import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    @Published var items: [Item] = []
    @Published var isPro: Bool = false

    /// Free tier item cap. Deliberately set above the seed-data count so a
    /// fresh install never hits the paywall immediately.
    let freeLimit = 20

    private let fileURL: URL = {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        return dir.appendingPathComponent("scrapbin_items.json")
    }()

    init() {
        load()
    }

    var isAtFreeLimit: Bool {
        !isPro && items.count >= freeLimit
    }

    func add(_ item: Item) -> Bool {
        guard !isAtFreeLimit else { return false }
        items.insert(item, at: 0)
        save()
        return true
    }

    func update(_ item: Item) {
        guard let idx = items.firstIndex(where: { $0.id == item.id }) else { return }
        items[idx] = item
        save()
    }

    func delete(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        save()
    }

    func delete(_ item: Item) {
        items.removeAll { $0.id == item.id }
        save()
    }

    private func load() {
        if let data = try? Data(contentsOf: fileURL),
           let decoded = try? JSONDecoder().decode([Item].self, from: data) {
            items = decoded
        } else {
            items = [
            Item(field1: "Deck Rebuild - 12 Elm", field2: "2x4 lumber", status: "Moderate"),
            Item(field1: "Kitchen Remodel", field2: "Tile", status: "Significant"),
            Item(field1: "Fence Repair", field2: "Cedar planks", status: "Minor"),
            Item(field1: "Patio Job", field2: "Concrete mix", status: "Minor"),
            Item(field1: "Shed Build", field2: "Plywood", status: "Moderate")
            ]
            save()
        }
    }

    func save() {
        guard let data = try? JSONEncoder().encode(items) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }
}
