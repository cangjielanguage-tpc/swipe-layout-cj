/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package ohos_app_cangjie_entry.pages
internal import cj_res_entry.app
import ohos.display.*
import swipelayout.SwipeLayoutLayDownFullList
import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
import ohos.hilog.*
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
