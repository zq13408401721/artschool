import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yhschool/BaseState.dart';

class QRViewPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return _QRViewPageState();
  }

}

class _QRViewPageState extends BaseState<QRViewPage>{

  final GlobalKey qrKey = GlobalKey(debugLabel: "QR");
  //QRViewController _controller;
  //Barcode _result;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  void dispose() {
   // _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    var scanArea = (MediaQuery.of(context).size.width < 400 || MediaQuery.of(context).size.height < 400) ? 200.0 : 300;

    return Scaffold(
      body: SafeArea(
        child: Container()/*QRView(
          key: qrKey,
          onQRViewCreated: _onQRViewCreated,
          overlay: QrScannerOverlayShape(
            borderColor: Colors.red,
            borderRadius: 10,
            borderLength: 30,
            borderWidth: 10,
            cutOutSize: scanArea
          ),
        ),*/
      ),
    );
  }
}