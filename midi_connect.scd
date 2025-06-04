// MIDIOut.findPort(0,0);
// m = MIDIOut.new(1);
//
// (
// Routine{
// 	inf.do{
// 		m.control(1,20, rrand(0,127));
// 		0.5.wait;
// 	};
// }.play;
// )
// MIDIEndPoint("Midi Through", "Midi Through Port-0")
// MIDIClient.destinations

(
~connect_midi_devices = { arg device, name;
    // init or refresh MIDIClient end points
    if(MIDIClient.initialized == false) {
        MIDIClient.init;
    } {
        MIDIClient.list;
    };

    MIDIClient.sources.do({ arg endPoint;
        if(device.notNil and: { name.notNil} and: {endPoint.device == device} and: { endPoint.name == name }) {
            // catch exception thrown when already connected
            try {
                // connect SuperCollider out port 0 to MIDI device
                MIDIOut.connect(0, endPoint.uid);
            };
            try {
                // connect MIDI device to SuperCollider in port 0
                MIDIIn.connect(1, endPoint.uid);
            }
        }
    })
})

~connect_midi_devices.("Launch Control XL", "Launch Control XL");
