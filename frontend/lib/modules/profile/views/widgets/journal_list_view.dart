import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:minder_frontend/helpers/styles/text_style.dart';
import 'package:minder_frontend/helpers/constants/colors.dart';
import 'package:minder_frontend/modules/start%20meditation/controllers/journal_controller.dart';

class JournalListView extends StatelessWidget {
  JournalListView({Key? key}) : super(key: key);

  // Put the controller (will fetch automatically)
  final JournalController journalCtl = Get.put(JournalController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (journalCtl.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (journalCtl.errorMessage.value != null) {
        return Center(
            child: Text(journalCtl.errorMessage.value!,
                style: TextStyle(color: Colors.red)));
      }
      if (journalCtl.entries.isEmpty) {
        return const Center(child: Text('No entries yet.'));
      }
      return ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: journalCtl.entries.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, i) {
          final e = journalCtl.entries[i];
          final formattedDate = DateFormat.yMMMd().add_jm().format(e.createdAt);
          return Card(
            color: appBackground,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListTile(
              title: Text(
                e.entry,
                style: AppTextStyles.body,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(formattedDate, style: AppTextStyles.lightheading),
              onTap: () {
                // TODO: optionally navigate to a detail/edit screen
              },
            ),
          );
        },
      );
    });
  }
}
