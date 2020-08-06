import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meedu_player/meedu_player.dart';


final videos = [
  'http://clips.vorwaerts-gmbh.de/VfE_html5.mp4',
  'http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8',
  'https://content.jwplatform.com/manifests/yp34SRmf.m3u8',
  'https://html5videoformatconverter.com/data/images/happyfit2.mp4'
];

class Video extends StatefulWidget {
    static final String routeName = 'video-page';

  Video({Key key}) : super(key: key);
  

  @override
  _VideoState createState() => _VideoState();
}



class _VideoState extends State<Video> with MeeduPlayerEventsMixin {
final MeeduPlayerController _controller = MeeduPlayerController(
    backgroundColor: Color(0xff263238)
  );


@override
  void initState() {
    super.initState();
    this._set(videos[0]);
    this._controller.events = this; // implement the mixin to listen the player events
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _set(String source) async {
    await _controller.setDataSource(
      dataSource: DataSource(type: DataSourceType.network, 
      dataSource: source
       ),
       autoPlay: false,
       aspectRatio: 16/9
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video'),
      ),
      body: Column(
        children: <Widget>[
          MeeduPlayer(controller: _controller),
          Expanded(
            child: ListView.builder(
              itemBuilder: (_, index) {
                return ListTile(
                  onTap: () {
                    this._set(videos[index]);
                  },
                  title: Text("View video ${index + 1}"),
                );
              },
              itemCount: videos.length,
            ),
          )
        ],
      ),
    );
  }

  @override
  void onLauchAsFullScreenStopped() {
    // TODO: implement onLauchAsFullScreenStopped
  }

  @override
  void onPlayerError(PlatformException e) {
    // TODO: implement onPlayerError
  }

  @override
  void onPlayerFinished() {
    // TODO: implement onPlayerFinished
  }

  @override
  void onPlayerFullScreen(bool isFullScreen) {
    // TODO: implement onPlayerFullScreen
  }

  @override
  void onPlayerLoaded(Duration duration) {
    // TODO: implement onPlayerLoaded
  }

  @override
  void onPlayerLoading() {
    // TODO: implement onPlayerLoading
  }

  @override
  void onPlayerPaused(Duration position) {
    // TODO: implement onPlayerPaused
  }

  @override
  void onPlayerPlaying() {
    // TODO: implement onPlayerPlaying
  }

  @override
  void onPlayerPosition(Duration position) {
    // TODO: implement onPlayerPosition
  }

  @override
  void onPlayerRepeat() {
    // TODO: implement onPlayerRepeat
  }

  @override
  void onPlayerResumed() {
    // TODO: implement onPlayerResumed
  }

  @override
  void onPlayerSeekTo(Duration position) {
    // TODO: implement onPlayerSeekTo
  }
}