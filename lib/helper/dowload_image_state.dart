abstract class  DowaloadImageState{
    DowaloadImageState();
}

class DownLoadStateErro extends DowaloadImageState{
   String messengerError;
   DownLoadStateErro({required this.messengerError}):super();
}


class DownLoadStateRunning extends DowaloadImageState{
  String messengerError;
  DownLoadStateRunning({required this.messengerError}):super();
}

class DownLoadSucessStateRunning extends DowaloadImageState{
  String messengerSucess;
  String url;
  DownLoadSucessStateRunning({required this.messengerSucess,required this.url}):super();
}

