import 'package:flutter/material.dart';

void main() {
  runApp( MaterialApp(
    home: MyHomePage(),
  ));
}

class MyHomePage extends StatefulWidget {



  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
 double padding = 0.0 ;
 double startpoint = 0.01 ;
 bool drag = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Swipe'),
      ),
      body: Center(

        child: Column(
          children: [
            Row(
              children: [
                SizedBox(width:padding ,),
                GestureDetector(
                  onHorizontalDragStart: (DragStartDetails details){
                    startpoint=details.globalPosition.dx;
                  },
                    onHorizontalDragUpdate: ( DragUpdateDetails details ){
                    if(details.globalPosition.dx-startpoint>=0&&drag){

                      if(details.globalPosition.dx-startpoint>=75){
                        setState(() {
                          padding=0;
                          drag=false;
                        });
                      }else{
                        setState(() {
                          padding=details.globalPosition.dx-startpoint;
                          print(details.globalPosition.dx-startpoint);
                        });
                      }

                    }

                    },

                    onHorizontalDragEnd: (DragEndDetails details){
                    setState(() {
                      padding=0.0;
                      drag=true;
                    });
                    },
                    child: Container(width: 200,height: 70,color: Colors.greenAccent,))
              ],
            )
          ],
        )
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
