/// Abstraction over pace submission. The bloc depends on this, not on the
/// concrete Dio implementation — so the transport can be swapped or mocked.
abstract interface class PaceRepository {
  /// POST the pace (in seconds). Throws on network/HTTP failure.
  Future<void> submitPace(int paceSeconds);
}
