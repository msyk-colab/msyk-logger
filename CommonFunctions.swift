//
//  CommonFunctions.swift
//  logger
//
//  Created by 水谷昌幸 on 2021/02/05.
//

import Foundation
var i = 0
//let sensorDataFileName = "SensorData.csv"

func getDateTimeString() -> String{
    let f = DateFormatter()
    f.dateFormat = "yyyy_MMdd_HHmmss"
    let now = Date()
    return f.string(from: now)
    //return f.string(from: dateDAQStarted)
}

func getNumber(num: Int) ->String{
    i = i + 1
    return String(i)
}

func convertDateTimeString(now: Date) -> String{
    let f = DateFormatter()
    f.dateFormat = "yyyy/MM/dd_HH:mm:ss"
    return f.string(from: now)
}

func getDateTimeMilisecString() -> String{
    let f = DateFormatter()
    f.dateFormat = "yyyy_MMdd_HHmm_ss_SSS"
    let now = Date()
    return f.string(from: now)
}

