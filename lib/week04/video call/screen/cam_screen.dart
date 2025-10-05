import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:video_call/const/agora.dart';

import '../const/agora.dart';

class CamScreen extends StatefulWidget {
  const CamScreen({Key? key}) : super(key: key);

  @override
  _CamScreenState createState() => _CamScreenState();

}

class _CamScreenState extends State<CamScreen> {
  Widget renderSubView(){
    if(uid !== null){
      return AgoraVideoView(
        controller: VideoViewController(
          rtcEngine: engine!,

          canvas: const VideoCanvas(uid: 0),
        ),

      );
    } else {

      return CircularProgressIndicator();
    }
  }
  Widget renderMainView(){
    if (otherUid != null){
      return AgoraVideoView(

        controller: VideoViewController.remote(
          rtcEngine: engine!,

          canvas: VideoCanvas(uid: otherUid),
          connection: const RtcConnection(channelId: CHANNEL_NAME),
        ),
      );
    }else{
      return Center(
        child: const Text(
          '다른 사용자가 입장할 때까지 대기해주세요.',
          textAlign: TextAlign.center,
        ),
      );
    }
  }
  }

  RtcEngine? engine;
  int? uid;
  int? otherUid;

  Future<bool> init() async {
    final resp = await [Permission.camera, Permission.microphone].request();

    final cameraPermission = resp[Permission.camera];
    final micPermission = resp[Permission.microphone];

    if (cameraPermission !=PermissionStatus.granted ||
        micPermission != Permission.microphone) {
          throw '카메라 또는 마이크 권한이 없습니다.';
        }
        if (engine == null) {
          engine = createAgoraRtcEngine();

          await engine!.initialize(
            RtcEngineContext(
              appleId: APP_ID,
              channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
            ),
          );

          engine!.registerEventHandler(

            RtcEngineEventHandler(
              onJoinChannelSuccess: (RtcConnection connection, int elapsed) {

                print('채널에 입장했습니다. uid: ${connection.localUid}');
                setState((){
                  this.uid = connection.localUid;
                });
              },
              onLeaveChannel: (RtcConnection connection, RtcStats stats) {
                print('채널 퇴장');
                setState((){
                  uid = null;
                });
              },
              onUserJoined: (RtcConnection connection, int remoteUid, int elapsed){

                print('상대가 채널에 입장했습니다. uid : $remoteUid');
                setState((){
                  otherUid = remoteUid;
                });
              },
              onUserOffline: (RtcConnection connection, int remoteUid,
              UserOfflineReasonType reason){

                print('상대가 채널에서 나갔습니다. uid : $uid');
                setState((){
                  otherUid = null;
                });
              },
            ),
          );

        await engine!.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
        await engine!.enableVideo();
        await engine!.startPreview();
        await engine!.joinChannel(

          token: TEMP_TOKEN,
          channelId: CHANNEL_NAME,

          options: ChannelMediaOptions(),
          uid: 0,
        );
        }

    return true;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LIVE'),
      ),
      body: FutureBuilder(
        future: init(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
              ),
            );
          }
          if(!snapshot.hasData){
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return Stack(
            children: [
              renderMainView(),
              Align(
                alignment: Alignment.topleft,
                child: Container(
                  color: Colors.grey,
                  height: 160,
                  width: 120,
                  child: renderSubView(),
                ),
              ),
            ],
          );
          
        },
      ),
    );
    
  }
