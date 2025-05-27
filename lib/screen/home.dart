import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';


class PlotterPage extends StatefulWidget {
  const PlotterPage({super.key, required this.title});

  final String title;

  @override
  State<PlotterPage> createState() => _PlotterPage();
}

class _PlotterPage extends State<PlotterPage> {

  // temporary placement TODO: separate them into a new class or file
  List<Marker> displayPoints = [];

  List<LatLng> initLinePoints = [];
  List<Polyline> displayLinePoints = [];

  List<LatLng> initLineScribbles = [];
  List<Polyline> displayLineScribbles = [];

  List<LatLng> initPolygon = [];
  List<Polygon> displayPolygons = [];

  String activeButton = "";
  String tileServer = "openstreetmaps"; // or maptiler
  bool isScribbling = false;

  // make new points
  void drawToLayer(String activeButton, LatLng p) {
    switch(activeButton) {
      case "point":
        setState(() {
          displayPoints.add(
            Marker(
              point: p,
              child: Icon(Icons.circle, color: Colors.white), 
            )
          );
        });
      case "line_point":
        setState(() {
          initLinePoints.add(p);
          displayLinePoints.add(
            Polyline(
              points: initLinePoints,
              color: Colors.white,
              strokeWidth: 12
            )
          );
        });
      case "line_scribble":
        setState(() {
          initLineScribbles.add(p);
          displayLineScribbles.add(
            Polyline(
              points: initLineScribbles,
              color: Colors.white,
              strokeWidth: 12
            )
          );
        });

        if (!isScribbling) {
          setState(() {
            initLineScribbles = [];
          });
        }
      case "polygon":
        setState(() {
          initPolygon.add(p);
          displayPolygons.add(
            Polygon(
              points: initPolygon,
              borderColor: Colors.white,
              borderStrokeWidth: 12
            )
          );
        });

      default:
        () {};
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(widget.title, style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(13.236999392306378, 123.77731740414964), // initial center at the Town Hall
          initialZoom: 15,
          interactionOptions: InteractionOptions(
            flags: ~InteractiveFlag.doubleTapZoom
          ),
          onTap: (_, p) {
            drawToLayer(activeButton, p);
          },
          onPointerDown: (_, p) {
            if (activeButton == "line_scribble") {
              setState(() {
                isScribbling = !isScribbling;
              });
            }
          },
          onPointerHover: (_, p) {
            if (activeButton == "line_scribble" && isScribbling) {
              drawToLayer(activeButton, p);
            }
          }
        ),

        children: [
          TileLayer( // Layer for displaying map tiles
            urlTemplate: (tileServer == "openstreetmaps") ? 'https://tile.openstreetmap.org/{z}/{x}/{y}.png' : 'https://api.maptiler.com/maps/satellite/256/{z}/{x}/{y}.jpg?key=1t5SvydPFIjH2v7LB8Jd', // OSMF's Tile Server
            userAgentPackageName: 'com.example.app',
            maxNativeZoom: 19,
          ),

          MarkerLayer(markers: displayPoints),

          PolylineLayer(
            polylines: displayLinePoints,
            polylineCulling: true,
          ),

          PolylineLayer(
            polylines: displayLineScribbles,
            polylineCulling: true,
          ),

          PolygonLayer(
            polygons: displayPolygons,
            polygonCulling: true
          ),

          RichAttributionWidget(
            attributions: [
              TextSourceAttribution(
              'OpenStreetMap Contributors',
              onTap: () => launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
              ),
              TextSourceAttribution(
                'MapTiler Contributors',
                onTap: () => launchUrl(Uri.parse('https://www.maptiler.com/')),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
              boxShadow: List.filled(1, BoxShadow(color: const Color.fromARGB(115, 28, 77, 62) , blurRadius: 2, spreadRadius: 2, offset: Offset(0, 5)))
            ),
            padding: EdgeInsets.all(10),
            child: OverflowBar(
              spacing: 8,
              overflowAlignment: OverflowBarAlignment.center,
              children: [
                // TODO: create a class for every iconbutton
                IconButton.filled(
                  style: ButtonStyle( 
                    backgroundColor:  (activeButton == "point") ? WidgetStateProperty.all(Colors.greenAccent[100]) : WidgetStateProperty.all(Colors.white)
                  ),
                  color: (activeButton == "point") ? Colors.green[800] : Colors.green,
                  onPressed: () {
                    setState(() {
                      if (activeButton != "point") {
                        activeButton = "point";
                      } else {
                        activeButton = "";
                      }
                    });
                  }, 
                  icon: Icon(
                    size: 45, 
                    Icons.control_point
                  )
                ),
                IconButton.filled(
                  style: ButtonStyle( 
                    backgroundColor:  (activeButton == "line_point") ? WidgetStateProperty.all(Colors.greenAccent[100]) : WidgetStateProperty.all(Colors.white)
                  ),
                  color: (activeButton == "line_point") ? Colors.green[800] : Colors.green,
                  onPressed: () {
                    setState(() {
                      if (activeButton != "line_point") {
                        activeButton = "line_point";
                      } else {
                        initLinePoints = [];
                        activeButton = "";
                      }
                    });
                  }, 
                  icon: Icon(size: 45, Icons.timeline)
                ),
                IconButton.filled(
                  style: ButtonStyle( 
                    backgroundColor:  (activeButton == "line_scribble") ? WidgetStateProperty.all(Colors.greenAccent[100]) : WidgetStateProperty.all(Colors.white)
                  ),
                  color: (activeButton == "line_scribble") ? Colors.green[800] : Colors.green,
                  onPressed: () {
                    setState(() {
                      if (activeButton != "line_scribble") {
                        activeButton = "line_scribble";
                      } else {
                        initLinePoints = [];
                        activeButton = "";
                      }
                    });
                  }, icon: Icon(size: 45, Icons.draw)
                ),
                IconButton.filled(
                  style: ButtonStyle( 
                    backgroundColor:  (activeButton == "polygon") ? WidgetStateProperty.all(Colors.greenAccent[100]) : WidgetStateProperty.all(Colors.white)
                  ),
                  color: (activeButton == "polygon") ? Colors.green[800] : Colors.green,
                  onPressed: () {
                    setState(() {
                      if (activeButton != "polygon") {
                        activeButton = "polygon";
                      } else {
                        initPolygon = [];
                        activeButton = "";
                      }
                    });
                  }, icon: Icon(size: 45, Icons.square_outlined)
                ),
                IconButton.filled(
                  style: ButtonStyle( 
                    backgroundColor:  (tileServer == "maptiler") ? WidgetStateProperty.all(Colors.greenAccent[100]) : WidgetStateProperty.all(Colors.white)
                  ),
                  color: (tileServer == "maptiler") ? Colors.green[800] : Colors.green,
                  onPressed: () {
                    setState(() {
                      if (tileServer != "maptiler") {
                        tileServer = "maptiler";
                      } else {
                        tileServer = "openstreetmaps";
                      }
                    });
                  }, 
                  icon: Icon(
                    size: 45, 
                    (tileServer == "openstreetmaps") ? Icons.layers_outlined : Icons.layers)
                ),
              ]
            )
          )
        ],
      )
    );
  }
}
