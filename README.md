# in3D iOS SDK

## Introduction

in3D iOS SDK can be used to enable 3D human scanning capabilities into iOS apps. It provides simple methods to capture data from the camera and communicate with in3D cloud. You can easily customize UI enabling seamless integration into existing user experience.

## Important

The quality of the resulting scan heavily depends on whether the user follows the recommended way of usage or not. You may refer to [in3D app](https://apps.apple.com/us/app/in3d-3d-body-scanning/id1467153183) to see the instructions we give our users. Without following the guidance, the quality of the scans might degrade.

## Contents

1. [Scanning pipeline](#scanning-pipeline)
2. [Recording](#recording)
3. [Upload](#upload)
4. [Server](#server)
5. [Demo App](#demo-app)
6. [Help and feedback](#help-and-feedback)

## Scanning pipeline

The scanning pipeline consists of three parts:

1. Create new `ScanRecording`. Call `newRecording(withHead:)` from `ScanService`.
2. Record head sequence, if you passed `true` in previous method.
3. Record body sequence.
4. Inform SDK about successful recording. Call `recorded(recording:)`from `ScanService`.
5. Upload recorded data to in3D servers using `ScanService`.

The recording result is an object conforming to `ScanRecording` protocol:

```swift
public protocol ScanRecording {
    
    var id: String { get }
    var status: ScanRecordingStatus { get }
    var baseURL: URL { get }
    var archiveURL: URL { get }
    var headSequence: ScanSequence { get }
    var bodySequence: ScanSequence { get }
    
}
```

Parameters:

- `id` - unique local id
- `status` - status of the recording
- `baseURL` - URL of the directory which will contain scanned data
- `archiveURL` - resulting archive URL

`headSequence` and `bodySequence` properties are objects conforming to the `ScanSequence`  protocol. `ScanSequence` contains information about sequence type and some of the recorder data.

```swift
public protocol ScanSequence {
    
    var type: ScanSequenceType { get }
    var rgb: URL { get }
    var firstFrame: URL { get }
    
}
```

## Recording

Now let's discover how `headSequence` and `bodySequence` recorded. The central element of the SDK is a `Recorder`. It records RGB and depth data(if available) from the specified camera.

```swift
public protocol Recorder: class {
    
    var delegate: RecorderDelegate? { get set}
    var previewView: MTKView? { get set }
    func prepareForRecord(imageFilter: ImageFilter?, 
                          sensorFilter: SensorFilter?, 
			  completion: @escaping ((Error?) -> ()))
    func startRecord()
    func cancelRecord(completion: @escaping (() -> ()))
    func stopRecord(completion: @escaping ((ScanSequence?, Error?) -> ()))
    func canUse(camera type: CameraType, for sequenceType: ScanSequenceType) -> Bool
    func availableCameras(for sequenceType: ScanSequenceType) -> [CameraType]

}
```

Next steps describe how to set up `Recorder` and use it:

- After initialization you need to set a delegate property. Delegate receives the recorder's state updates.

```swift
public protocol RecorderDelegate: class {

    func recorder(changed state: RecordState)

}
```

- Then you need set a `Recorder`'s `previewView`, otherwise SDK will crash on a next step.
- Now create instance of `I3DRecorderSettings`. Currently you can specify one of the 4 different camera types: `.lidar`, `.trueDepth`, `.rgbFront`, `.rgbBack`.
- You need to check if specified camera type is supported by device using `canUse(camera:for)`. Remember, that `headSequence` can only be recorde using `TrueDepth` camera.
- Before recording you need to call `prepareForRecord(settings:imageFilters:sensorFilters:completion:)`. It setups connection with camera and prepares data storers. You can also set filters for image and sensor data. The result of the method result comes in completion closure. This method also clears all the previously recorded data of the ScanSequence. 
- To start recording you need to call `startRecord()`.
- To cancel recording you need to call `cancelRecord(completion:)`. This method stops recording and removes all recorded data.
- To finish recording you need to call `stopRecord(completion:)`. This method finishes data dumping. Closure called upon completion.

## Upload

You should use `ScanService` to upload your `ScanRecording`.

```swift

public protocol ScanService {

    var delegate: ScanServiceDelegate? { get set } 
    var notLoadedRecordings: [ScanRecording] { get }   
    func recorded(recording: ScanRecording) throws
    func upload(recording: String, 
                progress: @escaping (_ fractionCompleted: Double,_ totalSize: Int64) -> (),
		completion: @escaping (_ scan: Scan?, _ error: Error?) -> ())
    func launchScanProcessing(with scanID: String,
                              completion: @escaping (_ scan: Scan?, _ error: Error?) -> ())
    func newRecording(withHead: Bool) -> ScanRecording
    func delete(recording: String) throws
    func isLocalScan(with id: String) -> Bool
    func recording(with scanID: String) -> ScanRecording?
    func clearCache()
    
}
```

Here how you use it:

- Set delegate property

```swift
public protocol ScanServiceDelegate: class {
    
    func createScan(for recording: ScanRecording, 
                    completion: @escaping (String?) -> ())
    
}
```

 You should return `scan_id` in completion closure. More about that [here](#scanservicedelegate).

- Call `upload(recording:progress:completion:)` method in order to upload successful recording.

### ScanServiceDelegate

This protocol contains only one method: `createScan(for:compeltion)`. This method hides quite a lot of stuff behind the scenes. This image describes it:

![images/image_(1).png](images/image_(1).png)

The "Vendor" here means your company. `createScan(for:compeltion)` method should make `/create_scan` request (you can name it whatever you want) which will make `/v2/scans/init` request to our server. You can read more about our server requests [here](#server).

## Server

### Intro

Your server should be an intermediary between in3D SDK and in3D Scanner API. All the API methods for data extraction require authorization header with your companies token. This token should be only stored on your server. This solution prevents direct access of users to scans and models. If you are already our partner and don't have a token, please contact us. Otherwise please email us at [hello@in3d.io](mailto:hello@in3d.io).If you used the beta version of the library, please contact us to get a new token.

Now let's talk about our API methods.

## Scanner API

1. [Init scan](#init-scan)
2. [Get scan](#get-scan)
3. [Scans list](#scans-list)
4. [Resulting mesh](#resulting-mesh)
5. [Delete scan](#delete-scan)

### Init scan

```
POST /v2/scans/init
Host: www.app.gsize.io
Authorization: Bearer <YOUR_TOKEN>
Content-Type: application/json
Content-Length: length
Accept-Language: en-us
Accept-Encoding: gzip, deflate
Connection: Keep-Alive

{
    vendor_id: string,
    callback_url: string
}

---------------------------

Response JSON:
{
    id: string,
    vendor_id: string,
    status: string,
    eta_minutes: number,
    config_name: string,
    created_at: string,
    started_at: string,
    processed_at: string,
    callback_url: string,
    etag: string
}
```

### Get scan

```
POST /v2/scans/get/{scan_id}
Host: www.app.gsize.io
Authorization: Bearer <YOUR_TOKEN>
Content-Type: application/json
Content-Length: length
Accept-Language: en-us
Accept-Encoding: gzip, deflate
Connection: Keep-Alive

---------------------------

Response JSON:
{
    id: string,
    vendor_id: string,
    status: string,
    eta_minutes: number,
    config_name: string,
    created_at: string,
    started_at: string,
    processed_at: string,
    callback_url: string,
    etag: string
}
```

### Scans list

```
POST /v2/scans/list
Host: www.app.gsize.io
Authorization: Bearer <YOUR_TOKEN>
Content-Type: application/json
Content-Length: length
Accept-Language: en-us
Accept-Encoding: gzip, deflate
Connection: Keep-Alive

---------------------------

Response JSON:
[{
    id: string,
    vendor_id: string,
    status: string,
    eta_minutes: number,
    config_name: string,
    created_at: string,
    started_at: string,
    processed_at: string,
    callback_url: string,
    etag: string
}]
```

### Resulting mesh

```
POST /v2/scans/model/{scan_id}
Host: www.app.gsize.io
Authorization: Bearer <YOUR_TOKEN>
Content-Type: application/json
Content-Length: length
Accept-Language: en-us
Accept-Encoding: gzip, deflate
Connection: Keep-Alive

---------------------------

Response JSON:
{
    url: string,
    ttl_sec: number,
    status: string
}
```

### Delete scan

```
POST /v2/scans/delete/{scan_id}
Host: www.app.gsize.io
Authorization: Bearer <YOUR_TOKEN>
Content-Type: application/json
Content-Length: length
Accept-Language: en-us
Accept-Encoding: gzip, deflate
Connection: Keep-Alive

---------------------------

Empty, 204
```

## Demo app

Please see [demoApp](../master/in3D%20SDK%20Example) directory for a complete example of the app using the SDK.

## Help and feedback

If you have any questions regarding the SDK, feel free to get in touch with us at `sdk@in3d.io`. 
