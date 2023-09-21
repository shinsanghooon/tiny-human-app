import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tiny_human_app/photo_view_page.dart';

class GalleryPage extends StatefulWidget {
  GalleryPage({Key? key}) : super(key: key);

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  double gridCount = 4;
  double endScale = 1.0;

  final List<String> photos =[
    "https://images.unsplash.com/photo-1561037404-61cd46aa615b?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&h=500&q=80",
    "https://images.unsplash.com/photo-1543466835-00a7907e9de1?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&h=500&q=80",
    "https://images.unsplash.com/photo-1497752531616-c3afd9760a11?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&h=500&q=80",
    "https://images.unsplash.com/photo-1537151625747-768eb6cf92b2?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&h=500&q=80",
    "https://images.unsplash.com/flagged/photo-1557650454-65194af63bf9?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&h=500&q=80",
    "https://images.unsplash.com/photo-1583512603805-3cc6b41f3edb?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&h=500&q=80",
    "https://images.unsplash.com/photo-1583337130417-3346a1be7dee?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&h=500&q=80",
    "https://images.unsplash.com/photo-1576201836106-db1758fd1c97?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&h=500&q=80",
  ];

  void onScaleUpdate(ScaleUpdateDetails details) {
    // 제스처에 따라 그리드 수를 동적으로 조절
    endScale = details.scale;
  }

  void onScaleEnd(ScaleEndDetails details) {
    setState(() {
      if (endScale < 1) {
        gridCount += 1;
      } else {
        gridCount -= 1;
      }

      if (gridCount == 0) {
        gridCount = 1;
      }

      if (gridCount == 11) {
        gridCount = 10;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent,
        title: Text(
          "tiny-human",
          style: TextStyle(
            color: Colors.deepOrange,
            fontWeight: FontWeight.w800,
          ),
        ),),
      body: GestureDetector(
        onScaleUpdate: onScaleUpdate,
        onScaleEnd: onScaleEnd,
        child: GridView.builder(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          padding: const EdgeInsets.all(1),
          itemCount: photos.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: gridCount.toInt(),
          ),
          itemBuilder: ((context, index) {

            if (index + 1 > photos.length) {
              return null;
            }

            return Container(
              padding: const EdgeInsets.all(0.5),
              child: InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PhotoViewPage(photos: photos, index: index),
                  ),
                ),
                child: Hero(
                  tag: photos[index],
                  child: CachedNetworkImage(
                    imageUrl: photos[index],
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(color: Colors.grey),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.red.shade400,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}