import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CalenderEventListView extends StatelessWidget {
  const CalenderEventListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3F1554),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          splashRadius: 20,
          icon: const Icon(
            Icons.arrow_back,
          ),
        ),
        title: const Text(
          "  tce",
          style: TextStyle(fontSize: 32),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Today",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20),
            ...List.generate(
              10,
              (index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: index.isEven
                        ? const Color(0xFFFFECD1)
                        : const Color(0xFFE3E8ED),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Hackathon",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: const [
                          Icon(CupertinoIcons.time, size: 20),
                          SizedBox(width: 10),
                          Text(
                            "10am - 12pm",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: const [
                          Icon(Icons.location_on_outlined, size: 20),
                          SizedBox(width: 10),
                          Text(
                            "InUnity Innvovative Hub",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
