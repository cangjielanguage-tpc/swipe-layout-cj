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
import std.math.abs
import ohos.hilog.*

@Component
public class SwipeLayout {
    @Link
    var parentIsTouch: Bool
    private var mDuration: Int32 = 200
    @BuilderParam
    let surfaceView: () -> Unit
    @BuilderParam
    let bottomViewRight: () -> Unit
    @BuilderParam
    let bottomViewLeft: () -> Unit
    @BuilderParam
    let bottomViewTop: () -> Unit
    @BuilderParam
    let bottomViewBottom: () -> Unit
    private var sX: Float64 = 0.0
    private var sY: Float64 = 0.0
    private var mWidth: Float64 = 100.0
    private var mHeight: Float64 = 180.0
    private var bottomViewRightW: Float64 = 180.0
    private var bottomViewLeftW: Float64 = 180.0
    private var bottomViewBottomH: Float64 = 180.0
    private var layoutRight: Bool = true
    private var layoutLeft: Bool = true
    private var layoutBottom: Bool = true
    private var layoutTop: Bool = true
    @State
    var offsetX: Float64 = 0.0
    @State
    var offsetY: Float64 = 0.0
    private var rightSlideEnable = true
    private var leftSlideEnable = true
    private var previousX: Float64 = 0.0

    func build() {
        Column() {
            ColumnSplit() {
                this.bottomViewTop()
            }.position(x: 0, y: -Int64(this.mHeight)).onTouch(
                {
                    event =>
                    if (event.eventType.toString() == "Down") {
                        this.sX = event.touches[0].screenX
                        this.sY = event.touches[0].screenY
                    }

                    if (event.eventType.toString() == "Move") {
                        let moveX = event.touches[0].screenX - this.sX
                        let moveY = event.touches[0].screenY - this.sY
                        if (abs(moveX) < abs(moveY)) { //纵向滑动
                            if (moveY < 0.0) { //上滑
                                //顶侧菜单开始关闭
                                if (this.offsetY > 0.0) {
                                    if (Float64(this.mHeight) - abs(moveY) >= 0.0) {
                                        this.offsetY = this.mHeight + moveY
                                        return
                                    }
                                }
                            }
                        }
                    }

                    if (event.eventType.toString() == "Up") {
                        let moveY = event.touches[0].screenY - this.sY
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
                                        this.offsetY = this.mHeight
                                    }
                                }
                            }
                        )
                    }
                }
            )

            Row() {
                ColumnSplit() {
                    this.bottomViewLeft()
                }.position(x: -this.bottomViewLeftW, y: 0.0)

                ColumnSplit() {
                    this.surfaceView()
                }.onTouch(
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
                            if (abs(moveX) > abs(moveY)) { // 横向滑动
                                if (this.offsetY == 0.0) {
                                    if (layoutLeft && moveX < 0.0 && moveY < 30.0 && moveY > -30.0) { //左滑
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

                                        //当前移动距离小于右侧View的宽度，并且没有处于刚好拉出的状态
                                        if (this.rightSlideEnable) {
                                            if (this.offsetX <= 0.0 && this.offsetX > -this.bottomViewRightW &&
                                                -moveX <= this.bottomViewRightW) {
                                                this.offsetX = moveX
                                            } else if (-moveX > this.bottomViewRightW) {
                                                this.offsetX = -this.bottomViewRightW
                                                this.sX = event.touches[0].screenX
                                                this.leftSlideEnable = false
                                            }
                                        }
                                    } else if (layoutRight && moveX > 0.0 && moveY < 30.0 && moveY > -30.0) { //右滑
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

                                        //当前移动距离小于左侧View的宽度  并且没有处于刚好拉出的状态
                                        if (this.leftSlideEnable) {
                                            if (this.offsetX >= 0.0 && this.offsetX < this.bottomViewLeftW && moveX <=
                                                this.bottomViewLeftW) {
                                                this.offsetX = moveX
                                            } else if (moveX > this.bottomViewRightW) {
                                                this.offsetX = this.bottomViewLeftW
                                                this.sX = event.touches[0].screenX
                                                this.rightSlideEnable = false
                                            }
                                        }
                                    }
                                }
                            } else { //纵向滑动
                                if (this.offsetX == 0.0) {
                                    if (layoutTop && moveY > 0.0) { //下滑
                                        //底部菜单开始关闭
                                        if (this.offsetY < 0.0) {
                                            if (moveY - this.mHeight <= 0.0) { //(moveY - this.bottomViewBottomH <= 0.0)
                                                this.offsetY = moveY - this.mHeight
                                                return
                                            }
                                        }
                                        //当前移动距离小于右侧View的宽度，并且没有处于刚好拉出的状态
                                        if (this.offsetY < this.mHeight) { //this.offsetY < this.bottomViewTopH
                                            this.offsetY = moveY
                                        } else {
                                            this.offsetY = this.mHeight
                                        }
                                    } else if (layoutBottom && moveY < 0.0) { //上滑
                                        //顶侧菜单开始关闭
                                        if (this.offsetY > 0.0) {
                                            if (this.mHeight - abs(moveY) <= 0.0) {
                                                this.offsetY = this.mHeight - moveY
                                                return
                                            }
                                        }

                                        //当前移动距离小于左侧View的宽度  并且没有处于刚好拉出的状态
                                        if (abs(this.offsetY) < this.mHeight) {
                                            this.offsetY = moveY
                                        } else {
                                            this.offsetY = -this.mHeight
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
                                        if (abs(moveY) >= 20.0) {
                                            this.offsetY = this.mHeight
                                        } else {
                                            this.offsetY = 0.0
                                        }
                                    }

                                    if (this.offsetY < 0.0) {
                                        if (abs(moveY) >= 20.0) {
                                            this.offsetY = -this.mHeight
                                        } else {
                                            this.offsetY = 0.0
                                        }
                                        return
                                    }
                                }
                            )
                            this.parentIsTouch = true
                        }
                    }
                )

                ColumnSplit {
                    this.bottomViewRight()
                }
            }

            if (layoutBottom) {
                ColumnSplit() {
                    this.bottomViewBottom()
                }.position(x: 0, y: Int64(this.mHeight)).onTouch(
                    {
                        event =>
                        if (event.eventType.toString() == "Down") {
                            this.sX = event.touches[0].screenX
                            this.sY = event.touches[0].screenY
                        }

                        if (event.eventType.toString() == "Move") {
                            let moveX = event.touches[0].screenX - this.sX
                            let moveY = event.touches[0].screenY - this.sY
                            if (abs(moveX) < abs(moveY)) { //纵向滑动
                                if (moveY > 0.0) { //下滑
                                    //底部菜单开始关闭
                                    if (this.offsetY < 0.0) {
                                        if (Float64(this.mHeight) - abs(moveY) >= 0.0) {
                                            this.offsetY = -(this.mHeight - moveY)
                                        }
                                    }
                                }
                            }
                        }

                        if (event.eventType.toString() == "Up") {
                            let moveY = event.touches[0].screenY - this.sY
                            animateTo(
                                AnimateParam(
                                    duration: this.mDuration, // 动画时长
                                    tempo: 1.0, // 播放速率
                                    curve: Curve.FastOutLinearIn, // 动画曲线
                                    iterations: 1, // 播放次数
                                    playMode: PlayMode.Normal, // 动画模式
                                ),
                                {
                                    => if (this.offsetY < 0.0) {
                                        if (abs(moveY) >= 20.0) {
                                            this.offsetY = 0.0
                                        } else {
                                            this.offsetY = -this.mHeight
                                        }
                                    }
                                }
                            )
                        }
                    }
                )
            }
        }.width(this.mWidth.percent).position(x: this.offsetX, y: this.offsetY)
    }
}
