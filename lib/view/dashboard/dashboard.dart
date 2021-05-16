import 'package:expen_bee/constants/app_colors.dart';
import 'package:expen_bee/constants/constants.dart';
import 'package:expen_bee/model/customer.dart';
import 'package:expen_bee/model/expense.dart';
import 'package:expen_bee/view/login/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:expen_bee/service/customer_service.dart';
import 'package:expen_bee/utils.dart';
import 'package:expen_bee/view/dashboard/add_expense.dart';
import 'package:expen_bee/view/dashboard/expense_list.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Customer customer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackBackground,
      body: SafeArea(
        child: StreamBuilder<Customer>(
          stream: CustomerService().getCustomerStream(),
          builder: (context, snapshot){
            if(snapshot.connectionState == ConnectionState.none || snapshot.connectionState == ConnectionState.waiting){
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            customer = snapshot.data;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: getUserDetails(),
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  getRecentExpenses(),
                  SizedBox(
                    height: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, bottom: 40.0),
                    child: Text(
                      "All Expenses",
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 24,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  getExpensesCategory(),
                ],
              ),
            );
          },
        ),
      ),
      endDrawer: Drawer(
          child: Container(
        color: AppColors.blackBackground,
        child: ListView(
          children: [
            Container(
              height: 100,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(gradient: AppColors.appGradient),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  "Settings",
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 1,
              color: Colors.white24,
            ),
            InkWell(
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                    (route) => false);
              },
              child: Container(
                height: 50,
                color: Colors.black,
                padding: EdgeInsets.only(left: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Text(
                        "Logout",
                        style: TextStyle(
                          color: AppColors.white,
                        ),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Icon(
                        Icons.logout,
                        color: AppColors.white,
                        size: 12,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: 1,
              color: Colors.white24,
            ),
          ],
        ),
      )),
      floatingActionButton: FloatingActionButton(
              backgroundColor: AppColors.appColor,
              elevation: 5.0,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddExpense(customer: customer,)));
              },
              child: Center(
                child: Icon(Icons.add),
              ),
            ),
    );
  }

  Widget getUserDetails() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hello, User",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 3,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              "Your daily expenses partner",
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
        Builder(
          builder: (context) {
            return InkWell(
              onTap: () {
                Scaffold.of(context).openEndDrawer();
              },
              child: Container(
                height: Constants.ctaButtonHeight,
                width: Constants.ctaButtonHeight,
                decoration: BoxDecoration(
                  color: Colors.indigo,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget getRecentExpenses() {
    return Container(
      height: 200,
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              "Expenses Overview",
              style: TextStyle(
                color: AppColors.white,
                fontSize: 24,
                letterSpacing: 1.5,
              ),
            ),
          ),
          SizedBox(
            height: 12,
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: customer.expenses.length,
              itemBuilder: (BuildContext context, int index) {
                double today = 0, total = 0;
                customer.expenses[index].list.forEach((ExpenseItem element) {
                  total = total + element.value;
                  if (isToday(element.time)) {
                    today = today + element.value;
                  }
                });
                return Row(
                  children: [
                    SizedBox(
                      width: index == 0 ? 40 : 0,
                    ),
                    Container(
                      height: 140,
                      width: MediaQuery.of(context).size.width / 1.5,
                      decoration: BoxDecoration(
                        color: Color(int.parse(customer.expenses[index].color)),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              customer.expenses[index].category,
                              style: TextStyle(
                                color: AppColors.white,
                              ),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "$today",
                                        style: TextStyle(
                                          color: AppColors.white,
                                          fontSize: 24,
                                        ),
                                      ),
                                      Text(
                                        "Today",
                                        style: TextStyle(
                                          color: AppColors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 0,
                                  child: Container(
                                    height: 50,
                                    width: 1,
                                    color: AppColors.white,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "$total",
                                        style: TextStyle(
                                          color: AppColors.white,
                                          fontSize: 24,
                                        ),
                                      ),
                                      Text(
                                        "Total",
                                        style: TextStyle(
                                          color: AppColors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 16,
                    )
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget getExpensesCategory() {
    return Column(
      children: List.generate(customer.expenses.length, (index) {
        double total = 0;
        customer.expenses[index].list.forEach((element) {
          total = total + element.value;
        });
        return Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Column(
            children: [
              InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ExpenseList(expense: customer.expenses[index], customer: customer,)));
                },
                child: Container(
                  height: 80,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Color(int.parse(customer.expenses[index].color)),
                        ),
                        child: Center(
                          child: Container(
                            height: 48,
                            width: 48,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: AppColors.blackBackground,
                            ),
                            child: Center(
                              child: Icon(
                                Constants.icons.containsKey(
                                        "${customer.expenses[index].category}")
                                    ? Constants
                                        .icons[customer.expenses[index].category]
                                    : Icons.add_box_outlined,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            customer.expenses[index].category,
                            style: TextStyle(
                              color: AppColors.white,
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            "$total",
                            style: TextStyle(
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
