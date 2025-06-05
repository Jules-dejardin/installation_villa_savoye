(
// Load factory
// "genericFunctions.scd".loadRelative;
"busses.scd".loadRelative;
"nodes.scd".loadRelative;
"events.scd".loadRelative;
"server.scd".loadRelative;
// s.plotTree;
// ###### <initialise global var ######/
//Pan4
~out = 0;
~bufenv = (-1);
// ~projectPath=PathName(thisProcess.nowExecutingPath).parentPath;
// ~sampleDirPath=~projectPath++"samples/";

// 4 register functions
// ServerBoot.add(~loadSamples); // fill up the ~buffers dict
ServerBoot.add(~makeBusses);
ServerQuit.add(~cleanup);

// 5 boot serv
s.waitForBoot({
	s.sync;

	~env0 = Env([0,1,0], [0.3,0.3], [-4, 4]).asSignal(512);
	~env1 = Env([0,1,0], [0.3,0.4], [-2,-4]).asSignal(512);
	~env2 = Env([0,1,0], [0.3,0.6], [2,-4]).asSignal(512);
	~env3 = Env([0,1,0], [2,2], [8,-4]).asSignal(512);

	s.sync;
	~allenv = [~env0, ~env1, ~env2, ~env3];
	s.sync;
	~bufenv = Buffer.allocConsecutive(4,s, 1024);
	s.sync;
	~bufenv.do({
	arg buf, i;
	buf.loadCollection(~allenv[i]);
	});

	s.sync; //wait the server to be ok
	"synthdefs/spookyDelay.scd".loadRelative;
	"synthdefs/gragitator.scd".loadRelative;
	"synthdefs/fonComb.scd".loadRelative;
	"synthdefs/routing.scd".loadRelative;
	// "midi_connect.scd".loadRelative;
	s.sync;
	ServerTree.add(~makeNodes);
	ServerTree.add(~makeEvents);
	s.freeAll;
	s.sync;
	~connect_midi_devices.("Launch Control XL", "Launch Control XL");
	"done".postln;
});
)

///
m = MIDIOut.new(1);

s.record(numChannels:4);

	~env0 = Env([0,1,0], [0.01,0.01], [-4,-4]).asSignal(1024).asWavetable;
	~env1 = Env([0,1,0], [0.3,0.4], [-2,-4]).asSignal(1024).asWavetable;
	~env2 = Env([0,1,0], [0.3,0.6], [2,-4]).asSignal(1024).asWavetable;
	~env3 = Env([0,1,0], [2,2], [8,-4]).asSignal(1024).asWavetable;

	s.sync;
	~allenv = [~env0, ~env1, ~env2, ~env3];
	s.sync;
	~bufenv = Buffer.allocConsecutive(4,s, 2048);
	s.sync;
~bufenv.do({
	arg buf, i;
	buf.loadCollection(~allenv[i]);
	});

~bufenv[0].bufnum + 3
~allenv.do({arg n,i; n.plot(~bufenv[i].bufnum.asString)});


20%21

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

