/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package swipelayout.commons

import ohos.state_macro_manage.Component
import ohos.state_macro_manage.BuilderParam
import ohos.state_macro_manage.Link


@Component
public class BottomViewTop {
    @BuilderParam
    let bottomViewTop: () -> Unit
    @Link var bottomViewTopH: Float64 = 100.0
    @Link var parentIsTouch: Bool = false
    private var sX: Float64 = 0.0
    private var sY: Float64 = 0.0
    @Link var offsetX: Float64 = 0.0
    @Link var offsetY: Float64 = 0.0
    @Link  var mHeight: Float64 = 90.0
    @Link var mDuration: Int32 = 200

    func builderParam(moveX: Float64, moveY: Float64){
        if (abs(moveX) < abs(moveY)) { //纵向滑动
            if (moveY < 0.0) { //上滑
                //顶侧菜单开始关闭
                if (this.offsetY > 0.0) {
                    if (this.mHeight - abs(moveY) >= 0.0) {
                        this.offsetY = this.bottomViewTopH + moveY
                        return
                    }
                }
            }
        }
    }

    func build() {
        Column() {
            this.bottomViewTop()
        }.position(x: 0.0, y: -this.bottomViewTopH).onTouch(
            {
                event =>
                if (event.eventType.toString() == "Down") {
                    this.parentIsTouch = false
                    this.sX = event.touches[0].screenX
                    this.sY = event.touches[0].screenY
                }

                if (event.eventType.toString() == "Move") {
                    let moveX = event.touches[0].screenX - this.sX
                    let moveY = event.touches[0].screenY - this.sY
                    builderParam(moveX, moveY)
                }

                if (event.eventType.toString() == "Up") {
                    let moveY = event.touches[0].screenY - this.sY
                    if (moveY >= 0.0) {
                        return
                    }
                    animateTo(
                        AnimateParam(
                            duration: this.mDuration, // 动画时长
                            tempo: 1.0, // 播放速率
                            curve: Curve.FastOutLinearIn, // 动画曲线
                            iterations: 1, // 播放次数
                            playMode: PlayMode.Normal, // 动画模式
                        ),
                        {
                            => if (this.offsetY > 0.0) {
                                if (abs(moveY) >= 20.0) {
                                    this.offsetY = 0.0
                                } else {
                                    this.offsetY = this.bottomViewTopH
                                }
                            }
                        }
                    )
                    this.parentIsTouch = true
                }
            }
        )
    }
}