import 'package:app_restaurant/config/colors.dart';
import 'package:app_restaurant/config/space.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

//------------------------------STAFF------------------------------
class ShimmerListFood extends StatelessWidget {
  const ShimmerListFood({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Shimmer.fromColors(
          baseColor: const Color.fromARGB(255, 221, 221, 221),
          highlightColor: lightGrey,
          child: Container(
              width: 1.sw,
              height: 35.h,
              // color: Colors.red,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Container(
                        width: 100.w,
                        // height: 30.h,
                        color: lightGrey,
                      ),
                    );
                  })),
        ),
        space50H,
        Expanded(
          child: Container(
            width: 1.sw,
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Shimmer.fromColors(
                        baseColor: const Color.fromARGB(255, 221, 221, 221),
                        highlightColor: lightGrey,
                        child: Row(
                          children: [
                            space20W,
                            Container(
                              width: 80.w,
                              height: 80.w,
                              color: Colors.amber,
                            ),
                            space50W,
                            Shimmer.fromColors(
                              baseColor:
                                  const Color.fromARGB(255, 221, 221, 221),
                              highlightColor: lightGrey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 200.w,
                                    height: 20.w,
                                    color: Colors.amber,
                                  ),
                                  space10H,
                                  Container(
                                    width: 200.w,
                                    height: 20.w,
                                    color: Colors.amber,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      space20H
                    ],
                  );
                }),
          ),
        )
      ],
    );
  }
}

class ShimmerListBill extends StatelessWidget {
  const ShimmerListBill({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        space20H,
        Shimmer.fromColors(
          baseColor: const Color.fromARGB(255, 221, 221, 221),
          highlightColor: lightGrey,
          child: Container(
              width: 1.sw,
              height: 45.h,
              // color: Colors.red,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Container(
                        width: 100.w,
                        // height: 30.h,
                        color: lightGrey,
                      ),
                    );
                  })),
        ),
        space50H,
        Expanded(
          child: Container(
            width: 1.sw,
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Shimmer.fromColors(
                        baseColor: const Color.fromARGB(255, 221, 221, 221),
                        highlightColor: lightGrey,
                        child: Container(
                          width: 1.sw,
                          height: 150.w,
                          color: Colors.amber,
                        ),
                      ),
                      space20H
                    ],
                  );
                }),
          ),
        )
      ],
    );
  }
}

class ShimmerUserInfor extends StatelessWidget {
  const ShimmerUserInfor({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          space20H,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Shimmer.fromColors(
                  baseColor: const Color.fromARGB(255, 221, 221, 221),
                  highlightColor: lightGrey,
                  child: Container(
                    width: 100.w,
                    height: 100.h,
                    decoration: new BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                    ),
                  )),
              space25W,
              Flexible(
                flex: 1,
                child: Container(
                    height: 100.h,
                    child: ListView.builder(
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Shimmer.fromColors(
                              baseColor:
                                  const Color.fromARGB(255, 221, 221, 221),
                              highlightColor: lightGrey,
                              child: Container(
                                height: 40.h,
                                color: Colors.red,
                              ),
                            ),
                            space10H,
                          ],
                        );
                      },
                    )),
              )
            ],
          ),
          space50H,
          Flexible(
            flex: 3,
            child: Shimmer.fromColors(
              baseColor: const Color.fromARGB(255, 221, 221, 221),
              highlightColor: lightGrey,
              child: Container(
                width: 1.sw,
                // height: 350.w,
                color: Colors.amber,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ShimmerBookingTable extends StatelessWidget {
  const ShimmerBookingTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        space20H,
        Shimmer.fromColors(
          baseColor: const Color.fromARGB(255, 221, 221, 221),
          highlightColor: lightGrey,
          child: Container(
              width: 1.sw,
              height: 45.h,
              // color: Colors.red,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Container(
                        width: 100.w,
                        // height: 30.h,
                        color: lightGrey,
                      ),
                    );
                  })),
        ),
        space50H,
        Expanded(
          child: GridView.builder(
              itemCount: 12,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.all(10.w),
                  child: Shimmer.fromColors(
                    baseColor: const Color.fromARGB(255, 221, 221, 221),
                    highlightColor: lightGrey,
                    child: Container(
                      width: 100.w,
                      height: 100.w,
                      color: Colors.amber,
                    ),
                  ),
                );
              }),
        )
      ],
    );
  }
}

//------------------------------MANAGER------------------------------

class ShimmerHomeManager extends StatelessWidget {
  const ShimmerHomeManager({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        space20H,
        space50H,
        Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Shimmer.fromColors(
                    baseColor: const Color.fromARGB(255, 221, 221, 221),
                    highlightColor: lightGrey,
                    child: Padding(
                        padding: EdgeInsets.all(20.h),
                        child: IntrinsicHeight(
                          child: Row(
                            children: [
                              Container(
                                width: 100.w,
                                color: Colors.amber,
                              ),
                              space20W,
                              Expanded(
                                  child: Column(
                                children: [
                                  Container(
                                    height: 30.w,
                                    color: Colors.amber,
                                  ),
                                  space10H,
                                  Container(
                                    height: 30.w,
                                    color: Colors.amber,
                                  ),
                                  space10H,
                                  Container(
                                    height: 30.w,
                                    color: Colors.amber,
                                  ),
                                ],
                              ))
                            ],
                          ),
                        )),
                  );
                }))
      ],
    );
  }
}
