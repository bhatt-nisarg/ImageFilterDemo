import 'dart:developer';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_demo/FilterList.dart';
import 'package:image_demo/FilterModel.dart';
import 'package:image_demo/HexagoneClipper.dart';
import 'package:image_demo/PickFiles.dart';
import 'package:image_picker/image_picker.dart';

class MainScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _MainScreen();
  }

}
class _MainScreen extends State<MainScreen>{
  XFile? image;
  int selection = -1;
  // zoom Count is ration for our count
  double zoomCount = 100;
  double scaleX = 1;
  double scaleY = 1;
  late TransformationController _controller ;
  int? selectedIndex;
   List<FilterModel> colorFilter  = [
    FilterModel(filterColor: [], filterName: "Normal"),
    // FilterModel(filterColor: FilterList.VINTAGE_MATRIX, filterName: "Vintage"),
    FilterModel(filterColor: FilterList.SEPIA_MATRIX, filterName: "Sepia"),
    // FilterModel(filterColor: FilterList.GREYSCALE_MATRIX, filterName: "GreyScale"),
     FilterModel(filterColor: FilterList.blackAndWhiteMatrix, filterName: "B&W"),
     FilterModel(filterColor: FilterList.lomoFilterMatrix, filterName: "Lomo"),
     FilterModel(filterColor: FilterList.oldPhotoFilterMatrix, filterName: "Old"),
    FilterModel(filterColor: FilterList.FILTER_1, filterName: "Filter 1"),
    FilterModel(filterColor: FilterList.FILTER_2, filterName: "Filter 2"),
    FilterModel(filterColor: FilterList.FILTER_3, filterName: "Filter 3")
  ];
  @override
  void initState() {
    print("starting of initState");
    // TODO: implement initState
    super.initState();
    _controller = TransformationController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }
  void showBottomSheet(BuildContext context,Function(double) zoomCallBack,XFile file,Function(int) filterIndex,GestureTapCallback onDelete){

    showModalBottomSheet(
        context: context,
        builder: (con){
          return StatefulBuilder(
            builder: (con,state){
              return Container(
                // height: 500,
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,

                  children: [
                    Container(
                      padding: EdgeInsets.all(5),
                      child: Row(mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: (){
                                  onDelete();
                                  state(() {
                                    selection = -1;
                                  });

                            },
                            child: Icon(Icons.delete_outline,color: Colors.black,size: 20,),
                          ),
                          Container(
                            padding: EdgeInsets.all(5),
                            child: Container(
                              width: 1,
                              color: Colors.grey,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: (){
                                  log("on Tap zoom");

                                  state(() {
                                    selection = 0;
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.all(5),
                                  padding: EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 5),
                                  decoration: BoxDecoration(
                                      color: selection == 0 ? Colors.green.shade50: Colors.white,
                                      borderRadius: BorderRadius.circular(15)
                                  ),
                                  child: Text("Zoom",style: 
                                  TextStyle(color: selection == 0 ? Colors.green : Colors.black ,fontWeight: FontWeight.bold,fontSize: 15),),
                                ),
                              ),
                              GestureDetector(
                                onTap: (){
                                  log("on Tap zoom");

                                  state(() {
                                    selection = 1;
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.all(5),
                                  padding: EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 5),
                                  decoration: BoxDecoration(
                                      color: selection == 1 ? Colors.green.shade50: Colors.white,
                                      borderRadius: BorderRadius.circular(15)
                                  ),
                                  child: Text("Filter",style: TextStyle(color: selection == 1 ? Colors.green : Colors.black ,fontWeight: FontWeight.bold,fontSize: 15),),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    /// selection 0 means zoom
                    selection == 0? Container(

                        child: Column(
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Photo Zoom",style: TextStyle(color: Colors.black,fontSize: 15),),
                                Text(zoomCount.toInt().toString(),style: TextStyle(color: Colors.black,fontSize: 15),)
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Icon(Icons.image_outlined,size: 25,color: Colors.black,),
                                  SliderTheme(
                                    data: SliderTheme.of(context).copyWith(
                                      thumbColor: Colors.green.shade200,
                                      overlayColor: Colors.grey.shade50,
                                      activeTickMarkColor: Colors.green,
                                      inactiveTickMarkColor: Colors.black12,
                                      activeTrackColor: Colors.green,

                                    ),
                                    child: Slider(
                                      min: 100,
                                        max: 250,

                                        value: zoomCount,
                                        onChanged: (change){
                                          state((){
                                            zoomCount = change;
                                            zoomCallBack(change);
                                          });

                                        },),
                                  ),
                                  Icon(Icons.image_outlined,size: 35,),
                                ],
                              ),
                            )

                          ],
                        ),
                    ) : Container(),
                    /// selection 1 means filter
                    selection == 1 ? Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      height: 180,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.all(15),
                        itemCount: colorFilter.length,
                          itemBuilder: (context,i){
                            return GestureDetector(
                              onTap: (){
                                filterIndex(i);
                              },
                              child: Container(
                                margin: EdgeInsets.all(5),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    i == 0 ?   Container(
                                      height: 100,
                                      width: 80,
                                      child: Image.file(File(file.path),),

                                    ):
                                    Container(
                                      height: 100,
                                      width: 80,
                                      child: ColorFiltered(colorFilter: ColorFilter.matrix(colorFilter[i].filterColor),
                                      child: Image.file(File(file.path),)
                                      ),

                                    ),
                                    Text(colorFilter[i].filterName,style: TextStyle(color: Colors.black,fontSize: 10),textAlign: TextAlign.center,)
                                  ],
                                ),
                              ),
                            );
                          }),
                    ):Container()
                  ],
                ),
              );
            },
            // child: ,
          );
        });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Demo Image",),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: MediaQuery.of(context).size.height/1.5,
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(8),
              child: Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height/1.5,
                    width: MediaQuery.of(context).size.width,
                    child: Image(image: AssetImage('lib/secondframe.jpg')),
                  ),
                 Column(
                   mainAxisSize: MainAxisSize.min,
                   children: [
                     image == null ?  GestureDetector(
                       onTap: () async{
                         print("on Tap select Image");
                         // setState(() {
                         image = await PickFiles().pickFiles();
                         // });
                         if(image != null){
                           setState(() {
                             image = image;
                           });
                           setState(() {
                             showBottomSheet(context,(value){
                               setState(() {
                                 zoomCount = value;
                                 _controller.value = Matrix4.identity()..scale(zoomCount/100);
                                 log("zoom count print : ${zoomCount}");
                               });
                             },image!,(filter){
                               setState(() {
                                 if(filter == 0){
                                   selectedIndex = null;
                                 }else {
                                   selectedIndex = filter;
                                 }
                               });

                             },(){
                               setState(() {
                                 image = null;
                                 selectedIndex = null;
                                 zoomCount = 100;
                               });
                               Navigator.pop(context);
                             });
                           });

                         }

                       },
                       child: Container(
                         height: 90,
                         alignment: Alignment.topCenter,
                         margin: EdgeInsets.only(top: 175),
                         child: const Column(
                           mainAxisSize: MainAxisSize.min,
                           mainAxisAlignment: MainAxisAlignment.center,
                           crossAxisAlignment: CrossAxisAlignment.center,
                           children: [
                             Icon(Icons.image_outlined,size: 30,color: Colors.white,),
                             SizedBox(height: 10,),
                             Text('Add Photo',style: TextStyle(color: Colors.white),)
                           ],
                         ),
                       ),
                     ):
                     GestureDetector(
                       onPanUpdate: (details){
                         log("on pan details update : ${details.delta.dx} dy : ${details.delta.dx}");
                       },
                       onTap: (){

                         setState(() {
                           showBottomSheet(context,(value){
                             setState(() {
                               zoomCount = value;
                               _controller.value = Matrix4.identity()..scale(zoomCount/100);

                               log("zoom count print : ${zoomCount}");
                             });
                           },image!,(filter){
                             setState(() {
                               if(filter == 0){
                                 selectedIndex = null;
                               }else {
                                 selectedIndex = filter;
                               }
                             });

                           },(){
                             setState(() {
                               image = null;
                               selectedIndex = null;
                               zoomCount = 100;
                             });
                             Navigator.pop(context);
                           });
                         });

                       },
                       child: selectedIndex != null ? Container(
                         width: MediaQuery.of(context).size.width,
                         margin: EdgeInsets.only(top: 135),
                         alignment: Alignment.topCenter,
                         child: ClipOval(
                           child: ColorFiltered(
                             colorFilter:  ColorFilter.matrix(colorFilter[selectedIndex!].filterColor),
                             child: FittedBox(
                               child: InteractiveViewer(
                                 transformationController: _controller,
                                 child: Image.file(File(image!.path),fit: BoxFit.cover,width: 140,height: 135,
                                 ),
                               ),
                             ),
                           ),
                         ),
                       ) :  Container(
                         margin: EdgeInsets.only(top: 135),
                         width: MediaQuery.of(context).size.width,
                         alignment: Alignment.topCenter,
                         child: ClipOval(

                           child: FittedBox(
                             fit: BoxFit.cover,
                             child: InteractiveViewer(
                               transformationController: _controller,
                               child: Image.file(File(image!.path),fit: BoxFit.cover,width: 140,height: 135,
                               ),
                             ),
                           ),
                         ),
                       ),
                     ),
                     Container(
                       margin: EdgeInsets.only(top: 40),
                       width: MediaQuery.of(context).size.width/1.4,
                       child: Column(
                         mainAxisSize: MainAxisSize.min,
                         children: [
                           Text("DANIEL + RACHEL",style: TextStyle(color: Colors.black26),textAlign: TextAlign.center,),

                           Text("are pleased to announce their marrieage",style: TextStyle(color: Colors.black26),textAlign: TextAlign.center,),
                           // Text("august 21 st | 2024 san dieago, ca",style: TextStyle(color: Colors.black26),textAlign: TextAlign.center,)
                         ],
                       ),
                     )
                   ],
                 )

                ],
              ),
            )
          ],
        ),
      )
    );
  }

}