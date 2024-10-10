/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
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
    var dialogController: CustomDialogController = CustomDialogController(
        CustomDialogControllerOptions(
            builder: CustomDialogExample(confirm: this.onAccept),
            alignment: DialogAlignment.Top,
            offset: Offset(170.vp, 5.vp),
            autoCancel: true,
        )
    )
    func onAccept(index: Int32) {
        if (index == 0) {
            Router.push(url: "CustomContainerUser")
        } else if (index == 1) {
            Router.push(url: "CustomContainerUserGrid")
        } else if (index == 2) {
            Router.push(url: "CustomContainerUserList")
        }
    }

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
                            bottomImageBottomH: 120.0,
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

                Row(5) {
                    Blank()
                    Text("SwipeLayout").width(55.percent).fontColor(Color.WHITE).fontSize(20).margin(top: 4)
                    Image(@r(app.media.more)).width(66).height(66).margin(right: 5).onClick(
                        {
                        event => this.dialogController.open()
                    })
                }.width(100.percent).height(66).backgroundColor(0x666060)
            }.backgroundColor(0xfdffffff)
        }.width(100.percent).height(100.percent).backgroundColor(0xDCDCDC)
    }
}

@CustomDialog
class CustomDialogExample {
    var controller: Option<CustomDialogController> = CustomDialogController(
        CustomDialogControllerOptions(
            cancel: {=>},
            autoCancel: true,
            alignment: DialogAlignment.Center
        )
    )
    var confirm: (index: Int32) -> Unit = {index =>}

    func build() {
        Column() {
            Text("CustomView").width(100.percent).height(60).padding(left: 20).fontSize(18).margin(top: 10).onClick(
                {
                    evt =>
                    this.controller.getOrThrow().close()
                    this.confirm(0)
                }
            )
            Text("GridView").width(100.percent).height(60).padding(left: 20).fontSize(18).margin(top: 10).onClick(
                {
                    evt =>
                    this.controller.getOrThrow().close()
                    this.confirm(1)
                }
            )
            Text("ListView").width(100.percent).height(60).padding(left: 20).fontSize(18).margin(top: 10).onClick(
                {
                    evt =>
                    this.controller.getOrThrow().close()
                    this.confirm(2)
                }
            )
        }.backgroundColor(0xb0a6a6)
    }
}
