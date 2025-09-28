import 'package:dartz/dartz.dart';
import '../../domain/entities/reimbursement.dart';
import '../../domain/repositories/reimbursement_repository.dart';
import '../datasources/reimbursement_database_helper.dart';
import '../models/reimbursement_model.dart';

class ReimbursementRepositoryImpl implements ReimbursementRepository {
  final ReimbursementDatabaseHelper databaseHelper;

  ReimbursementRepositoryImpl(this.databaseHelper);

  @override
  Future<Either<String, List<Reimbursement>>> getAllReimbursements() async {
    try {
      final db = await databaseHelper.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'reimbursements',
        orderBy: 'createdAt DESC',
      );

      final reimbursements =
          maps
              .map((map) => ReimbursementModel.fromMap(map).toEntity())
              .toList();
      return Right(reimbursements);
    } catch (e) {
      return Left('Failed to get reimbursements: $e');
    }
  }

  @override
  Future<Either<String, Reimbursement>> getReimbursementById(int id) async {
    try {
      final db = await databaseHelper.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'reimbursements',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (maps.isEmpty) {
        return Left('Reimbursement not found');
      }

      final reimbursement = ReimbursementModel.fromMap(maps.first).toEntity();
      return Right(reimbursement);
    } catch (e) {
      return Left('Failed to get reimbursement: $e');
    }
  }

  @override
  Future<Either<String, Reimbursement>> createReimbursement(
    Reimbursement reimbursement,
  ) async {
    try {
      final db = await databaseHelper.database;
      final reimbursementModel = ReimbursementModel.fromEntity(reimbursement);
      final id = await db.insert('reimbursements', reimbursementModel.toMap());

      final createdReimbursement = reimbursement.copyWith(id: id);
      return Right(createdReimbursement);
    } catch (e) {
      return Left('Failed to create reimbursement: $e');
    }
  }

  @override
  Future<Either<String, Reimbursement>> updateReimbursement(
    Reimbursement reimbursement,
  ) async {
    try {
      final db = await databaseHelper.database;
      final reimbursementModel = ReimbursementModel.fromEntity(reimbursement);

      await db.update(
        'reimbursements',
        reimbursementModel.toMap(),
        where: 'id = ?',
        whereArgs: [reimbursement.id],
      );

      return Right(reimbursement);
    } catch (e) {
      return Left('Failed to update reimbursement: $e');
    }
  }

  @override
  Future<Either<String, void>> deleteReimbursement(int id) async {
    try {
      final db = await databaseHelper.database;
      await db.delete('reimbursements', where: 'id = ?', whereArgs: [id]);

      return const Right(null);
    } catch (e) {
      return Left('Failed to delete reimbursement: $e');
    }
  }

  @override
  Future<Either<String, List<Reimbursement>>> getReimbursementsByStatus(
    ReimbursementStatus status,
  ) async {
    try {
      final db = await databaseHelper.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'reimbursements',
        where: 'status = ?',
        whereArgs: [status.name],
        orderBy: 'createdAt DESC',
      );

      final reimbursements =
          maps
              .map((map) => ReimbursementModel.fromMap(map).toEntity())
              .toList();
      return Right(reimbursements);
    } catch (e) {
      return Left('Failed to get reimbursements by status: $e');
    }
  }
}
