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

@Entry
@Component
class MyView {
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
        }else if (index == 1) {
            Router.push(url: "CustomContainerUserGrid")
        }else if (index == 2) {
            Router.push(url: "CustomContainerUserList")
        }
    }

    func build() {
        Column() {
            Stack(Alignment.Top) {
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