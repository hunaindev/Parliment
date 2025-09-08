import 'package:flutter/material.dart';
import 'package:parliament_app/src/core/widgets/custom_button.dart';
import 'package:parliament_app/src/core/widgets/custom_input_field.dart';
import 'package:parliament_app/src/core/widgets/custom_text.dart';

class ReportProblem extends StatefulWidget {
  const ReportProblem({super.key});

  @override
  State<ReportProblem> createState() => _ReportProblemState();
}

class _ReportProblemState extends State<ReportProblem> {
  String? selectedProblem;
  final TextEditingController _otherProblemController = TextEditingController();
  final List<String> problems = [
    'App crashes frequently',
    'Login issues',
    'Payment problems',
    'Performance is slow',
    'Features not working',
    'Other problem'
  ];
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _otherProblemController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
        title: const TextWidget(
          text: 'Report a Problem',
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TextWidget(
                        text: 'Select the problem you are facing:',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Museo-Bolder",
                      ),
                      const SizedBox(height: 16),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: problems.length,
                        itemBuilder: (context, index) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              unselectedWidgetColor: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.5),
                            ),
                            child: RadioListTile<String>(
                              title: TextWidget(
                                text: problems[index],
                                fontWeight: FontWeight.bold,
                              ),
                              value: problems[index],
                              groupValue: selectedProblem,
                              activeColor: Theme.of(context).primaryColor,
                              onChanged: (value) {
                                setState(() {
                                  selectedProblem = value;
                                });
                              },
                            ),
                          );
                        },
                      ),
                      if (selectedProblem == 'Other problem') ...[
                        const SizedBox(height: 16),
                        CustomInputField(
                          controller: _otherProblemController,
                          label: 'Please describe your problem',
                          hintText: 'Please describe your problem',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your problem';
                            }
                            return null;
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CustomButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (selectedProblem == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please select a problem'),
                        ),
                      );
                      return;
                    }
                    if (selectedProblem == 'Other problem' &&
                        _otherProblemController.text.isEmpty) {
                      return;
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Problem registered successfully..!'),
                      ),
                    );

                    setState(() {
                      _otherProblemController.text = "";
                      selectedProblem = null;
                    });
                    // Handle submit action here
                  }
                },
                text: ('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
