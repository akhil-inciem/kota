import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kota/constants/colors.dart';
import 'package:kota/model/clinic_model.dart';
import 'package:kota/model/therapist_model.dart';
import 'package:kota/views/drawer/find/widgets/find_search.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

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
          padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 4.w),
          child: SearchHeader(
            onReset: onReset,
            onSearch: onSearch,
            hintText: 'Search Therapist',
          ),
        ),
        // Results or Empty Message
        Expanded(
          child:
              results.isEmpty
                  ? const Center(
                    child: Text(
                      'No results available',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                  : ListView.builder(
                    itemCount: results.length,
                    padding: EdgeInsets.symmetric(
                      horizontal: 5.w,
                      vertical: 1.h,
                    ),
                    itemBuilder: (context, index) {
                      final therapist = results[index];
                      return TherapistTile(therapist: therapist);
                    },
                  ),
        ),
      ],
    );
  }
}

class TherapistTile extends StatelessWidget {
  final TherapistDatum therapist;

  const TherapistTile({super.key, required this.therapist});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 1.5.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Circle Icon
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.blue.shade100,
            child: Icon(Icons.person, size: 28, color: AppColors.primaryColor),
          ),
          SizedBox(width: 3.w),

          // Name and District
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  therapist.firstName ?? 'N/A',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  "District : ${therapist.district ?? 'N/A'}",
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: Colors.grey.shade700,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 5.w),
          child: SearchHeader(
            onReset: onReset,
            onSearch: onSearch,
            hintText: 'Search Clinic',
          ),
        ),
        Expanded(
          child:
              results.isEmpty
                  ? const Center(
                    child: Text(
                      'No results available',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                  : ListView.builder(
                    itemCount: results.length,
                    padding: EdgeInsets.symmetric(
                      horizontal: 3.w,
                      vertical: 1.h,
                    ),
                    itemBuilder: (context, index) {
                      final result = results[index];
                      return ClinicTile(clinic: result, index: index);
                    },
                  ),
        ),
      ],
    );
  }
}

class ClinicTile extends StatelessWidget {
  final Clinic clinic;
  final int index;

  const ClinicTile({super.key, required this.clinic, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(color: Colors.grey.shade400, width: 0.15.w),
      ),
      child: Padding(
        padding: EdgeInsets.all(3.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hospital Icon
            Container(
              width: 10.w,
              height: 10.w,
              decoration: BoxDecoration(
                color: const Color(0xFF4A90E2).withOpacity(0.3),
                borderRadius: BorderRadius.circular(6.w),
              ),
              child: Padding(
                padding: EdgeInsets.all(
                  2.5.w,
                ), // Optional, adjust to center the SVG
                child: SvgPicture.asset(
                  'assets/icons/gov_clinic_icon.svg',
                  color: AppColors.primaryColor, // Apply tint if needed
                  width: 6.w,
                  height: 6.w,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(width: 4.w),

            // Hospital Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hospital Name
                  Text(
                    clinic.nameAndPlaceOfInstitution ??
                        'Government Medical College Hospital',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF2C3E50),
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: 1.h),

                  // Address
                  Text(
                    _formatAddress(),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[800],
                      height: 1.3,
                    ),
                  ),
                  SizedBox(height: 1.h),

                  // Phone Numbers
                  if (_getPhoneNumbers().isNotEmpty)
                    Text(
                      _getPhoneNumbers(),
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey[800],
                        height: 1.3,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatAddress() {
    List<String> addressParts = [];

    if (clinic.address != null && clinic.address!.isNotEmpty) {
      addressParts.add(clinic.address!);
    }
    if (clinic.district != null && clinic.district!.isNotEmpty) {
      addressParts.add(clinic.district!);
    }

    if (addressParts.isEmpty) {
      return "No address provided";
    }

    return addressParts.join(', ');
  }

  String _getPhoneNumbers() {
    List<String> phoneNumbers = [];

    if (clinic.phoneNumber != null && clinic.phoneNumber!.isNotEmpty) {
      phoneNumbers.add(clinic.phoneNumber!);
    }
    if (clinic.secondaryNumber != null && clinic.secondaryNumber!.isNotEmpty) {
      phoneNumbers.add(clinic.secondaryNumber!);
    }

    if (phoneNumbers.isEmpty) {
      return "No Contact Info";
    }

    return phoneNumbers.join(', ');
  }
}
