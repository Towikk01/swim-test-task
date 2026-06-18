import '../data/models/user.dart';

/// Abstraction over user fetching. The cubit depends on this interface,
/// not on the concrete Dio implementation.
abstract interface class UsersRepository {
  /// Fetch all users. Throws on network/HTTP failure.
  Future<List<User>> fetchUsers();
}
