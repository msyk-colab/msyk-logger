//
//  SensorDataManager.swift
//  logger WatchKit Extension
//
//  Created by msyk on 2021/02/17.
//

import Foundation
import CoreMotion
//import SwiftUI
import AVFoundation
import WatchConnectivity
import HealthKit
import Combine

//
// Heart rate data acquisition
// All functionalities are implemented by WorkoutManager.swift.

//
// Acceleration data acquisition
//

extension CMSensorDataList: Sequence {
    public typealias Iterator = NSFastEnumerationIterator
    public func makeIterator() -> NSFastEnumerationIterator {
        return NSFastEnumerationIterator(self)
    }
}

let sensorrecorder = CMSensorRecorder()
let sensorDataFileName = "SensorData.csv"

func startAccelerationSensorUpdates(durationMinutes: Double)->String{
    dateDAQStarted = Date()
    var stringreturn = "Acceleration DAQ failed."
    if CMSensorRecorder.isAccelerometerRecordingAvailable() {
        sensorrecorder.recordAccelerometer(forDuration: durationMinutes * 60)
        stringreturn = "Acceleration DAQ started at \n\(convertDateTimeString(now: dateDAQStarted)) \nfor \(durationMinutes) min"
    }
    return stringreturn
}

func getsend720(intervalSeconds: Double)->String {
    dateDAQEnded = Date()
    var stringreturn = "Acceleration data retrieve failed"
    for i in stride(from: 10, to: 750, by: 10){
        a = Calendar.current.date(byAdding: .minute, value: i-10, to: dateDAQStarted)!
        b = Calendar.current.date(byAdding: .minute, value: i, to: dateDAQStarted)!
        print("i: \(i)")
        print("a: \(a)")
        print("b: \(b)")
        if let listCMSensorData = sensorrecorder.accelerometerData(from: a, to: b){
            //c.append("(convertDateTimeString(now: a))")
            stringreturn = "Acceleration data retrieved \nfrom \(convertDateTimeString(now: a)) \nto\(convertDateTimeString(now: b))"
            //with interval \(intervalSeconds) sec"
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let docsDirect = paths[0]
            let fileURL = docsDirect.appendingPathComponent(sensorDataFileName)
            let stringfirstline = "\(convertDateTimeString(now: a)),\(convertDateTimeString(now: b))\nTimestamp,AxelX,AxelY,AxelZ\n"
            creatDataFile(onetimestring: stringfirstline, fileurl: fileURL)
            for (index, data) in (listCMSensorData.enumerated()) {
                let stringData = "\((data as AnyObject).timestamp!),\((data as AnyObject).acceleration.x),\((data as AnyObject).acceleration.y),\((data as AnyObject).acceleration.z)\n"
                appendDataToFile(string: stringData, fileurl: fileURL)
                //print(index, data)
            }
            stringreturn = "Acceleration data retrieved \nfrom \(convertDateTimeString(now: dateDAQStarted)) \nto\(convertDateTimeString(now: b))\n" + fileTransfer(fileURL: getSensorDataFileURL(), metaData: ["":""])
            /*
            do{
                try fileTransfer(fileURL: getSensorDataFileURL(), metaData: ["":""])
                print("success")
            }catch{
                print("fail")
            }
            */
        }else{
            print("Acceleration data retrieve failed")
        }
    }
    return stringreturn
}


//func

func getsend480(intervalSeconds: Double)->String {
    dateDAQEnded = Date()
    var stringreturn = "Acceleration data retrieve failed"
    for i in stride(from: 10, to: 490, by: 10) {
        a = Calendar.current.date(byAdding: .minute, value: i-10, to: dateDAQStarted)!
        b = Calendar.current.date(byAdding: .minute, value: i, to: dateDAQStarted)!
        print("i: \(i)")
        print("a: \(a)")
        print("b: \(b)")
        
        //
        if let listCMSensorData = sensorrecorder.accelerometerData(from: a, to: b){
            stringreturn = "Acceleration data retrieved \nfrom \(convertDateTimeString(now: a)) \nto\(convertDateTimeString(now: b))"
            //with interval \(intervalSeconds) sec"
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let docsDirect = paths[0]
            let fileURL = docsDirect.appendingPathComponent(sensorDataFileName)
            let stringfirstline = "\(convertDateTimeString(now: a)),\(convertDateTimeString(now: b))\nTimestamp,AxelX,AxelY,AxelZ\n"
            creatDataFile(onetimestring: stringfirstline, fileurl: fileURL)
            
            /*
            for (data) in (listCMSensorData) {
            //Process the data.
            NSLog(@"Sample: (%f, %f, %f)", data.acceleration.x,
                    data.acceleration.y, data.acceleration.z);
            }
        */
            //for (index, data) in (listCMSensorData.enumerated())
            for (data) in (listCMSensorData) {
                let stringData = "\((data as AnyObject).timestamp!),\((data as AnyObject).acceleration.x),\((data as AnyObject).acceleration.y),\((data as AnyObject).acceleration.z)\n"
                appendDataToFile(string: stringData, fileurl: fileURL)
            }
            stringreturn = "Acceleration data retrieved \nfrom \(convertDateTimeString(now: dateDAQStarted)) \nto\(convertDateTimeString(now: b))\n" + fileTransfer(fileURL: getSensorDataFileURL(), metaData: ["":""])
        }
    }
    return stringreturn
}

func getsend12(intervalSeconds: Double)->String {
    var stringreturn = "Acceleration data retrieve failed"
    
        dateDAQEnded = Date()
        for i in 1..<13 {
            a = Calendar.current.date(byAdding: .minute, value: i-1, to: dateDAQStarted)!
            b = Calendar.current.date(byAdding: .minute, value: i, to: dateDAQStarted)!
            print("i: \(i)")
            print("a: \(a)")
            print("b: \(b)")
            if let listCMSensorData = sensorrecorder.accelerometerData(from: a, to: b){
                stringreturn = "Acceleration data retrieved \nfrom \(convertDateTimeString(now: a)) \nto\(convertDateTimeString(now: b))"
                print("stringreturn: \(stringreturn)")
                //with interval \(intervalSeconds) sec"
                let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
                let docsDirect = paths[0]
                let fileURL = docsDirect.appendingPathComponent(sensorDataFileName)
                let stringfirstline = "\(convertDateTimeString(now: a)),\(convertDateTimeString(now: b))\nTimestamp,AxelX,AxelY,AxelZ\n"
                creatDataFile(onetimestring: stringfirstline, fileurl: fileURL)
                for (index, data)  in (listCMSensorData.enumerated()) {
                    let stringData = "\((data as AnyObject).timestamp!),\((data as AnyObject).acceleration.x),\((data as AnyObject).acceleration.y),\((data as AnyObject).acceleration.z)\n"
                    appendDataToFile(string: stringData, fileurl: fileURL)
                    //print(index, data)
                }
                stringreturn = "Acceleration data retrieved \nfrom \(convertDateTimeString(now: dateDAQStarted)) \nto\(convertDateTimeString(now: b))\n" + fileTransfer(fileURL: getSensorDataFileURL(), metaData: ["":""])
                print("stringreturn: \(stringreturn)")
            }
            
        }
        return stringreturn
}


func stopAccelerationSensorUpdates(intervalSeconds: Double)->String {
    dateDAQEnded = Date()
    print("intervalSeconds",intervalSeconds)
    var stringreturn = "Acceleration data retrieve failed"
    if let listCMSensorData = sensorrecorder.accelerometerData(from: dateDAQStarted, to: dateDAQEnded){
        stringreturn = "Acceleration data retrieved at \(convertDateTimeString(now: dateDAQEnded)) with interval \(intervalSeconds) sec"
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docsDirect = paths[0]
        let fileURL = docsDirect.appendingPathComponent(sensorDataFileName)
        let stringfirstline = "\(convertDateTimeString(now: dateDAQStarted))\nTimestamp,AxelX,AxelY,AxelZ\n"
        creatDataFile(onetimestring: stringfirstline, fileurl: fileURL)
        let tol: Double = 1.0/(50*100) // intervalSeconds must be smaller than 100 [s] in this case.
        for (index, data) in (listCMSensorData.enumerated()) {
            if (abs(Double(index).remainder(dividingBy: intervalSeconds*50.0)) < tol) {
                let stringData = "\((data as AnyObject).timestamp!),\((data as AnyObject).acceleration.x),\((data as AnyObject).acceleration.y),\((data as AnyObject).acceleration.z)\n"
                appendDataToFile(string: stringData, fileurl: fileURL)
                //print(index, data)
            }
        }
        stringreturn = "Acceleration data retrieved at \(convertDateTimeString(now: dateDAQEnded)) with interval \(intervalSeconds) sec\n" + fileTransfer(fileURL: getSensorDataFileURL(), metaData: ["":""])
    }
    return stringreturn
}

/*
func stopAccelerationSensorUpdates(intervalSeconds: Double)->String {
    dateDAQEnded = Date()
    var stringreturn = "Acceleration data retrieve failed"
    if let listCMSensorData = sensorrecorder.accelerometerData(from: dateDAQStarted, to: dateDAQEnded){
        stringreturn = "Acceleration data retrieved at \(convertDateTimeString(now: dateDAQEnded)) with interval \(intervalSeconds) sec"
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docsDirect = paths[0]
        let fileURL = docsDirect.appendingPathComponent(sensorDataFileName)
        let stringfirstline = "\(convertDateTimeString(now: dateDAQStarted))\nTimestamp,AxelX,AxelY,AxelZ\n"
        creatDataFile(onetimestring: stringfirstline, fileurl: fileURL)
        let tol: Double = 1.0/(50*100) // intervalSeconds must be smaller than 100 [s] in this case.
        for (index, data) in (listCMSensorData.enumerated()) {
            if (abs(Double(index).remainder(dividingBy: intervalSeconds*50.0)) < tol) {
                let stringData = "\((data as AnyObject).timestamp!),\((data as AnyObject).acceleration.x),\((data as AnyObject).acceleration.y),\((data as AnyObject).acceleration.z)\n"
                appendDataToFile(string: stringData, fileurl: fileURL)
                //print(index, data)
            }
        }
    }
    return stringreturn
}
 */



//
// Motion data acquisition
//

let motionManager = CMMotionManager()

func startMotionSensorUpdates(intervalSeconds: Double)->String{
    var stringreturn = "Default motion sensor"
    if motionManager.isDeviceMotionAvailable{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docsDirect = paths[0]
        let fileURL = docsDirect.appendingPathComponent(sensorDataFileName)
        let stringfirstline = "Timestamp,DateTimeMilisec,Pitch,Roll,Yaw,RotX,RotY,RotZ,GravX,GravY,GravZ,AxelX,AxelY,AxelZ\n"
        creatDataFile(onetimestring: stringfirstline, fileurl: fileURL)
        motionManager.deviceMotionUpdateInterval = intervalSeconds
        motionManager.startDeviceMotionUpdates(to: OperationQueue.current!,withHandler: {
            (motion:CMDeviceMotion?, error:Error?) in
            saveMotionData(deviceMotion: motion!, fileurl: fileURL)
        })
        stringreturn = "Started motion sensor DAQ with "+String(intervalSeconds)+"s"
    } else{
    stringreturn = "Failed motion sensor DAQ"
    }
    return stringreturn
}

func getMotionData(deviceMotion: CMDeviceMotion){
    print("attitudeX:", deviceMotion.attitude.pitch)
    print("attitudeY:", deviceMotion.attitude.roll)
    print("attitudeZ:", deviceMotion.attitude.yaw)
    print("gyroX:", deviceMotion.rotationRate.x)
    print("gyroY:", deviceMotion.rotationRate.y)
    print("gyroZ:", deviceMotion.rotationRate.z)
    print("gravityX:", deviceMotion.gravity.x)
    print("gravityY:", deviceMotion.gravity.y)
    print("gravityZ:", deviceMotion.gravity.z)
    print("accX:", deviceMotion.userAcceleration.x)
    print("accY:", deviceMotion.userAcceleration.y)
    print("accZ:", deviceMotion.userAcceleration.z)
}

func saveMotionData(deviceMotion: CMDeviceMotion, fileurl: URL){
    let datetimemilisecstring = getDateTimeMilisecString()
    let string = "\(deviceMotion.timestamp), \(datetimemilisecstring),\(deviceMotion.attitude.pitch),\(deviceMotion.attitude.roll),\(deviceMotion.attitude.yaw),\(deviceMotion.rotationRate.x),\(deviceMotion.rotationRate.y),\(deviceMotion.rotationRate.z),\(deviceMotion.gravity.x),\(deviceMotion.gravity.y),\(deviceMotion.gravity.z),\(deviceMotion.userAcceleration.x),\(deviceMotion.userAcceleration.y),\(deviceMotion.userAcceleration.z)\n"
    appendDataToFile(string: string, fileurl: fileurl)
}

func stopMotionSensorUpdates()->String {
    if motionManager.isDeviceMotionAvailable{
        motionManager.stopDeviceMotionUpdates()
        return "Stopped motion sensor updates."
    }else {
        return "Failed stopping motion sensor updates"
    }
}



//
// Common data file handling functions
//

func testDataFileSave()->String{
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let docsDirect = paths[0]
    let fileURL = docsDirect.appendingPathComponent(sensorDataFileName)
    creatDataFile(onetimestring: "First line\n", fileurl: fileURL)
    appendDataToFile(string: "Second line\n", fileurl: fileURL)
    return "Saved test data file"
}

func creatDataFile(onetimestring: String, fileurl: URL){
    if FileManager.default.fileExists(atPath: fileurl.path) {
      do {
        try FileManager.default.removeItem(atPath: fileurl.path)
      } catch {
        print("Existing sensor data file cannot be deleted.")
      }
    }
    let data = onetimestring.data(using: .utf8)
    if FileManager.default.createFile(atPath: fileurl.path, contents: data, attributes: nil){
        print("Data file was created successfully.")
    } else {
        print("Failed creating data file.")
    }
}

func appendDataToFile(string: String, fileurl: URL){
    if let outputStream = OutputStream(url: fileurl, append: true) {
        outputStream.open()
        let data = string.data(using: .utf8)!
        let bytesWritten = outputStream.write(string, maxLength: data.count)
        if bytesWritten < 0 { print("Data write(append) failed.") }
        outputStream.close()
    } else {
        print("Unable to open file for appending data.")
    }
}

func fileTransfer(fileURL: URL, metaData: [String:String])->String{
    WCSession.default.transferFile(fileURL, metadata: metaData)
    return "File transfer initiated."
}


func getSensorDataFileURL() -> URL{
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let docsDirect = paths[0]
    let fileURL = docsDirect.appendingPathComponent("SensorData.csv")
    return fileURL
}


func two(intervalSeconds: Double)->String {
    dateDAQEnded = Date()
    var stringreturn = "Acceleration data retrieve failed"
    for i in stride(from: e, to: e+120, by: 10) {
        a = Calendar.current.date(byAdding: .minute, value: i-10, to: dateDAQStarted)!
        b = Calendar.current.date(byAdding: .minute, value: i, to: dateDAQStarted)!
        //print("i: \(i)")
        print("a: \(a)")
        //print("b: \(b)")
        let sensorDataFileName = "10min from\(convertDateTimeString(now: a)).csv"
        if d == 1{
            d = 0
            if let listCMSensorData = sensorrecorder.accelerometerData(from: a, to: b){
                stringreturn = "Acceleration data retrieved \nfrom \(convertDateTimeString(now: a)) \nto\(convertDateTimeString(now: b))"
                //with interval \(intervalSeconds) sec"
                let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
                let docsDirect = paths[0]
                let fileURL = docsDirect.appendingPathComponent(sensorDataFileName)
                let stringfirstline = "\(convertDateTimeString(now: a)),\(convertDateTimeString(now: b))\nTimestamp,AxelX,AxelY,AxelZ\n"
                creatDataFile(onetimestring: stringfirstline, fileurl: fileURL)
                //for (index, data) in (listCMSensorData.enumerated())
                for (data) in (listCMSensorData) {
                    let stringData = "\((data as AnyObject).timestamp!),\((data as AnyObject).acceleration.x),\((data as AnyObject).acceleration.y),\((data as AnyObject).acceleration.z)\n"
                    appendDataToFile(string: stringData, fileurl: fileURL)
                }
                stringreturn = "Acceleration data retrieved \nfrom \(convertDateTimeString(now: dateDAQStarted)) \nto\(convertDateTimeString(now: b))\n"+fileTransfer(fileURL: getSensorDataFileURL(), metaData: ["":""])
        }
        }
    }
    return stringreturn
}
/*
func four(intervalSeconds: Double)->String {
    dateDAQEnded = Date()
    var stringreturn = "Acceleration data retrieve failed"
    for i in stride(from: 130, to: 250, by: 10) {
        a = Calendar.current.date(byAdding: .minute, value: i-10, to: dateDAQStarted)!
        b = Calendar.current.date(byAdding: .minute, value: i, to: dateDAQStarted)!
        let sensorDataFileName = "10min from\(convertDateTimeString(now: a)).csv"
        if let listCMSensorData = sensorrecorder.accelerometerData(from: a, to: b){
            stringreturn = "Acceleration data retrieved \nfrom \(convertDateTimeString(now: a)) \nto\(convertDateTimeString(now: b))"
            //with interval \(intervalSeconds) sec"
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let docsDirect = paths[0]
            let fileURL = docsDirect.appendingPathComponent(sensorDataFileName)
            let stringfirstline = "\(convertDateTimeString(now: a)),\(convertDateTimeString(now: b))\nTimestamp,AxelX,AxelY,AxelZ\n"
            creatDataFile(onetimestring: stringfirstline, fileurl: fileURL)
            //for (index, data) in (listCMSensorData.enumerated())
            for (data) in (listCMSensorData) {
                let stringData = "\((data as AnyObject).timestamp!),\((data as AnyObject).acceleration.x),\((data as AnyObject).acceleration.y),\((data as AnyObject).acceleration.z)\n"
                appendDataToFile(string: stringData, fileurl: fileURL)
            }
            stringreturn = "Acceleration data retrieved \nfrom \(convertDateTimeString(now: dateDAQStarted)) \nto\(convertDateTimeString(now: b))\n" + fileTransfer(fileURL: getSensorDataFileURL(), metaData: ["":""])
        }
    }
    return stringreturn
}
func six(intervalSeconds: Double)->String {
    dateDAQEnded = Date()
    var stringreturn = "Acceleration data retrieve failed"
    for i in stride(from: 250, to: 370, by: 10) {
        a = Calendar.current.date(byAdding: .minute, value: i-10, to: dateDAQStarted)!
        b = Calendar.current.date(byAdding: .minute, value: i, to: dateDAQStarted)!
        let sensorDataFileName = "10min from\(convertDateTimeString(now: a)).csv"
        if let listCMSensorData = sensorrecorder.accelerometerData(from: a, to: b){
            stringreturn = "Acceleration data retrieved \nfrom \(convertDateTimeString(now: a)) \nto\(convertDateTimeString(now: b))"
            //with interval \(intervalSeconds) sec"
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let docsDirect = paths[0]
            let fileURL = docsDirect.appendingPathComponent(sensorDataFileName)
            let stringfirstline = "\(convertDateTimeString(now: a)),\(convertDateTimeString(now: b))\nTimestamp,AxelX,AxelY,AxelZ\n"
            creatDataFile(onetimestring: stringfirstline, fileurl: fileURL)
            //for (index, data) in (listCMSensorData.enumerated())
            for (data) in (listCMSensorData) {
                let stringData = "\((data as AnyObject).timestamp!),\((data as AnyObject).acceleration.x),\((data as AnyObject).acceleration.y),\((data as AnyObject).acceleration.z)\n"
                appendDataToFile(string: stringData, fileurl: fileURL)
            }
            stringreturn = "Acceleration data retrieved \nfrom \(convertDateTimeString(now: dateDAQStarted)) \nto\(convertDateTimeString(now: b))\n" + fileTransfer(fileURL: getSensorDataFileURL(), metaData: ["":""])
        }
    }
    return stringreturn
}
func eight(intervalSeconds: Double)->String {
    dateDAQEnded = Date()
    var stringreturn = "Acceleration data retrieve failed"
    for i in stride(from: 370, to: 490, by: 10) {
        a = Calendar.current.date(byAdding: .minute, value: i-10, to: dateDAQStarted)!
        b = Calendar.current.date(byAdding: .minute, value: i, to: dateDAQStarted)!
        let sensorDataFileName = "10min from\(convertDateTimeString(now: a)).csv"
        if let listCMSensorData = sensorrecorder.accelerometerData(from: a, to: b){
            stringreturn = "Acceleration data retrieved \nfrom \(convertDateTimeString(now: a)) \nto\(convertDateTimeString(now: b))"
            //with interval \(intervalSeconds) sec"
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let docsDirect = paths[0]
            let fileURL = docsDirect.appendingPathComponent(sensorDataFileName)
            let stringfirstline = "\(convertDateTimeString(now: a)),\(convertDateTimeString(now: b))\nTimestamp,AxelX,AxelY,AxelZ\n"
            creatDataFile(onetimestring: stringfirstline, fileurl: fileURL)
            //for (index, data) in (listCMSensorData.enumerated())
            for (data) in (listCMSensorData) {
                let stringData = "\((data as AnyObject).timestamp!),\((data as AnyObject).acceleration.x),\((data as AnyObject).acceleration.y),\((data as AnyObject).acceleration.z)\n"
                appendDataToFile(string: stringData, fileurl: fileURL)
            }
            stringreturn = "Acceleration data retrieved \nfrom \(convertDateTimeString(now: dateDAQStarted)) \nto\(convertDateTimeString(now: b))\n" + fileTransfer(fileURL: getSensorDataFileURL(), metaData: ["":""])
        }
    }
    return stringreturn
}
func ten(intervalSeconds: Double)->String {
    dateDAQEnded = Date()
    var stringreturn = "Acceleration data retrieve failed"
    for i in stride(from: 490, to: 610, by: 10) {
        a = Calendar.current.date(byAdding: .minute, value: i-10, to: dateDAQStarted)!
        b = Calendar.current.date(byAdding: .minute, value: i, to: dateDAQStarted)!
        let sensorDataFileName = "10min from\(convertDateTimeString(now: a)).csv"
        if let listCMSensorData = sensorrecorder.accelerometerData(from: a, to: b){
            stringreturn = "Acceleration data retrieved \nfrom \(convertDateTimeString(now: a)) \nto\(convertDateTimeString(now: b))"
            //with interval \(intervalSeconds) sec"
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let docsDirect = paths[0]
            let fileURL = docsDirect.appendingPathComponent(sensorDataFileName)
            let stringfirstline = "\(convertDateTimeString(now: a)),\(convertDateTimeString(now: b))\nTimestamp,AxelX,AxelY,AxelZ\n"
            creatDataFile(onetimestring: stringfirstline, fileurl: fileURL)
            //for (index, data) in (listCMSensorData.enumerated())
            for (data) in (listCMSensorData) {
                let stringData = "\((data as AnyObject).timestamp!),\((data as AnyObject).acceleration.x),\((data as AnyObject).acceleration.y),\((data as AnyObject).acceleration.z)\n"
                appendDataToFile(string: stringData, fileurl: fileURL)
            }
            stringreturn = "Acceleration data retrieved \nfrom \(convertDateTimeString(now: dateDAQStarted)) \nto\(convertDateTimeString(now: b))\n" + fileTransfer(fileURL: getSensorDataFileURL(), metaData: ["":""])
        }
    }
    return stringreturn
}
func twelve(intervalSeconds: Double)->String {
    dateDAQEnded = Date()
    var stringreturn = "Acceleration data retrieve failed"
    for i in stride(from: 610, to: 730, by: 10) {
        a = Calendar.current.date(byAdding: .minute, value: i-10, to: dateDAQStarted)!
        b = Calendar.current.date(byAdding: .minute, value: i, to: dateDAQStarted)!
        let sensorDataFileName = "10min from\(convertDateTimeString(now: a)).csv"
        if let listCMSensorData = sensorrecorder.accelerometerData(from: a, to: b){
            stringreturn = "Acceleration data retrieved \nfrom \(convertDateTimeString(now: a)) \nto\(convertDateTimeString(now: b))"
            //with interval \(intervalSeconds) sec"
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let docsDirect = paths[0]
            let fileURL = docsDirect.appendingPathComponent(sensorDataFileName)
            let stringfirstline = "\(convertDateTimeString(now: a)),\(convertDateTimeString(now: b))\nTimestamp,AxelX,AxelY,AxelZ\n"
            creatDataFile(onetimestring: stringfirstline, fileurl: fileURL)
            //for (index, data) in (listCMSensorData.enumerated())
            for (data) in (listCMSensorData) {
                let stringData = "\((data as AnyObject).timestamp!),\((data as AnyObject).acceleration.x),\((data as AnyObject).acceleration.y),\((data as AnyObject).acceleration.z)\n"
                appendDataToFile(string: stringData, fileurl: fileURL)
            }
            stringreturn = "Acceleration data retrieved \nfrom \(convertDateTimeString(now: dateDAQStarted)) \nto\(convertDateTimeString(now: b))\n" + fileTransfer(fileURL: getSensorDataFileURL(), metaData: ["":""])
        }
    }
    return stringreturn
}
*/

func session(_ session: WCSession, didFinish fileTransfer: WCSessionFileTransfer, error: Error?) {
    d = 1
    print("File transfer from Watch has been done successfully.")
}

/*
// Called when a file is received.
//20210218ここじゃだめ
func session(_ session: WCSession, didReceive file: WCSessionFile) {
    let atURL = file.fileURL
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let docsDirect = paths[0]
    //let toURL = docsDirect.appendingPathComponent("DataFileRecievedFromWatch.m4a")
    let fileExtention = atURL.pathExtension
    //(convertDateTimeString(now: dateDAQStarted))
    //(convertDateTimeString(now: a))
    let toURL = docsDirect.appendingPathComponent("FileFromWatch"+(convertDateTimeString(now:a))+"."+fileExtention)
    //let toURL = docsDirect.appendingPathComponent("FileFromWatch"+getDateTimeString()+"."+fileExtention)
    print("fileExtention",fileExtention)
    do {
     try FileManager.default.copyItem(at: atURL, to: toURL)
        print("Recieved file has been successfully copied under Documents folder.")
    }catch {
        print("Recieved file cannot be copied under Documents folder.")
    }
    
}
*/
