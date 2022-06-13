import 'package:flutter/material.dart';

class ImageBubble extends StatefulWidget {
  final String image;
  final String email;
  final bool isMe;
  const ImageBubble({
    Key? key,
    required this.image,
    required this.email,
    required this.isMe
  }) : super(key: key);
  @override
  _ImageBubbleState createState() => _ImageBubbleState();
}

class _ImageBubbleState extends State<ImageBubble> {
  final double imageProfileSize = 42;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print('IMG------${widget.message?.file?.path?.chatUrl() ?? ""}');
    return Column(
      crossAxisAlignment:
      widget.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          widget.email,
          style: const TextStyle(color: Colors.black54, fontSize: 12),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment:
          widget.isMe? MainAxisAlignment.end: MainAxisAlignment.start,
          children: [
            SizedBox(width: 10),
            // _buildProfile(),
            InkWell(
              // onTap: () {
              //   Navigator.of(context).pushNamed(PhotoViewPage.routeName,
              //       arguments: widget.message?.file?.path?.chatUrl() ?? "");
              // },
              child: Container(
                width: 220,
                height: 190,
                clipBehavior: Clip.hardEdge,
                margin: EdgeInsets.only(
                  top: 5,
                  left: 5,
                  right: 10,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: NetworkImage(
                      widget.image
                    )
                  )
                ),


              ),
            ),
          ],
        ),
      ],
    );
  }

  // Widget _buildTextTime() {
  //   if (widget.message.createdDate == null) return Container();
  //   return AppText(
  //     DateHelper.formatDate(
  //       timestamp: widget.message.createdDate,
  //       format: 'hh:mm a',
  //     ),
  //     margin: EdgeInsets.only(
  //       top: 3,
  //       left: imageProfileSize + AppDimension().bodySpace + 10,
  //       right: AppDimension().bodySpace,
  //     ),
  //     alignment: widget.isUser ? Alignment.centerRight : Alignment.centerLeft,
  //     style: AppFont().text(fontSize: 9, color: AppColors().title()),
  //   );
  // }
  //
  // Widget _buildSending() {
  //   if (widget.message.status != SendStatus.SENDING) return Container();
  //   return Align(
  //       child: Container(
  //         width: 80,
  //         height: 10,
  //         margin: EdgeInsets.only(left: imageProfileSize),
  //         child: SpinKitThreeBounce(
  //           key: UniqueKey(),
  //           color: AppColors().primary,
  //           size: 13,
  //         ),
  //       ),
  //       alignment: Alignment.bottomRight);
  // }
  //
  // Widget _buildProfile() {
  //   //print('Profile_chat-------->${widget.message?.customer?.image?.fullUrl() ?? ""}');
  //   if (widget.isUser) return Container();
  //   return Container(
  //     clipBehavior: Clip.hardEdge,
  //     width: 42,
  //     height: 42,
  //     margin: EdgeInsets.only(left: 10),
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(21),
  //       color: Colors.grey.shade300,
  //     ),
  //     child: AppImageLoading(
  //       url: widget?.message?.staff?.profile?.fullUrl() ?? "",
  //       errorWidget: Padding(
  //         padding: EdgeInsets.all(8),
  //         child: Image.asset(
  //           AppImages.profile,
  //           fit: BoxFit.contain,
  //           color: Colors.white,
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
