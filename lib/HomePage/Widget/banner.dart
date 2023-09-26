import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../../Model/home_banner_model.dart';
import '../../constant/constatnt.dart';

class BannerWidget extends StatefulWidget {
  const BannerWidget({Key? key}) : super(key: key);

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  List<HomeBannerModel> bannerlist = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse("${baseUrlCi}slider"));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as List<dynamic>;
        setState(() {
          bannerlist =
              jsonData.map((item) => HomeBannerModel.fromJson(item)).toList();
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      throw Exception('Failed to load data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SizedBox(
        height: height * 0.15,
        width: width,
        child: CarouselSlider(
          items: bannerlist.map((i) {
            return Builder(
              builder: (BuildContext context) {
                return InkWell(
                  onTap: () {
                    urllaunch('https://enq.bharatekrishi.com/harvester');
                  },
                  child: SizedBox(
                    height: height * 1,
                    width: width * 0.99,
                    child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        elevation: 5,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: Image.network(
                            '${i.images}',
                            fit: BoxFit.fill,
                            height: MediaQuery.of(context).size.height * 1,
                          ),
                        )),
                  ),
                );
              },
            );
            // $i'
          }).toList(),
          options: CarouselOptions(
            height: height * 1,
            aspectRatio: 12 / 9,
            viewportFraction: 1,
            initialPage: 0,
            enableInfiniteScroll: true,
            reverse: false,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: true,
            enlargeFactor: 0.3,
            scrollDirection: Axis.horizontal,
          ),
        ));
  }
}

void urllaunch(String uri) async {
  var url = uri;
  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url));
  } else {
    throw 'Could not launch $url';
  }
}
