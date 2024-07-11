import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'main.dart';

class AccumulatorWidget extends StatelessWidget {
  const AccumulatorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          textScaler: const TextScaler.linear(4),
          appState.acc.toStringAsFixed(
              appState.acc.truncateToDouble() == appState.acc ? 0 : 2),
        ),
        const SizedBox(height: 20),
        ...NumberField().columnElements(context),
      ],
    );
  }
}

class NumberField {
  NumberField();

  List<Widget> columnElements(BuildContext context) {
    var appState = context.watch<AppState>();
    return [
      SizedBox(
          width: 0.6 * MediaQuery.of(context).size.width,
          child: TextField(
            onChanged: (numberStr) =>
                {appState.updateNumberField(double.parse(numberStr))},
            maxLines: 1,
            textAlign: TextAlign.center,
            decoration:
                const InputDecoration(labelText: "Please record a number"),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]'))
            ],
          )),
      const SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () => appState.increment(),
            child: const Text("Increment"),
          ),
          ElevatedButton(
            onPressed: () => appState.decrement(),
            child: const Text("Decrement"),
          ),
        ],
      ),
      const SizedBox(
        height: 30,
      ),
      ElevatedButton(
          onPressed: () => appState.resetAcc(),
          child: const Text("Reset Accumulator"))
    ];
  }
}
