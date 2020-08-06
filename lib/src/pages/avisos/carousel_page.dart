import 'package:flutter/material.dart';
import 'package:preferencia_usuario_app/src/widgets/slider_image_widget.dart';

class CarouselPage extends StatelessWidget {
  // const CarouselPage({Key key}) : super(key: key);
    static final String routeName = 'carousel-page';

  @override
  Widget build(BuildContext context) {
  final List<String> _imageUrls = ModalRoute.of(context).settings.arguments;

return SafeArea(
  child:   Scaffold(
  
          body: Container(
  
            child: SliderWidget(
  
              imageUrls: _imageUrls,
  
              imageBorderRadius: BorderRadius.circular(8.0),
  
            ),
  
          )
  
          ),
);
  }
}