/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package swipelayout

import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
import ohos.resource_manager.*
import cj_res_swipelayout.app
import ohos.prompt_action.*
import ohos.hilog.*
import std.math.abs

@Component
public class SwipeLayoutLayDownFullList {
    private var mDuration: Int32 = 200
    private var sX: Float64 = 0.0
    private var sY: Float64 = 0.0
    private var mWidth: Float64 = 100.0
    private var mHeight: Float64 = 90.0
    private var bottomViewRightW: Float64 = 320.0
    private var bottomViewLeftW: Float64 = 120.0
    private var bottomViewTopH: Float64 = 100.0
    private var bottomViewBottomH: Float64 = 100.0
    private var itemContent: String = ""
    @BuilderParam
    let bottomViewRight: () -> Unit
    @State
    var offsetX: Float64 = 0.0
    @State
    var offsetY: Float64 = 0.0
    private var rightSlideEnable: Bool = true
    private var leftSlideEnable: Bool = true
    private var previousX: Float64 = 0.0
    private var enableSlide: Array<Bool> = [false, true, true, false]

    func build() {
        Row() {
            Text(this.itemContent).fontSize(14).width(100.percent).height(this.mHeight).fontColor(Color.BLACK).padding(
                5).backgroundColor(Color.WHITE).onTouch(
                {
                    event =>
                    if (event.eventType.toString() == "Down") {
                        this.sX = event.touches[0].screenX
                        this.sY = event.touches[0].screenY
                    }

                    if (event.eventType.toString() == "Move") {
                        let moveX = event.touches[0].screenX - this.sX
                        let moveY = event.touches[0].screenY - this.sY
                        if (abs(moveX) > abs(moveY)) { // 横向滑动
                            if (this.offsetY == 0.0) {
                                if (moveX < 0.0 && moveY < 30.0 && moveY > -30.0) { //左滑
                                    //左侧菜单处于打开状态，开始关闭
                                    if (this.offsetX > 0.0) {
                                        this.rightSlideEnable = false
                                        if (-moveX < this.bottomViewLeftW) {
                                            this.offsetX = moveX + this.bottomViewLeftW
                                        } else {
                                            this.offsetX = 0.0
                                        }
                                        return
                                    }

                                    if (!this.enableSlide[2]) {
                                        return
                                    }
                                    //当前移动距离小于右侧View的宽度，并且没有处于刚好拉出的状态
                                    if (this.rightSlideEnable) {
                                        if (this.offsetX <= 0.0 && this.offsetX > -this.bottomViewRightW && -moveX <=
                                            this.bottomViewRightW) {
                                            this.offsetX = moveX
                                        } else if (-moveX > this.bottomViewRightW) {
                                            this.offsetX = -this.bottomViewRightW
                                            this.sX = event.touches[0].screenX
                                            this.leftSlideEnable = false
                                        }
                                    }
                                } else if (moveX > 0.0 && moveY < 30.0 && moveY > -30.0) { //右滑
                                    //右侧菜单开始关闭
                                    if (this.offsetX < 0.0) {
                                        this.leftSlideEnable = false
                                        if (moveX <= this.bottomViewRightW) {
                                            this.offsetX = moveX - this.bottomViewRightW
                                            return
                                        } else {
                                            this.offsetX = 0.0
                                        }
                                    }

                                    if (!this.enableSlide[0]) {
                                        return
                                    }
                                    //当前移动距离小于左侧View的宽度  并且没有处于刚好拉出的状态
                                    if (this.leftSlideEnable) {
                                        if (this.offsetX >= 0.0 && this.offsetX < this.bottomViewLeftW && moveX <= this.
                                            bottomViewLeftW) {
                                            this.offsetX = moveX
                                        } else if (moveX > this.bottomViewRightW) {
                                            this.offsetX = this.bottomViewLeftW
                                            this.sX = event.touches[0].screenX
                                            this.rightSlideEnable = false
                                        }
                                    }
                                }
                            }
                        }
                        this.previousX = event.touches[0].screenX
                    }

                    if (event.eventType.toString() == "Up") {
                        let moveX = event.touches[0].screenX - this.sX
                        let moveY = event.touches[0].screenY - this.sY
                        animateTo(
                            AnimateParam(
                                duration: this.mDuration, // 动画时长
                                tempo: 1.0, // 播放速率
                                curve: Curve.FastOutLinearIn, // 动画曲线
                                iterations: 1, // 播放次数
                                playMode: PlayMode.Normal, // 动画模式
                                onFinish: {
                                    =>
                                    this.rightSlideEnable = true
                                    this.leftSlideEnable = true
                                }
                            ),
                            {
                                =>
                                if (this.offsetX > 0.0 && this.leftSlideEnable) {
                                    if (moveX >= 40.0) {
                                        this.offsetX = this.bottomViewLeftW
                                    } else if (moveX > 0.0) {
                                        this.offsetX = 0.0
                                    }
                                    if (moveX < -40.0) {
                                        this.offsetX = 0.0
                                    } else if (moveX < 0.0) {
                                        this.offsetX = this.bottomViewLeftW
                                    }
                                    return
                                }

                                if (this.offsetX < 0.0 && this.rightSlideEnable) {
                                    if (moveX >= 40.0) {
                                        this.offsetX = 0.0
                                    } else if (moveX > 0.0) {
                                        this.offsetX = -this.bottomViewRightW
                                    }

                                    if (moveX <= -40.0) {
                                        this.offsetX = -this.bottomViewRightW
                                    } else if (moveX < 0.0) {
                                        this.offsetX = 0.0
                                    }
                                    return
                                }

                                if (this.offsetY > 0.0) {
                                    if (moveY >= 20.0) {
                                        this.offsetY = this.bottomViewTopH
                                    } else {
                                        this.offsetY = 0.0
                                    }
                                    return
                                }

                                if (this.offsetY < 0.0) {
                                    if (moveY <= -20.0) {
                                        this.offsetY = -this.bottomViewBottomH
                                    } else {
                                        this.offsetY = 0.0
                                    }
                                    return
                                }
                            }
                        )
                    }
                }
            )

            Row() {
                this.bottomViewRight()
            }.height(this.mHeight).width(px2vp(this.bottomViewRightW.px) ?? this.bottomViewRightW.px).onTouch(
                {
                    event =>
                    if (event.eventType.toString() == "Down") {
                        this.sX = event.touches[0].screenX
                        this.sY = event.touches[0].screenY
                    }

                    if (event.eventType.toString() == "Move") {
                        let moveX = event.touches[0].screenX - this.sX
                        let moveY = event.touches[0].screenY - this.sY
                        if (abs(moveX) > abs(moveY)) { // 横向滑动
                            if (this.offsetY == 0.0) {
                                if (moveX < 0.0 && moveY < 30.0 && moveY > -30.0) { //左滑
                                } else if (moveX > 0.0 && moveY < 30.0 && moveY > -30.0) { //右滑
                                    if (this.offsetX < 0.0) {
                                        this.leftSlideEnable = false
                                        if (moveX <= this.bottomViewRightW) {
                                            this.offsetX = moveX - this.bottomViewRightW
                                            return
                                        } else {
                                            this.offsetX = 0.0
                                        }
                                    }
                                }
                            }
                        }
                        this.previousX = event.touches[0].screenX
                    }

                    if (event.eventType.toString() == "Up") {
                        let moveX = event.touches[0].screenX - this.sX
                        animateTo(
                            AnimateParam(
                                duration: this.mDuration, // 动画时长
                                tempo: 1.0, // 播放速率
                                curve: Curve.FastOutLinearIn, // 动画曲线
                                iterations: 1, // 播放次数
                                playMode: PlayMode.Normal, // 动画模式
                                onFinish: {
                                    =>
                                    this.rightSlideEnable = true
                                    this.leftSlideEnable = true
                                }
                            ),
                            {
                                => if (this.offsetX < 0.0 && this.rightSlideEnable) {
                                    if (moveX >= 40.0) {
                                        this.offsetX = 0.0
                                    } else if (moveX > 0.0) {
                                        this.offsetX = -this.bottomViewRightW
                                    }

                                    if (moveX <= -40.0) {
                                        this.offsetX = -this.bottomViewRightW
                                    } else if (moveX < 0.0) {
                                        this.offsetX = 0.0
                                    }
                                    return
                                }
                            }
                        )
                    }
                }
            ).backgroundColor(0xFF5534)
        }.width(this.mWidth.percent).height(this.mHeight).position(x: px2vp(this.offsetX.px) ?? this.offsetX.px,
            y: px2vp(this.offsetY.px) ?? this.offsetY.px)
    }
}
