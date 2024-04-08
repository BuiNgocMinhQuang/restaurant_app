import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ManagerHome extends StatefulWidget {
  const ManagerHome({super.key});

  @override
  State<ManagerHome> createState() => _ManagerHomeState();
}

class _ManagerHomeState extends State<ManagerHome> {
  bool showModal = true;
  String imageSrc = 'https://picsum.photos/200';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _showSuccesModal(context);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: RefreshIndicator(
      color: Colors.blue,
      onRefresh: () async {
        await Future.delayed(Duration(seconds: 2));
        setState(() {
          imageSrc = "https://picsum.photos/250";
        });
      },
      child: SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.only(
                top: 20.w, left: 20.w, right: 20.w, bottom: 20.w),
            child: ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: 6,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: Row(
                      children: [
                        Container(
                          width: 100.w,
                          height: 100.w,
                          color: Colors.grey,
                          child: CachedNetworkImage(
                            fit: BoxFit.fill,
                            imageUrl: imageSrc,
                            placeholder: (context, url) => SizedBox(
                              height: 10.w,
                              width: 10.w,
                              child: const Center(
                                  child: CircularProgressIndicator()),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        const Expanded(
                          child: Text(
                            "Every city is good for travel.",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  );
                })),
      ),
    )));
  }
}
