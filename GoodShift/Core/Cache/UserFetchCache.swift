import Observation

/// A lightweight, multi-user in-memory cache for fetching secondary users (not the current user).
///
/// Problem it solves: 6 different views independently called `FirestoreService.shared.fetchUser(id:)`,
/// causing duplicate reads for the same user and no caching between views.
///
/// How it works:
/// - First call for a user ID fires a Firestore read and stores the Task in `inFlight`.
/// - Any concurrent calls for the same ID await the SAME Task — no duplicate reads.
/// - Once resolved, the result goes into `cache` for instant future lookups.
/// - Cleared on logout via `AppContainer.clearUserSession()`.
///
/// Usage: inject via @Environment(UserFetchCache.self)
@Observable
final class UserFetchCache {

    // MARK: - Private State

    private var cache: [String: User] = [:]
    private var inFlight: [String: Task<User?, Never>] = [:]

    // MARK: - Public API

    /// Returns a cached user immediately, or fetches from Firestore once if not cached.
    /// Concurrent calls for the same `id` share a single in-flight Task — no duplicate reads.
    func fetchUser(id: String) async -> User? {
        // 1. Cache hit — return instantly
        if let cached = cache[id] { return cached }

        // 2. Already fetching — await the existing task
        if let existing = inFlight[id] { return await existing.value }

        // 3. Start a new fetch
        let task = Task<User?, Never> {
            try? await FirestoreService.shared.fetchUser(id: id)
        }
        inFlight[id] = task
        let result = await task.value

        // Store result and clean up in-flight entry
        if let user = result {
            cache[id] = user
        }
        inFlight.removeValue(forKey: id)
        return result
    }

    /// Evicts a single user from the cache (e.g., after their profile was updated).
    func invalidate(id: String) {
        cache.removeValue(forKey: id)
    }

    /// Clears all cached users and cancels any in-flight fetches. Called on logout.
    func clearAll() {
        inFlight.values.forEach { $0.cancel() }
        inFlight.removeAll()
        cache.removeAll()
    }
}
