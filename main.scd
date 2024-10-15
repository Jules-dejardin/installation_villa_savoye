(
// Load factory
"genericFunctions.scd".loadRelative;
"busses.scd".loadRelative;

"nodes.scd".loadRelative;
"events.scd".loadRelative;
"server.scd".loadRelative;
// s.plotTree;
// ###### <initialise global var ######/
//Pan4
~out = 0;
~freqNoise = 50;
~rateNoise = 2;
~atkNoise = 1;
~volNappes = (-5);
~often = 0.01;
~interp_cloche = 1;
~witchChannel = [0,1];
~fg = 130; //fondamental du gong
~projectPath=PathName(thisProcess.nowExecutingPath).parentPath;
~sampleDirPath=~projectPath++"samples/";

// 4 register functions
ServerBoot.add(~loadSamples); // fill up the ~buffers dict
ServerBoot.add(~makeBusses);
ServerQuit.add(~cleanup);

// 5 boot serv
s.waitForBoot({
	s.sync; //wait the server to be ok
	"synthdefs.scd".loadRelative;
	// "midi_connect.scd".loadRelative;

	VSTPlugin.plugins['ValhallaFreqEcho'];
	VSTPlugin.plugins['ValhallaSupermassive'];

	s.sync;
	ServerTree.add(~makeNodes);
	ServerTree.add(~makeEvents);
	s.freeAll;
	s.sync;
	~connect_midi_devices.("Launch Control XL", "Launch Control XL");
	"done".postln;
});
)

20%21

s.record(numChannels:10);
// ~master.set(\out, 0.8);
/*
travailler en DB
faire un bus master
utiliser in
supernova => type de server automatique en multitrhead (utiliser Pargroup)
explorer UGEN grain
GranBufI => interpolation entre deux samples
demand => jouer au samplerate
Server.latency= 0.025
sccode.org
tanh
awesome-supercollider => madskejldegaard
*/
// route
//jingle
//réglage radio
//               into noise
//                             vers sub avec nappes elie (fin à ~7min)
 //                                             puis mer
//                                                         wobble elie = début fôret (10min)
//                                                              vibra = cloches
//                                                                        percu pur (~15min)
//                                                                                footwork (~20min)

