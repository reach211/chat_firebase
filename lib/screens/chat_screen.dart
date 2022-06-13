import 'dart:io';
import 'package:chat/screens/bubbles/image_bubble.dart';
import 'package:chat/screens/bubbles/voice_bubble.dart';
import 'package:chat/screens/function.dart';
import 'package:chat/screens/widgets/browse_photo_bottom_sheet.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import '../constants/app_image.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as path;
// import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:intl/intl.dart' show DateFormat;

final _fireStore = FirebaseFirestore.instance;
late User loggedInUser;

class ChatScreen extends StatefulWidget {
  static const String id = "chat_screen";
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  late FlutterSoundRecorder _recordingSession;
  // final recordingPlayer = AssetsAudioPlayer();
  final recordingPlayer = AudioPlayer();
  late String pathToAudio;
   bool _playAudio = false;
  String _timerText = '00:00:00';

  void initializer() async {
    pathToAudio = '/sdcard/Download/temp.wav';
    _recordingSession = FlutterSoundRecorder();
    await _recordingSession.openAudioSession(
        focus: AudioFocus.requestFocusAndStopOthers,
        category: SessionCategory.playAndRecord,
        mode: SessionMode.modeDefault,
        device: AudioDevice.speaker);
    await _recordingSession.setSubscriptionDuration(Duration(milliseconds: 10));
    await initializeDateFormatting();
    await Permission.microphone.request();
    await Permission.storage.request();
    await Permission.manageExternalStorage.request();
  }
  Future<void> startRecording() async {
    Directory directory = Directory(path.dirname(pathToAudio));
    if (!directory.existsSync()) {
      directory.createSync();
    }
    _recordingSession.openAudioSession();
    await _recordingSession.startRecorder(
      toFile: pathToAudio,
      codec: Codec.pcm16WAV,
    );
    StreamSubscription _recorderSubscription =
    _recordingSession.onProgress!.listen((e) {
      var date = DateTime.fromMillisecondsSinceEpoch(e.duration.inMilliseconds,
          isUtc: true);
      var timeText = DateFormat('mm:ss:SS', 'en_GB').format(date);
      setState(() {
        _timerText = timeText.substring(0, 8);
      });
    });
    _recorderSubscription.cancel();
  }
  Future<String?> stopRecording() async {
    _recordingSession.closeAudioSession();
    return await _recordingSession.stopRecorder();
  }
  Future<void> playFunc() async {
    recordingPlayer.play(
    );

    // recordingPlayer.open(
    //   Audio.file(pathToAudio),
    //   autoStart: true,
    //   showNotification: true,
    // );
  }
  Future<void> stopPlayFunc() async {
    recordingPlayer.stop();
  }





  late bool _recordOn = false;
  final picker = ImagePicker();
  final textController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  final storageRef = FirebaseStorage.instance.ref();
  late String userText;

  late RecordingDisposition recordingDisposition;
  late PermissionStatus microphoneStatus;

  final _audioRecorder = Record();


  void getCurrentUser() async {
    print("sdaflkfsdksdfsadfda ${_auth.currentUser?.providerData}");
    try {
      final user = await _auth.currentUser!;
      if (user != null) {
        loggedInUser = user;
        // print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  Future getImage(ImageSource source) async {
    final pickedFile = await picker.getImage(
      source: source,
      imageQuality: 25,
      maxHeight: 1024,
      maxWidth: 1024,
    );
    // File imageFile = File(pickedFile?.path);

    File imageFile = File(pickedFile!.path);
    if (pickedFile == null) return;

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  child: Icon(
                    Icons.cancel_outlined,
                    color: Colors.red,
                  ),
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            titlePadding: const EdgeInsets.fromLTRB(0, 10, 10, 0),
            content: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.5,
              ),
              child: Image.file(
                File(pickedFile.path),
              ),
            ),
            actions: [
              InkWell(
                onTap: () async {
                  final imageUrl =
                      await uploadImageToFirebase(context, imageFile);
                  _fireStore.collection("new_messages").add({
                    "voice": null,
                    "image": imageUrl,
                    "email": loggedInUser.email,
                    "text": null,
                    'timestamp': FieldValue.serverTimestamp(),
                  });
                  setState(() {
                    // _chatBloc.sendMessage(
                    //   channel: _channel,
                    //   role: ChatUserRole.customer,
                    //   file: MessageFile(
                    //     file: File(pickedFile.path),
                    //     fileExtension: p.extension(pickedFile.path),
                    //   ),
                    // );
                  });
                  Navigator.pop(context);
                },
                child: CircleAvatar(
                  backgroundColor: Colors.red,
                  child: Center(
                    child: Container(
                      width: 20,
                      child: Image.asset(AppImages.send, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          );
        });
    // setState(() {
    //   _chatBloc.sendMessage(
    //     channel: _channel,
    //     role: ChatUserRole.customer,
    //     file: MessageFile(
    //       file: File(pickedFile.path),
    //       fileExtension: p.extension(pickedFile.path),
    //     ),
    //   );
    // });
  }

  void getMessage() async {
    await for (var snapshot in _fireStore.collection("new_messages").snapshots()) {
      for (var message in snapshot.docs) {
        print(message.data());
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    initializer();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.close),
              onPressed: () async{
                await _auth.signOut().then((value) => Navigator.pop(context));
              }),
        ],
        title: const Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const MessageStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child:
              _recordOn?
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 5,
                  ),
                  InkWell(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Icon(Icons.delete_outline_rounded),
                    ),
                    onTap: (){
                      _recordOn = false;
                      setState(() {

                      });
                    },
                    // onTap: () {
                    //   soundRecorder.onStopped = ({wasUser}) {
                    //     File(soundPath).delete();
                    //   };
                    //   setState(() {
                    //     recordAudioStatus = RecordAudioStatus.cancel;
                    //     _recordOn = false;
                    //   });
                    // },
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5.5, bottom: 4),
                    child: Container(
                      width: MediaQuery.of(context).size.width / 1.4,
                      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(23),
                        color: Colors.red,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            offset: Offset.zero,
                            color: Colors.transparent,
                          )
                        ],
                      ),
                      child: SpinKitWave(
                        key: UniqueKey(),
                        color: Colors.white,
                        type: SpinKitWaveType.center,
                        size: 25.0,
                      ),
                    ),
                  ),
                  InkWell(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Image.asset(AppImages.send),
                    ),
                    onTap: () async{
                      stopRecording();
                      final voiceUrl = await uploadVoiceToFirebase(context, File(pathToAudio));
                      await _fireStore.collection("new_messages").add({
                        "voice": voiceUrl,
                        "image": null,
                        "email": loggedInUser.email,
                        "text": null,
                        'timestamp': FieldValue.serverTimestamp(),
                      });
                      _recordOn = false;
                      setState(() {

                      });
                    },
                  ),
                ],
              ):
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  InkWell(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Image.asset(AppImages.mic),
                    ),
                      onTap: () async {
                        startRecording();
                        _recordOn = true;
                        setState(() {
                        });
                      },
                  ),
                  InkWell(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Image.asset(AppImages.gallery),
                    ),
                    onTap: () async {
                      FocusScope.of(context).unfocus();
                      await showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return BrowsePhotoBottomSheetView(
                              onCameraTap: () {
                                getImage(ImageSource.camera);
                              },
                              onGalleryTap: () {
                                getImage(ImageSource.gallery);
                              },
                            );
                          });
                    },
                  ),
                  Expanded(
                    child: TextField(
                      controller: textController,
                      onChanged: (value) {
                        userText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      textController.clear();
                      //Implement send functionality.
                      _fireStore.collection("new_messages").add({
                        "voice": null,
                        "image": null,
                        "email": loggedInUser.email,
                        "text": userText,
                        'timestamp': FieldValue.serverTimestamp(),
                      });
                    },
                    child: const Text(
                      'Send',
                      style: kSendButtonTextStyle,
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
}

class MessageStream extends StatelessWidget {
  const MessageStream({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _fireStore
              .collection("new_messages")
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.blueAccent,
              ),
            );
          }
          List<Widget> messageBubble = [];
          final messages = snapshot.data!.docs;
          for (var message in messages) {
            final image = message.get("image");
            final voice = message.get("voice");
            final email = message.get('email');
            final text = message.get('text');

            final textMessage = image == null && voice == null
                ? MessageBubble(
                    text: text,
                    email: email,
                    isMe: loggedInUser.email == message.get('email'),
                  )
                :
            voice == null && text == null?
            ImageBubble(
                    image : image,
                    email: email,
                    isMe: loggedInUser.email == message.get('email'),
                  )
          :
            AudioBubble(
              email: email,
              isUser: loggedInUser.email == message.get('email'),
              voiceUrl: voice,
            )
          ;
            messageBubble.add(textMessage);
          }

          return Expanded(
            child: ListView(
              reverse: true,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              children: messageBubble,
            ),
          );
        });
  }
}



class MessageBubble extends StatelessWidget {
  final String text;
  final String email;
  final bool isMe;
  const MessageBubble(
      {Key? key, required this.text, required this.email, required this.isMe})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            "$email",
            style: const TextStyle(color: Colors.black54, fontSize: 12),
          ),
          Material(
            borderRadius: isMe
                ? const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30))
                : const BorderRadius.only(
                    // topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
            ),
            elevation: 5.0,
            color: isMe ? Colors.blueAccent : Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
              child: Text(
                text,
                style: TextStyle(
                    color: isMe ? Colors.white : Colors.black54, fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
