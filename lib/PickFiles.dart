import 'dart:developer';

import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class PickFiles{

  // first check permission
  Future<bool> PermissionCheck() async{
    try{

      var check =await Permission.photos.status;
      if(check.isGranted){
        return true;
      }else{
        return false;
      }
    }catch(e){
      throw Exception("Exception in checkPermission : ${e.toString()}");
    }
  }

  Future<XFile?> pickFiles() async{
    try{
      log("inside pickFile function : ");
      bool check = await PermissionCheck();
      if(check){
        log("inside permission check Satisfied :");
        XFile? file  = await ImagePicker().pickImage(source: ImageSource.gallery);
        log(" inside file  : ${file!.path}");
        if(file!= null){
          log("file is notnull : ${file}");
          return file;
        }else{
          return null;
        }
      }else{
        await Permission.photos.request();

        log("permission check is false : ");
      }
    }catch(e){
      throw Exception("Exception in pickFiles : ${e.toString()}");
    }
  }
}


/**
 * Container(
    color: Colors.grey[200],
    // height: MediaQuery.of(context).size.height,
    child: Container(
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height/1.5,

    margin: EdgeInsets.all(10),
    decoration: BoxDecoration(
    // color: Colors.white54,
    image: DecorationImage(image:  AssetImage('lib/secondframe.jpg'),fit: BoxFit.cover),
    borderRadius: BorderRadius.circular(12)
    ),
    child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
    GestureDetector(
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
    decoration: BoxDecoration(
    border: Border.all(color: Colors.green.shade50,width: 1)
    ),
    margin: EdgeInsets.all(5),
    // color: Colors.white60,
    // height: MediaQuery.of(context).size.width/1.1,
    width: MediaQuery.of(context).size.width,
    child: image == null ?
    Container(
    alignment: Alignment.center,
    height: 400,
    width: MediaQuery.of(context).size.width,
    child: Stack(
    children: [


    Container(
    // decoration: BoxDecoration(
    //   image: DecorationImage(image: AssetImage('lib/frame.jpg'),fit: BoxFit.cover)
    // ),
    alignment: Alignment.center,
    margin: EdgeInsets.only(top: 50),
    // margin: EdgeInsets.only(top: 215,right: 95),
    child: Column(

    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
    Icon(Icons.image_outlined,size: 30,color: Colors.white,),
    SizedBox(height: 10,),
    Text('Add photo',style: TextStyle(color: Colors.white),)
    ],
    ),
    ),
    ],
    ),
    )
    : GestureDetector(
    onTap: (){
    setState(() {
    showBottomSheet(context,(value){
    setState(() {
    zoomCount = value;
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
    // decoration: BoxDecoration(
    //   image: DecorationImage(image:AssetImage('lib/frame.jpg') ,fit: BoxFit.cover),
    // ),
    // margin: EdgeInsets.only(top: 40),
    // margin: EdgeInsets.only(top: 135,right: 50),
    alignment: Alignment.center,
    // alignment: Alignment.center,
    height: 400,
    width: MediaQuery.of(context).size.width,
    child: Stack(alignment: AlignmentDirectional.center,
    children: [


    // Container(
    //   width: 400,
    //   color: Colors.transparent,
    //   child: Image(image: AssetImage('lib/flowerFrame.png')),
    // )
    // Container(
    //   width: 400,
    //   color: Colors.transparent,
    //   child: Image(image: AssetImage('lib/frame.jpg')),
    // ),
    ClipOval(
    child: ColorFiltered(
    colorFilter:  ColorFilter.matrix(colorFilter[selectedIndex!].filterColor),
    child: Transform.scale(
    scale: zoomCount/100,
    child: FittedBox(
    child: Image.file(File(image!.path),fit: BoxFit.cover,width: 170,height: 170,
    ),
    ),
    ),
    ),
    ),
    ],
    ),
    ) : Container(
    // decoration: BoxDecoration(
    //   image: DecorationImage(image: AssetImage('lib/frame.jpg'),fit: BoxFit.cover)
    // ),
    margin: EdgeInsets.only(top: 40),
    // margin: EdgeInsets.only(top: 135,right: 50),
    alignment: Alignment.center,
    height: 318,
    width: MediaQuery.of(context).size.width,
    child: Stack(
    alignment: AlignmentDirectional.center,
    children: [


    // Container(
    //   width: 400,
    //   color: Colors.transparent,
    //   child: Image(image: AssetImage('lib/frame.jpg')),
    // ),
    ClipOval(

    child: Transform.scale(
    scale: zoomCount/100,
    child: FittedBox(
    fit: BoxFit.cover,
    child: Image.file(File(image!.path),fit: BoxFit.cover,width: 140,height: 135,
    ),
    ),
    ),
    ),

    ],
    // child:
    ),
    )
    ,),
    ),
    ),
    Container(
    // margin: EdgeInsets.only(bottom: 180),
    width: MediaQuery.of(context).size.width/1.4,
    child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
    Text("DANIEL + RACHEL",style: TextStyle(color: Colors.black26),textAlign: TextAlign.center,),
    Text("are pleased to announce their marrieage",style: TextStyle(color: Colors.black26),textAlign: TextAlign.center,),
    Text("august 21 st | 2024 san dieago, ca",style: TextStyle(color: Colors.black26),textAlign: TextAlign.center,)
    ],
    ),
    )
    ],
    ),
    ),
    ),
 */