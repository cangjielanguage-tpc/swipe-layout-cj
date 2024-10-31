# swipelayout4cj 特性文档

## 介绍

swipelayout4cj 用于设置屏幕顶部、底部、左侧和右侧的滑动布局。

## 1 自定义滑动容器

### 1.1 SwipeLayout Component API Description

- 用户自定义 组件使用时推荐用 ColumnSplit 包裹
- surfaceView 滑动组件宽度、高度推荐和组件宽度、高度（ mWidth、mHeight）保持一致。
- 用户自定义 bottomViewRight 右滑动组件宽度推荐和 SwipeLayout 组件参数（bottomViewRight）保持一致。
- 用户自定义 bottomViewLeft 左滑动组件宽度推荐和 SwipeLayout 组件参数（bottomViewLeftW）保持一致。
- 用户自定义 bottomViewTop 顶部滑动组件宽度推荐和 SwipeLayout 组件参数（bottomViewTopH）保持一致。
- 用户自定义 bottomViewBottom 底部滑动组件宽度推荐和 SwipeLayout 组件参数（bottomViewBottomH）保持一致。

```cangjie
@Component
public class SwipeLayout {
    @BuilderParam
    let surfaceView: () -> Unit              // 滑动组件  
    @BuilderParam
    let bottomViewRight: () -> Unit          // 设置右侧滑动布局样式
    @BuilderParam
    let bottomViewLeft: () -> Unit           // 设置左侧滑动布局样式
    @BuilderParam
    let bottomViewTop: () -> Unit            // 设置顶部滑动布局样式
    @BuilderParam
    let bottomViewBottom: () -> Unit         // 设置底部滑动布局样式
    var mWidth: Float64                      // 设置组件宽度，单位 百分比
    var mHeight: Float64                     // 设置组件高度，单位 vp
    var bottomViewRightW: Float64            // 设置右侧布局宽度，单位 vp
    var bottomViewLeftW: Float64             // 设置右侧布局宽度，单位 vp
    var bottomViewTopH: Float64              // 设置右侧布局宽度，单位 vp
    var bottomViewBottomH: Float64           // 设置右侧布局宽度，单位 vp
    var layoutRight: Bool                    // 是否开启右侧滑动，默认 true
    var layoutLeft: Bool                     // 是否开启左侧滑动，默认 true
    var layoutBottom: Bool                   // 是否开启底部滑动，默认 true    
    var layoutTop: Bool                      // 是否开启顶部滑动，默认 true
    @Link
    var parentIsTouch: Bool                  // 父组件是否触摸（用作组件嵌套）
    var mDuration: Int32                     // 设置动画持续时间
}
```

### 1.2 示例

```cangjie
package ohos_app_cangjie_entry.pages

import cj_res_entry.app
import swipelayout.SwipeLayout
import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
import ohos.prompt_action.*

@Entry
@Component
class CustomContainerUser {
    private let bottomViewRightW: Float64 = 120.0
    private let bottomViewLeftW: Float64 = 120.0
    private let bottomImageBottomH: Float64 = 120.0
    private let bottomViewTopH: Float64 = 100.0
    private let mHeight: Float64 = 700.0
    
    @Builder
    func SurfaceView() {
        Text(
            "因为一段经历、一个故事……祖国在每一位公民心中不断变得具象、立体、厚重，成为人们最坚实的依靠、最深切的思念、最荣耀的象征。"
        ).fontSize(15).width(100.percent).height(mHeight).fontColor(0x968d8d).padding(5).onClick(
            {
            evt => PromptAction.showToast(
                message: "Click on surface",
                duration: 1500,
            )
        })
    }

    @Builder
    func BottomViewRight() {
        Row() {
            Image(@r(app.media.left)).backgroundColor(0xe8eca5).width(33.33.percent).height(100.percent).padding(8).
                objectFit(ImageFit.Contain).onClick({
                evt => PromptAction.showToast(
                    message: "left",
                    duration: 1500,
                )
            })
            Image(@r(app.media.star)).backgroundColor(0x0dd398).height(100.percent).width(33.33.percent).padding(8).
                objectFit(ImageFit.Contain).onClick({
                evt => PromptAction.showToast(
                    message: "Star",
                    duration: 1500,
                )
            })
            Image(@r(app.media.trash)).backgroundColor(0xdb0f4f).width(33.33.percent).height(100.percent).padding(8).
                objectFit(ImageFit.Contain).onClick(
                {
                evt => PromptAction.showToast(
                    message: "Trash Bin",
                    duration: 1500,
                )
            })
        }.height(mHeight).width(bottomViewRightW)
    }

    @Builder
    func BottomViewLeft() {
        Row() {
            Text("Archive").backgroundColor(0xe83e5e).width(50.percent).height(100.percent).textAlign(TextAlign.Center).
                fontColor(Color.WHITE).fontSize(14).onClick(
                {
                evt => PromptAction.showToast(
                    message: "click Archive",
                    duration: 500,
                )
            })
            Text("Delete").backgroundColor(0xbbbebd).width(50.percent).height(100.percent).textAlign(TextAlign.Center).
                fontColor(0x333333).fontSize(14).onClick(
                {
                evt => PromptAction.showToast(
                    message: "click Delete",
                    duration: 1500,
                )
            })
        }.height(mHeight).width(bottomViewLeftW)
    }

    @Builder
    func BottomViewTop() {
        Image(@r(app.media.down)).backgroundColor(0x595a57).padding(12).objectFit(ImageFit.Contain).onClick(
            {
            evt => PromptAction.showToast(
                message: "click down",
                duration: 1500,
            )
        }).height(mHeight).width(100.percent)
    }

    @Builder
    func BottomViewBottom() {
        Image(@r(app.media.top)).backgroundColor(0x595a57).padding(12).objectFit(ImageFit.Contain).onClick(
            {
            evt => PromptAction.showToast(
                message: "click search",
                duration: 1500,
            )
        }).height(mHeight).width(100.percent)
    }

    func build() {
        Column() {
            ColumnSplit() {
                Text("CustomView").width(100.percent).height(100.percent).padding(left: 20).fontSize(18).margin(top: 10)
            }.backgroundColor(0xb0a6a6).width(100.percent).height(60)
            ColumnSplit() {
                SwipeLayout(
                    layoutRight: true,
                    layoutLeft: true,
                    layoutBottom: true,
                    layoutTop: true,
                    surfaceView: SurfaceView,
                    bottomViewRight: BottomViewRight,
                    bottomViewLeft: BottomViewLeft,
                    bottomViewTop: BottomViewTop,
                    bottomViewBottom: BottomViewBottom,
                    bottomViewLeftW: 120.0,
                    bottomViewRightW: 120.0,
                    mWidth: 100.0,
                    mHeight: 700.0,
                    parentIsTouch: true
                )
            }
        }
    }
}

```

## 2 List 滑动容器

### 2.1 SwipeLayoutLayDownFullList Component API Description

- 用户自定义 surfaceView 滑动组件宽度、高度推荐和组件宽度、高度（ mWidth、mHeight）保持一致。
- 用户自定义 bottomViewRight 右滑动组件宽度推荐和 SwipeLayout 组件参数（bottomViewRight）保持一致。
- 用户自定义 bottomViewLeft 左滑动组件宽度推荐和 SwipeLayout 组件参数（bottomViewLeftW）保持一致。
- 用户自定义 bottomViewTop 顶部滑动组件宽度推荐和 SwipeLayout 组件参数（bottomViewTopH）保持一致。
- 用户自定义 bottomViewBottom 底部滑动组件宽度推荐和 SwipeLayout 组件参数（bottomViewBottomH）保持一致。

```cangjie
@Component
public class SwipeLayoutLayDownFullList {
    @Link
    var itemContent: String                // List 组件内容
    @Link
    var itemId: Int64                      // List 组件索引
    var mWidth: Float64                    // 设置组件宽度，单位 百分比
    var mHeight: Float64                   // 设置组件高度，单位 vp
    var bottomViewRightW: Float64          // 设置右侧布局宽度，单位 vp
    @BuilderParam
    let surfaceView: () -> Unit            // 滑动组件
    @BuilderParam
    let bottomViewRight: () -> Unit        // 设置右侧滑动布局样式
    var mDuration: Int32                   // 设置动画持续时间
}
```
### 2.2 示例

```cangjie
internal import cj_res_entry.app
import ohos.display.*
import swipelayout.SwipeLayoutLayDownFullList
import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
import ohos.prompt_action.*

@Entry
@Component
public class CustomContainerUserList {
    private var arr: Array<Int64> = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23,
    24, 25, 26]
    private var text: String = ".Do not, for one repulse, forgo the purpose that you resolved to effort."

    private var disWidth: Int32 = 0

    protected override func aboutToAppear() {
        this.disWidth = getDefaultDisplaySync().width
    }
    @Builder
    func surfaceView(itemContent: String, itemId: Int64) {
            Text("${itemContent + this.text}").fontSize(16).width(100.percent).height(90).fontColor(Color.BLACK).padding(
                5).backgroundColor(Color.WHITE)
    }
    @Builder
    func bottomViewRight(itemId: Int64) {
        Image(@r(app.media.trash)).backgroundColor(0xff64e3b9).width(10.percent).height(100.percent).padding(10).objectFit(
            ImageFit.Contain).onClick({
            evt => PromptAction.showToast(
                message: "Magnifier",
                duration: 1500,
            )
        })
        Text("Delete item?").fontSize(14).height(100.percent).fontColor(Color.WHITE).padding(5).onClick(
            {
            evt => PromptAction.showToast(
                message: "Click on surface",
                duration: 1500,
            )
        })

        Blank()

        Button("Yes,Delete").backgroundColor(Color.WHITE).fontColor(0xe52626).fontSize(14).width(35.percent).height(
            70.px).shape(ShapeType.Capsule).margin(right: 10.0).onClick(
            {
            event => PromptAction.showToast(message: "click delete", duration: 1500)
        })
    }
    func build() {
        Column() {
            List(initialIndex: 0) {
                ForEach(
                    this.arr,
                    itemGeneratorFunc: {
                        item: Int64, index: Int64 => ListItem() {
                            SwipeLayoutLayDownFullList(
                                bottomViewRightW: Float64(this.disWidth),
                                surfaceView: surfaceView,
                                bottomViewRight: bottomViewRight,
                                mWidth: 100.0,
                                mHeight: 90.0,
                                itemContent: item.toString(),
                                itemId: index
                            )
                        }
                    }
                )
            }.divider(strokeWidth: 5.px, color: Color(0xd2d3cc)).width(100.percent)
        }.width(100.percent).height(100.percent).backgroundColor(0xDCDCDC).padding(top: 5)
    }
}
```

## 3 Grid 滑动容器

### 3.1 CustomContainerUserGrid Component API Description

- 组件使用时推荐用 ColumnSplit 包裹
- 用户自定义 surfaceView 滑动组件宽度、高度推荐和组件宽度、高度（ mWidth、mHeight）保持一致。
- 用户自定义 bottomViewRight 右滑动组件宽度推荐和 SwipeLayout 组件参数（bottomViewRight）保持一致。
- 用户自定义 bottomViewLeft 左滑动组件宽度推荐和 SwipeLayout 组件参数（bottomViewLeftW）保持一致。
- 用户自定义 bottomViewTop 顶部滑动组件宽度推荐和 SwipeLayout 组件参数（bottomViewTopH）保持一致。
- 用户自定义 bottomViewBottom 底部滑动组件宽度推荐和 SwipeLayout 组件参数（bottomViewBottomH）保持一致。

```cangjie
@Component
public class CustomContainerUserGrid {
    @Link
    var itemContent: String                // Grid 组件内容
    @Link
    var itemId: Int64                      // Grid 组件索引
    var mWidth: Float64                    // 设置组件宽度，单位 百分比
    var mHeight: Float64                   // 设置组件高度，单位 vp
    var bottomViewRightW: Float64          // 设置右侧布局宽度，单位 vp
    @BuilderParam
    let surfaceView: () -> Unit            // 滑动组件
    @BuilderParam
    let bottomViewRight: () -> Unit        // 设置右侧滑动布局样式
    var mDuration: Int32                   // 设置动画持续时间
}
```
### 3.2 示例

```cangjie
internal import cj_res_entry.app
import swipelayout.SwipeLayoutLayDownFullGrid
import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
import ohos.prompt_action.*

@Entry
@Component
class CustomContainerUserGrid {
    private var arr: Array<Int32> = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16]
    private var text = ".If winter comes , can spring be far behind ?\n"
    private let bottomViewRightW: Float64 = 40.0
    private let mHeight: Float64 = 80.0

    @Builder
    func surfaceView(itemContent: String, itemId: Int64) {
            Text("${itemContent + this.text}").fontSize(16).width(100.percent).height(80.0).fontColor(0x000000).backgroundColor(
        Color.WHITE).padding(5)
    }

    @Builder
    func bottomViewRight(itemId: Int64) {
        Image(@r(app.media.trash)).backgroundColor(0xff64e3b9).width(100.percent).height(100.percent).padding(8).
            objectFit(ImageFit.Contain).onClick({
            evt => PromptAction.showToast(
                message: "Trash Bin",
                duration: 1500,
            )
        })
    }

    func build() {
        Column() {
            Grid {
                ForEach(
                    this.arr,
                    itemGeneratorFunc: {
                        item: Int32, index: Int64 => GridItem {
                            ColumnSplit() {
                                SwipeLayoutLayDownFullGrid(
                                    surfaceView: surfaceView,
                                    bottomViewRight: bottomViewRight,
                                    mWidth: 100.0,
                                    mHeight: mHeight,
                                    bottomViewRightW: bottomViewRightW,
                                    itemContent: item.toString(),
                                    itemId: index
                                )
                            }.backgroundColor(0xd2d3cc)
                        }
                    }
                )
            }.columnsGap(10).rowsGap(10).columnsTemplate("1fr 1fr").width(100.percent)
        }.width(100.percent).height(100.percent).backgroundColor(0xDCDCDC).padding(10)
    }
}
```

## 4 嵌套滑动容器

### 4.1 SwipeLayoutLayDownRoot Component API Description

- 组件使用时推荐用 ColumnSplit 包裹
- 用户自定义 surfaceView 滑动组件宽度、高度推荐和组件宽度、高度（ mWidth、mHeight）保持一致。
- 用户自定义 bottomViewRight 右滑动组件宽度推荐和 SwipeLayout 组件参数（bottomViewRight）保持一致。
- 用户自定义 bottomViewLeft 左滑动组件宽度推荐和 SwipeLayout 组件参数（bottomViewLeftW）保持一致。
- 用户自定义 bottomViewTop 顶部滑动组件宽度推荐和 SwipeLayout 组件参数（bottomViewTopH）保持一致。
- 用户自定义 bottomViewBottom 底部滑动组件宽度推荐和 SwipeLayout 组件参数（bottomViewBottomH）保持一致。

```cangjie
@Component
public class SwipeLayoutLayDownRoot {
    @BuilderParam
    let surfaceView: () -> Unit              // 滑动组件
    @BuilderParam
    var innerSwipeLayout: () -> Unit         // 子组件滑动容器
    @BuilderParam
    let bottomViewRight: () -> Unit          // 设置右侧滑动布局样式
    @BuilderParam
    let bottomViewLeft: () -> Unit           // 设置左侧滑动布局样式
    @BuilderParam
    let bottomViewTop: () -> Unit            // 设置顶部滑动布局样式
    @BuilderParam
    let bottomViewBottom: () -> Unit         // 设置底部滑动布局样式
    var mWidth: Float64                      // 设置组件宽度，单位 百分比
    var mHeight: Float64                     // 设置组件高度，单位 vp
    var bottomViewRightW: Float64            // 设置右侧布局宽度，单位 vp
    var bottomViewLeftW: Float64             // 设置左侧布局宽度，单位 vp
    var bottomViewTopH: Float64              // 设置顶部布局宽度，单位 vp
    var bottomViewBottomH: Float64           // 设置底部布局宽度，单位 vp
    @Link    
    var isTouch: Bool                        // 父组件是否触摸（用作组件嵌套）
    var mDuration: Int32                     // 设置动画持续时间
}
```
### 4.2 示例

```cangjie
/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

package ohos_app_cangjie_entry

internal import ohos.base.LengthProp
internal import ohos.component.Column
internal import ohos.component.Row
internal import ohos.component.Button
internal import ohos.component.Text
internal import ohos.component.CustomView
internal import ohos.component.CJEntry
internal import ohos.component.loadNativeView
internal import ohos.state_manage.SubscriberManager
internal import ohos.state_manage.ObservedProperty
internal import ohos.state_manage.LocalStorage
import ohos.state_macro_manage.Entry
import ohos.state_macro_manage.Component
import ohos.state_macro_manage.State
import ohos.state_macro_manage.r
import swipelayout.*
import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
import ohos.router.*
import ohos.prompt_action.*

@Entry
@Component
class MyView {
    @State
    var isTouch: Bool = true
    
    @Builder
    func surfaceView() {
        Text(
            "SwipeLayout 用于设置屏幕顶部、底部、左侧和右侧的滑动布局。").
            fontSize(12).width(100.percent).height(100).fontColor(Color.BLACK).padding(5).maxLines(2).onClick(
            {
            evt => PromptAction.showToast(
                message: "Click on surface",
                duration: 1000,
            )
        }).backgroundColor(Color.WHITE)
    }
    @Builder
    func layOutsurfaceView() {
        Text("用平和的心态交往时间。").fontSize(12).width(100.percent).height(100).fontColor(Color.BLACK).padding(5).
            maxLines(2).onClick({
            evt => PromptAction.showToast(
                message: "Click on surface",
                duration: 1000,
            )
        }).backgroundColor(Color.WHITE)
    }
    @Builder
    func fullsurfaceView() {
        Text("SwipeLayout is used to set the swipe layouts on the top, bottom, left, and right of the screen. ").fontSize(12).width(
            100.percent).height(100).fontColor(Color.BLACK).padding(5).maxLines(2).onClick(
            {
            evt => PromptAction.showToast(
                message: "Click on surface",
                duration: 1500
            )
        }).backgroundColor(Color.WHITE)
    }

    @Builder
    func bottomViewRight() {
        Image(@r(app.media.magnifier)).backgroundColor(0xe8eca5).width(33.33.percent).height(100.percent).padding(8).
            objectFit(ImageFit.Contain).onClick({
            evt => PromptAction.showToast(
                message: "Magnifier",
                duration: 1500,
            )
        })

        Image(@r(app.media.star)).backgroundColor(0x0dd398).height(100.percent).width(33.33.percent).padding(8).
            objectFit(ImageFit.Contain).onClick({
            evt => PromptAction.showToast(
                message: "Star",
                duration: 1500,
            )
        })

        Image(@r(app.media.trash)).backgroundColor(0xdb0f4f).width(33.33.percent).height(100.percent).padding(8).
            objectFit(ImageFit.Contain).onClick({
            evt => PromptAction.showToast(
                message: "Trash Bin",
                duration: 1500,
            )
        })
    }
    @Builder
    func fullbottomViewRight() {
        Image(@r(app.media.star)).backgroundColor(0xb1b2aa).width(100.percent).height(100.percent).padding(8).objectFit(
            ImageFit.Contain).onClick({
            evt => PromptAction.showToast(
                message: "Magnifier",
                duration: 1500,
            )
        })
    }

    @Builder
    func bottomViewLeft() {
        Text("Archive").backgroundColor(0xe83e5e).width(50.percent).height(100.percent).fontColor(Color.WHITE).textAlign(
            TextAlign.Center).fontSize(14).onClick(
            {
            evt => PromptAction.showToast(
                message: "click Archive",
                duration: 1500,
            )
        })
        Text("Delete").backgroundColor(0xbbbebd).width(50.percent).height(100.percent).fontColor(0x333333).fontSize(14).
            textAlign(TextAlign.Center).onClick(
            {
            evt => PromptAction.showToast(
                message: "click Delete",
                duration: 1500,
            )
        })
    }

    @Builder
    func bottomViewTop() {
        Image(@r(app.media.star)).backgroundColor(0xb9ee4d).padding(12).objectFit(ImageFit.Contain).onClick(
            {
            evt => PromptAction.showToast(
                message: "click search",
                duration: 1500,
            )
        }).height(100).width(100.percent)
    }
    @Builder
    func fullbottomViewTop() {
        Image(@r(app.media.star)).backgroundColor(0xb9ee4d).padding(12).objectFit(ImageFit.Contain).onClick(
            {
            evt => PromptAction.showToast(
                message: "click search",
                duration: 1500,
            )
        }).height(100.0).width(100.percent)
    }

    @Builder
    func bottomViewBottom() {
        Image(@r(app.media.magnifier)).backgroundColor(0x595a57).padding(12).objectFit(ImageFit.Contain).onClick(
            {
            evt => PromptAction.showToast(
                message: "click search",
                duration: 1500,
            )
        }).height(100).width(100.percent)
    }
    //-------------root------
    @Builder
    func rootBottomViewRight() {
        Image(@r(app.media.take_photo)).backgroundColor(Color.WHITE).padding(12).objectFit(ImageFit.Contain).
            interpolation(ImageInterpolation.Medium).onClick(
            {
            evt => PromptAction.showToast(
                message: "click search",
                duration: 1500,
            )
        }).height(1080).width(120)
    }

    @Builder
    func rootBottomViewLeft() {
        Image(@r(app.media.take_photo)).backgroundColor(Color.WHITE).padding(12).objectFit(ImageFit.Contain).
            interpolation(ImageInterpolation.Medium).onClick(
            {
            evt => PromptAction.showToast(
                message: "click search",
                duration: 1500,
            )
        }).height(1080).width(120)
    }

    @Builder
    func rootBottomViewTop() {
        Image(@r(app.media.take_photo)).padding(12).objectFit(ImageFit.Contain).interpolation(ImageInterpolation.Medium).
            backgroundColor(Color.WHITE).onClick(
            {
            evt => PromptAction.showToast(
                message: "click search",
                duration: 1500,
            )
        }).height(120).width(100.percent)
    }
    @Builder
    func rootBottomViewBottom() {
        Image(@r(app.media.take_photo)).backgroundColor(Color.WHITE).padding(12).objectFit(ImageFit.Contain).
            interpolation(ImageInterpolation.Medium).onClick(
            {
            evt => PromptAction.showToast(
                message: "click search",
                duration: 1500,
            )
        }).height(120).width(100.percent)
    }
    @Builder
    func rootInnerSwipeLayout() {
        ColumnSplit() {
            SwipeLayoutLayDown(
                surfaceView: surfaceView,
                bottomViewRight: bottomViewRight,
                bottomViewLeft: bottomViewLeft,
                bottomViewTop: bottomViewTop,
                bottomViewBottom: bottomViewBottom,
                bottomViewLeftW: 120.0,
                bottomViewRightW: 120.0,
                mWidth: 100.0,
                mHeight: 100.0,
                parentIsTouch: isTouch
            )
        }
        ColumnSplit() {
            SwipeLayoutLayOut(
                surfaceView: layOutsurfaceView,
                bottomViewRight: bottomViewRight,
                bottomViewRightW: 120.0,
                mWidth: 100.0,
                mHeight: 100.0,
                parentIsTouch: isTouch
            )
        }
        ColumnSplit() {
            SwipeLayoutLayDownFull(
                surfaceView: fullsurfaceView,
                bottomViewRight: fullbottomViewRight,
                bottomViewTop: fullbottomViewTop,
                bottomViewRightW: 300.0,
                mWidth: 100.0,
                mHeight: 100.0,
                parentIsTouch: isTouch
            )
        }
        Image(@r(app.media.arrow_up)).backgroundColor(Color.WHITE).objectFit(ImageFit.Contain).onClick(
            {
            evt => PromptAction.showToast(
                message: "click search",
                duration: 1500,
            )
        }).height(90).width(90).margin(top: 40)
    }

    func build() {
        Column() {
            Stack(Alignment.Top) {
                Column() {
                    ColumnSplit() {
                        SwipeLayoutLayDownRoot(
                            bottomViewLeftW: 120.0,
                            bottomViewRightW: 120.0,
                            mWidth: 100.0,
                            mHeight: 1080.0,
                            bottomViewRight: rootBottomViewRight,
                            bottomViewLeft: rootBottomViewLeft,
                            bottomViewTop: rootBottomViewTop,
                            bottomViewBottom: rootBottomViewBottom,
                            innerSwipeLayout: rootInnerSwipeLayout,
                            isTouch: isTouch
                        )
                    }
                }.margin(top: 66)
            }.backgroundColor(0xfdffffff)
        }.width(100.percent).height(100.percent).backgroundColor(0xDCDCDC)
    }
}
```