/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package swipelayout

import ohos.state_macro_manage.*

@Component
public class SwipeLayoutLayDownFull {
    @Link var parentIsTouch: Bool
    private var mDuration: Int32 = 200
    private var sX: Float64 = 0.0
    private var sY: Float64 = 0.0
    public var mWidth: Float64 = 100.0
    public var mHeight: Float64 = 90.0
    private var bottomViewRightW: Float64 = 320.0
    private var bottomViewLeftW: Float64 = 120.0
    private var bottomViewTopH: Float64 = 100.0
    private var bottomViewBottomH: Float64 = 100.0
    @BuilderParam let surfaceView: () -> Unit
    @BuilderParam let bottomViewRight: () -> Unit
    @BuilderParam let bottomViewTop: () -> Unit
    @State var offsetX: Float64 = 0.0
    @State var offsetY: Float64 = 0.0
    private var rightSlideEnable: Bool = true
    private var leftSlideEnable: Bool = true
    private var previousX: Float64 = 0.0
    private var enableSlide: Array<Bool> = [false, true, true, false]

    protected override func aboutToAppear() {
        this.mWidth = if (this.mWidth > 100.0) { 100.0 } else { this.mWidth }
    }

    func bottomViewRightDown(event: TouchEvent) {
        if (event.eventType.toString() == "Down") {
            this.sX = event.touches[0].screenX
            this.sY = event.touches[0].screenY
            this.parentIsTouch = false
        }
    }

    func bottomViewRightMove(event: TouchEvent) {
        if (event.eventType.toString() == "Move") {
            let moveX = event.touches[0].screenX - this.sX
            let moveY = event.touches[0].screenY - this.sY
            if (abs(moveX) > abs(moveY)) { // 横向滑动
                if (this.offsetY == 0.0) {
                    if (moveY < 30.0 && moveX < 0.0 && moveY > -30.0) { //左滑
                        this.parentIsTouch = true
                    } else if (moveY > -30.0 && moveX > 0.0 && moveY < 30.0) { //右滑
                        bottomViewRightMove1(moveX)
                    }
                }
            }
            this.previousX = event.touches[0].screenX
        }
    }

    func bottomViewRightMove1(moveX: Float64) {
        if (this.offsetX < 0.0) {
            this.leftSlideEnable = false
            if (moveX > this.bottomViewRightW) {
                this.offsetX = 0.0
            } else {
                this.offsetX = moveX - this.bottomViewRightW
                return
              }
        }
    }

    func bottomViewRightOnTouch(event: TouchEvent) {
        bottomViewRightDown(event)
        bottomViewRightMove(event)
        if (event.eventType.toString() == "Up") {
            let moveX = event.touches[0].screenX - this.sX
            animateTo(
                AnimateParam(
                    duration: this.mDuration, // 动画时长
                    tempo: 1.0, // 播放速率
                    iterations: 1, // 播放次数
                    playMode: PlayMode.Normal, // 动画模式
                    curve: Curve.FastOutLinearIn, // 动画曲线
                    onFinish: {
                        =>
                        this.rightSlideEnable = true
                        this.leftSlideEnable = true
                    }
                ),
                {
                    => if (this.rightSlideEnable && this.offsetX < 0.0) {
                        bottomViewRightOnTouch1(moveX)
                        return
                    }
                }
            )
            this.parentIsTouch = true
        }
    }

    func bottomViewRightOnTouch1(moveX: Float64) {
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
    }

    func surfaceViewDown(event: TouchEvent) {
        if (event.eventType.toString() == "Down") {
            this.sX = event.touches[0].screenX
            this.parentIsTouch = false
            this.sY = event.touches[0].screenY
        }
    }

    func surfaceViewOnTouch(event12: TouchEvent) {
        surfaceViewDown(event12)
        if (event12.eventType.toString() == "Move") {
            let moveX12 = event12.touches[0].screenX - this.sX
            let moveY12 = event12.touches[0].screenY - this.sY
            if (abs(moveX12) > abs(moveY12)) { // 横向滑动
                if (this.offsetY == 0.0) {
                    if (moveY12 > -30.0 && moveX12 < 0.0 && moveY12 < 30.0) { //左滑
                        //左侧菜单处于打开状态，开始关闭
                        surfaceViewOnTouch1(moveX12)
                        if (!this.enableSlide[2]) {
                            return
                        }
                        //当前移动距离小于右侧View的宽度，并且没有处于刚好拉出的状态
                        surfaceViewOnTouch2(moveX12, event12)
                    } else if (moveY12 < 30.0 && moveX12 > 0.0 && moveY12 > -30.0) { //右滑
                        //右侧菜单开始关闭
                        surfaceViewOnTouch3(moveX12)
                        if (!this.enableSlide[0]) {
                            return
                        }
                        //当前移动距离小于左侧View的宽度  并且没有处于刚好拉出的状态
                        surfaceViewOnTouch4(moveX12, event12)
                    }
                }
            } else { //纵向滑动
                if (0.0 == this.offsetX) {
                    if (moveY12 > 0.0) { //下滑
                        //底部菜单开始关闭
                        surfaceViewOnTouch5(moveY12)
                        if (!this.enableSlide[1]) {
                            return
                        }
                        //当前移动距离小于右侧View的宽度，并且没有处于刚好拉出的状态
                        surfaceViewOnTouch6(moveY12)
                    } else if (moveY12 < 0.0) { //上滑
                        //顶侧菜单开始关闭
                        surfaceViewOnTouch7(moveY12)
                        if (!this.enableSlide[3]) {
                            return
                        }
                        //当前移动距离小于左侧View的宽度  并且没有处于刚好拉出的状态
                        surfaceViewOnTouch8(moveY12)
                    }
                }
            }
            this.previousX = event12.touches[0].screenX
        }
        surfaceViewUp(event12)
    }

    func surfaceViewOnTouch1(moveX12: Float64) {
        if (this.offsetX > 0.0) {
            this.rightSlideEnable = false
            if (-moveX12 < this.bottomViewLeftW) {
                this.offsetX = moveX12 + this.bottomViewLeftW
            } else {
                this.offsetX = 0.0
            }
            return
        }
    }

    func surfaceViewOnTouch2(moveX12: Float64, event12: TouchEvent) {
        if (this.rightSlideEnable) {
            if (-moveX12 <= this.bottomViewRightW && this.offsetX <= 0.0
            && this.offsetX > -this.bottomViewRightW) {
                this.offsetX = moveX12
            } else if (-moveX12 > this.bottomViewRightW) {
                this.leftSlideEnable = false
                this.offsetX = -this.bottomViewRightW
                this.sX = event12.touches[0].screenX
            }
        }
    }

    func surfaceViewOnTouch3(moveX12: Float64) {
        if (this.offsetX < 0.0) {
            this.leftSlideEnable = false
            if (moveX12 <= this.bottomViewRightW) {
                this.offsetX = moveX12 - this.bottomViewRightW
                return
            } else {
                this.offsetX = 0.0
            }
        }
    }

    func surfaceViewOnTouch4(moveX12: Float64, event12: TouchEvent) {
        if (this.leftSlideEnable) {
            if (this.offsetX < this.bottomViewLeftW && this.offsetX >= 0.0 && moveX12 <=
                this.bottomViewLeftW) {
                this.offsetX = moveX12
            } else if (moveX12 > this.bottomViewRightW) {
                this.offsetX = this.bottomViewLeftW
                this.rightSlideEnable = false
                this.sX = event12.touches[0].screenX
            }
        }
    }

    func surfaceViewOnTouch5(moveY12: Float64) {
        if (this.offsetY < 0.0) {
            if (moveY12 - this.bottomViewBottomH <= 0.0) {
                this.offsetY = moveY12 - this.bottomViewBottomH
                return
            }
        }
    }

    func surfaceViewOnTouch6(moveY12: Float64) {
        if (this.offsetY < this.bottomViewTopH) {
            this.offsetY = moveY12
        } else {
            this.offsetY = this.bottomViewTopH
        }
    }

    func surfaceViewOnTouch7(moveY12: Float64) {
        if (this.offsetY > 0.0) {
            if (this.bottomViewTopH - abs(moveY12) >= 0.0) {
                this.offsetY = this.bottomViewTopH + moveY12
                return
            }
        }
    }

    func surfaceViewOnTouch8(moveY12: Float64) {
        if (abs(this.offsetY) < this.bottomViewBottomH) {
            this.offsetY = moveY12
        } else {
            this.offsetY = -this.bottomViewBottomH
        }
    }

    func surfaceViewUp(event13: TouchEvent) {
        if (event13.eventType.toString() == "Up") {
            let moveY13 = event13.touches[0].screenY - this.sY
            let moveX13 = event13.touches[0].screenX - this.sX
            animateTo(
                AnimateParam(
                    playMode: PlayMode.Normal, // 动画模式
                    duration: this.mDuration, // 动画时长
                    curve: Curve.FastOutLinearIn, // 动画曲线
                    iterations: 1, // 播放次数
                    onFinish: {
                        =>
                        this.rightSlideEnable = true
                        this.leftSlideEnable = true
                    },
                    tempo: 1.0 // 播放速率
                ),
                {
                    =>
                    this.offsetY = CommonFunc.offseYCalculate(offsetY, bottomViewTopH, moveY13, bottomViewBottomH)
                    this.offsetX = CommonFunc.offsetXCalculate(offsetX, leftSlideEnable, bottomViewLeftW, moveX13, rightSlideEnable, bottomViewRightW)
                }
            )
            this.parentIsTouch = true
        }
    }

    func build() {
        Column() {
            BottomViewTop(
                bottomViewTop: bottomViewTop,bottomViewTopH: bottomViewTopH,parentIsTouch: parentIsTouch,offsetX: offsetX,
                offsetY: offsetY, mHeight: mHeight, mDuration:mDuration
            )
            Row() {
                Column() {
                    this.surfaceView()
                }.onTouch(
                    {
                        event => surfaceViewOnTouch(event)
                    }
                )
                Column() {
                    Row() {
                        this.bottomViewRight()
                    }.width(this.bottomViewRightW).height(this.mHeight)
                }.onTouch(
                    {
                        event => bottomViewRightOnTouch(event)
                    }
                )
            }
        }.width(this.mWidth.percent).height(this.mHeight).position(x: this.offsetX, y: this.offsetY)
    }
}
