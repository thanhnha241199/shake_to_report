# shake

Add in pubspec.yml
    shake:
        git:
            url: 'https://github.com/thanhnha241199/shake_to_report'

A flutter package to detect phone shakes.

    ShakeDetector detector = ShakeDetector.waitForStart(
        onReport: (images, reason) {
            // Do stuff on phone shake
        }
    );
    
    detector.startListening();

To stop listening:

    detector.stopListening();


