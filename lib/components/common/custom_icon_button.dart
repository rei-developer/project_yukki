import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_yukki/config/ui_config.dart';
import 'package:project_yukki/providers/audio_player_provider.dart';

class CustomIconButton extends ConsumerStatefulWidget {
  const CustomIconButton(
    this.icon, {
    this.size = 14,
    this.color = primaryColor,
    this.audioFileName = 'move.mp3',
    this.callback,
    Key? key,
  }) : super(key: key);

  final IconData icon;
  final double size;
  final Color color;
  final String? audioFileName;
  final VoidCallback? callback;

  @override
  ConsumerState<CustomIconButton> createState() => _CustomIconButtonState();
}

class _CustomIconButtonState extends ConsumerState<CustomIconButton> {
  @override
  Widget build(BuildContext context) => CupertinoButton(
        minSize: 0,
        padding: EdgeInsets.zero,
        child: Icon(
          widget.icon,
          size: widget.size,
          color: widget.color,
        ),
        onPressed: () {
          if (widget.audioFileName != null) {
            _audioProvider.setSE(widget.audioFileName!);
          }
          widget.callback?.call();
        },
      );

  AudioPlayerProvider get _audioProvider => ref.read(audioPlayerProvider.notifier);
}
