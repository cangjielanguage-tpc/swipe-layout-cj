/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package swipelayout

import ohos.state_macro_manage.*

@Component
public class SwipeLayout {
    @Link var parentIsTouch: Bool
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
    private var bottomViewTopH: Float64 = 100.0
    private var bottomViewBottomH: Float64 = 100.0
    private var layoutRight: Bool = true
    private var layoutLeft: Bool = true
    private var layoutBottom: Bool = true
    private var layoutTop: Bool = true
    @State var offsetX: Float64 = 0.0
    @State var offsetY: Float64 = 0.0
    private var rightSlideEnable = true
    private var leftSlideEnable = true
    private var topSlideEnable = true
    private var bottomSlideEnable = true
    private var previousX: Float64 = 0.0

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
        this.bottomViewLeftW = if (bottomViewLeftW >= screenW) {
            screenW
        } else if (bottomViewLeftW < 0.0) {
            0.0
        } else {
            this.bottomViewLeftW
        }

        this.mWidth = if (this.mWidth > 100.0) { 100.0 } else { this.mWidth }
    }

    func build() {
        Column() {
            ColumnSplit() {
                this.bottomViewTop()
            }.position(x: 0, y: -Int64(this.bottomViewTopH)).onTouch(
                {
                    event => bottomOnTouch(event)
                }
            )

            Row() {
                ColumnSplit() {
                    this.bottomViewLeft()
                }.position(x: -this.bottomViewLeftW, y: 0.0).onTouch(
                    {
                        event => viewLeftOnTouch(event)
                    }
                )

                ColumnSplit() {
                    this.surfaceView()
                }.onTouch(
                    {
                        event => surfaceViewOnTouch(event)
                    }
                )

                ColumnSplit {
                    this.bottomViewRight()
                }.onTouch(
                    {
                        event => bottomViewRightOnTouch(event)
                    }
                )
            }
            if (layoutBottom) {
                ColumnSplit() {
                    this.bottomViewBottom()
                }.onTouch(
                    {
                        event => bottomViewBottomOnTouch(event)
                    }
                )
            }
        }.width(this.mWidth.percent).height(this.mHeight).position(x: this.offsetX, y: this.offsetY)
    }

    func bottomViewBottomOnTouch(event: TouchEvent){
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
                        this.topSlideEnable = false
                        if (Float64(this.mHeight) - abs(moveY) >= 0.0) {
                            this.offsetY = -(this.bottomViewBottomH - moveY)
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
                    iterations: 1, // 播放次数
                    tempo: 1.0, // 播放速率
                    curve: Curve.FastOutLinearIn, // 动画曲线
                    playMode: PlayMode.Normal, // 动画模式
                    onFinish: {
                        =>
                        this.topSlideEnable = true
                        this.bottomSlideEnable = true
                    }
                ),
                {
                    => if (this.offsetY < 0.0) {
                        if (abs(moveY) >= 20.0) {
                            this.offsetY = 0.0
                        } else {
                            this.offsetY = -this.bottomViewBottomH
                        }
                    }
                }
            )
        }
    }

    func bottomViewRightOnTouch(event: TouchEvent){
        if ("Down" == event.eventType.toString()) {
            this.sX = event.touches[0].screenX
            this.sY = event.touches[0].screenY
        }

        if (event.eventType.toString() == "Move") {
            let moveY = event.touches[0].screenY - this.sY
            let moveX = event.touches[0].screenX - this.sX
            if (abs(moveX) > abs(moveY)) { // 横向滑动
                if (this.offsetY == 0.0) {
                    if (moveX > 0.0 && moveY < 30.0 && moveY > -30.0) { //右滑
                        bottomViewRightOnTouch4(moveX)
                    }
                }
            }
            this.previousX = event.touches[0].screenX
        }

        if ("Up" == event.eventType.toString()) {
            let moveX = event.touches[0].screenX - this.sX
            bottomViewRightOnTouch1(moveX)
        }
    }

    func bottomViewRightOnTouch1(moveX1: Float64){
        animateTo(
            AnimateParam(
                curve: Curve.FastOutLinearIn, // 动画曲线
                duration: this.mDuration, // 动画时长
                tempo: 1.0, // 播放速率
                iterations: 1, // 播放次数
                onFinish: {
                    =>
                    this.leftSlideEnable = true
                    this.rightSlideEnable = true
                },
                playMode: PlayMode.Normal// 动画模式
            ),
            {
                => if (this.rightSlideEnable && this.offsetX < 0.0) {
                    bottomViewRightOnTouch2(moveX1)
                    return
                }
            }
        )
    }

    func surfaceViewOnTouch1(event: TouchEvent){
        if (event.eventType.toString() == "Up") {
            let moveX = event.touches[0].screenX - this.sX
            let moveY = event.touches[0].screenY - this.sY
            animateTo(
                AnimateParam(
                    curve: Curve.FastOutLinearIn, // 动画曲线
                    iterations: 1, // 播放次数
                    playMode: PlayMode.Normal, // 动画模式
                    tempo: 1.0, // 播放速率
                    duration: this.mDuration, // 动画时长
                    onFinish: {
                        =>
                        this.rightSlideEnable = true
                        this.leftSlideEnable = true
                        this.topSlideEnable = true
                        this.bottomSlideEnable = true
                    }
                ),
                { =>
                    this.offsetX = CommonFunc.offsetXCalculate(offsetX, leftSlideEnable, bottomViewLeftW, moveX, rightSlideEnable, bottomViewRightW)
                    surfaceViewOnTouch2(moveY)
                    if (this.offsetY < 0.0 && this.bottomSlideEnable) {
                        surfaceViewOnTouch3(moveY)
                        return
                    }
                }
            )
            this.parentIsTouch = true
        }
    }

    func bottomViewRightOnTouch4(moveX: Float64){
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

    func bottomViewRightOnTouch2(moveX1: Float64){
        if (moveX1 <= -40.0) {
            this.offsetX = -this.bottomViewRightW
        } else if (moveX1 < 0.0) {
            this.offsetX = 0.0
        }
        if (moveX1 >= 40.0) {
            this.offsetX = 0.0
        } else if (moveX1 > 0.0) {
            this.offsetX = -this.bottomViewRightW
        }
    }

    func surfaceViewOnTouch2(moveY: Float64){
        if (this.offsetY > 0.0 && this.topSlideEnable) {
            if (abs(moveY) >= 20.0) {
                this.offsetY = this.bottomViewTopH
            } else if (moveY > 0.0) {
                this.offsetY = 0.0
            }
            if (moveY < -20.0) {
                this.offsetY = 0.0
            } else if (moveY < 0.0) {
                this.offsetY = this.bottomViewTopH
            }
        }
    }

    func surfaceViewOnTouch3(moveY: Float64){
        if (abs(moveY) >= 20.0) {
            this.offsetY = 0.0
        } else if (moveY > 0.0) {
            this.offsetY = -this.bottomViewBottomH
        }
        if (moveY < -20.0) {
            this.offsetY = -this.bottomViewBottomH
        } else if (moveY < 0.0) {
            this.offsetY = 0.0
        }
    }

    func surfaceViewOnTouch1(moveX1: Float64){
        this.rightSlideEnable = false
        if (-moveX1 < this.bottomViewLeftW) {
            this.offsetX = moveX1 + this.bottomViewLeftW
        } else {
            this.offsetX = 0.0
        }
    }

    func surfaceViewOnTouch2(moveX: Float64, event: TouchEvent){
        if (this.rightSlideEnable) {
            if (this.offsetX <= 0.0 && this.offsetX > -this.bottomViewRightW &&
                -moveX <= this.bottomViewRightW) {
                this.offsetX = moveX
            } else if (-moveX > this.bottomViewRightW) {
                this.leftSlideEnable = false
                this.offsetX = -this.bottomViewRightW
                this.sX = event.touches[0].screenX
            }
        }
    }

    func surfaceViewOnTouch3(moveX: Float64, event: TouchEvent){
        if (this.leftSlideEnable) {
            if (this.offsetX >= 0.0 && this.offsetX < this.bottomViewLeftW && moveX <=
                this.bottomViewLeftW) {
                this.offsetX = moveX
            } else if (moveX > this.bottomViewRightW) {
                this.rightSlideEnable = false
                this.offsetX = this.bottomViewLeftW
                this.sX = event.touches[0].screenX
            }
        }
    }

    func surfaceViewOnTouch4(moveX: Float64){
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

    func surfaceViewOnTouch5(moveY: Float64){
        if (this.offsetY < 0.0) {
            this.topSlideEnable = false
            if (moveY - this.bottomViewBottomH <= 0.0) {
                this.offsetY = moveY - this.bottomViewBottomH
                return
            }
        }
    }

    func surfaceViewOnTouch6(moveY: Float64){
        if (this.topSlideEnable) {
            if (this.offsetY < this.bottomViewTopH) {
                this.offsetY = moveY
            } else {
                this.offsetY = this.bottomViewTopH
                this.bottomSlideEnable = false
            }
        }
    }

    func surfaceViewOnTouch7(moveY: Float64){
        if (this.offsetY > 0.0) {
            this.bottomSlideEnable = false
            if (this.bottomViewTopH - abs(moveY) >= 0.0) {
                this.offsetY = this.bottomViewTopH + moveY
                return
            }
        }
    }

    func surfaceViewOnTouch8(moveY: Float64){
        if (this.bottomSlideEnable) {
            if (abs(this.offsetY) < this.bottomViewBottomH) {
                this.offsetY = moveY
            } else {
                this.offsetY = -this.bottomViewBottomH
                this.topSlideEnable = false
            }
        }
    }

    func surfaceViewOnTouch9(event: TouchEvent){
        if (event.eventType.toString() == "Down") {
            this.parentIsTouch = false
            this.sX = event.touches[0].screenX
            this.sY = event.touches[0].screenY
        }
    }

    func surfaceViewOnTouch10(moveX: Float64, moveY: Float64, event: TouchEvent){
        if (this.offsetY == 0.0) {
            if (layoutRight && moveX < 0.0 && moveY < 30.0 && moveY > -30.0) { //左滑
                //左侧菜单处于打开状态，开始关闭
                if (this.offsetX > 0.0) {
                    surfaceViewOnTouch1(moveX)
                    return
                }
                //当前移动距离小于右侧View的宽度，并且没有处于刚好拉出的状态
                surfaceViewOnTouch2(moveX, event)
            } else if (layoutLeft && moveX > 0.0 && moveY < 30.0 && moveY > -30.0) { //右滑
                //右侧菜单开始关闭
                surfaceViewOnTouch4(moveX)
                //当前移动距离小于左侧View的宽度  并且没有处于刚好拉出的状态
                surfaceViewOnTouch3(moveX, event)
            }
        }
    }

    func surfaceViewOnTouch(event: TouchEvent){
        surfaceViewOnTouch9(event)
        if (event.eventType.toString() == "Move") {
            let moveX = event.touches[0].screenX - this.sX
            let moveY = event.touches[0].screenY - this.sY
            if (abs(moveX) > abs(moveY)) { // 横向滑动
                surfaceViewOnTouch10(moveX, moveY, event)
            } else { //纵向滑动
                if (this.offsetX == 0.0) {
                    if (layoutTop && moveY > 0.0) { //下滑
                        //底部菜单开始关闭
                        surfaceViewOnTouch5(moveY)
                        //当前移动距离小于顶部View的宽度，并且没有处于刚好拉出的状态
                        surfaceViewOnTouch6(moveY)
                    } else if (layoutBottom && moveY < 0.0) { //上滑
                        //顶侧菜单开始关闭
                        surfaceViewOnTouch7(moveY)
                        //当前移动距离小于左侧View的宽度  并且没有处于刚好拉出的状态
                        surfaceViewOnTouch8(moveY)
                    }
                }
            }
            this.previousX = event.touches[0].screenX
        }
        surfaceViewOnTouch1(event)
    }

    func viewLeftOnTouch1(event: TouchEvent){
        if (event.eventType.toString() == "Move") {
            let moveX = event.touches[0].screenX - this.sX
            let moveY = event.touches[0].screenY - this.sY
            if (abs(moveX) > abs(moveY)) { // 横向滑动
                if (this.offsetY == 0.0) {
                    if (moveX < 0.0 && moveY < 30.0 && moveY > -30.0) {
                        if (this.offsetX > 0.0) {
                            this.rightSlideEnable = false
                            if (-moveX <= this.bottomViewLeftW) {
                                this.offsetX = moveX + this.bottomViewLeftW
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
    }

    func viewLeftOnTouch3(moveX: Float64){
        if (this.offsetX > 0.0 && this.leftSlideEnable) {
            if (moveX >= 40.0) {
                this.offsetX = this.bottomViewLeftW
            } else if (moveX > 0.0) {
                this.offsetX = 0.0
            }
            viewLeftOnTouch2(moveX)
            return
        }
    }

    func viewLeftOnTouch2(moveX: Float64){
        if (moveX <= -40.0) {
            this.offsetX = 0.0
        } else if (moveX < 0.0) {
            this.offsetX = this.bottomViewLeftW
        }
    }

    func viewLeftOnTouch(event: TouchEvent){
        if (event.eventType.toString() == "Down") {
            this.sX = event.touches[0].screenX
            this.sY = event.touches[0].screenY
        }
        viewLeftOnTouch1(event)
        if ("Up" == event.eventType.toString()) {
            let moveX = event.touches[0].screenX - this.sX
            animateTo(
                AnimateParam(
                    iterations: 1, // 播放次数
                    duration: this.mDuration, // 动画时长
                    tempo: 1.0, // 播放速率
                    playMode: PlayMode.Normal, // 动画模式
                    curve: Curve.FastOutLinearIn, // 动画曲线
                    onFinish: {
                        =>
                        this.leftSlideEnable = true
                        this.rightSlideEnable = true
                    }
                ),
                {
                    => viewLeftOnTouch3(moveX)
                }
            )
        }
    }

    func bottomOnTouch1(event: TouchEvent){
        if (event.eventType.toString() == "Move") {
            let moveX = event.touches[0].screenX - this.sX
            let moveY = event.touches[0].screenY - this.sY
            if (abs(moveX) < abs(moveY)) { //纵向滑动
                if (moveY < 0.0) { //上滑
                    //顶侧菜单开始关闭
                    if (this.offsetY > 0.0) {
                        this.bottomSlideEnable = false
                        if (Float64(this.mHeight) - abs(moveY) >= 0.0) {
                            this.offsetY = this.bottomViewTopH + moveY
                            return
                        }
                    }
                }
            }
        }
    }

    func bottomOnTouch(event: TouchEvent){
        if (event.eventType.toString() == "Down") {
            this.sX = event.touches[0].screenX
            this.sY = event.touches[0].screenY
        }
        bottomOnTouch1(event)
        if (event.eventType.toString() == "Up") {
            let moveY = event.touches[0].screenY - this.sY
            animateTo(
                AnimateParam(
                    curve: Curve.FastOutLinearIn, // 动画曲线
                    playMode: PlayMode.Normal, // 动画模式
                    iterations: 1, // 播放次数
                    duration: this.mDuration, // 动画时长
                    tempo: 1.0, // 播放速率
                    onFinish: {
                        =>
                        this.topSlideEnable = true
                        this.bottomSlideEnable = true
                    }
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
        }
    }
}
