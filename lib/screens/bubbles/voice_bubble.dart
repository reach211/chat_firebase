
import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:just_audio/just_audio.dart';

import '../../constants/app_image.dart';

enum AudioStatus { play, stop, download, push }

class AudioBubble extends StatefulWidget {
  final bool isUser;
  final String email;
  final String voiceUrl;
  const AudioBubble({
    Key? key,
    required this.email,
    required this.isUser,
    required this.voiceUrl
  }) : super(key: key);
  @override
  _AudioBubbleState createState() => _AudioBubbleState();
}

class _AudioBubbleState extends State<AudioBubble> {
  var player = AudioPlayer();
  late Track track;
  final double imageProfileSize = 42;
  double progress = 0;
  String timeFormat = "";
  AudioStatus audioStatus = AudioStatus.stop;
  late Stream<PlaybackDisposition> _dispositionStream;
  @override
  void initState() {
    // final file = widget.message?.file?.file;
    // track = file != null
    //     ? Track.fromFile(file.path)
    //     : Track.fromURL(widget.message.file.path.chatUrl());
    // timeFormat = format(Duration(seconds: widget.message.file.audioDuration));
    // print('StaffPhoto-----------${widget.message}');
    player.setUrl(widget.voiceUrl);
    timeFormat = player.duration.toString();
    print("sa;dfdsksfdak;a ${timeFormat}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: widget.isUser ? CrossAxisAlignment.end: CrossAxisAlignment.start,
      children: [
        Text(
          widget.email
        ),
        const SizedBox(height: 3),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment:
          widget.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            SizedBox(width: 6),
            // _buildProfile(),
            _buildContainer(
              child: Stack(
                children: [
                  FractionallySizedBox(
                    widthFactor: progress,
                    child: Container(
                      color: Color(0xFFE3E3E3),
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildIconPlay(),
                      _buildTimeLine(),
                      _buildLabelTime(),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
        // _buildTextTime(),
        // _buildSending(),
      ],
    );
  }

  Widget _buildIconPlay() {
    Widget icon = Image.asset(AppImages.playLeft);
    if (audioStatus == AudioStatus.download) {
      icon = SpinKitDualRing(
        color: Colors.grey,
        size: 5,
      );
    } else if (audioStatus == AudioStatus.play) {
      icon = Icon(
        Icons.pause,
        color: Colors.grey,
        size: 15,
      );
    } else if (audioStatus == AudioStatus.stop ||
        audioStatus == AudioStatus.push) {}

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: EdgeInsets.only(left: 16, top: 8, bottom: 8, right: 5),
        child: icon,
      ),
      onTap: () async {
        if(audioStatus == AudioStatus.stop){
          player.play();
          audioStatus = AudioStatus.play;
        }else if(audioStatus == AudioStatus.play){
          player.pause();
          audioStatus = AudioStatus.stop;
        }
        setState(() {

        });
      },
    );
  }

  double countProgress(PlaybackDisposition event) {
    return event.position.inMicroseconds / event.duration.inMicroseconds;
  }

  String format(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  Widget _buildTimeLine() {
    return Expanded(
      child: Container(
        height: 1,
        color: Color(0xFF9B9B9B),
      ),
    );
  }

  Widget _buildContainer({required Widget child}) {
    return Container(
      width: 220,
      height: 30,
      clipBehavior: Clip.hardEdge,
      margin: EdgeInsets.only(
        top: 5,
        left: 5,
        right: 5,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.
            white, //widget.isUser ? AppColors().white : Color(0xFFE3E3E3),
      ),
      child: child,
    );
  }

  Widget _buildLabelTime() {
    return Container(
      child: Text(
      timeFormat,
      ),
      padding: EdgeInsets.only(left: 5, top: 8, bottom: 8, right: 16),
    );
  }

  // Widget _buildProfile() {
  //   if (widget.isUser) return Container();
  //   //String imageProfile = "";
  //   // if (widget.message.customer != null)
  //   //   imageProfile = widget.message.staff.image;
  //   return Container(
  //     clipBehavior: Clip.hardEdge,
  //     width: imageProfileSize,
  //     height: imageProfileSize,
  //     margin: EdgeInsets.only(left: 10),
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(21),
  //       color: Colors.grey.shade300,
  //     ),
  //     child: AppImageLoading(
  //       url: widget?.message?.staff?.profile?.fullUrl() ?? "",
  //       errorWidget: Padding(
  //         padding: EdgeInsets.all(8),
  //         child: Image.asset(
  //           AppImages.profile,
  //           fit: BoxFit.contain,
  //           color: Colors.white,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildTextTime() {
  //   if (widget.message.createdDate == null) return Container();
  //   return AppText(
  //     DateHelper.formatDate(
  //       timestamp: widget.message.createdDate,
  //       format: 'hh:mm a',
  //     ),
  //     margin: EdgeInsets.only(
  //       top: 3,
  //       left: imageProfileSize + AppDimension().bodySpace + 10,
  //       right: AppDimension().bodySpace,
  //     ),
  //     alignment: widget.isUser ? Alignment.centerRight : Alignment.centerLeft,
  //     style: AppFont().text(fontSize: 9, color: AppColors().title()),
  //   );
  // }

  // Widget _buildSending() {
  //   if (widget.message.status != SendStatus.SENDING) return Container();
  //   return Align(
  //       child: Container(
  //         width: 80,
  //         height: 10,
  //         margin: EdgeInsets.only(left: imageProfileSize),
  //         child: SpinKitThreeBounce(
  //           color: AppColors().primary,
  //           size: 13,
  //         ),
  //       ),
  //       alignment: Alignment.bottomRight);
  // }

  @override
  void dispose() {
    player.stop();
    super.dispose();
  }
}
