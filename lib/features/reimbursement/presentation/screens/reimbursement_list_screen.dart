import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../domain/entities/reimbursement.dart';
import '../bloc/reimbursement_bloc.dart';
import '../bloc/reimbursement_event.dart';
import '../bloc/reimbursement_state.dart';
import '../widgets/reimbursement_item.dart';
import 'reimbursement_form_screen.dart';

class ReimbursementListScreen extends StatefulWidget {
  const ReimbursementListScreen({super.key});

  @override
  State<ReimbursementListScreen> createState() =>
      _ReimbursementListScreenState();
}

class _ReimbursementListScreenState extends State<ReimbursementListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ReimbursementBloc>().add(LoadReimbursements());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reimbursement'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocConsumer<ReimbursementBloc, ReimbursementState>(
        listener: (context, state) {
          if (state is ReimbursementError) {
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(
            //     content: Text(state.message),
            //     backgroundColor: Colors.red,
            //   ),
            // );
          } else if (state is ReimbursementSuccess) {
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(
            //     content: Text(state.message),
            //     backgroundColor: Colors.green,
            //   ),
            // );
          }
        },
        builder: (context, state) {
          if (state is ReimbursementLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ReimbursementLoaded) {
            if (state.reimbursements.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.receipt_long, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'Belum ada reimbursement',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Tap tombol + untuk membuat reimbursement baru',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              );
            }
            return RefreshIndicator(
              onRefresh: () async {
                context.read<ReimbursementBloc>().add(LoadReimbursements());
              },
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final reimbursement = state.reimbursements[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Slidable(
                            key: ValueKey(reimbursement.id),
                            endActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              children: [
                                SlidableAction(
                                  onPressed:
                                      (context) => _navigateToEditReimbursement(
                                        context,
                                        reimbursement,
                                      ),
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                  icon: Icons.edit,
                                  label: 'Edit',
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                SlidableAction(
                                  onPressed:
                                      (context) => _showDeleteConfirmation(
                                        context,
                                        reimbursement,
                                      ),
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete,
                                  label: 'Hapus',
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ],
                            ),
                            child: ReimbursementItem(
                              reimbursement: reimbursement,
                            ),
                          ),
                        );
                      }, childCount: state.reimbursements.length),
                    ),
                  ),
                ],
              ),
            );
          } else if (state is ReimbursementError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${state.message}',
                    style: const TextStyle(fontSize: 16, color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ReimbursementBloc>().add(
                        LoadReimbursements(),
                      );
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return const Center(child: Text('Something went wrong'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToCreateReimbursement(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _navigateToCreateReimbursement(BuildContext context) {
    final reimbursementBloc = context.read<ReimbursementBloc>();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => BlocProvider.value(
              value: reimbursementBloc,
              child: const ReimbursementFormScreen(),
            ),
      ),
    );
  }

  void _navigateToEditReimbursement(
    BuildContext context,
    Reimbursement reimbursement,
  ) {
    final reimbursementBloc = context.read<ReimbursementBloc>();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => BlocProvider.value(
              value: reimbursementBloc,
              child: ReimbursementFormScreen(
                existingReimbursement: reimbursement,
              ),
            ),
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    Reimbursement reimbursement,
  ) {
    // Save bloc reference before opening dialog
    final reimbursementBloc = context.read<ReimbursementBloc>();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Hapus Reimbursement'),
          content: Text(
            'Apakah Anda yakin ingin menghapus reimbursement "${reimbursement.detail}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                // Use the saved bloc reference instead of context
                reimbursementBloc.add(DeleteReimbursement(reimbursement.id!));
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }
}
