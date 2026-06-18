

abstract interface class PaceRepository {
  
  Future<void> submitPace(int paceSeconds);
}
