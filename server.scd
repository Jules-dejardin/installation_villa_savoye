(
// ServerOptions.outDevices;
s.options.outDevice_(
// 	"Focusrite USB Au"
	// "ASIO4ALL v2"
	// "ASIO : JackRouter"
	// "MME : Ligne (4- ZOOM U-22 Driver)"
	// "MME : Ligne (4- ZOOM U-22 Audio)"
	);
s.options.inDevice_(
	// "ASIO4ALL v2"
	// "ASIO : JackRouter"
	// "MME : Ligne (4- ZOOM U-22 Driver)"
	);

s.options.numInputBusChannels_(1);
s.options.numOutputBusChannels_(18);
s.options.sampleRate_(48000);
s.options.memSize_(2.pow(20)); // ~1 GB of active memory
s.options.blockSize_(512);
// s.newBusAllocators;
// 2.pow(20)
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


)