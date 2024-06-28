import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:objectbox/objectbox.dart';

class ProgramRepository {
  final Box<D2Program> _box;
  final Box<D2DataSet> _datasetBox;

  List<D2Program> getAllPrograms() {
    return _box.getAll();
  }

  ProgramRepository(D2ObjectBox db)
      : _box = db.store.box<D2Program>(),
        _datasetBox = db.store.box<D2DataSet>();

  Future<List<D2Program>> getPrograms(
      {required int offset, required int limit}) async {
    Query<D2Program> query = _box.query().build();
    query
      ..offset = offset
      ..limit = limit;
    return await query.findAsync();
  }

  Future<List<D2DataSet>> getDatasets(
      {required int offset, required int limit}) async {
    Query<D2DataSet> query = _datasetBox.query().build();
    query
      ..offset = offset
      ..limit = limit;
    return await query.findAsync();
  }
}
