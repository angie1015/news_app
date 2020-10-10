import 'package:flutter/material.dart';
import 'package:newsapp/helper/news.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  bool _loading =true;
  var newslist;

  void getNews() async {
    News news = News();
    await news.getNews();
    newslist = news.news;
    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    _loading = true;
    // TODO: implement initState
    super.initState();
    getNews();
  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.blueGrey,
      title: Text('News'),
      centerTitle: true,
    ),
    body: SafeArea(
      child: _loading ? Center(
        child: Container(
          child: CircularProgressIndicator(),
        ),
      )
          : SingleChildScrollView(
        child: Container(
          child: Container(
            margin: EdgeInsets.only(top: 16),
            child: ListView.builder(
                itemCount: newslist.length,
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemBuilder: (context, index) {
                  return NewsTile(
                    provider: newslist[index].author ?? "",
                    pubDate: newslist[index].publishedAt ?? "",
                    imgURL: newslist[index].urlToImage ?? "",
                    title: newslist[index].title ?? "",
                    desc: newslist[index].description ?? "",
                    posturl: newslist[index].articleUrl ?? "",
                  );
                }),
          ),
        ),
      ),
    ),
  );
}
}
class BlogTile extends StatelessWidget {

  final String provider, title, desc, url, imgURL;
  final DateTime pubDate;
  BlogTile({@required this.provider, @required this.title, @required this.desc, @required this.url, @required this.imgURL, @required this.pubDate,});
  @override
  @override

  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(provider),
          Image.network(imgURL),
          Text(title),
          Text(desc),
          //Text(pubDate),
          FlatButton(
            onPressed: _launchURL(url),
            child: Text(url),
          ),
        ],
      ),
    );
  }
}

class NewsTile extends StatelessWidget {
  final String imgURL, title, desc, posturl, provider;
  final DateTime pubDate;

  NewsTile({this.imgURL, this.desc, this.title, @required this.posturl, this.provider, this.pubDate});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        //Navigator.push(context, MaterialPageRoute(
         //   builder: (context) => ArticleView(
         //     postUrl: posturl,
       //     )
       // ));
      },
      child: Container(
          margin: EdgeInsets.only(bottom: 24),
          width: MediaQuery.of(context).size.width,
          child: Container(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(6),bottomLeft:  Radius.circular(6))
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(provider),
                  SizedBox(height: 4,),
                  ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.network(
                        imgURL,
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      )),
                  SizedBox(height: 12,),
                  Text(
                    title,
                    maxLines: 2,
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    desc,
                    maxLines: 2,
                    style: TextStyle(color: Colors.black54, fontSize: 14),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  FlatButton(
                    onPressed: () => _launchURL(posturl),
                    child: Text(posturl),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
_launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
