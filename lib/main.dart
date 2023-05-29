import 'dart:convert';
import 'dart:developer';

import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_project/repo_model.dart';

import 'calender.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: false,
      builder: (context) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CalenderPage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<FormModel> data = [];

  final pageController = PageController();
  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    rootBundle.loadString('assets/dummy_resp.json').then((value) {
      data = List.from(jsonDecode(value))
          .map((e) => FormModel.fromJson(e))
          .toList();

      if (mounted) setState(() {});
    });
  }

  int currentPage = 0;
  String? selectedRadio;
  List<String> selectedCheckboxValues = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        children: [
          TweenAnimationBuilder<double>(
            duration: const Duration(seconds: 1),
            tween: Tween(begin: 0.0, end: currentPage.toDouble()),
            builder: (context, value, child) {
              return Row(
                children: [
                  Expanded(
                    child: LinearProgressIndicator(
                      value: (value / data.length).isNaN ||
                              (value / data.length).isInfinite
                          ? 0
                          : value / data.length,
                      valueColor: const AlwaysStoppedAnimation(Colors.orange),
                      backgroundColor: Colors.black,
                    ),
                  ),
                ],
              );
            },
          ),
          Expanded(
            child: PageView.builder(
              controller: pageController,
              scrollDirection: Axis.vertical,
              itemCount: data.length,
              onPageChanged: (value) {
                currentPage = value;
                setState(() {});
              },
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final title = data[index].title;
                final type = data[index].type;
                final options = data[index].options;

                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${index + 1}. $title",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 20),
                      //
                      if (type == 'input')
                        AppTextField(
                          controller: textController,
                          onChanged: (value) {
                            final ans = textController.text.trim();
                            if (ans.isEmpty) {
                              final up =
                                  data[index].copyWith(isAnswered: false);
                              data.removeAt(index);
                              data.insert(index, up);
                            } else {
                              final up = data[index].copyWith(
                                isAnswered: true,
                                answers: [ans],
                              );
                              data.removeAt(index);
                              data.insert(index, up);
                            }
                            log(ans);
                            log("${ans.isEmpty}   ${data[index].isAnswered}    ${data[index].answers}");

                            setState(() {});
                          },
                        ),

                      //
                      if (type == 'radio')
                        ...List.generate(
                          options.length,
                          (index) {
                            final radioTitle = options[index];
                            return AppRadio(
                              value: radioTitle,
                              selectedValue: selectedRadio,
                              onChanged: (value) {
                                if (value != null) {
                                  selectedRadio = value;

                                  if (selectedRadio == null) {
                                    final up =
                                        data[index].copyWith(isAnswered: false);
                                    data.removeAt(index);
                                    data.insert(index, up);
                                  } else {
                                    final up = data[index].copyWith(
                                      isAnswered: true,
                                      answers: [selectedRadio!],
                                    );
                                    data.removeAt(index);
                                    data.insert(index, up);
                                  }
                                  setState(() {});
                                }
                              },
                              title: title,
                            );
                          },
                        ),

                      //
                      if (type == 'checkbox')
                        ...List.generate(
                          options.length,
                          (index) {
                            final checkboxTitle = options[index];

                            return AppCheckBox(
                              title: checkboxTitle,
                              value: selectedCheckboxValues
                                  .contains(checkboxTitle),
                              onChanged: (value) {
                                if (value != null && value) {
                                  selectedCheckboxValues.add(checkboxTitle);
                                } else {
                                  selectedCheckboxValues.remove(checkboxTitle);
                                }

                                if (selectedCheckboxValues.isEmpty) {
                                  final up =
                                      data[index].copyWith(isAnswered: false);
                                  data.removeAt(index);
                                  data.insert(index, up);
                                } else {
                                  final up = data[index].copyWith(
                                    isAnswered: true,
                                    answers: selectedCheckboxValues,
                                  );
                                  data.removeAt(index);
                                  data.insert(index, up);
                                }
                                setState(() {});
                              },
                            );
                          },
                        ),

                      //
                      const SizedBox(height: 20),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            onPressed: () {
              if (currentPage != 0) {
                pageController.previousPage(
                  duration: const Duration(seconds: 1),
                  curve: Curves.linear,
                );
              }
            },
            tooltip: 'Increment',
            child: const Icon(Icons.arrow_back),
          ),
          const SizedBox(width: 10),
          if (currentPage < (data.length - 1))
            FloatingActionButton(
              onPressed: () {
                if (currentPage < (data.length - 1)) {
                  if (data[currentPage].isAnswered) {
                    pageController.nextPage(
                      duration: const Duration(seconds: 1),
                      curve: Curves.linear,
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please answer the question'),
                      ),
                    );
                  }
                }
              },
              backgroundColor:
                  currentPage < (data.length - 1) ? Colors.blue : Colors.grey,
              tooltip: 'Increment',
              child: const Icon(
                Icons.arrow_forward,
              ),
            ),
          if (currentPage == (data.length - 1))
            FloatingActionButton.extended(
              onPressed: () {
                final result = data
                    .map((e) => {
                          "title": e.title,
                          "options": e.answers,
                        })
                    .toList();

                log("$result");
              },
              tooltip: 'Increment',
              label: const Text("Submit"),
              icon: const Icon(Icons.arrow_forward),
            ),
        ],
      ),
    );
  }
}

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  const AppTextField({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      decoration: const InputDecoration(
        hintText: 'Type your answer here',
      ),
    );
  }
}

class AppCheckBox extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool?> onChanged;
  const AppCheckBox({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

class AppRadio extends StatelessWidget {
  final String title;
  final String value;
  final String? selectedValue;
  final ValueChanged<String?> onChanged;

  const AppRadio({
    super.key,
    required this.value,
    this.selectedValue,
    required this.onChanged,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Radio(value: value, groupValue: selectedValue, onChanged: onChanged),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
