library floating_draggable_widget;
import 'package:flutter/material.dart';
/// Support Android, IOS, Web etc.
/// This package is used to make a widget movable or draggable around the screen freely;
/// Works fine for any Widget;
/// Does not affect the functionality or performance of the particular widget;
/// Used physics law supported animation to make it more attractive;
class FloatingDraggableWidget extends StatefulWidget {
  FloatingDraggableWidget({required this.child,
    required this.floatingWidget,
    this.dy,
    this.dx,
    required this.floatingWidgetWidth,
    required this.floatingWidgetHeight,
    this.speed,
    Key? key}) : super(key: key);

  /// Child is required and it accept any widget.
  /// This is actually the base Widget or the parent widget on where the floating widget will be dragged or moved.
  /// floatingWidget is also required and it accept any widget.
  /// This is actually the particular widget which will be floated and can be mode or dragged around the screen.
  /// floatingWidgetWidth is also required and it accepts a double value which is the width of the floating widget above mentioned.
  /// floatingWidgetHeight is also required and it accepts a double value which is the height of the floating widget above mentioned.
  /// dy accepts a double value which is the distance from the top of the screen where floating widget will be positioned initially .
  /// dx accepts a double value which is the distance from the left of the screen where floating widget will be positioned initially.
  /// speed accepts a double value which is the speed factor of the floating widget after it will be let go.
  /// The more speed will be provided the slower the object will move after the user let the widget go freely.
  Widget child;
  double floatingWidgetWidth;
  double floatingWidgetHeight;
  Widget floatingWidget;
  double? dy;
  double? dx;
  double? speed;

  @override
  _FloatingDraggableWidgetState createState() => _FloatingDraggableWidgetState();
}

class _FloatingDraggableWidgetState extends State<FloatingDraggableWidget> with SingleTickerProviderStateMixin {
  /// distance from top and left initial value
  double top = 200, left = 200;
  /// is the widget tabbed bool value
  bool isTabbed = false;
  /// appbar height
  double appBarHeight = AppBar().preferredSize.height;
  /// bool value if it is dragging
  bool isDragging = false;


  @override
  Widget build(BuildContext context) {
    /// total screen width & height
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    /// distance from top and left from user
    top = widget.dy?? MediaQuery.of(context).size.height / 2;
    left = widget.dx?? MediaQuery.of(context).size.width / 2;
    return Scaffold(
      body: GestureDetector(
        /// if the user touched out side of the widget the tabbed will be false
        onTap: (){
          setState(() {
            isTabbed = false;
          });
        },
        /// if the user touched out side of the widget the tabbed will be false
        onLongPress: (){
          setState(() {
            isTabbed = false;
          });
        },
        /// if the user touch of even gesture detector detect any drag gesture out side of the widget the dragging will be false
        onPanStart: (value){
          setState(() {
            isTabbed = false;
          });
        },
        /// setting the top and left globally
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
                  duration: Duration(milliseconds: isDragging? 100: 700), /// setting animation time and animation type
                  /// the widget will bounce when it will touch the main screen border.
                  /// other wise it has just a simple ease animation.
                  curve: top >= (height - widget.floatingWidgetHeight - appBarHeight) || left >= (width - widget.floatingWidgetWidth) || top <=  widget.floatingWidgetHeight || left <= 1? Curves.bounceOut : Curves.ease,
                  child: GestureDetector(
                    /// tabbing on widget makes the isTabbed true.
                    /// it is because the widget will move only when we are touch it and drag to to somewhere else in the screen
                    onTap: (){
                      setState(() {
                        isTabbed = true;
                      });
                    },
                    /// also in the case of long press
                    onLongPress: (){

                      setState(() {
                        isTabbed = true;
                      });
                    },
                    /// also in the case when a user start to drag the widget
                    onPanStart: (value){
                      setState(() {
                        isTabbed = true;
                        isDragging = true;
                      });
                    },
                    /// updating top and left variable
                    onPanUpdate: (value){
                      setState(() {
                        if(isTabbed){
                          top = _getDy(value.globalPosition.dy, height);
                          left = _getDx(value.globalPosition.dx, width);
                        }
                      });
                    },
                    /// give a sliding animation
                    onPanEnd: (value){
                      setState(() {
                        if(isTabbed){
                          isDragging = false;
                          left = _getDx(left + value.velocity.pixelsPerSecond.dx/(widget.speed??50.0).toDouble(), width);
                          top = _getDy(top + value.velocity.pixelsPerSecond.dy/(widget.speed??50.0).toDouble(), height);
                        }
                      });
                    },
                    /// the floating widget with size
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

  /// get the y axis value or top value with screen size
  double _getDy(double dy, double totalHeight){
    /// checking if top is higher or less than total screen height (except
    /// appbar), if so, then top will be the lowest of highest point of the screen.
    /// top variable will be no more than the screen total height
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

  /// get the x axis value or left value with screen size
  double _getDx (double dx, double totalWidth){
    /// checking if left is higher or less than total screen width ,
    /// if so, then left will be the lowest width (0.o) of highest point of width of the screen
    /// widget will not go out side of the screen.
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
