import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'Widget/save_btn.dart';
import 'employee.dart';
import 'dart:async';
import 'db_helper.dart';

class DBTestPage extends StatefulWidget {
  final String title;
  DBTestPage({Key key, this.title}) : super(key: key);
  @override
  _DBTestPageState createState() => _DBTestPageState();
}

class _DBTestPageState extends State<DBTestPage> {
  final List<String> genderItems = [
    'أرسلت',
    'قيد الانتظار ',
    'استلمت',
  ];
  final List<String> ty = [
    'وارده ',
    'صادرة',
  ];

  Future<List<Employee>> rasayel;

  TextEditingController codee = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  final TextEditingController _fraixController = TextEditingController();

  String code;
  String id;

  String destination;
  String fraix;
  String status;
  String type;

  final formKey = new GlobalKey<FormState>();
  var dbHelper;
  bool isUpdating;

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    isUpdating = false;
    refreshList();
  }

  refreshList() {
    setState(() {
      rasayel = dbHelper.getEmployees();
    });
  }

  clearName() {
    status = null;
    type = null;
    formKey.currentState.reset();
    _destinationController.text = "";
    _fraixController.text = "";
    codee.text = "";
    setState(() {});

    print(_destinationController.text);
  }

  validate() async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      if (isUpdating) {
        Employee e =
            Employee(int.parse(id), code, destination, fraix, status, type);
        dbHelper.update(e);
        setState(() {
          isUpdating = false;
        });
      } else {
        // print(code);
        // print(destination);
        // print("e");

        Employee e = Employee(null, code, destination, fraix, status, type);
        // print(e.toMap());
        Employee h = await dbHelper.save(e);
        print(h.toMap());
      }
      clearName();
      refreshList();
    }
  }

  form() {
    return Form(
      key: formKey,
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
            TextFormField(
              textAlign: TextAlign.center,
              controller: codee,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "الرمز"),
              validator: (val) => val.length == 0 ? "Enter destination" : null,
              onSaved: (val) => code = val,
            ),
            TextFormField(
              controller: _destinationController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(labelText: "الوجهة "),
              validator: (val) => val.length == 0 ? "Enter destination" : null,
              onSaved: (val) => destination = val,
            ),
            TextFormField(
              controller: _fraixController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(labelText: "المبلغ "),
              validator: (val) => val.length == 0 ? "Enter fraix" : null,
              onSaved: (val) => fraix = val,
            ),
            // TextFormField(
            //   controller: _statusController,
            //   keyboardType: TextInputType.text,
            //   decoration: InputDecoration(labelText: "status"),
            //   validator: (val) => val.length == 0 ? "Enter status" : null,
            //   onSaved: (val) => status = val,
            // ),
            SizedBox(
              height: 10,
            ),
            DropdownButtonFormField2<String>(
              isExpanded: true,
              decoration: InputDecoration(
                // Add Horizontal padding using menuItemStyleData.padding so it matches
                // the menu padding when button's width is not specified.
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                // Add more decoration..
              ),
              hint: Text(
                status == null ? "حالة الرساله " : status,
                style: TextStyle(fontSize: 14),
              ),
              value: status != null ? status : null,
              items: genderItems
                  .map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item,
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ))
                  .toList(),
              validator: (value) {
                if (value == null) {
                  return 'Please select gender.';
                }
                print(value);
                return null;
              },
              onChanged: (value) {
                //Do something when selected item is changed.
                print(value);
              },
              onSaved: (value) {
                status = value.toString();
                value = null;
                setState(() {});
              },
              buttonStyleData: const ButtonStyleData(
                padding: EdgeInsets.only(right: 8),
              ),
              iconStyleData: const IconStyleData(
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: Colors.black45,
                ),
                iconSize: 24,
              ),
              dropdownStyleData: DropdownStyleData(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              menuItemStyleData: const MenuItemStyleData(
                padding: EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            DropdownButtonFormField2<String>(
              isExpanded: true,
              decoration: InputDecoration(
                // Add Horizontal padding using menuItemStyleData.padding so it matches
                // the menu padding when button's width is not specified.
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                // Add more decoration..
              ),
              hint: Text(
                type == null ? "الرسائل" : type,
                style: TextStyle(fontSize: 14),
              ),
              value: type != null ? type : null,
              items: ty
                  .map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item,
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ))
                  .toList(),
              validator: (value) {
                if (value == null) {
                  print(value);
                  return 'Please select gender.';
                }
                print(value);
                return null;
              },
              onChanged: (value) {
                //Do something when selected item is changed.
                // print(value);
              },
              onSaved: (value) {
                type = value.toString();
              },
              buttonStyleData: const ButtonStyleData(
                padding: EdgeInsets.only(right: 8),
              ),
              iconStyleData: const IconStyleData(
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: Colors.black45,
                ),
                iconSize: 24,
              ),
              dropdownStyleData: DropdownStyleData(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              menuItemStyleData: const MenuItemStyleData(
                padding: EdgeInsets.symmetric(horizontal: 16),
              ),
            ),

                SaveBtnBuilder(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: validate,
                  child: Text(isUpdating ? "تحديث" : "إضافة "),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isUpdating = false;
                    });
                    clearName();
                  },
                  child: Text("الغاء"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  SingleChildScrollView dataTable(List<Employee> employees) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(label: Text("الرمز")),
            DataColumn(label: Text("الوجهة")),
            DataColumn(label: Text("المبلغ")),
            DataColumn(label: Text(" الرسائل")),
            DataColumn(label: Text("تعديل ")),
            DataColumn(label: Text("مسح")),
          ],
          rows: employees
              .map(
                (employee) => DataRow(cells: [
                  DataCell(
                    Text(employee.code.toString()),
                    onTap: () {},
                  ),
                  DataCell(
                    Text(employee.destination.toString()),
                  ),
                  DataCell(
                    Text(employee.fraix.toString()),
                  ),
                  DataCell(
                    Text(employee.type.toString()),
                  ),
                  DataCell(IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        setState(() {
                          isUpdating = true;
                          id = employee.id.toString();
                          print(employee.code.toString());
                        });
                        codee.text = employee.code.toString();
                        _destinationController.text =
                            employee.destination.toString();
                        _fraixController.text = employee.fraix.toString();
                        status = employee.status.toString();
                        type = employee.type.toString();
                      })),
                  DataCell(IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        dbHelper.delete(employee.id);
                        refreshList();
                      })),
                ]),
              )
              .toList(),
        ),
      ),
    );
  }

  list() {
    return Expanded(
      child: FutureBuilder(
        future: rasayel,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return dataTable(snapshot.data);
          }
          if (null == snapshot.data || snapshot.data.length == 0) {
            return Text("No Data Found");
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("النسخة التجريبية "),
      ),
      body: new Container(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
            form(),
            list(),
            
          ],
        ),
      ),
    );
  }
}
