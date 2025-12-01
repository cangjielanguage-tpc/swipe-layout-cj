/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package swipelayout

import ohos.state_macro_manage.*

@Component
public class SwipeLayoutLayDown {
    @Link var parentIsTouch: Bool
    private var mDuration: Int32 = 200
    private var sX: Float64 = 0.0
    private var sY: Float64 = 0.0
    public var mWidth: Float64 = 100.0
    public var mHeight: Float64 = 90.0
    private var bottomViewRightW: Float64 = 180.0
    private var bottomViewLeftW: Float64 = 120.0
    private var bottomViewTopH: Float64 = 100.0
    private var bottomViewBottomH: Float64 = 100.0
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
    @State var offsetX: Float64 = 0.0
    @State var offsetY: Float64 = 0.0
    private var rightSlideEnable: Bool = true
    private var leftSlideEnable: Bool = true
    private var previousX: Float64 = 0.0

    protected override func aboutToAppear() {
        this.mWidth = if (this.mWidth > 100.0) { 100.0 } else { this.mWidth }
    }

    func bottomViewLeftDown(event: TouchEvent){
        if (event.eventType.toString() == "Down") {
            this.parentIsTouch = false
            this.sX = event.touches[0].screenX
            this.sY = event.touches[0].screenY
        }
    }

    func bottomViewLeftOnTouch(event10: TouchEvent){
        bottomViewLeftDown(event10)
        if (event10.eventType.toString() == "Move") {
            let moveX10 = event10.touches[0].screenX - this.sX
            let moveY10 = event10.touches[0].screenY - this.sY
            if (abs(moveX10) > abs(moveY10)) { // 横向滑动
                if (this.offsetY == 0.0) {
                    if (moveX10 < 0.0 && moveY10 < 30.0 && moveY10 > -30.0) { //左滑
                        //左侧菜单处于打开状态，开始关闭
                        bottomViewLeftOnTouch1(moveX10)
                        //当前移动距离小于右侧View的宽度，并且没有处于刚好拉出的状态
                        bottomViewLeftOnTouch2(moveX10, event10)
                    } else if (moveY10 < 30.0 && moveY10 > -30.0 && moveX10 > 0.0) { //右滑
                        //右侧菜单开始关闭
                        bottomViewLeftOnTouch3(moveX10)
                        //当前移动距离小于左侧View的宽度  并且没有处于刚好拉出的状态
                        bottomViewLeftOnTouch4(moveX10, event10)
                    }
                }
            } else { //纵向滑动
                if (0.0 == this.offsetX) {
                    if (moveY10 > 0.0) { //下滑
                        //底部菜单开始关闭
                        bottomViewLeftOnTouch5(moveY10)
                        //当前移动距离小于右侧View的宽度，并且没有处于刚好拉出的状态
                        bottomViewLeftOnTouch6(moveY10)
                    } else if (moveY10 < 0.0) { //上滑
                        //顶侧菜单开始关闭
                        bottomViewLeftOnTouch7(moveY10)
                        //当前移动距离小于左侧View的宽度  并且没有处于刚好拉出的状态
                        bottomViewLeftOnTouch8(moveY10)
                    }
                }
            }
            this.previousX = event10.touches[0].screenX
        }
        bottomViewLeftUp(event10)
    }

    func bottomViewLeftOnTouch1(moveX10: Float64){
        if (this.offsetX > 0.0) {
            this.rightSlideEnable = false
            if (-moveX10 < this.bottomViewLeftW) {
                this.offsetX = moveX10 + this.bottomViewLeftW
            } else {
                this.offsetX = 0.0
            }
            return
        }
    }

    func bottomViewLeftOnTouch2(moveX10: Float64, event10: TouchEvent){
        if (this.rightSlideEnable) {
            if (this.offsetX <= 0.0 && this.offsetX > -this.bottomViewRightW &&
                -moveX10 <= this.bottomViewRightW) {
                this.offsetX = moveX10
            } else if (-moveX10 > this.bottomViewRightW) {
                this.sX = event10.touches[0].screenX
                this.offsetX = -this.bottomViewRightW
                this.leftSlideEnable = false
            }
        }
    }

    func bottomViewLeftOnTouch3(moveX10: Float64){
        if (this.offsetX < 0.0) {
            this.leftSlideEnable = false
            if (moveX10 <= this.bottomViewRightW) {
                this.offsetX = moveX10 - this.bottomViewRightW
                return
            } else {
                this.offsetX = 0.0
            }
        }
    }

    func bottomViewLeftOnTouch4(moveX10: Float64, event10: TouchEvent){
        if (this.leftSlideEnable) {
            if (this.offsetX < this.bottomViewLeftW && this.offsetX >= 0.0 && moveX10 <=
                this.bottomViewLeftW) {
                this.offsetX = moveX10
            } else if (moveX10 > this.bottomViewRightW) {
                this.rightSlideEnable = false
                this.offsetX = this.bottomViewLeftW
                this.sX = event10.touches[0].screenX
            }
        }
    }

    func bottomViewLeftOnTouch5(moveY10: Float64){
        if (this.offsetY < 0.0) {
            if (moveY10 - this.bottomViewBottomH <= 0.0) {
                this.offsetY = moveY10 - this.bottomViewBottomH
                return
            }
        }
    }

    func bottomViewLeftOnTouch6(moveY10: Float64){
        if (this.offsetY < this.bottomViewTopH) {
            this.offsetY = moveY10
        } else {
            this.offsetY = this.bottomViewTopH
        }
    }

    func bottomViewLeftOnTouch7(moveY10: Float64){
        if (this.offsetY > 0.0) {
            if (this.bottomViewTopH - abs(moveY10) >= 0.0) {
                this.offsetY = moveY10 + this.bottomViewTopH
                return
            }
        }
    }

    func bottomViewLeftOnTouch8(moveY10: Float64){
        if (abs(this.offsetY) < this.bottomViewBottomH) {
            this.offsetY = moveY10
        } else {
            this.offsetY = -this.bottomViewBottomH
        }
    }

    func bottomViewLeftUp(event11: TouchEvent){
        if (event11.eventType.toString() == "Up") {
            let moveY11 = event11.touches[0].screenY - this.sY
            let moveX11 = event11.touches[0].screenX - this.sX
            animateTo(
                AnimateParam(
                    duration: this.mDuration, // 动画时长
                    tempo: 1.0, // 播放速率
                    curve: Curve.FastOutLinearIn, // 动画曲线
                    iterations: 1, // 播放次数
                    onFinish: {
                        =>
                        this.leftSlideEnable = true
                        this.rightSlideEnable = true
                    },
                    playMode: PlayMode.Normal // 动画模式
                ),
                {
                    =>
                    this.offsetY = CommonFunc.offseYCalculate(offsetY, bottomViewTopH, moveY11, bottomViewBottomH)
                    this.offsetX = CommonFunc.offsetXCalculate(offsetX, leftSlideEnable, bottomViewLeftW, moveX11, rightSlideEnable, bottomViewRightW)
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
                    Row() {
                        this.bottomViewLeft()
                    }.height(this.mHeight).width(this.bottomViewLeftW)
                }.position(x: -this.bottomViewLeftW, y: 0.0)

                Column() {
                    this.surfaceView()
                }.onTouch(
                    {
                        event => bottomViewLeftOnTouch(event)
                    }
                )

                Column() {
                    Row() {
                        this.bottomViewRight()
                    }.height(this.mHeight).width(this.bottomViewRightW)
                }
            }
            BottomViewBottom(
                bottomViewBottom: bottomViewBottom,bottomViewBottomH: bottomViewBottomH, parentIsTouch: parentIsTouch, offsetX: offsetX,
                offsetY: offsetY, mHeight: mHeight, mDuration:mDuration
            )
        }.position(x: this.offsetX, y: this.offsetY).width(this.mWidth.percent).height(this.mHeight)
    }
}
