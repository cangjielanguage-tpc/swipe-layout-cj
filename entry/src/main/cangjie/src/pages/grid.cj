/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

package ohos_app_cangjie_entry.pages

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
    func bottomViewRight() {
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
                        item: Int32, _: Int64 => GridItem {
                            ColumnSplit() {
                                SwipeLayoutLayDownFullGrid(
                                    bottomViewRight: bottomViewRight,
                                    mWidth: 100.0,
                                    mHeight: mHeight,
                                    bottomViewRightW: bottomViewRightW,
                                    itemContent: "${item.toString() + this.text}"
                                )
                            }.backgroundColor(0xd2d3cc)
                        }
                    }
                )
            }.columnsGap(10).rowsGap(10).columnsTemplate("1fr 1fr").width(100.percent)
        }.width(100.percent).height(100.percent).backgroundColor(0xDCDCDC).padding(10)
    }
}
