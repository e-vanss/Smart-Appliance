import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class Devices extends StatefulWidget {
  const Devices({Key? key}) : super(key: key);

  @override
  State<Devices> createState() => _DevicesState();
}

class _DevicesState extends State<Devices> {
  bool isON = false;
  final CircularSliderAppearance appearance01 =
      const CircularSliderAppearance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(
            height: 100,
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Time: ${DateTime.now().hour}:${DateTime.now().minute}',
                  style: TextStyle(),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    'Date: ${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}',
                    style: TextStyle())
              ],
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  const Text('Current'),
                  const SizedBox(
                    height: 20,
                  ),
                  SleekCircularSlider(
                    onChangeStart: (double value) {},
                    onChangeEnd: (double value) {},
                    innerWidget: (double value) {
                      return Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${value.toInt()}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text("A"),
                          ],
                        ),
                      );
                    },
                    appearance: appearance01,
                    min: 0,
                    max: 40,
                    initialValue: isON ? 30 : 0,
                  )
                ],
              ),
              Column(
                children: [
                  const Text('Power'),
                  const SizedBox(
                    height: 20,
                  ),
                  SleekCircularSlider(
                    onChangeStart: (double value) {},
                    onChangeEnd: (double value) {},
                    innerWidget: (double value) {
                      return Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${value.toInt()}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text("W"),
                          ],
                        ),
                      );
                    },
                    appearance: appearance01,
                    min: 0,
                    max: 5000,
                    initialValue: isON ? 300 : 0,
                  )
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 70),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  isON = !isON;
                });
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                elevation: 10,
                side: BorderSide(
                  color: isON ? Colors.green : Colors.red,
                  width: 2,
                ),
                textStyle: TextStyle(color: isON ? Colors.green : Colors.red),
                fixedSize: Size(50, 70),
                minimumSize: Size(70, 70),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              child: Text(
                isON ? 'ON' : 'OFF',
                style: TextStyle(
                  color: isON ? Colors.green : Colors.red,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
