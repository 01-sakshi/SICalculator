import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Simple Interest Calculator App",
    home: SIForm(),
    theme: ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.deepPurple,
      accentColor: Colors.deepPurpleAccent,
    ),
  ));
}

class SIForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SIFormState();
  }
}

class _SIFormState extends State<SIForm> {
  var _formkey =
      GlobalKey<FormState>(); //this key is used to identify Form instance
  var _currencies = ['Rupees', 'Dollars', 'Pounds', 'Others'];
  final _minimumpadding = 5.0; //setting a constant padding value
  var _currentitemselected = '';

  @override
  void initState() {
    super.initState();
    _currentitemselected = _currencies[0];
  }

  var _displayResult = '';

  //TextEditingController is used to extract values from TextFields
  TextEditingController principalcontroller = TextEditingController();
  TextEditingController roicontroller = TextEditingController();
  TextEditingController termcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    TextStyle textstyle =
        Theme.of(context).textTheme.subtitle; //it considers the nearest theme
    return Scaffold(
      //resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("Simple Interest Calculator"),
      ),
      body: Form(
        key: _formkey,
        child: Padding(
            padding: EdgeInsets.all(_minimumpadding),
            //Form doesnt contain margin
            //margin: EdgeInsets.all(_minimumpadding),
            child: ListView(
              //Listview is used instead of Column so that all
              // widgets are visible on even a small screen
              children: <Widget>[
                getImageAsset(),
                Padding(
                    padding: EdgeInsets.only(
                        top: _minimumpadding, bottom: _minimumpadding),
                    child: TextFormField(
                      //instead of TextField,use TextFormField
                      style: textstyle,
                      controller: principalcontroller,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Please enter Principal amount';
                        }
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: "Principal",
                          labelStyle: textstyle,
                          errorStyle: TextStyle(
                            fontSize: 15.0
                          ),
                          hintText: "Enter Principal e.g 12000",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    )),
                Padding(
                    padding: EdgeInsets.only(
                        top: _minimumpadding, bottom: _minimumpadding),
                    child: TextFormField(
                      style: textstyle,
                      controller: roicontroller,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Please enter Rate';
                        }
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: "Rate of Interest",
                          labelStyle: textstyle,
                          hintText: "Enter Rate in %",
                          errorStyle: TextStyle(
                              fontSize: 15.0
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    )),
                Padding(
                    padding: EdgeInsets.only(
                        top: _minimumpadding, bottom: _minimumpadding),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: TextFormField(
                          style: textstyle,
                          controller: termcontroller,
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return 'Please enter Term';
                                }
                              },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              labelText: "Term",
                              labelStyle: textstyle,
                              hintText: "Time in years",
                              errorStyle: TextStyle(
                                  fontSize: 15.0
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0))),
                        )),
                        Container(
                          //to add space between textfield and drop down
                          width: _minimumpadding * 5,
                        ),
                        Expanded(
                            child: DropdownButton<String>(
                          items: _currencies.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          value: _currentitemselected,
                          onChanged: (String newValueSelected) {
                            //Your code to execute when a menu item is selected from dropdown
                            _onDropDownItemSelected(newValueSelected);
                          },
                        ))
                      ],
                    )),
                Padding(
                    padding: EdgeInsets.only(
                        top: _minimumpadding, bottom: _minimumpadding),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: RaisedButton(
                                color: Theme.of(context).accentColor,
                                textColor: Theme.of(context).primaryColorDark,
                                child: Text(
                                  "Calculate",
                                  textScaleFactor: 1.1,
                                ),
                                onPressed: () {
                                  setState(() {
                                    if (_formkey.currentState.validate()) {
                                      _displayResult = _calculateTotalReturns();
                                    }
                                  });
                                })),
                        Expanded(
                            child: RaisedButton(
                                color: Theme.of(context).primaryColorDark,
                                textColor: Theme.of(context).primaryColorLight,
                                child: Text(
                                  "Reset",
                                  textScaleFactor: 1.1,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _reset();
                                  });
                                }))
                      ],
                    )),
                Padding(
                    padding: EdgeInsets.all(_minimumpadding * 2),
                    child: Text(
                      this._displayResult,
                      style: textstyle,
                    ))
              ],
            )),
      ),
    );
  }

  Widget getImageAsset() {
    AssetImage assetimage = AssetImage('images/cash.png');
    Image image = Image(image: assetimage, width: 125.0, height: 125.0);
    return Container(
      child: image,
      margin: EdgeInsets.all(_minimumpadding * 7),
    ); //wrapping image into a container
  }

  void _onDropDownItemSelected(String newValueSelected) {
    setState(() {
      this._currentitemselected = newValueSelected;
    });
  }

  String _calculateTotalReturns() {
    double principal = double.parse(principalcontroller.text);
    double rate = double.parse(roicontroller.text);
    double term = double.parse(termcontroller.text);
    double totalamountpayable = principal + (principal * rate * term) / 100;
    String result = "After $term years ,your investment will be"
        " worth $totalamountpayable $_currentitemselected";
    return result;
  }

  void _reset() {
    principalcontroller.text = '';
    roicontroller.text = '';
    termcontroller.text = '';
    _displayResult = '';
    _currentitemselected = _currencies[0];
  }
}
