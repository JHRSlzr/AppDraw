import 'package:app_draw/gallery.dart';
import 'package:app_draw/upload.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';

const AppBarColor = const Color(0xFF35225C);
const MenuSideBar = const Color(0xFF35225C);
const IconColor = const Color(0xff8353E1);
const ToolBarColor = const Color(0xCC5510DB);
  List<DrawingArea> points = [];
  double brushWidth=0;
      String imageUrl;
    Color selectedColor;
      GlobalKey globalKey = GlobalKey();
    
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(MyApp());
}
// void main() => runApp(MyApp());
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    

    return MaterialApp(
      title: 'APP DIBUJO',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppBarColor,
        scaffoldBackgroundColor: Colors.white
      ),
      home: MyHomePage(),
    );
  }
}

class DrawingArea {
  Offset point;
  Paint areaPaint;

  DrawingArea({this.point, this.areaPaint});
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void changeColor(Color color) => this.setState(() => selectedColor = color);
  void changeWidth(double value) => this.setState(() => brushWidth = value);
   @override
  void initState() {
    super.initState();
    selectedColor = Colors.black;
    brushWidth=20;
  }
  @override
  Widget build(BuildContext context) {
double bwidth = MediaQuery.of(context).size.width;
double bheight = MediaQuery.of(context).size.height;
        void selectColor() {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            titlePadding: const EdgeInsets.all(0.0),
                            contentPadding: const EdgeInsets.all(0.0),
                            content: SingleChildScrollView(
                              child: ColorPicker(
                                pickerColor: selectedColor,
                                onColorChanged: changeColor,
                                colorPickerWidth: 300.0,
                                pickerAreaHeightPercent: 0.7,
                                enableAlpha: true,
                                displayThumbColor: true,
                                showLabel: true,
                                paletteType: PaletteType.hsv,
                                pickerAreaBorderRadius: const BorderRadius.only(
                                  topLeft: const Radius.circular(2.0),
                                  topRight: const Radius.circular(2.0),
                                ),
                              ),
                            ),
                          );
                        },
                      );
    }
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Text('WHITEBOARD'),
         actions: <Widget>[
    IconButton(
      icon: Icon(
        Icons.west_rounded,
        color: Colors.white,
      ),
      onPressed: () {
        this.setState(() {
          if(points.length>10)
          {
            points = new List.from(points)..removeRange(points.length-10, points.length);
          }else if(points.length>0){
            points = new List.from(points)..removeLast();
          }
        });
      },
    )
  ],
      ),
      body: Stack(
  children: <Widget>[
    Container(
                    child: new GestureDetector(

          onPanUpdate: (DragUpdateDetails details) {
            setState(() {
              DrawingArea punto = new DrawingArea(
                              point: details.localPosition,
                              areaPaint: Paint()
                                ..strokeCap = StrokeCap.round
                                ..isAntiAlias = true
                                ..color = selectedColor
                                ..strokeWidth = brushWidth);
             points = new List.from(points)..add(punto);
            });
          },
          onPanEnd: (DragEndDetails details) => points.add(null),
          child: RepaintBoundary(
        key: globalKey,
        child: Stack (
        children:<Widget>[           Container(
            color: Colors.white,
            width: bwidth,
            height: bheight,
          ),
          CustomPaint(
            painter: Signature(points: points),
            size: Size.infinite,
          )])
          )
        ),
        ///////////////////////////////////////////////////////////////////////////////////////////////
      ),
    Positioned.fill(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
      width: 300,
      height: 50,
                  decoration: BoxDecoration(
                      color: ToolBarColor, borderRadius: BorderRadius.all(Radius.circular(20.0))),
      child:Row(
  mainAxisAlignment: MainAxisAlignment.spaceAround,
  children: <Widget>[
                      IconButton(
                          icon: Icon(
                            Icons.palette,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            selectColor();
                          }),
                          SliderTheme(
  data: SliderTheme.of(context).copyWith(
    activeTrackColor: Colors.green,
    valueIndicatorColor: Colors.green,
    inactiveTrackColor: Colors.black,
    thumbColor: Colors.white,
    showValueIndicator: ShowValueIndicator.always,
    overlayColor: Colors.white.withAlpha(32),
    overlayShape: RoundSliderOverlayShape(overlayRadius: 14.0),
  ),
  child: Slider(
      value: brushWidth,
      min: 1,
      max: 50,
      divisions: 50,
      onChanged: (value) {
        setState(() {
          brushWidth = value;
        });
      },
            label: brushWidth.toString()
      ),
),
                      IconButton(
                          icon: Icon(
                            Icons.blur_circular,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            selectedColor=Colors.white;
                          })
  ],
)
    ),
    ),
    )
  ],
)
///////////////////////////////////////////////////////////////////////////////////////////////////////
    );
  }
}

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: MenuSideBar,
        child:ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
          margin: new EdgeInsets.symmetric(vertical: 25.0),
          child: Text(
              'MENÚ',
              style: TextStyle(color: Colors.white, fontSize: 25,),
            ),
          ),
              ListTileTheme(
                textColor: Colors.white,
                iconColor: IconColor,
      child:  ListTile(
            leading: Icon(Icons.collections),
            title: Text('GALERÍA'),
            onTap: () => {
                Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => ImagePage()),
  )
            },
          ),
      ),
      
              ListTileTheme(
                textColor: Colors.white,
                iconColor: IconColor,
      child:  ListTile(
            leading: Icon(Icons.drive_folder_upload_rounded),
            title: Text('SUBIR DIBUJO'),
            onTap: () => {
                Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => AddImage()),
  )
            },
          ),
      ),
                    ListTileTheme(
                textColor: Colors.white,
                iconColor: IconColor,
      child:  ListTile(
            leading: Icon(Icons.save_alt),
            title: Text('GUARDAR EN DISPOSITIVO'),
            onTap: () => {
      _save()

            },
          ),
      ),
                    ListTileTheme(
                textColor: Colors.white,
                iconColor: IconColor,
      child:  ListTile(
            leading: Icon(Icons.delete_forever),
            title: Text('BORRAR TODO'),
            onTap: () => {
              points.clear()
            },
          ),
      ),
        ],
      ),)
    );
  }
}
class Signature extends CustomPainter {
  List<DrawingArea> points;

  Signature({this.points});

  @override
  void paint(Canvas canvas, Size size) {

    for (int x = 0; x < points.length - 1; x++) {
      if (points[x] != null && points[x + 1] != null) {
        canvas.drawLine(points[x].point, points[x + 1].point, points[x].areaPaint);
      } else if (points[x] != null && points[x + 1] == null) {
        canvas.drawPoints(PointMode.points, [points[x].point], points[x].areaPaint);
      }
    }
  }
  @override
  bool shouldRepaint(Signature oldDelegate) => oldDelegate.points != points;
}

   uploadImage() async {
    final _storage = FirebaseStorage.instance;
    final _picker = ImagePicker();
    PickedFile image;


    //Check Permissions
    await Permission.photos.request();

    var permissionStatus = await Permission.photos.status;

    if (permissionStatus.isGranted){
      //Select Image
      image = await _picker.getImage(source: ImageSource.gallery);
      var file = File(image.path);

      if (image != null){
        //Upload to Firebase
        var snapshot = await _storage.ref()
        .child('folderName/imageName')
        .putFile(file)
        .onError((error, stackTrace) => null);

        var downloadUrl = await snapshot.ref.getDownloadURL();

          imageUrl = downloadUrl;
      } else {
        print('No Path Received');
      }

    } else {
      print('Grant Permissions and try again');
    }    
  }

  Future<void> _save() async {
  RenderRepaintBoundary boundary =
      globalKey.currentContext.findRenderObject();
  ui.Image image = await boundary.toImage();
  ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  Uint8List pngBytes = byteData.buffer.asUint8List();

  //Request permissions if not already granted
  if (!(await Permission.storage.status.isGranted))
    await Permission.storage.request();

  final result = await ImageGallerySaver.saveImage(
      Uint8List.fromList(pngBytes),
      quality: 60,
      name: "canvas_image");
  print(result);
}