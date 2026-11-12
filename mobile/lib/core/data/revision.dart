import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Groups of server data that screens show.
enum DataSet {
  sites,
  clients,
  people,
  payments,
  attendance,
  staffUpdates,
  engineerUpdates,
  issues,
  notifications,
  stock,

  /// Leave, and staff members' money and food requests.
  requests,

  /// Company vehicles, who holds them, and money asked for their repair.
  vehicles,
}

/// A counter per data set. Screens watch it; anything that changes that data
/// calls [Revision.bump], so every list and detail showing it reloads.
class Revision extends Notifier<int> {
  Revision(this.dataSet);

  final DataSet dataSet;

  @override
  int build() => 0;

  void bump() => state++;
}

final revisionProvider = NotifierProvider.family<Revision, int, DataSet>(Revision.new);

extension BumpData on Ref {
  void bump(DataSet set) => read(revisionProvider(set).notifier).bump();
}

extension BumpDataFromWidget on WidgetRef {
  void bump(DataSet set) => read(revisionProvider(set).notifier).bump();
}
