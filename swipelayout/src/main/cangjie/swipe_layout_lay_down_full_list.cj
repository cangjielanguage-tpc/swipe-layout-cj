/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package swipelayout

import ohos.state_macro_manage.*

@Component
public class SwipeLayoutLayDownFullList {
    @Link var itemContent: String = ""
    @Link var itemId: Int64 = 0
    private var mDuration: Int32 = 200
    private var sX: Float64 = 0.0
    private var sY: Float64 = 0.0
    private var mWidth: Float64 = 100.0
    private var mHeight: Float64 = 90.0
    private var bottomViewRightW: Float64 = 320.0
    private var bottomViewLeftW: Float64 = 120.0
    private var bottomViewTopH: Float64 = 100.0
    private var bottomViewBottomH: Float64 = 100.0
    @BuilderParam let surfaceView: (String, Int64) -> Unit
    @BuilderParam let bottomViewRight: (Int64) -> Unit
    @State var offsetX: Float64 = 0.0
    @State var offsetY: Float64 = 0.0
    private var rightSlideEnable: Bool = true
    private var leftSlideEnable: Bool = true
    private var previousX: Float64 = 0.0
    private var enableSlide: Array<Bool> = [false, true, true, false]

    protected override func aboutToAppear() {
        var screenW: Float64 = px2vp(Float64(getDefaultDisplaySync().width).px).getOrThrow(
            ).value
        this.bottomViewRightW = if (bottomViewRightW >= screenW) {
            screenW
        } else if (bottomViewRightW < 0.0) {
            0.0
        } else {
            this.bottomViewRightW
        }
        this.mWidth = if (this.mWidth > 100.0) { 100.0 } else { this.mWidth }
    }

    func bottomViewRightOnTouch(event4: TouchEvent) {
        bottomViewRightOnTouch2(event4)
        if ("Move" == event4.eventType.toString()) {
            let moveY5 = event4.touches[0].screenY - this.sY
            let moveX5 = event4.touches[0].screenX - this.sX
            if (abs(moveX5) > abs(moveY5)) { // 横向滑动
                if (0.0 == this.offsetY) {
                    bottomViewRightOnTouch3(event4, moveX5, moveY5)
                }
            }
            this.previousX = event4.touches[0].screenX
        }

        if (event4.eventType.toString() == "Up") {
            let moveX6 = event4.touches[0].screenX - this.sX
            animateTo(
                AnimateParam(
                    curve: Curve.FastOutLinearIn, // 动画曲线
                    iterations: 1, // 播放次数
                    tempo: 1.0, // 播放速率
                    playMode: PlayMode.Normal, // 动画模式
                    onFinish: {
                        =>
                        this.leftSlideEnable = true
                        this.rightSlideEnable = true
                    },
                    duration: this.mDuration // 动画时长
                ),
                {
                    => if (this.offsetX < 0.0 && this.rightSlideEnable) {
                        bottomViewRightOnTouch4(moveX6)
                        return
                    }
                }
            )
        }
    }

    func surfaceViewDown(event: TouchEvent) {
        if ("Down" == event.eventType.toString()) {
            this.sY = event.touches[0].screenY
            this.sX = event.touches[0].screenX
        }
    }

    func surfaceViewOnTouch(event7: TouchEvent) {
        surfaceViewDown(event7)
        if (event7.eventType.toString() == "Move") {
            let moveY7 = event7.touches[0].screenY - this.sY
            let moveX7 = event7.touches[0].screenX - this.sX
            if (abs(moveX7) > abs(moveY7)) { // 横向滑动
                if (this.offsetY == 0.0) {
                    if (moveY7 < 30.0 && moveY7 > -30.0 && moveX7 < 0.0 ) { //左滑
                        //左侧菜单处于打开状态，开始关闭
                        surfaceViewOnTouch1(moveX7)
                        if (!this.enableSlide[2]) {
                            return
                        }
                        //当前移动距离小于右侧View的宽度，并且没有处于刚好拉出的状态
                        surfaceViewOnTouch2(moveX7, event7)
                    } else if (moveY7 > -30.0 && moveX7 > 0.0 && moveY7 < 30.0) { //右滑
                        //右侧菜单开始关闭
                        surfaceViewOnTouch3(moveX7)
                        if (!this.enableSlide[0]) {
                            return
                        }
                        //当前移动距离小于左侧View的宽度  并且没有处于刚好拉出的状态
                        surfaceViewOnTouch4(moveX7, event7)
                    }
                }
            }
            this.previousX = event7.touches[0].screenX
        }
        surfaceViewUp(event7)
    }

    func surfaceViewUp(event8: TouchEvent) {
        if (event8.eventType.toString() == "Up") {
            let moveY8 = event8.touches[0].screenY - this.sY
            let moveX8 = event8.touches[0].screenX - this.sX
            animateTo(
                AnimateParam(
                    duration: this.mDuration, // 动画时长
                    playMode: PlayMode.Normal, // 动画模式
                    tempo: 1.0, // 播放速率
                    curve: Curve.FastOutLinearIn, // 动画曲线
                    iterations: 1, // 播放次数
                    onFinish: {
                        =>
                        this.rightSlideEnable = true
                        this.leftSlideEnable = true
                    }
                ),
                {
                    =>
                    this.offsetY = CommonFunc.offseYCalculate(offsetY, bottomViewTopH, moveY8, bottomViewBottomH)
                    this.offsetX = CommonFunc.offsetXCalculate(offsetX, leftSlideEnable, bottomViewLeftW, moveX8, rightSlideEnable, bottomViewRightW)
                }
            )
        }
    }

    func bottomViewRightOnTouch1(moveX5: Float64) {
        if (this.offsetX < 0.0) {
            this.leftSlideEnable = false
            if (moveX5 <= this.bottomViewRightW) {
                this.offsetX = moveX5 - this.bottomViewRightW
                return
            } else {
                this.offsetX = 0.0
            }
        }
    }

    func bottomViewRightOnTouch2(event4: TouchEvent) {
        if (event4.eventType.toString() == "Down") {
            this.sY = event4.touches[0].screenY
            this.sX = event4.touches[0].screenX
        }
    }

    func bottomViewRightOnTouch3(event4: TouchEvent, moveX5: Float64, moveY5: Float64) {
        if (moveY5 < 30.0 && moveX5 < 0.0 && moveY5 > -30.0) { //左滑
        } else if (moveX5 > 0.0 && moveY5 < 30.0 && moveY5 > -30.0) { //右滑
            bottomViewRightOnTouch1(moveX5)
        }
    }

    func bottomViewRightOnTouch4(moveX6: Float64) {
        if (moveX6 <= -40.0) {
            this.offsetX = -this.bottomViewRightW
        } else if (moveX6 < 0.0) {
            this.offsetX = 0.0
        }
        if (moveX6 >= 40.0) {
            this.offsetX = 0.0
        } else if (moveX6 > 0.0) {
            this.offsetX = -this.bottomViewRightW
        }
    }

    func build() {
        Row() {
            Row() {
                this.surfaceView(itemContent, itemId)
            }.onTouch(
                {
                    event => surfaceViewOnTouch(event)
                }
            )
            
            Row() {
                this.bottomViewRight(itemId)
            }.width(this.bottomViewRightW).height(this.mHeight).onTouch(
                {
                    event => bottomViewRightOnTouch(event)

                }
            ).backgroundColor(0xFF5534)
        }.width(this.mWidth.percent).height(this.mHeight).position(x: this.offsetX, y: this.offsetY)
    }

    func surfaceViewOnTouch1(moveX7: Float64) {
        if (this.offsetX > 0.0) {
            this.rightSlideEnable = false
            if (-moveX7 < this.bottomViewLeftW) {
                this.offsetX = moveX7 + this.bottomViewLeftW
            } else {
                this.offsetX = 0.0
            }
            return
        }
    }

    func surfaceViewOnTouch2(moveX7: Float64, event7: TouchEvent) {
        if (this.rightSlideEnable) {
            if (-moveX7 <= this.bottomViewRightW && this.offsetX <= 0.0
                && this.offsetX > -this.bottomViewRightW) {
                this.offsetX = moveX7
            } else if (-moveX7 > this.bottomViewRightW) {
                this.sX = event7.touches[0].screenX
                this.offsetX = -this.bottomViewRightW
                this.leftSlideEnable = false
            }
        }
    }

    func surfaceViewOnTouch3(moveX7: Float64) {
        if (this.offsetX < 0.0) {
            this.leftSlideEnable = false
            if (moveX7 <= this.bottomViewRightW) {
                this.offsetX = moveX7 - this.bottomViewRightW
                return
            } else {
                this.offsetX = 0.0
            }
        }
    }

    func surfaceViewOnTouch4(moveX7: Float64, event7: TouchEvent) {
        if (this.leftSlideEnable) {
            if (this.offsetX < this.bottomViewLeftW && this.offsetX >= 0.0 && moveX7 <= this.
                bottomViewLeftW) {
                this.offsetX = moveX7
            } else if (moveX7 > this.bottomViewRightW) {
                this.offsetX = this.bottomViewLeftW
                this.rightSlideEnable = false
                this.sX = event7.touches[0].screenX
            }
        }
    }
}
