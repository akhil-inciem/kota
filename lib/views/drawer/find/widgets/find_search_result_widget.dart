import 'package:flutter/material.dart';
import 'package:kota/model/clinic_model.dart';
import 'package:kota/model/therapist_model.dart';
import 'package:kota/views/drawer/find/widgets/find_search.dart';
import 'package:kota/views/home/widgets/search_bar.dart';
import 'package:kota/views/login/widgets/custom_button.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:flutter/material.dart';

class SearchResultTherapistWidget extends StatelessWidget {
  final List<TherapistDatum> results;
  final VoidCallback onReset;
  final ValueChanged<String> onSearch;

  const SearchResultTherapistWidget({
    super.key,
    required this.results,
    required this.onReset,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search and Back Row
        Padding(
          padding:  EdgeInsets.symmetric(vertical: 1.h),
          child: SearchHeader(
  onReset: onReset,
  onSearch: onSearch,
  hintText: 'Search Therapist..',
),
),
        // Results or Empty Message
        Expanded(
          child: results.isEmpty
              ? const Center(
                  child: Text(
                    'No data found',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                )
              : ListView.separated(
                  itemCount: results.length,
                  separatorBuilder: (_, __) => const Divider(
                    
                  ),
                  itemBuilder: (context, index) {
                    final result = results[index];
                    return ListTile(
                      title: Text("${index + 1}. ${result.firstName ?? 'N/A'}"),
                      subtitle: Text("District: ${result.district ?? 'N/A'}"),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class SearchResultClinicWidget extends StatelessWidget {
  final List<Clinic> results;
  final VoidCallback onReset;
  final ValueChanged<String> onSearch;

  const SearchResultClinicWidget({
    super.key,
    required this.results,
    required this.onReset,
    required this.onSearch
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding:  EdgeInsets.symmetric(vertical: 1.h),
          child: SearchHeader(
  onReset: onReset,
  onSearch: onSearch,
  hintText: 'Search Clinic..',
),

        ),
        Expanded(
          child:results.isEmpty
              ? const Center(
                  child: Text(
                    'No data found',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                )
              : ListView.separated(
            itemCount: results.length,
            separatorBuilder: (_, __) => Divider(),
            itemBuilder: (context, index) {
              final result = results[index];
              return ListTile(
                title: Text("${index + 1}. ${result.nameAndPlaceOfInstitution ?? 'N/A'}"),
                subtitle: Text(
                  "District: ${result.district ?? 'N/A'}",
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
