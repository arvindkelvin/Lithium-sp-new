import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


class DBHelper{
  static final DBHelper _instance = DBHelper.internal();

  factory DBHelper() => _instance;

  static Database? _db;

  DBHelper.internal();

  final String UserTable = 'userTable';
  final String DB_Name = 'user.db';
  final String TAG = 'DBHelper';

  final String lithiumId = 'lithium_id';
  final String callbackURL = 'callbackURL';
  final String spUsername = 'sp_username';
  final String id = 'id';
  final String password = 'password';
  final String pswEncrypt = 'pswEncrypt';
  final String mobileNo = 'mobileNo';
  final String emailId = 'emailId';
  final String accessToken = 'accessToken';
  final String refreshToken = 'refreshToken';

  final String chargingTable = 'chargingTable';
  final String lithiumid = 'lithiumid';
  final String name = 'username';
  final String startsoc = 'startsoc';
  final String endsoc = 'endsoc';
  final String odometer = 'odometer';
  final String vehiclenumber = 'vehiclenumber';
  final String Lattitude = 'latitude';
  final String Longtitude = 'longitude';
  final String charging = 'charging';
  final String startsocimage = 'startsocimage';
  final String endsocimage = 'endsocimage';
  final String ododometerimage = 'ododometerimage';
  final String service_provider = 'service_provider';



  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDB();
    return _db;
  }

  initDB() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, DB_Name);

    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int version) async {
    await db.execute('CREATE TABLE $UserTable($lithiumId TEXT,$callbackURL TEXT, $spUsername TEXT, $id TEXT, $password TEXT, $pswEncrypt TEXT, $mobileNo TEXT, $emailId TEXT, $accessToken TEXT, $refreshToken TEXT)');

    await db.execute('CREATE TABLE $chargingTable($lithiumid TEXT,$name TEXT, $startsoc TEXT,  $endsoc TEXT,$odometer TEXT,$vehiclenumber TEXT, $Lattitude TEXT, $Longtitude TEXT,$charging TEXT,$startsocimage TEXT, $endsocimage TEXT, $ododometerimage TEXT, $service_provider TEXT)');
  }

  Future<int?> getuserCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(
        await dbClient!.rawQuery('SELECT COUNT(*) FROM $UserTable'));
  }

  Future<int?> saveUserdetails(Map<String, dynamic> rowval) async {
    var dbClient = await db;

    var result = await dbClient!.insert(UserTable, rowval);
    return result;
  }

  Future GetUserdata() async {
    var dbClient = await db;
    List<Map> result = await dbClient!.query(UserTable,
        columns: [
          lithiumId,
          callbackURL,
          spUsername,
          id,
          password,
          pswEncrypt,
          mobileNo,
          emailId,
          accessToken,
          refreshToken,
        ]
    );
    // where: '$username =?',
    // whereArgs: [name]);

    var dataval = await dbClient.rawQuery('SELECT * FROM $UserTable');
    print('=== get user dataval = $dataval \n=======');

    if (result.isNotEmpty) {
      Map searchquery = result.first;
      // print("query test == ${searchquery.toString()}");
      return searchquery;
    } else {
      // Fluttertoast.showToast(
      //   msg: "Data not found",
      //   gravity: ToastGravity.CENTER,
      // );
    }
    return null;
  }


  Future<int?> saveCharginList(Map<String,dynamic> row) async{
    var dbClient = await db;
    var result = await dbClient!.insert(chargingTable, row);
    print('result--$result');

    return result;
  }

  Future<List> getChargingList() async {
    var dbClinet = await db;
    var result = await dbClinet!.query(chargingTable,columns: [
      lithiumid,
      name,
      startsoc,
      endsoc,
      odometer,
      vehiclenumber,
      Lattitude,
      Longtitude,
      charging,
      startsocimage,
      endsocimage,
      ododometerimage,
      service_provider
    ]);
    var getdata =await dbClinet.rawQuery('SELECT * FROM $chargingTable');
    print('getdata==$getdata');

    return result.toList();
  }

  Future<void>deletechargetTable() async{
    var dbClient = await db;
    dbClient!.delete(chargingTable);
    print('data deleted');
  }
}