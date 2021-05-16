
import 'package:expen_bee/constants/app_colors.dart';
import 'package:expen_bee/constants/constants.dart';
import 'package:expen_bee/model/customer.dart';
import 'package:expen_bee/model/expense.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:expen_bee/service/bill_service.dart';

class AddExpense extends StatefulWidget {
  final Customer customer;
  AddExpense({@required this.customer});
  @override
  _AddExpenseState createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  String selectedCategory = "Travel";
  double value = 0.0;
  TextEditingController _value = TextEditingController();
  TextEditingController _remark = TextEditingController();
  TextEditingController _custom = TextEditingController();
  String color;
  bool isUploading = false, isCustom = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackBackground,
      body: Container(
        padding: EdgeInsets.only(left: 28, right: 28),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getAppBar(),
              SizedBox(
                height: 40,
              ),
              Text(
                "Add a bill",
                style: TextStyle(
                    color: AppColors.white, fontSize: 28, letterSpacing: 2.5),
              ),
              SizedBox(
                height: 32,
              ),
              getForm(),
            ],
          ),
        ),
      ),
    );
  }

  Widget getAppBar() {
    return Padding(
      padding: EdgeInsets.only(top: 60),
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Icon(
          Icons.arrow_back_ios,
          color: AppColors.white,
          size: 20,
        ),
      ),
    );
  }

  Widget getForm() {
    return Container(
      padding: EdgeInsets.all(20),
      width: MediaQuery.of(context).size.width,
      color: AppColors.blackBackground,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --------------------- CATEGORY ----------------------
          Text(
            "CATEGORY",
            style: TextStyle(
              color: AppColors.white,
              fontSize: 12,
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Container(
            height: 60,
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                width: 2,
                color: Color(0xff222222),
              ),
            ),
            child: DropdownButton<String>(
              isExpanded: true,
              underline: Container(),
              focusColor: Colors.white,
              value: selectedCategory,
              dropdownColor: Color(0xff101010),
              style: TextStyle(color: Colors.white),
              iconEnabledColor: Colors.white,
              items: [...widget.customer.expenses.map((value) {
                return DropdownMenuItem<String>(
                  value: value.category,
                  child: Text(
                    value.category,
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }).toList(), DropdownMenuItem<String>(
                value: "Custom",
                child: Text(
                  "Custom",
                  style: TextStyle(color: Colors.white),
                ),
              )],
              onChanged: (String value) {
                setState(() {
                  selectedCategory = value;
                  if(value == "Custom"){
                    setState(() {
                      isCustom = true;
                    });
                  }
                  else{
                    setState(() {
                      isCustom = false;
                    });
                  }
                });
              },
            ),
          ),
          SizedBox(
            height: 40,
          ),


          // ------------------------ CUSTOM ---------------------
          isCustom?Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "CUSTOM CATEGORY NAME",
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 12,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                height: 60,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    width: 2,
                    color: Color(0xff222222),
                  ),
                ),
                child: TextField(
                  controller: _custom,
                  keyboardType: TextInputType.text,
                  style: TextStyle(
                    color: AppColors.white,
                  ),
                  cursorColor: AppColors.white,
                  cursorWidth: 1,
                  minLines: 1,
                  maxLines: 4,
                  maxLength: 10,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration.collapsed(),
                ),
              ),
              SizedBox(
                height: 40,
              ),
            ],
          ):SizedBox(),



          // ----------------------------- CHOOSE COLOR -----------------------------

          isCustom?colorChooser():SizedBox(),


          // ----------------------------- AMOUNT --------------------------
          Text(
            "AMOUNT",
            style: TextStyle(
              color: AppColors.white,
              fontSize: 12,
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Container(
            height: 60,
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                width: 2,
                color: Color(0xff222222),
              ),
            ),
            child: Center(
              child: TextField(
                controller: _value,
                keyboardType: TextInputType.number,
                style: TextStyle(
                  color: AppColors.white,
                ),
                cursorColor: AppColors.white,
                cursorWidth: 1,
                decoration: InputDecoration.collapsed(),
                onChanged: (String data) {
                  try {
                    value = double.parse(data);
                  } catch (e) {
                    setState(() {
                      _value = TextEditingController(text: "");
                      value = 0;
                    });
                    Fluttertoast.showToast(msg: "Please enter a valid number");
                  }
                },
              ),
            ),
          ),
          SizedBox(
            height: 40,
          ),

          // -------------------------------- REMARK -------------------------------
          Text(
            "REMARK",
            style: TextStyle(
              color: AppColors.white,
              fontSize: 12,
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Container(
            height: 120,
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                width: 2,
                color: Color(0xff222222),
              ),
            ),
            child: TextField(
              controller: _remark,
              keyboardType: TextInputType.text,
              style: TextStyle(
                color: AppColors.white,
              ),
              cursorColor: AppColors.white,
              cursorWidth: 1,
              minLines: 1,
              maxLines: 4,
              maxLength: 100,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration.collapsed(),
            ),
          ),
          SizedBox(
            height: 60,
          ),

          // ---------------------- SUBMIT --------------------------
          InkWell(
            onTap: ()async{
              if(isUploading) return;
              if(isCustom){
                if( _custom.text.length<=0 || _custom.text.length>10){
                  Fluttertoast.showToast(msg: "Custom category name should not be empty or more than 10 characters");
                  return;
                }
                if(color==null){
                  Fluttertoast.showToast(msg: "Please select a color");
                  return;
                }
              }
              if(value<=0){
                Fluttertoast.showToast(msg: "Please enter an amount");
                return;
              }
              if(_remark.text.length<=0 || _remark.text.length>100){
                Fluttertoast.showToast(msg: "Remark should be not be empty or more than 100 characters");
                return;
              }
              setState(() {
                isUploading = true;
              });

              await BillService().uploadBill(widget.customer, selectedCategory!="Custom"?selectedCategory:_custom.text, ExpenseItem(value: value, remark: _remark.text, time: DateTime.now()), color);
              Navigator.pop(context);
              // setState(() {
              //   isUploading = false;
              // });
            },
            child: Container(
              height: Constants.ctaButtonHeight,
              decoration: BoxDecoration(
                gradient: AppColors.appGradient,
                borderRadius: BorderRadius.circular(28),
              ),
              child: Center(
                child: isUploading
                    ? CircularProgressIndicator()
                    : Text(
                        "Upload Bill",
                        style: TextStyle(
                          color: AppColors.white,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget colorChooser(){
    return Column(
      children: [
        Row(
          children: [
            Text(
              "COLOR",
              style: TextStyle(
                color: AppColors.white,
                fontSize: 12,
              ),
            ),
            SizedBox(
              width: 12,
            ),
            Container(
              height: 16,
              width: 16,
              decoration: BoxDecoration(
                color: color!=null?Color(int.parse(color)):null,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 16,
        ),
        Container(
          height: 24,
          child: Row(
            children: [
              getColoredBox("0xfffd8450"),
              getColoredBox("0xff3816e9"),
              getColoredBox("0xffce8676"),
              getColoredBox("0xff9829ec"),
              getColoredBox("0xff527ea1"),
              getColoredBox("0xfff33119"),
              getColoredBox("0xff5c5c64"),

            ],
          ),
        ),
        SizedBox(
          height: 40,
        ),
      ],
    );
  }

  Widget getColoredBox(String colorCode){
      return Padding(
        padding: const EdgeInsets.only(right: 12.0),
        child: InkWell(
          onTap: (){
            setState(() {
              color = colorCode;
            });
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            height: color==colorCode?24:20,
            width: color==colorCode?24:20,
            decoration: BoxDecoration(
              color: Color(int.parse(colorCode)),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      );
  }
}
