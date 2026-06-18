import '../data/models/user.dart';

abstract interface class UsersRepository {
  Future<List<User>> fetchUsers();
}
