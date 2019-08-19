import 'package:flutter/material.dart';

class QnAItem{
  String title;
  String content;

  QnAItem(this.title, this.content);
}

class QnAPage extends StatefulWidget {
  @override
  _QnAPageState createState() => _QnAPageState();
}

class _QnAPageState extends State<QnAPage> {

  final qna_items = [
    QnAItem("조속기가 고장 났을때 시동을 걸면 어떤 현상이 일어나나요?",
        "조속기는 연료 분사량을 가감 시켜 주는 장치 입니다. 조속기가 고장 나면 연료의 가감이 어려우니 시동이 잘 안걸릴 수 있고, 시동이 걸린다고 해도 차의 가속이 어려울 것입니다."),
    QnAItem("RPM 불안정 현상",
        "4개의 글로우 플러그 중에서 두개 이상 고장이 나면 시동 직후 엔진 회전수가 안정되지 못하고 500에서 1000Rpm으로 회전수 변화가 심하게 발생하며 소음과 진동이 동반하게 됩니다.\n"
            "글로우 플러그 고장확인은 저항값을 측정하는 방법도 있고 차량에서 분해해서 배터리 직결 연결시 저항의 발열이 없으면 고장입니다. 저항은 0.4옴 이상 나와야합니다."),
    QnAItem("차량 타이밍 밸트 교체",
        "대게 타이밍 벨트를 교환하시게되면 크게 베어링류와 벨트류, 워터 펌프가 교환됩니다.구체적으로는 타이밍 벨트, 텐션 베어링, 아이들 베어링, 휀벨트(외부 벨트), 워터 펌프, 가스켓, 부동액\n"
            "등등이 교환됩니다. 타이밍 벨트 교환주기가 8만키로인점을 감안했을 때, 베어링류와 워커 펌프는 16만 키로를 견뎌야 하나, 사실 그렇지 못합니다.\n"
        "따라서 베어링류와 워터펌프도 같이 교환해주시는게 좋습니다."),
    QnAItem("차량 에어컨 고장",
    "차량에 바람이 안나오는 것은 차안에서, 조수석 안쪽 아래부분의 블로워 모터가 고장 났을 때의 현상입니다.\n "
        "블로워 모터가 회전을 하고 있는데 바람이 잘나오지 않는다면, 히터의 외기, 내기 전환부쪽의 고장, 에어 통로 막힘, 실내 에어필터에 먼지가 쌓여서 그런 것 입니다.")
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Q&A")
      ),
      body: ListView.separated(
          separatorBuilder: (context, index) => Divider(
            color: Colors.black,
          ),
//          shrinkWrap: true,

          itemCount: qna_items.length,
          itemBuilder: (BuildContext context, int index){
            return ListTile(
              title: Text(qna_items[index].title),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: (){
                showDialog(
                    context: context,
                builder: (BuildContext context){
                      return AlertDialog(
                        title: Text(qna_items[index].title),
                        content: Text(qna_items[index].content),
                      );
                });

              },
//              trailing: Text(qna_items[index].content),
            );
          },
      ),
    );
  }
}
