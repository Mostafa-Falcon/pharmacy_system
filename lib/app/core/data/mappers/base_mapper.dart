/// العقد الأساسي لكل DataMapper — يحوّل بين Drift TableData والـ Model
abstract class DataMapper<D, M> {
  M fromData(D data);
}

/// العقد الأساسي لكل CompanionMapper — يحوّل من Model إلى Drift Companion
abstract class CompanionMapper<M, C> {
  C toCompanion(M model);
}