/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
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
    private let bottomViewBottomH: Float64 = 120.0
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
        }).height(bottomViewTopH).width(100.percent)
    }

    @Builder
    func BottomViewBottom() {
        Image(@r(app.media.top)).backgroundColor(0x595a57).padding(12).objectFit(ImageFit.Contain).onClick(
            {
            evt => PromptAction.showToast(
                message: "click search",
                duration: 1500,
            )
        }).height(bottomViewBottomH).width(100.percent)
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
                    bottomViewTopH: bottomViewTopH,
                    bottomViewBottomH: bottomViewBottomH,
                    mWidth: 100.0,
                    mHeight: 700.0,
                    parentIsTouch: true
                )
            }
        }
    }
}
