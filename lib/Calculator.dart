//Author: Elad_Abramov - portfolio website: https://myportfolioelad.herokuapp.com/
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String initialVal = '';
  List<String> buttons = [ 'AC', '', '%', '/', '7', '8', '9', 'x', '4', '5', '6', '-', '1', '2', '3', '+', '0', '.', '^', '=' ];
  String operation = '';
  String valAfterOperation = '';
  String finalResult='';
  UploadTask _upload;
  bool loading;
  bool isOk = false;
  var jsonFileUrl = '';
  final FirebaseStorage _storage = FirebaseStorage.instance;
  File jsonFile;
  Directory dir;
  bool fileExists = false;
  Map<String, dynamic> fileContent;
  String filePath = 'file.json';


  void createFile(Map<String, dynamic> content, Directory dir, String fileName) {
    print("Creating file!");
    File file = new File(dir.path + "/" + fileName);
    file.createSync();
    fileExists = true;
    file.writeAsStringSync(json.encode(content));
  }

  void writeToFile(String key, dynamic value) {
    print("Writing to file!");
    Map<String, dynamic> content = {key: value};
    if (fileExists) {
      print("File exists");
      Map<String, dynamic> jsonFileContent = json.decode(jsonFile.readAsStringSync());
      jsonFileContent.addAll(content);
      jsonFile.writeAsStringSync(json.encode(jsonFileContent));
    } else {
      print("File does not exist!");
      createFile(content, dir, filePath);
    }
    this.setState(() => fileContent = json.decode(jsonFile.readAsStringSync()));
    uploadResultJsonToFS();
    print(fileContent);
  }

  uploadResultJsonToFS(){
    loading = true;
    setState(() {
      _upload = _storage.ref().child(filePath).putFile(jsonFile);
    });

    if(_upload!=null){
      print("Upload finish successfully");
      loading=false;
      isOk=true;
      return AwesomeDialog(
          context: context,
          dialogType: DialogType.SUCCES,
          animType: AnimType.BOTTOMSLIDE,
          title: 'Thanks For The File :)',
          headerAnimationLoop: false,
          desc: '',
          btnOkOnPress: () {
            getJsonUrl();
          }
      ).show();
    }

  }
  getJsonUrl()async {
    Reference rfs = _upload.snapshot.ref;
    return Timer(Duration(seconds: 5), () async {
      jsonFileUrl = await rfs.getDownloadURL();
      print(jsonFileUrl);
    });
  }

  void initState() {
    super.initState();
    getExternalStorageDirectory().then((Directory directory) {
      dir = directory;
      jsonFile = new File(dir.path + "/" + filePath);
      print(jsonFile.path);
      fileExists = jsonFile.existsSync();
      if (fileExists) this.setState(() => fileContent = json.decode(jsonFile.readAsStringSync()));
    });

    setState(() {
      jsonFileUrl = '';
      loading = false;
    });

  }


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Calculator', style: TextStyle(color: Colors.black,)),),
        backgroundColor: Colors.blue[500],
      ),
      body: Container(
        child: Column(
          children: [
            buildResult(),
            buildCalculatorGrid(),
          ],
        ),
      ),

    );
  }

  Widget buildResult() {
    return Expanded(
        flex: 3,
        child: Column(
          children: [
            Container(
              height: 223,
              color: Colors.blue,
              child: Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        initialVal=='' ? '0' : initialVal,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.w700
                        ),
                      ),
                      Text(
                        operation=='' ? '' : operation,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.w700
                        ),
                      ),
                      Text(
                        valAfterOperation=='' ? '' : valAfterOperation,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.w700
                        ),
                      ),
                    ],
                  ),
              ),
            ),
            Container(
              width: 400,
              height: 74,
              color: Colors.blue[600],
              child: Center(
                child: Text(
                  finalResult=='' ? '' : finalResult,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.w700,
                      color: Colors.brown
                  ),
                ),
              ),
            ),
          ],
        ),
    );
  }

  Widget buildCalculatorGrid(){
    return Container(
      height: 420,
      child: GridView.count(
        crossAxisCount:4,
        crossAxisSpacing: 20,
        children: [
          buildOperationButton(buttons[0]),
          buildButtonIcon(),
          buildOperationButton(buttons[2]),
          buildOperationButton(buttons[3]),
          buildButton(buttons[4]),
          buildButton(buttons[5]),
          buildButton(buttons[6]),
          buildOperationButton(buttons[7]),
          buildButton(buttons[8]),
          buildButton(buttons[9]),
          buildButton(buttons[10]),
          buildOperationButton(buttons[11]),
          buildButton(buttons[12]),
          buildButton(buttons[13]),
          buildButton(buttons[14]),
          buildOperationButton(buttons[15]),
          buildButton(buttons[16]),
          buildButton(buttons[17]),
          buildOperationButton(buttons[18]),
          buildOperationButton(buttons[19]),

        ],
      ),
    );
  }

  Widget buildButton(String button){
    return Container(
      padding: EdgeInsets.all(8),
      child: InkResponse(
        onTap: (){
          setState(() {
            if(operation==''){
              initialVal = initialVal + '' + button;
            }
            else{
              valAfterOperation = valAfterOperation + '' + button;
            }

          });
        },
        child: Container(
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black
          ),
          child: Center(
            child: Text(button, style: TextStyle(fontSize: 30, color: Colors.white),),
          ),
        ),
      ),
    );
  }
  Widget buildButtonIcon(){
    return Container(
      padding: EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.deepOrange[100],
        ),
        child: Center(
          child: IconButton(
            color: Colors.deepOrangeAccent,
            onPressed: () {
              setState(() {
                var initialValLength = initialVal.length;
                var valAfterOperationLength = valAfterOperation.length;

                if(initialValLength!=0){
                  initialVal = initialVal.substring(0, initialValLength - 1);
                }
                if(operation.isEmpty){
                  valAfterOperation = valAfterOperation.substring(0, valAfterOperationLength);
                }
                if(initialValLength==0){
                  operation='';
                  valAfterOperation='';
                }
              });
            },
            icon:  Icon(Icons.backspace),
          ),
        ),
      ),
    );
  }

  Widget buildOperationButton(String button){
    return Container(
      padding: EdgeInsets.all(8),
      child: InkResponse(
        onTap: (){
          if(button=='AC'){
            setState(() {
              initialVal='';
              operation='';
              valAfterOperation='';
              finalResult = "0";
            });
          }
          if(button=='+'){
            setState(() {
              if(initialVal!=''){
                operation = "+";
              }
            });
          }
          if(button=="="){
            setState(() {
              if(initialVal!='' && operation!='' && valAfterOperation!=''){
                if(operation=='+'){
                  double tempInitVal = double.parse(initialVal);
                  double tempAfterVal = double.parse(valAfterOperation);
                  double tempResultVal = tempInitVal + tempAfterVal;
                  finalResult = tempResultVal.toString();
                  initialVal = tempResultVal.toString();
                  valAfterOperation = '';
                  operation = '';
                  setState(() {
                    writeToFile("last result", finalResult);
                  });
                }
                else if(operation=='-'){
                  double tempInitVal = double.parse(initialVal);
                  double tempAfterVal = double.parse(valAfterOperation);
                  double tempResultVal = tempInitVal - tempAfterVal;
                  finalResult = tempResultVal.toString();
                  initialVal = tempResultVal.toString();
                  valAfterOperation = '';
                  operation = '';
                }
                else if(operation=='x'){
                  double tempInitVal = double.parse(initialVal);
                  double tempAfterVal = double.parse(valAfterOperation);
                  double tempResultVal = tempInitVal * tempAfterVal;
                  finalResult = tempResultVal.toString();
                  initialVal = tempResultVal.toString();
                  valAfterOperation = '';
                  operation = '';
                }
                else if(operation=='/'){
                  double tempInitVal = double.parse(initialVal);
                  double tempAfterVal = double.parse(valAfterOperation);
                  double tempResultVal = tempInitVal / tempAfterVal;
                  finalResult = tempResultVal.toString();
                  initialVal = tempResultVal.toString();
                  valAfterOperation = '';
                  operation = '';
                }
              }
            });
          }
          if(button=='-'){
            setState(() {
              if (initialVal != '') {
                operation = "-";
              }
            });
          }
          if(button=='x') {
            setState(() {
              if (initialVal != '') {
                operation = "x";
              }
            });
          }
          if(button=='/') {
            setState(() {
              if (initialVal != '') {
                operation = "/";
              }
            });
          }
          if(button=='%') {
            setState(() {
              if (initialVal != '') {
                double tempInitVal = double.parse(initialVal);
                double tempResultVal = (tempInitVal)/100;
                finalResult = tempResultVal.toString();
                initialVal = tempResultVal.toString();
                operation = '';
              }
            });
          }
          if(button=='^'){
            setState(() {
              if (initialVal != '') {
                double tempInitVal = double.parse(initialVal);
                double tempResultVal = (tempInitVal)*(tempInitVal);
                finalResult = tempResultVal.toString();
                initialVal = tempResultVal.toString();
                operation = '';
              }
            });
          }

        },
        child: Container(
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.deepOrange[100]
          ),
          child: Center(
            child: Text(button, style: TextStyle(fontSize: 30, color: Colors.deepOrangeAccent),),
          ),
        ),
      ),
    );
  }

}
