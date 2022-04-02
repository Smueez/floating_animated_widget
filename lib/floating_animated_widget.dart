library floating_animated_widget;
import 'package:flutter/material.dart';

class FloatingWidget extends StatefulWidget {
  FloatingWidget({required this.child,
    required this.floatingWidget,
    this.dy,
    this.dx,
    required this.floatingWidgetWidth,
    required this.floatingWidgetHeight,
    this.speed,
    Key? key}) : super(key: key);

  Widget child;
  double floatingWidgetWidth;
  double floatingWidgetHeight;
  Widget floatingWidget;
  double? dy;
  double? dx;
  double? speed;

  @override
  _FloatingWidgetState createState() => _FloatingWidgetState();
}

class _FloatingWidgetState extends State<FloatingWidget> with SingleTickerProviderStateMixin {
  double top = 200, left = 200;
  bool isTabbed = false;
  double appBarHeight = AppBar().preferredSize.height;
  bool isDragging = false;


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    top = widget.dy?? MediaQuery.of(context).size.height / 2;
    left = widget.dx?? MediaQuery.of(context).size.width / 2;
    return Scaffold(
      body: GestureDetector(
        onTap: (){
          setState(() {
            isTabbed = false;
          });
        },
        onLongPress: (){
          setState(() {
            isTabbed = false;
          });
        },
        onPanStart: (value){
          setState(() {
            isTabbed = false;
          });
        },
        onPanUpdate: (value){
          setState(() {
            if(isTabbed){
              top = value.localPosition.dy;
              left = value.localPosition.dx;
            }
          });
        },

        child: SizedBox(
          height: height,
          width: width,
          child: Stack(
            children: [
              widget.child,
              AnimatedPositioned(
                  top: top,
                  left: left,
                  duration: Duration(milliseconds: isDragging? 100: 700),
                  curve: top >= (height - widget.floatingWidgetHeight - appBarHeight) || left >= (width - widget.floatingWidgetWidth) || top <=  widget.floatingWidgetHeight || left <= 1? Curves.bounceOut : Curves.ease,
                  child: GestureDetector(
                    onTap: (){
                      setState(() {
                        isTabbed = true;
                      });
                    },
                    onLongPress: (){

                      setState(() {
                        isTabbed = true;
                      });
                    },
                    onPanStart: (value){
                      setState(() {
                        isTabbed = true;
                        isDragging = true;
                      });
                    },
                    onPanUpdate: (value){
                      setState(() {
                        if(isTabbed){
                          top = _getDy(value.globalPosition.dy, height);
                          left = _getDx(value.globalPosition.dx, width);
                        }
                      });
                    },
                    onPanEnd: (value){
                      setState(() {
                        if(isTabbed){
                          isDragging = false;
                          left = _getDx(left + value.velocity.pixelsPerSecond.dx/(widget.speed??50.0).toDouble(), width);
                          top = _getDy(top + value.velocity.pixelsPerSecond.dy/(widget.speed??50.0).toDouble(), height);
                        }
                      });
                    },
                    child: SizedBox(
                        width: widget.floatingWidgetWidth,
                        height: widget.floatingWidgetHeight,
                        child: widget.floatingWidget
                    ),
                  )
              )
            ],
          ),
        ),
      ),
    );
  }

  double _getDy(double dy, double totalHeight){
    double currentTop;
    if(dy >= (totalHeight - widget.floatingWidgetHeight - appBarHeight)){
      currentTop = (totalHeight - widget.floatingWidgetHeight - appBarHeight);
    }
    else {
      if(dy <= 0){
        currentTop = 51;
      }
      else {
        currentTop = dy;
      }
    }
    return currentTop;
  }
  double _getDx (double dx, double totalWidth){
    double currentTop;
    if(dx >= (totalWidth - widget.floatingWidgetWidth)){
      currentTop = (totalWidth - widget.floatingWidgetWidth);
    }
    else {
      if(dx <= 0){
        currentTop = 0;
      }
      else {
        currentTop = dx;
      }
    }
    return currentTop;
  }
}
