import 'package:flutter/material.dart';
import 'package:kota/views/drawer/widgets/custom_expansion_tile.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ExpansionTileGroup extends StatefulWidget {
  const ExpansionTileGroup({super.key});

  @override
  State<ExpansionTileGroup> createState() => _ExpansionTileGroupState();
}

class _ExpansionTileGroupState extends State<ExpansionTileGroup> {
  int? _expandedIndex;

  void _handleTileTap(int index) {
    setState(() {
      _expandedIndex = _expandedIndex == index ? null : index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CustomExpansionTile(
                    title:
                        'Points to Check Before Contacting an Occupational Therapist',
                    options: [
                      ExpansionOption(
                        heading: 'If He/She is a Qualified Therapist',
                        description:
                            'Make sure your therapist has a professional degree, Bachelor\'s in Occupational Therapy (BOT) or a Master\'s in Occupational Therapy (MOT), from an AIOTA accredited college.',
                      ),
                      ExpansionOption(
                        heading:
                            'Ensure the therapist is licensed under AIOTA and KOTA',
                        description:
                            'This helps you to make sure that your therapist is competent to provide occupational therapy services and follows guidelines laid down by a national/state governing board adhering to the Code of Ethics.',
                      ),
                      ExpansionOption(
                        heading:
                            'Therapist\'s Experience in the Area of Practice',
                        description:
                            'Look for your therapist\'s expertise in treating people with concerns similar to your problem. Experienced therapists will be able to assess, observe and recommend therapy scientifically. A minimum period of 2 years of experience or more under a licensed senior therapist helps understand and plan treatments most appropriately./n Apart from the above, if you feel more comfortable with a specific age group or gender category, you may look for their availability in your locality. India being a country with multiple spoken and written languages, you may also want to check on the language proficiency of a therapist with whom you can communicate and express your concerns more freely. ',
                      ),
                    ],
                    isExpanded: _expandedIndex == 0,
              onExpansionChanged: () => _handleTileTap(0),
                  ),
              
                  CustomExpansionTile(
                    title: 'Know Your Professional',
                    options: [
                      ExpansionOption(
                        heading: 'Who is an occupational therapist?',
                        description:
                            'Occupational therapists are healthcare professionals who provide treatment on scientific bases with a holistic perspective to promote a person’s ability to achieve their daily routines and roles.',
                      ),
                      ExpansionOption(
                        heading:
                            'What does an occupational therapist do?',
                        description:
                            'An Occupational Therapist assesses how different health conditions can affect people’s abilities and help people overcome or work with their disabilities to be independent in their physical, social and psychological well being. The different areas of practice include Pediatrics (neonatal to teenager), Neurological conditions, Orthopedic conditions, Mental health well-being, Geriatrics, Ergonomics, Splinting.',
                      ),
                    ],
                    isExpanded: _expandedIndex == 1,
              onExpansionChanged: () => _handleTileTap(1),
                  ),
                  CustomExpansionTile(
                    title:
                        'Questions to Ask an Occupational Therapist When You Contact Them',
                    options: [
                      ExpansionOption(
                        heading: 'What services will I receive?',
                        description:
                            'An occupational therapist will assess, observe, recommend and provide therapy services based on your concerns and therapy requirements. Therapy goals are set in discussion with the client and/or the caregiver depending on their needs. Home programs for continuing therapy practice at home are part of therapy services. An occupational therapist may also recommend home, school or office modifications and recommend equipment, if required, to help the client perform their everyday activities independently.',
                      ),
                      ExpansionOption(
                        heading:
                            'Where do you provide therapy services?',
                        description:
                            'There are occupational therapy centres and independent therapists who provide online and offline therapy services. Some therapists may visit home or office to provide services while some therapists prefer treatment at hospitals or clinics only. Make sure to check the mode of therapy services available and ensure the option you are choosing is the most convenient and appropriate one for your therapy needs.',
                      ),
                      ExpansionOption(
                        heading:
                            'Will you work with other therapists or doctors involved in my treatment?',
                        description:
                            'When all the health professionals involved with a patient\'s treatment work in coordination with each other, it results in a better understanding of the difficulties of the patient and providing the most beneficial treatment. Occupational therapists work in coordination with other therapists, doctors and health professionals involved in their client\'s treatment. Ensuring the same with your therapist before commencing your therapy program is important for coordinated treatment planning.',
                      ),ExpansionOption(
                        heading:
                            'Will you be able to recommend equipment that my child/my parent or I may need? ',
                        description:
                            'Occupational therapists can recommend equipment depending on the need of the client. They can help you with the different equipment options that might be useful for you and where to buy them. ',
                      ),
                      ExpansionOption(
                        heading:
                            'How much do you charge?',
                        description:
                            'There is no stipulated charge for independent practitioners. Please clarify with the therapist if their cost is inclusive of assessments, reports and therapy. Also, check if there will be additional costs involved if the therapist has to visit the home or office.',
                      ),
                      ExpansionOption(
                        heading:
                            'Will I get a report? ',
                        description:
                            'Checking with your therapist if they can provide a written report and asking if the report will cover details about assessment findings, goals, intervention recommendations and equipment recommendations will be useful for later reference. You may also ask if the cost covers the written report or if there are additional charges associated with it.',
                      ),
                    ],
                    isExpanded: _expandedIndex == 2,
              onExpansionChanged: () => _handleTileTap(2),
                  ),
                  SizedBox(height: 4.h),
                ],
              ),
            ),
          );
  }
}
