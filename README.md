# shake

Screenshot
![](image/image.png)


Add in pubspec.yml 


```dart
    shake:
        git:
            url: 'https://github.com/thanhnha241199/shake_to_report'
```


A flutter package to detect phone shakes.

```dart
    ShakeDetector detector = ShakeDetector.waitForStart(
        onReport: (images, reason) {
            // Do stuff on phone shake
        }
    );
    
    detector.startListening();
```



To stop listening:

```dart
    detector.stopListening();
```

