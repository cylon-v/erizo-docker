var erizo = require('/app/licode/erizoAPI/build/Release/addon');
var muxer = new erizo.OneToManyProcessor();
var wrtc = new erizo.WebRtcConnection(true, true, 'stun:stun.l.google.com', 19302, 45000, 60000, false);
console.log('It works!');
