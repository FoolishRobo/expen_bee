import 'package:expen_bee/constants/app_colors.dart';
import 'package:expen_bee/constants/constants.dart';
import 'package:expen_bee/model/customer.dart';
import 'package:expen_bee/model/expense.dart';
import 'package:expen_bee/service/bill_service.dart';
import 'package:expen_bee/utils.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ExpenseList extends StatefulWidget {
  Expense expense;
  Customer customer;
  ExpenseList({this.expense, this.customer});
  @override
  _ExpenseListState createState() => _ExpenseListState();
}

class _ExpenseListState extends State<ExpenseList> {
  double total = 0;
  bool isDeleting = false;
  String deletingId;
  bool isEditing = false;
  String editingId;

  TextEditingController _value;
  TextEditingController _remark;
  double value=0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackBackground,
      body: SingleChildScrollView(
        child: Column(
          children: [
            getAppBar(),
            getTimeLine(),
          ],
        ),
      ),
    );
  }

  Widget getAppBar() {
    total = 0;
    widget.expense.list.forEach((element) {
      total = total + element.value;
    });
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      width: MediaQuery.of(context).size.width,
      color: Color(int.parse(widget.expense.color)),
      padding: EdgeInsets.only(top: 60, left: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.arrow_back_ios,
            color: AppColors.white,
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: AppColors.blackBackground,
                ),
                child: Center(
                  child: Icon(
                    Constants.icons.containsKey("${widget.expense.category}")
                        ? Constants.icons[widget.expense.category]
                        : Icons.add_box_outlined,
                    color: AppColors.white,
                  ),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                "${widget.expense.category}",
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 28,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Rs. $total",
            style: TextStyle(
              color: AppColors.white,
              fontSize: 28,
              letterSpacing: 2,
            ),
          )
        ],
      ),
    );
  }

  Widget getTimeLine() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Transactions",
            style: TextStyle(
              color: AppColors.white,
              fontSize: 28,
            ),
          ),
          widget.expense.list.length > 0
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    getStraightLine(40),
                    getTransactions(),
                  ],
                )
              : Container(
                  padding: EdgeInsets.only(top: 60),
                  child: Center(
                    child: Text(
                      "No Transaction Available!",
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget getTransactions() {
    widget.expense.list.sort((a, b) => a.time.compareTo(b.time));
    return Column(
      children: List.generate(
        widget.expense.list.length,
        (index) {
          int day = widget.expense.list[index].time.day;
          int month = widget.expense.list[index].time.month;
          int hr = widget.expense.list[index].time.hour;
          int min = widget.expense.list[index].time.minute;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(12),
                width: MediaQuery.of(context).size.width - 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Color(int.parse(widget.expense.color)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              "${day}th ${intToMonth(month)},",
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              "$hr:$min",
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                if (isEditing) return;
                                setState(() {
                                  isEditing = true;
                                  editingId = widget.expense.list[index].id;
                                });
                                _value = TextEditingController(text: "${widget.expense.list[index].value}");
                                _remark = TextEditingController(text: "${widget.expense.list[index].remark}");
                                value= widget.expense.list[index].value;
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    backgroundColor: AppColors.blackBackground,
                                    title: Text(
                                      'Edit your bill',
                                      style: TextStyle(
                                        color: AppColors.white,
                                      ),
                                    ),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          children: [
                                            Text(
                                              "Amount",
                                              style: TextStyle(
                                                color: AppColors.white,
                                              ),
                                            ),
                                            SizedBox(width: 12,),
                                            Container(
                                              height: 50,
                                              width: 80,
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
                                          ],
                                        ),
                                        SizedBox(height: 12,),
                                        Row(
                                          children: [
                                            Text(
                                              "Remark",
                                              style: TextStyle(
                                                color: AppColors.white,
                                              ),
                                            ),
                                            SizedBox(width: 12,),
                                            Container(
                                              height: 80,
                                              width: 140,
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
                                          ],
                                        ),
                                      ],
                                    ),
                                    actions: <Widget>[
                                      FlatButton(
                                        onPressed: ()async{
                                          if(value<=0 || _remark.text.length<=0 || _remark.text.length>100){
                                            Fluttertoast.showToast(msg: "Value can not be less than 1 and remark should be between 1-100 characters long");
                                            return;
                                          }
                                          await BillService().editBill(widget.customer, widget.expense.category, ExpenseItem(id: widget.expense.list[index].id, remark: _remark.text, value: value, time: widget.expense.list[index].time));
                                          Navigator.of(context).pop();
                                        },
                                        textColor:
                                            Theme.of(context).primaryColor,
                                        child: Text('Upload'),
                                      ),
                                    ],
                                  ),
                                );
                                setState(() {
                                  isEditing = false;
                                  // editingId = null;
                                });
                              },
                              child: Icon(
                                Icons.edit_outlined,
                                color: AppColors.white,
                                size: 16,
                              ),
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            InkWell(
                              onTap: () async {
                                if (isDeleting) return;
                                setState(() {
                                  isDeleting = true;
                                  deletingId = widget.expense.list[index].id;
                                });
                                await BillService().deleteBill(
                                    widget.customer,
                                    widget.expense.category,
                                    widget.expense.list[index].id);
                                setState(() {
                                  isDeleting = false;
                                  deletingId = null;
                                });
                              },
                              child: isDeleting &&
                                      deletingId ==
                                          widget.expense.list[index].id
                                  ? SizedBox(
                                      height: 12,
                                      width: 12,
                                      child: CircularProgressIndicator(),
                                    )
                                  : Icon(
                                      Icons.delete_outline_outlined,
                                      color: AppColors.white,
                                      size: 16,
                                    ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      "Amount:  Rs. ${widget.expense.list[index].value}",
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      "Remark:  ${widget.expense.list[index].remark}",
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              index != widget.expense.list.length - 1
                  ? getStraightLine(40)
                  : SizedBox(),
            ],
          );
        },
      ),
    );
  }

  Widget getStraightLine(double height) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: Container(
        height: height,
        width: 2,
        color: Color(int.parse(widget.expense.color)),
      ),
    );
  }
}
