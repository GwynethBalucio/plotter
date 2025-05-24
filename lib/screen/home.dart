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
  
  String activeButton = "";
  bool startScribble = false;

  // make new points
  void drawToLayer(String activeButton, LatLng p) {
    switch(activeButton) {
      case "point":
        setState(() {
          displayPoints.add(
            Marker(
              point: p,
              child: Icon(Icons.circle), 
            )
          );
        });
      case "line_point":
        setState(() {
          initLinePoints.add(p);
          displayLinePoints.add(
            Polyline(
              points: initLinePoints,
              color: Colors.black,
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
              color: Colors.black,
              strokeWidth: 12
            )
          );
        });

        if (!startScribble) {
          setState(() {
            initLineScribbles = [];
          });
        }
      default:
        () {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(13.236999392306378, 123.77731740414964), // initial center at the Town Hall
          initialZoom: 12.5,
          interactionOptions: InteractionOptions(
            flags: ~InteractiveFlag.doubleTapZoom
          ),
          onTap: (_, p) {
            drawToLayer(activeButton, p);
          },
          onPointerDown: (_, p) {
            if (activeButton == "line_scribble") {
              setState(() {
                startScribble = !startScribble;
              });
            }
          },
          onPointerHover: (_, p) {
            if (activeButton == "line_scribble" && startScribble) {
              drawToLayer(activeButton, p);
            }
          }
        ),

        children: [
          TileLayer( // Layer for displaying map tiles
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png', // OSMF's Tile Server
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

          RichAttributionWidget(
          attributions: [
            TextSourceAttribution(
              'OpenStreetMap contributors',
              onTap: () => launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OverflowBar(
            spacing: 8,
            overflowAlignment: OverflowBarAlignment.center,
            children: [
              IconButton.filled(
                onPressed: () {
                  setState(() {
                    if (activeButton != "point") {
                      activeButton = "point";
                    } else {
                      activeButton = "";
                    }
                  });
                }, 
                icon: Icon(size: 45, Icons.control_point)),
              IconButton.filled(
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
                icon: Icon(size: 45, Icons.timeline)),
              IconButton.filled(
                onPressed: () {
                  setState(() {
                    if (activeButton != "line_scribble") {
                      activeButton = "line_scribble";
                    } else {
                      initLinePoints = [];
                      activeButton = "";
                    }
                  });
                }, icon: Icon(size: 45, Icons.draw))
            ]
          )
        ],
        
      )
    
    );
  }
}
