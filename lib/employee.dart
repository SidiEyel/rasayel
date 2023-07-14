class Employee {
  int id;
  String code;
  String destination;
  String fraix;
  String status;
  String type;
  Employee(
      this.id, this.code, this.destination, this.fraix, this.status, this.type);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'code': code,
      'destination': destination,
      'fraix': fraix,
      'status': status,
      'type': type,
    };
    return map;
  }

  Employee.fromMap(Map<dynamic, dynamic> map) {
    id = map["id"];
    code = map["code"];
    destination = map["destination"];
    fraix = map["fraix"];
    status = map["status"];
    type = map["type"];
  }
}
