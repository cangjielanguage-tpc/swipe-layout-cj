/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package swipelayout.commons

public class CommonFunc{
    public static func offsetXCalculate(offX: Float64, leftSlideEnable: Bool, bottomViewLeftW: Float64, moveX: Float64, rightSlideEnable: Bool, bottomViewRightW: Float64): Float64{
        var offsetX = offX
        if (offsetX > 0.0 && leftSlideEnable) {
            if (moveX >= 40.0) {
                offsetX = bottomViewLeftW
            } else if (moveX > 0.0) {
                offsetX = 0.0
            }
            if (moveX < -40.0) {
                offsetX = 0.0
            } else if (moveX < 0.0) {
                offsetX = bottomViewLeftW
            }
            return offsetX
        }

        if (offsetX < 0.0 && rightSlideEnable) {
            if (moveX >= 40.0) {
                offsetX = 0.0
            } else if (moveX > 0.0) {
                offsetX = -bottomViewRightW
            }

            if (moveX <= -40.0) {
                offsetX = -bottomViewRightW
            } else if (moveX < 0.0) {
                offsetX = 0.0
            }
            return offsetX
        }
        return offsetX
    }

    public static func offseYCalculate(offY: Float64, bottomViewTopH: Float64, moveY: Float64, bottomViewBottomH: Float64): Float64{
        var offsetY: Float64 = offY
        if (offsetY > 0.0) {
            if (moveY >= 20.0) {
                offsetY = bottomViewTopH
            } else {
                offsetY = 0.0
            }
            return offsetY
        }

        if (offsetY < 0.0) {
            if (moveY <= -20.0) {
                offsetY = -bottomViewBottomH
            } else {
                offsetY = 0.0
            }
            return offsetY
        }
        return offsetY
    }


}