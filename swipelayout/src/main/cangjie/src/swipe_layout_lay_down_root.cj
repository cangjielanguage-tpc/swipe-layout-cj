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
                        event =>
                        if (!this.isTouch) {
                            return
                        }
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
                                    if (moveY > 0.0) { //下滑
                                        //底部菜单开始关闭
                                        if (this.offsetY < 0.0) {
                                            if (moveY - this.bottomViewBottomH <= 0.0) {
                                                this.offsetY = moveY - this.bottomViewBottomH
                                                return
                                            }
                                        }
                                        //当前移动距离小于右侧View的宽度，并且没有处于刚好拉出的状态
                                        if (this.offsetY < this.bottomViewTopH) {
                                            this.offsetY = moveY
                                        } else {
                                            this.offsetY = this.bottomViewTopH
                                        }
                                    } else if (moveY < 0.0) { //上滑
                                        //顶侧菜单开始关闭
                                        if (this.offsetY > 0.0) {
                                            if (this.bottomViewTopH - abs(moveY) >= 0.0) {
                                                this.offsetY = this.bottomViewTopH + moveY
                                                return
                                            }
                                        }

                                        if (this.offsetY <= 0.0) {
                                            if (abs(this.offsetY) < this.bottomViewBottomH) {
                                                this.offsetY = moveY
                                            } else {
                                                this.offsetY = -this.bottomViewBottomH
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
                                   this.offsetX = CommonFunc.offsetXCalculate(offsetX, leftSlideEnable, bottomViewLeftW, moveX, rightSlideEnable, bottomViewRightW)
                                   this.offsetY = CommonFunc.offseYCalculate(offsetY, bottomViewTopH, moveY, bottomViewBottomH)
                                }
                            )
                        }
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
}
