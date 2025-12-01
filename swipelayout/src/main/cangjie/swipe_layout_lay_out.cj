/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package swipelayout

import ohos.state_macro_manage.*

@Component
public class SwipeLayoutLayOut {
    @Link var parentIsTouch: Bool
    private var mDuration: Int32 = 200
    private var sX: Float64 = 0.0
    private var sY: Float64 = 0.0
    public var mWidth: Float64 = 100.0
    public var mHeight: Float64 = 90.0
    private var bottomViewRightW: Float64 = 180.0
    private var bottomViewLeftW: Float64 = 120.0
    @BuilderParam let surfaceView: () -> Unit
    @BuilderParam let bottomViewRight: () -> Unit
    @State var offsetX: Float64 = 0.0
    @State var offsetY: Float64 = 0.0
    private var rightSlideEnable: Bool = true
    private var leftSlideEnable: Bool = true
    private var previousX: Float64 = 0.0
    private var enableSlide: Array<Bool> = [false, false, true, false]

    protected override func aboutToAppear() {
        this.mWidth = if (this.mWidth > 100.0) { 100.0 } else { this.mWidth }
    }

    func surfaceViewDown(event: TouchEvent) {
        if (event.eventType.toString() == "Down") {
            this.parentIsTouch = false
            this.sY = event.touches[0].screenY
            this.sX = event.touches[0].screenX
        }

    }

    func surfaceViewOnTouch(event15: TouchEvent) {
        surfaceViewDown(event15)
        if (event15.eventType.toString() == "Move") {
            let moveY15 = event15.touches[0].screenY - this.sY
            let moveX15 = event15.touches[0].screenX - this.sX
            if (abs(moveX15) > abs(moveY15)) { // 横向滑动
                if (this.offsetY == 0.0) {
                    if (moveY15 < 30.0 && moveX15 < 0.0 && moveY15 > -30.0) { //左滑
                        //左侧菜单处于打开状态，开始关闭
                        surfaceViewOnTouch1(moveX15)
                        //当前移动距离小于右侧View的宽度，并且没有处于刚好拉出的状态
                        if (!this.enableSlide[2]) {
                            return
                        }
                        surfaceViewOnTouch2(moveX15, event15)
                    } else if (moveY15 < 30.0 && moveX15 > 0.0 && moveY15 > -30.0) { //右滑
                        //右侧菜单开始关闭
                        surfaceViewOnTouch3(moveX15)

                        if (!this.enableSlide[0]) {
                            return
                        }
                        //当前移动距离小于左侧View的宽度  并且没有处于刚好拉出的状态
                        surfaceViewOnTouch4(moveX15, event15)
                    }
                }
            } else { //纵向滑动
                if (0.0 == this.offsetX) {
                    if (moveY15 > 0.0) { //下滑
                        //底部菜单开始关闭
                        surfaceViewOnTouch5(moveY15)
                        if (!this.enableSlide[1]) {
                            return
                        }
                        //当前移动距离小于右侧View的宽度，并且没有处于刚好拉出的状态
                        surfaceViewOnTouch6(moveY15)
                    } else if (moveY15 < 0.0) { //上滑
                        //顶侧菜单开始关闭
                        surfaceViewOnTouch7(moveY15)
                        if (!this.enableSlide[3]) {
                            return
                        }
                        //当前移动距离小于左侧View的宽度  并且没有处于刚好拉出的状态
                        surfaceViewOnTouch8(moveY15)
                    }
                }
            }
            this.previousX = event15.touches[0].screenX
        }
        surfaceViewUp(event15)
    }

    func surfaceViewUp(event16: TouchEvent) {
       if (event16.eventType.toString() == "Up") {
            let moveY16 = event16.touches[0].screenY - this.sY
            let moveX16 = event16.touches[0].screenX - this.sX
            animateTo(
                AnimateParam(
                    playMode: PlayMode.Normal, // 动画模式
                    duration: this.mDuration, // 动画时长
                    tempo: 1.0, // 播放速率
                    curve: Curve.FastOutLinearIn, // 动画曲线
                    iterations: 1, // 播放次数
                    onFinish: {
                        =>
                        this.leftSlideEnable = true
                        this.rightSlideEnable = true
                    }
                ),
                {
                    =>
                    this.offsetX = CommonFunc.offsetXCalculate(offsetX, leftSlideEnable, bottomViewLeftW, moveX16, rightSlideEnable, bottomViewRightW)
                    surfaceViewOnTouch8(moveY16)
                    surfaceViewOnTouch9(moveY16)
                }
            )
            this.parentIsTouch = true
        }
    }

    func build() {
        Column() {
            Stack() {
                Row() {
                    Blank()
                    Column() {
                        Row() {
                            this.bottomViewRight()
                        }.height(this.mHeight).width(this.bottomViewRightW)
                    }
                }.width(100.percent)

                Column() {
                    this.surfaceView()
                }.onTouch(
                    {
                        event => surfaceViewOnTouch(event)
                    }
                ).position(x: this.offsetX, y: 0.0)
            }
        }.width(this.mWidth.percent).height(this.mHeight).position(x: 0.0, y: this.offsetY)
    }

    func surfaceViewOnTouch1(moveX15: Float64) {
        if (this.offsetX > 0.0) {
            this.rightSlideEnable = false
            if (-moveX15 < this.bottomViewLeftW) {
                this.offsetX = moveX15 + this.bottomViewLeftW
            } else {
                this.offsetX = 0.0
            }
            return
        }
    }

    func surfaceViewOnTouch2(moveX15: Float64, event15: TouchEvent) {
        if (this.rightSlideEnable) {
            if (this.offsetX <= 0.0 && this.offsetX > -this.bottomViewRightW &&
                -moveX15 <= this.bottomViewRightW) {
                this.offsetX = moveX15
            } else if (-moveX15 > this.bottomViewRightW) {
                this.leftSlideEnable = false
                this.offsetX = -this.bottomViewRightW
                this.sX = event15.touches[0].screenX
            }
        }
    }

    func surfaceViewOnTouch3(moveX15: Float64) {
        if (this.offsetX < 0.0) {
            this.leftSlideEnable = false
            if (moveX15 <= this.bottomViewRightW) {
                this.offsetX = moveX15 - this.bottomViewRightW
                return
            } else {
                this.offsetX = 0.0
            }
        }
    }

    func surfaceViewOnTouch4(moveX15: Float64, event15: TouchEvent) {
        if (this.leftSlideEnable) {
            if (moveX15 <= this.bottomViewLeftW && this.offsetX >= 0.0
            && this.offsetX < this.bottomViewLeftW) {
                this.offsetX = moveX15
            } else if (moveX15 > this.bottomViewRightW) {
                this.sX = event15.touches[0].screenX
                this.offsetX = this.bottomViewLeftW
                this.rightSlideEnable = false
            }
        }
    }

    func surfaceViewOnTouch5(moveY15: Float64) {
        if (this.offsetY < 0.0) {
            if (moveY15 - this.mHeight <= 0.0) {
                this.offsetY = moveY15 - this.mHeight
                return
            }
        }
    }

    func surfaceViewOnTouch6(moveY15: Float64) {
        if (this.offsetY < this.mHeight) {
            this.offsetY = moveY15
        } else {
            this.offsetY = this.mHeight
        }
    }

    func surfaceViewOnTouch7(moveY15: Float64) {
        if (this.offsetY > 0.0) {
            if (this.mHeight - abs(moveY15) <= 0.0) {
                this.offsetY = this.mHeight - moveY15
                return
            }
        }
    }

    func surfaceViewOnTouch8(moveY16: Float64) {
        if (this.offsetY < 0.0) {
            if (abs(moveY16) >= 20.0) {
                this.offsetY = -this.mHeight
            } else {
                this.offsetY = 0.0
            }
        }
    }

    func surfaceViewOnTouch9(moveY16: Float64) {
        if (this.offsetY > 0.0) {
            if (abs(moveY16) >= 20.0) {
                this.offsetY = this.mHeight
            } else {
                this.offsetY = 0.0
            }
        }
    }

    func surfaceViewUp1(event16: TouchEvent) {

    }

}
