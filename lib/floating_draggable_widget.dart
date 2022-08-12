library floating_draggable_widget;

import 'package:flutter/material.dart';

/// Support Android, IOS, Web etc.
/// This package is used to make a widget movable or draggable around the screen freely;
/// Works fine for any Widget;
/// Does not affect the functionality or performance of the particular widget;
/// Used physics law supported animation to make it more attractive;
class FloatingDraggableWidget extends StatefulWidget {
  const FloatingDraggableWidget({
    Key? key,
    required this.child,
    required this.floatingWidget,
    required this.floatingWidgetWidth,
    required this.floatingWidgetHeight,
    this.dy,
    this.dx,
    this.speed,
    this.deleteWidget,
    this.onDeleteWidget,
    this.isDraggable = true,
    this.autoAlign = false,
  }) : super(key: key);

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
  final Widget child;
  final double floatingWidgetWidth;
  final double floatingWidgetHeight;
  final Widget floatingWidget;
  final double? dy;
  final double? dx;
  final double? speed;
  final bool isDraggable;
  final bool autoAlign;
  final Widget? deleteWidget;
  final Function()? onDeleteWidget;

  @override
  State<FloatingDraggableWidget> createState() =>
      _FloatingDraggableWidgetState();
}

class _FloatingDraggableWidgetState extends State<FloatingDraggableWidget>
    with SingleTickerProviderStateMixin {
  /// distance from top and left initial value
  late double top, left;
  double? right = 20;
  double? bottom = 20;

  /// is the widget tabbed bool value
  bool isTabbed = false;

  /// appbar height
  double appBarHeight = AppBar().preferredSize.height;

  /// bool value if it is dragging
  bool isDragging = false;

  /// is the floating widget is draggable of not.
  bool isDragEnable = true;

  /// total screen size width and height
  late double width;
  late double height;

  /// is the floating widget colliding with the close widget.
  bool isColliding = true;

  /// If the user requested to remove the floating widget.
  bool isRemoved = false;

  bool hasCollision(GlobalKey<State<StatefulWidget>> key1,
      GlobalKey<State<StatefulWidget>> key2) {
    final box1 = key1.currentContext?.findRenderObject() as RenderBox?;
    final box2 = key2.currentContext?.findRenderObject() as RenderBox?;
    if (box1 != null && box2 != null) {
      final position1 = box1.localToGlobal(Offset.zero);
      final position2 = box2.localToGlobal(Offset.zero);
      return position1.dx < position2.dx + box2.size.width &&
          position1.dx + box1.size.width > position2.dx &&
          position1.dy < position2.dy + box2.size.height &&
          position1.dy + box1.size.height > position2.dy;
    }
    return false;
  }

  @override
  void initState() {
    top = widget.dy ?? -1;
    left = widget.dx ?? -1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /// total screen width & height
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    final hasDeleteWidget = widget.deleteWidget != null;
    final containerKey1 = GlobalKey();
    final containerKey2 = GlobalKey();

    /// distance from top and left from user
    /// top = widget.dy?? MediaQuery.of(context).size.height / 2;
    /// left = widget.dx?? MediaQuery.of(context).size.width / 2;
    return Scaffold(
      body: GestureDetector(
        /// if the user touched out side of the widget the tabbed will be false
        onTap: () {
          setState(() {
            isTabbed = false;
          });
        },

        /// if the user touched out side of the widget the tabbed will be false
        onLongPress: () {
          setState(() {
            isTabbed = false;
          });
        },

        /// if the user touch of even gesture detector detect any drag gesture out side of the widget the dragging will be false
        onPanStart: (value) {
          setState(() {
            isTabbed = false;
          });
        },

        /// setting the top and left globally
        onPanUpdate: (value) {
          setState(() {
            if (isTabbed && isDragEnable) {
              top = value.localPosition.dy;
              left = value.localPosition.dx;
            }
          });
        },

        child: SizedBox(
          height: height,
          width: width,
          child: isRemoved
              ? widget.child
              : Stack(
                  children: [
                    widget.child,
                    if (hasDeleteWidget)
                      AnimatedOpacity(
                        opacity: isDragging ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 500),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: AnimatedSize(
                            curve: Curves.linear,
                            duration: const Duration(milliseconds: 100),
                            child: SizedBox(
                              key: containerKey1,
                              height: isColliding ? 60 : 40,
                              width: isColliding ? 60 : 40,
                              child: widget.deleteWidget,
                            ),
                          ),
                        ),
                      ),
                    AnimatedPositioned(
                      /// getting top and left distance where the widget will be floating
                      /// if user hasn't provide the dy and dx then the widget will auto matically
                      /// align 20 right and 20 bottom like a FloatingActionButton
                      /// otherwise the bottom and right will be null.
                      top: top == -1 ? null : top,
                      left: left == -1 ? null : left,
                      right: widget.dx == null && left == -1 && top == -1
                          ? 20
                          : null,
                      bottom: widget.dy == null && left == -1 && top == -1
                          ? 20
                          : null,
                      duration: Duration(milliseconds: isDragging ? 100 : 700),

                      /// setting animation time and animation type
                      /// the widget will bounce when it will touch the main screen border.
                      /// other wise it has just a simple ease animation.
                      curve: top >=
                                  (height -
                                      widget.floatingWidgetHeight -
                                      appBarHeight) ||
                              left >= (width - widget.floatingWidgetWidth) ||
                              top <= widget.floatingWidgetHeight ||
                              left <= 1
                          ? Curves.bounceOut
                          : Curves.ease,
                      child: GestureDetector(
                        /// tabbing on widget makes the isTabbed true.
                        /// it is because the widget will move only when we are touch it and drag to to somewhere else in the screen
                        onTap: () {
                          setState(() {
                            isTabbed = true;
                          });
                        },

                        /// also in the case of long press
                        onLongPress: () {
                          setState(() {
                            isTabbed = true;
                          });
                        },

                        /// also in the case when a user start to drag the widget
                        onPanStart: (value) {
                          setState(() {
                            isTabbed = true;
                            isDragging = true;
                          });
                        },

                        /// updating top and left variable
                        onPanUpdate: (value) {
                          setState(() {
                            if (isTabbed && isDragEnable) {
                              isColliding = hasDeleteWidget &&
                                  hasCollision(containerKey1, containerKey2);
                              top = _getDy(value.globalPosition.dy, height);
                              left = _getDx(value.globalPosition.dx, width);
                            }
                          });
                        },

                        /// give a sliding animation
                        onPanEnd: (value) {
                          setState(() {
                            if (isTabbed && isDragEnable) {
                              isDragging = false;
                              left = _getDx(
                                  left +
                                      value.velocity.pixelsPerSecond.dx /
                                          (widget.speed ?? 50.0).toDouble(),
                                  width);
                              top = _getDy(
                                  top +
                                      value.velocity.pixelsPerSecond.dy /
                                          (widget.speed ?? 50.0).toDouble(),
                                  height);
                            }
                            if (hasDeleteWidget && isColliding) {
                              isRemoved = true;
                              widget.onDeleteWidget?.call();
                            }
                          });

                          /// activates only if auto align is set to true
                          /// the widget will automagically align to left or right of the screen now
                          /// after the user release the widget
                          ///  if the widget is on the left screen side then
                          ///  left = width - widget.floatingWidgetWidth;
                          ///  if the widget on the right side then
                          ///  left = 0
                          if (widget.autoAlign) {
                            if (left >= width / 2) {
                              setState(() {
                                left = width - widget.floatingWidgetWidth;
                              });
                            } else {
                              setState(() {
                                left = 0;
                              });
                            }
                          }
                        },

                        /// the floating widget with size
                        child: SizedBox(
                          key: containerKey2,
                          width: widget.floatingWidgetWidth,
                          height: widget.floatingWidgetHeight,
                          child: widget.floatingWidget,
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    isDragEnable = widget.isDraggable;
  }

  /// get the y axis value or top value with screen size
  double _getDy(double dy, double totalHeight) {
    /// checking if top is higher or less than total screen height (except
    /// appbar), if so, then top will be the lowest of highest point of the screen.
    /// top variable will be no more than the screen total height
    double currentTop;
    if (dy >= (totalHeight - widget.floatingWidgetHeight - appBarHeight)) {
      currentTop = (totalHeight - widget.floatingWidgetHeight);
    } else {
      if (dy <= 0) {
        currentTop = widget.floatingWidgetHeight;
      } else {
        currentTop = dy;
      }
    }
    // print(currentTop);
    return currentTop;
  }

  /// get the x axis value or left value with screen size
  double _getDx(double dx, double totalWidth) {
    /// checking if left is higher or less than total screen width ,
    /// if so, then left will be the lowest width (0.o) of highest point of width of the screen
    /// widget will not go out side of the screen.
    double currentLeft;
    if (dx >= (totalWidth - widget.floatingWidgetWidth)) {
      currentLeft = (totalWidth - widget.floatingWidgetWidth);
    } else {
      if (dx <= 0) {
        currentLeft = 0;
      } else {
        currentLeft = dx;
      }
    }

    return currentLeft;
  }
}
