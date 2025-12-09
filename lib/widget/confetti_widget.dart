// confetti_widget.dart
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

class VictoryConfetti extends StatefulWidget {
  final bool play;

  const VictoryConfetti({super.key, required this.play});

  @override
  State<VictoryConfetti> createState() => _VictoryConfettiState();
}

class _VictoryConfettiState extends State<VictoryConfetti> {
  late ConfettiController _controller;
  final player = AudioPlayer();

  _init() async {
    await player.play(AssetSource('sounds/clap.mp3'));
  }

  @override
  void initState() {
    super.initState();
    _controller = ConfettiController(duration: const Duration(seconds: 1));

    if (widget.play) {
      _init();
      _controller.play();
    }
  }

  @override
  void didUpdateWidget(covariant VictoryConfetti oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.play) {
      _controller.play();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConfettiWidget(
        confettiController: _controller,
        blastDirectionality: BlastDirectionality.explosive,

        shouldLoop: false,
        colors: const [Colors.green, Colors.blue, Colors.pink, Colors.orange],
        numberOfParticles: 20,
        gravity: 0.4,
        emissionFrequency: 0.05,
        maxBlastForce: 10,
        minBlastForce: 5,
      ),
    );
  }
}
