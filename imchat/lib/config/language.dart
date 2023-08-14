




extension Language on String  {

  static int type = 0;

  Map<String, String> get languageInfoMap {
    return englisgh;
  }

  String get localize {
    String? ret = languageInfoMap[this];
    if(ret?.isNotEmpty == true){
      return ret!;
    }else {
      return this;
    }
  }



}

Map<String, String> englisgh = {
  "": "",
};