/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package swipelayout

import ohos.state_macro_manage.*

@Component
public class SwipeLayoutLayDownRoot {
    @Link var isTouch: Bool
    private var mDuration: Int32 = 200
    private var sX: Float64 = 0.0
    private var sY: Float64 = 0.0
    private var mWidth: Float64 = 100.0
    private var mHeight: Float64 = 90.0
    private var bottomViewRightW: Float64 = 120.0
    private var bottomViewLeftW: Float64 = 120.0
    private var bottomViewTopH: Float64 = 120.0
    private var bottomViewBottomH: Float64 = 720.0
    @BuilderParam let bottomViewRight: () -> Unit
    @BuilderParam let bottomViewLeft: () -> Unit
    @BuilderParam let bottomViewTop: () -> Unit
    @BuilderParam let bottomViewBottom: () -> Unit
    @BuilderParam var innerSwipeLayout: () -> Unit
    @State var offsetX: Float64 = 0.0
    @State var offsetY: Float64 = 0.0
    private var rightSlideEnable: Bool = true
    private var leftSlideEnable: Bool = true
    private var previousX: Float64 = 0.0

    protected override func aboutToAppear() {
        this.mWidth = if (this.mWidth > 100.0) { 100.0 } else { this.mWidth }
    }

    func innerSwipeLayoutDown(event: TouchEvent) {
        if ("Down" == event.eventType.toString()) {
            this.sY = event.touches[0].screenY
            this.sX = event.touches[0].screenX
        }
    }

    func innerSwipeLayoutOnTouch(event9: TouchEvent) {
        if (!this.isTouch) {
            return
        }
        innerSwipeLayoutDown(event9)
        if (event9.eventType.toString() == "Move") {
            let moveY9 = event9.touches[0].screenY - this.sY
            let moveX9 = event9.touches[0].screenX - this.sX
            if (abs(moveX9) > abs(moveY9)) { // 横向滑动
                if (this.offsetY == 0.0) {
                    if (moveY9 > -30.0 && moveX9 < 0.0 && moveY9 < 30.0) { //左滑
                        //左侧菜单处于打开状态，开始关闭
                        innerSwipeLayoutOnTouch1(moveX9)
                        //当前移动距离小于右侧View的宽度，并且没有处于刚好拉出的状态
                        innerSwipeLayoutOnTouch2(moveX9, event9)
                    } else if (moveY9 < 30.0 && moveX9 > 0.0 && moveY9 > -30.0) { //右滑
                        //右侧菜单开始关闭
                        innerSwipeLayoutOnTouch3(moveX9)
                        //当前移动距离小于左侧View的宽度  并且没有处于刚好拉出的状态
                        innerSwipeLayoutOnTouch4(moveX9, event9)
                    }
                }
            } else { //纵向滑动
                if (0.0 == this.offsetX) {
                    if (moveY9 > 0.0) { //下滑
                        //底部菜单开始关闭
                        innerSwipeLayoutOnTouch5(moveY9)
                        //当前移动距离小于右侧View的宽度，并且没有处于刚好拉出的状态
                        innerSwipeLayoutOnTouch6(moveY9)
                    } else if (moveY9 < 0.0) { //上滑
                        //顶侧菜单开始关闭
                        innerSwipeLayoutOnTouch7(moveY9)
                        innerSwipeLayoutOnTouch8(moveY9)
                    }
                }
            }
            this.previousX = event9.touches[0].screenX
        }
        innerSwipeLayoutUp(event9)
    }

    func innerSwipeLayoutUp(event: TouchEvent) {
        if (event.eventType.toString() == "Up") {
            let moveY = event.touches[0].screenY - this.sY
            let moveX = event.touches[0].screenX - this.sX
            animateTo(
                AnimateParam(
                    tempo: 1.0, // 播放速率
                    duration: this.mDuration, // 动画时长
                    curve: Curve.FastOutLinearIn, // 动画曲线
                    iterations: 1, // 播放次数
                    playMode: PlayMode.Normal, // 动画模式
                    onFinish: {
                        =>
                        this.leftSlideEnable = true
                        this.rightSlideEnable = true
                    }
                ),
                {
                    =>
                   this.offsetY = CommonFunc.offseYCalculate(offsetY, bottomViewTopH, moveY, bottomViewBottomH)
                   this.offsetX = CommonFunc.offsetXCalculate(offsetX, leftSlideEnable, bottomViewLeftW, moveX, rightSlideEnable, bottomViewRightW)
                }
            )
        }
    }


    func build() {
        Column() {
            BottomViewTop(
                bottomViewTop: bottomViewTop,bottomViewTopH: bottomViewTopH,parentIsTouch: isTouch,offsetX: offsetX,
                offsetY: offsetY, mHeight: mHeight, mDuration:mDuration
            )

            Row() {
                Column() {
                    this.bottomViewLeft()
                }.position(x: -this.bottomViewLeftW, y: 0.0)

                Column() {
                    this.innerSwipeLayout()
                }.height(100.percent).width(100.percent).backgroundColor(Color.WHITE).onTouch(
                    {
                        event => innerSwipeLayoutOnTouch(event)
                    }
                )

                Column() {
                    this.bottomViewRight()
                }
            }

            BottomViewBottom(
                bottomViewBottom: bottomViewBottom,bottomViewBottomH: bottomViewBottomH, parentIsTouch: isTouch, offsetX: offsetX,
                offsetY: offsetY, mHeight: mHeight, mDuration:mDuration
            )
        }.width(this.mWidth.percent).height(this.mHeight).position(x: this.offsetX, y: this.offsetY)
    }

    func innerSwipeLayoutOnTouch1(moveX9: Float64) {
        if (this.offsetX > 0.0) {
            this.rightSlideEnable = false
            if (-moveX9 < this.bottomViewLeftW) {
                this.offsetX = this.bottomViewLeftW + moveX9
            } else {
                this.offsetX = 0.0
            }
            return
        }
    }

    func innerSwipeLayoutOnTouch2(moveX9: Float64, event9: TouchEvent) {
        if (this.rightSlideEnable) {
            if (this.offsetX > -this.bottomViewRightW && this.offsetX <= 0.0 &&
                -moveX9 <= this.bottomViewRightW) {
                this.offsetX = moveX9
            } else if (-moveX9 > this.bottomViewRightW) {
                this.offsetX = -this.bottomViewRightW
                this.leftSlideEnable = false
                this.sX = event9.touches[0].screenX
            }
        }
    }

    func innerSwipeLayoutOnTouch3(moveX9: Float64) {
        if (this.offsetX < 0.0) {
            this.leftSlideEnable = false
            if (moveX9 <= this.bottomViewRightW) {
                this.offsetX = moveX9 - this.bottomViewRightW
                return
            } else {
                this.offsetX = 0.0
            }
        }
    }

    func innerSwipeLayoutOnTouch4(moveX9: Float64, event9: TouchEvent) {
        if (this.leftSlideEnable) {
            if (moveX9 <= this.bottomViewLeftW && this.offsetX >= 0.0
            && this.offsetX < this.bottomViewLeftW) {
                this.offsetX = moveX9
            } else if (moveX9 > this.bottomViewRightW) {
                this.rightSlideEnable = false
                this.offsetX = this.bottomViewLeftW
                this.sX = event9.touches[0].screenX
            }
        }
    }

    func innerSwipeLayoutOnTouch5(moveY9: Float64) {
        if (this.offsetY < 0.0) {
            if (moveY9 - this.bottomViewBottomH <= 0.0) {
                this.offsetY = moveY9 - this.bottomViewBottomH
                return
            }
        }
    }

    func innerSwipeLayoutOnTouch6(moveY9: Float64) {
        if (this.offsetY < this.bottomViewTopH) {
            this.offsetY = moveY9
        } else {
            this.offsetY = this.bottomViewTopH
        }
    }

    func innerSwipeLayoutOnTouch7(moveY9: Float64) {
        if (this.offsetY > 0.0) {
            if (this.bottomViewTopH - abs(moveY9) >= 0.0) {
                this.offsetY = this.bottomViewTopH + moveY9
                return
            }
        }
    }

    func innerSwipeLayoutOnTouch8(moveY9: Float64) {
        if (this.offsetY <= 0.0) {
            if (abs(this.offsetY) < this.bottomViewBottomH) {
                this.offsetY = moveY9
            } else {
                this.offsetY = -this.bottomViewBottomH
            }
        }
    }
}
