import 'package:flutter/material.dart';
import 'estimate.dart';
class MyUsagePage extends StatefulWidget {
  List<SendEstimate> sendList;
  List<ReceiveEstimate> receiveList;
  MyUsagePage(this.sendList,this.receiveList);
  @override
  _MyUsagePageState createState() => _MyUsagePageState(sendList,receiveList);
}

class _MyUsagePageState extends State<MyUsagePage> {
  List<SendEstimate> sendList;
  List<ReceiveEstimate> receiveList;
  _MyUsagePageState(this.sendList,this.receiveList);

  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('이용내역'),
      ),
      body: ListView.separated(
        separatorBuilder: (context, index) => Divider(
          color: Colors.black,
        ),
//          shrinkWrap: true,

        itemCount: sendList.length,
        itemBuilder: (BuildContext context, int index){
          return ExpansionTile(
            title: Text(sendList[index].contents),
            trailing: Icon(Icons.keyboard_arrow_right),
            // onTap: (){
            //   showDialog(
            //       context: context,
            //   builder: (BuildContext context){
            //         return AlertDialog(
            //           title: Text(sendList[index].contents),
            //           content: Image.network(sendList[index].car_image),
            //         );
            //   });
            // },
            children: _build_feedback(sendList[index]),
//              trailing: Text(qna_items[index].content),
          );
        },
      ),
    );
  }
  List<Widget> _build_feedback(SendEstimate sendEst) {
    int id = sendEst.id;
    List<ReceiveEstimate> subList = List<ReceiveEstimate>();
    List<Widget> ans = List<Widget>();
    for(ReceiveEstimate est in receiveList) {
      if(est.id == id) {
        subList.add(est);
      }
    }
    for(ReceiveEstimate item in subList) {
      ans.add(new ListTile(
        title: new Text(item.contents, style: new TextStyle(fontSize: 18.0),),
      ));
    }
    return ans;
  }
}