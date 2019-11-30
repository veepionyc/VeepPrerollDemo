#  VPKit with Preroll video ads



Demo app showing how to manage Google Ads preroll video with VPKPreview and VPKVeeepViewers.

The basic idea:   
- intercept the user tap on VPKPreview  
- play the preroll on the VPKPreview  
- launch the VPKVeepViewer when the preroll has finisshed.

Files:

## GoogleViewController.swift

This is  Google's sample code and is included here for comparitive purposes only.  
See: [https://developers.google.com/interactive-media-ads/docs/sdks/ios/](https://developers.google.com/interactive-media-ads/docs/sdks/ios/)

## VeepViewController.swift

This is a basic implementation of VPKPreview and VPKVeepViewer.    
The view controller conforms to VPKPreviewDelegate protocol and is set as it's delegate. 

The protocol has one method:  
[```func vpkPreviewTouched(_ preview: VPKPreview, image: VPKImage)```](x-source-tag://vpkPreviewTouched) 

This is an intercept point at which we can invoke a preroll handler.

The handler will inject an AVPLayer into the VPKPreview to play the preroll.  
It is initialised with a closure which is used to invoke the VPKVeepViewer when the preroll has finished playing.

To launch the VPKVeepViewer:  
```
guard let vpViewer = VPKit.viewer(with:preview) else { return }
vpViewer.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
self?.present(vpViewer, animated: true, completion: nil)

```

## PrerollHandler.swift

The Preroll handler handles ad loading and management functions and callbacks.   It also creates and injects an AVPlayer for ad playback into the passed-in view.




