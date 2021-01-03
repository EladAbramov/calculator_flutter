import 'package:flutter/material.dart';

class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String initialVal = '';
  List<String> buttons = [ 'AC', '', '%', '/', '7', '8', '9', 'x', '4', '5', '6', '-', '1', '2', '3', '+', '0', '.', 'S', '=' ];
  String operation = '';
  String valAfterOperation = '';
  String finalResult='';

  uploadResultJsonToFS(){

  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Calculator', style: TextStyle(color: Colors.white70,)),),
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
                            fontSize: 64,
                            fontWeight: FontWeight.w700
                        ),
                      ),
                      Text(
                        operation=='' ? '' : operation,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 64,
                            fontWeight: FontWeight.w700
                        ),
                      ),
                      Text(
                        valAfterOperation=='' ? '' : valAfterOperation,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 64,
                            fontWeight: FontWeight.w700
                        ),
                      ),
                    ],
                  ),
              ),
            ),
            Container(
              width: 400,
              color: Colors.blue[200],
              child: Text(
                finalResult=='' ? '' : finalResult,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.w700,
                    color: Colors.brown
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
          buildButton(buttons[18]),
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
              print(initialVal);
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
                initialVal = initialVal.substring(0, initialValLength - 1);
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
          if(button=='S'){
            setState(() {
              uploadResultJsonToFS();
            });
          }

        },
        child: Container(
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.deepOrange[100]
          ),
          child: Center(
            child: Text(button, style: TextStyle(fontSize: 28, color: Colors.deepOrangeAccent),),
          ),
        ),
      ),
    );
  }

}
