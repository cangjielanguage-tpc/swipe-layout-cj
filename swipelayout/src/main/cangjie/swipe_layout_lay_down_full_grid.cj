/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package swipelayout

import ohos.state_macro_manage.*

@Component
public class SwipeLayoutLayDownFullGrid {
    @Link var itemContent: String = ""
    @Link var itemId: Int64 = 0
    private var mDuration: Int32 = 200
    public var mWidth: Float64 = 100.0
    public var mHeight: Float64 = 90.0
    private var sX: Float64 = 0.0
    private var sY: Float64 = 0.0
    private var bottomViewTopH: Float64 = 100.0
    private var bottomViewBottomH: Float64 = 100.0
    private var bottomViewRightW: Float64 = 320.0
    private var bottomViewLeftW: Float64 = 120.0
    @BuilderParam let surfaceView: (String, Int64) -> Unit
    @BuilderParam let bottomViewRight: (Int64) -> Unit
    @State var offsetY: Float64 = 0.0
    @State var offsetX: Float64 = 0.0
    private var leftSlideEnable: Bool = true
    private var rightSlideEnable: Bool = true
    private var previousX: Float64 = 0.0
    private var enableSlide: Array<Bool> = [false, true, true, false]

    protected override func aboutToAppear() {
        var screenW: Float64 = (px2vp(Float64(getDefaultDisplaySync().width).px)??Float64(
                getDefaultDisplaySync().width).px).value
        this.mWidth = if (this.mWidth > 100.0) { 100.0 } else { this.mWidth }
        this.bottomViewRightW = if (bottomViewRightW >= screenW) {
            screenW
        } else if (bottomViewRightW < 0.0) {
            0.0
        } else {
            this.bottomViewRightW
        }
    }

    func bottomViewRightDown(event: TouchEvent){
        if ("Down" == event.eventType.toString()) {
            this.sX = event.touches[0].screenX
            this.sY = event.touches[0].screenY
        }
    }

    func bottomViewRightMove(event: TouchEvent){
        if (event.eventType.toString() == "Move") {
            let moveX = event.touches[0].screenX - this.sX
            let moveY = event.touches[0].screenY - this.sY
            if (abs(moveX) > abs(moveY)) { // 横向滑动
                if (0.0 == this.offsetY) {
                    if (moveY > -30.0 && moveX < 0.0 && moveY < 30.0) { //左滑
                    } else if (moveY < 30.0 && moveX > 0.0 && moveY > -30.0) { //右滑
                        if (this.offsetX < 0.0) {
                            this.leftSlideEnable = false
                            bottomViewRightMove1(moveX)
                        }
                    }
                }
            }
            this.previousX = event.touches[0].screenX
        }
    }

    func bottomViewRightOnTouch(event1: TouchEvent){
        bottomViewRightDown(event1)
        bottomViewRightMove(event1)
        if (event1.eventType.toString() == "Up") {
            let moveX2 = event1.touches[0].screenX - this.sX
            animateTo(
                AnimateParam(
                    duration: this.mDuration, // 动画时长
                    tempo: 1.0, // 播放速率
                    iterations: 1, // 播放次数
                    playMode: PlayMode.Normal, // 动画模式
                    onFinish: {
                        =>
                        this.leftSlideEnable = true
                        this.rightSlideEnable = true
                    },
                    curve: Curve.FastOutLinearIn // 动画曲线
                ),
                {
                    => if (this.rightSlideEnable && this.offsetX < 0.0) {
                        if (moveX2 <= -40.0) {
                            this.offsetX = -this.bottomViewRightW
                        } else if (moveX2 < 0.0) {
                            this.offsetX = 0.0
                        }
                        bottomViewRightOnTouch1(moveX2)
                        return
                    }
                }
            )
        }
    }

    func surfaceViewDown(event: TouchEvent){
        if ("Down" == event.eventType.toString()) {
            this.sY = event.touches[0].screenY
            this.sX = event.touches[0].screenX
        }
    }

    func surfaceViewOnTouch(event3: TouchEvent){
        surfaceViewDown(event3)
        if (event3.eventType.toString() == "Move") {
            let moveY2 = event3.touches[0].screenY - this.sY
            let moveX2 = event3.touches[0].screenX - this.sX
            if (abs(moveX2) > abs(moveY2)) { // 横向滑动
                if (this.offsetY == 0.0) {
                    if (moveX2 < 0.0 && moveY2 < 30.0 && moveY2 > -30.0) { //左滑
                        //左侧菜单处于打开状态，开始关闭
                        surfaceViewOnTouch1(moveX2)
                        if (!this.enableSlide[2]) {
                            return
                        }
                        //当前移动距离小于右侧View的宽度，并且没有处于刚好拉出的状态
                        surfaceViewOnTouch2(moveX2, event3)
                    } else if (moveY2 < 30.0 && moveX2 > 0.0 && moveY2 > -30.0) { //右滑
                        //右侧菜单开始关闭
                        surfaceViewOnTouch3(moveX2)
                        if (!this.enableSlide[0]) {
                            return
                        }
                        //当前移动距离小于左侧View的宽度  并且没有处于刚好拉出的状态
                        surfaceViewOnTouch4(moveX2, event3)
                    }
                }
            }
            this.previousX = event3.touches[0].screenX
        }
        surfaceViewUp(event3)
    }

    func surfaceViewOnTouch1(moveX2: Float64){
        if (this.offsetX > 0.0) {
            this.rightSlideEnable = false
            if (-moveX2 < this.bottomViewLeftW) {
                this.offsetX = moveX2 + this.bottomViewLeftW
            } else {
                this.offsetX = 0.0
            }
            return
        }
    }

    func surfaceViewOnTouch2(moveX2: Float64, event3: TouchEvent){
        if (this.rightSlideEnable) {
            if (this.offsetX <= 0.0 && this.offsetX > -this.bottomViewRightW &&
                -moveX2 <= this.bottomViewRightW) {
                this.offsetX = moveX2
            } else if (-moveX2 > this.bottomViewRightW) {
                this.sX = event3.touches[0].screenX
                this.offsetX = -this.bottomViewRightW
                this.leftSlideEnable = false
            }
        }
    }

    func surfaceViewOnTouch3(moveX2: Float64){
        if (this.offsetX < 0.0) {
            this.leftSlideEnable = false
            if (moveX2 <= this.bottomViewRightW) {
                this.offsetX = moveX2 - this.bottomViewRightW
                return
            } else {
                this.offsetX = 0.0
            }
        }
    }

    func surfaceViewOnTouch4(moveX2: Float64, event3: TouchEvent){
        if (this.leftSlideEnable) {
            if (this.offsetX < this.bottomViewLeftW && moveX2 <=
                this.bottomViewLeftW && this.offsetX >= 0.0) {
                this.offsetX = moveX2
            } else if (moveX2 > this.bottomViewRightW) {
                this.offsetX = this.bottomViewLeftW
                this.rightSlideEnable = false
                this.sX = event3.touches[0].screenX
            }
        }
    }

    func surfaceViewUp(event: TouchEvent){
        if ("Up" == event.eventType.toString()) {
            let moveY = event.touches[0].screenY - this.sY
            let moveX = event.touches[0].screenX - this.sX
            animateTo(
                AnimateParam(
                    iterations: 1, // 播放次数
                    duration: this.mDuration, // 动画时长
                    tempo: 1.0, // 播放速率
                    curve: Curve.FastOutLinearIn, // 动画曲线
                    playMode: PlayMode.Normal, // 动画模式
                    onFinish: {
                        =>
                        this.leftSlideEnable = true
                        this.rightSlideEnable = true
                    }
                ),
                {
                    =>
                    surfaceViewUp1(moveX)
                    surfaceViewUp2(moveX)
                }
            )
        }
    }

    func surfaceViewUp1(moveX: Float64){
        if (this.offsetX > 0.0 && this.leftSlideEnable) {
            if (moveX >= 15.0) {
                this.offsetX = this.bottomViewLeftW
            } else if (moveX > 0.0) {
                this.offsetX = 0.0
            }
            if (moveX < -15.0) {
                this.offsetX = 0.0
            } else if (moveX < 0.0) {
                this.offsetX = this.bottomViewLeftW
            }
            return
        }
    }

    func surfaceViewUp2(moveX: Float64){
        if (this.rightSlideEnable && this.offsetX < 0.0) {
            if (moveX <= -15.0) {
                this.offsetX = -this.bottomViewRightW
            } else if (moveX < 0.0) {
                this.offsetX = 0.0
            }
            if (moveX >= 15.0) {
                this.offsetX = 0.0
            } else if (moveX > 0.0) {
                this.offsetX = -this.bottomViewRightW
            }
            return
        }
    }

    func bottomViewRightMove1(moveX: Float64){
        if (moveX <= this.bottomViewRightW) {
            this.offsetX = moveX - this.bottomViewRightW
            return
        } else {
            this.offsetX = 0.0
        }
    }

    func bottomViewRightOnTouch1(moveX2: Float64){
        if (moveX2 >= 40.0) {
            this.offsetX = 0.0
        } else if (moveX2 > 0.0) {
            this.offsetX = -this.bottomViewRightW
        }
    }

    func build() {
        Column() {
            Row() {
                Column() {
                    this.surfaceView(itemContent, itemId)
                }.onTouch(
                    {
                        event => surfaceViewOnTouch(event)
                    }
                )
                Column() {
                    Row() {
                        this.bottomViewRight(itemId)
                    }.width(this.bottomViewRightW).height(this.mHeight)
                }.onTouch(
                    {
                        event: TouchEvent => bottomViewRightOnTouch(event)
                    }
                )
            }
        }.width(this.mWidth.percent).height(this.mHeight).position(x: this.offsetX, y: this.offsetY)
    }
}
