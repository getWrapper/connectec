
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:photo_view/photo_view.dart';

class SliderWidget extends StatefulWidget {
  final List<String> imageUrls;
  final BorderRadius imageBorderRadius;
  const SliderWidget({
    Key key,
    @required this.imageUrls,
    @required this.imageBorderRadius,
  }) : super(key: key);
  @override
  ImageSliderWidgetState createState() {
    return new ImageSliderWidgetState();
  }
}

class ImageSliderWidgetState extends State<SliderWidget> {
  List<Widget> _pages = [];
  final _controller = PageController(viewportFraction: 1);
  @override
  void initState() {
    super.initState();
    _pages = widget.imageUrls.map((url) {
      return _buildImagePageItem(url);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return _buildingImageSlider();
  }

  Widget _buildingImageSlider() {
    return Container(
      padding: EdgeInsets.all(8.0),
      color: Colors.black,
      child: Stack(
        children: [
          widget.imageUrls.length > 1
              ? _buildPagerViewSlider()
              : PhotoView(
                  imageProvider: NetworkImage(widget.imageUrls[0]),
                  minScale: 0.2,
                  maxScale: 2.0,
                ),
          Positioned(
              child: IconButton(
                  icon: Icon(Icons.more_vert),
                  iconSize: 30.0,
                  onPressed: () {
                    _displayBottomSheet();
                  },
                  color: Colors.white),
              right: 0.0,
              top: 16.0),
        ],
      ),
    );
  }

  Widget _buildPagerViewSlider() {
    return PageIndicatorContainer(
      child: PageView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        controller: _controller,
        itemCount: _pages.length,
        itemBuilder: (BuildContext context, int index) {
          return _pages[index % _pages.length];
        },
        onPageChanged: (page) {
          setState(() {});
        },
      ),
      length: _pages.length,
      indicatorSelectorColor: Theme.of(context).accentColor,
      shape: IndicatorShape.circle(size: 8.0),
    );
  }

  Widget _buildImagePageItem(String imgUrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: PhotoView(
        imageProvider: NetworkImage(imgUrl),
        minScale: 0.2,
        maxScale: 2.0,
      ),
    );
  }

  void _displayBottomSheet() async {
    showModalBottomSheet(
        context: Scaffold.of(context).context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
        ),
        backgroundColor: Colors.white,
        builder: (ctx) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.15,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.file_download),
                    title: Text('Guardar en el teléfono'),
                    onTap: () async {
                      int pos = _controller.page.toInt();
        Navigator.pop(context);
        _showToast('Descargando imagen ...');
String path = widget.imageUrls[pos];
    GallerySaver.saveImage(path, albumName: 'ConnecTec').then((bool success) {
      // setState(() {
      //   _showToast('Imagen guardada');
      // });
    });
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  void _showToast(String _msg) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        duration: Duration(seconds: 2),
        content: ListTile(leading: Icon(Icons.file_download), title: Text(_msg, style: TextStyle(fontSize: 15.0)), trailing: CircularProgressIndicator())
      ),
    );
  }
}
