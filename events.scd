(
~makeEvents = {
	// MIDIClient.init;
	// MIDIIn.connectAll;

	e = Dictionary.new;

	e.add(\init -> {
		~one = Synth(\radio, [\in, 0, \mod,1, \out, ~bus[\delayValh] , \amp, -60], ~mainGrp);//radio
		~recBuff = Buffer.alloc(s, s.sampleRate * 5, 1);
		// ~recBuff_2 = Buffer.alloc(s, s.sampleRate * 40, 1);
		//~recBuff.plot;
		~radioRead = Synth(\AudioInputMono, [\input, 0, \out, ~bus[\radioBus], \amp, 0], ~radioGrp);
		~radioPtr = Synth(\ptr, [\buf, ~recBuff, \out, ~bus[\ptrBus]], ~ptrGrp);
		~radioRecord = Synth(\rec, [\ptrIn, ~bus[\ptrBus], \micIn, ~bus[\radioBus], \buf, ~recBuff], ~recGrp);
		~vstDelaySynth.open("ValhallaFreqEcho", editor: true, verbose:true);
		~vstMassiveSynth.open("ValhallaSupermassive", editor: true, verbose:true);
		~env_grad= Buffer.sendCollection(s, Env([0, 1,0.5,0], [0.001, 0.1,0.2], [-4,-4, -2]).discretize, 1);
	});
	// Compander
	// ~vstMassiveSynth.editor;

	e.add(\loadPresets-> {
		~vstMassiveSynth.loadPreset("dirtyVerb1");
		// ~vstMassiveSynth.editor;
		// ~vstMassiveSynth.savePreset("dirtyVerb1");
	});

	e.add(\event1 -> {
		//init
		~bullenap.free;
		~spat_bull.stop;
		~masterNappes.set(\lag, 0.49);
		~masterNappes.set(\width, 5.0);

		~bullenap = Synth(\audioBuf, [\buf, ~buffers[\bullenap][0], \loop, 1,\out, ~bus[\masterNappes], \amp, -1],~mainGrp);

		~spat_bull = Routine{
			inf.do{
				~masterNappes.set(\pos, ((0..20)/10).choose);
				rrand(0.5,3).wait;
			}
		}.play;
	});

	e.add(\event2 -> {
		//init
		~mom.free;
		~mom = Synth(\audioBuf, [\buf, ~buffers[\mom][0], \loop, 0,\out,0, \amp, -1],~mainGrp);
});

	e.add(\event9
		-> {
			~boucheGran.stop;
			~mer.stop;
			~granOizo.stop;
			~chord.stop;
			~snow.set(\relOut, 1, \gate,0);
			//~g.do({ arg n; n.set(\gate, 0) });

			~jumpSample = (0..5);

			~granOizo = Pbind(
				\instrument, \gran,
				\buf, ~buffers[\oizo][~jumpSample.choose],
				\sync, Pseq([0,0,0,0,
					1,1,0,0,
					0,0,1,1,
					0,0,1,0,1,0,1,0],inf),
				\gDur, Pwhite(0.05, 0.8, inf),
				\dens, Pwhite(5,40, inf),
				\pos, Pwhite(0.2,0.6,inf),
				\c0, Pwhite(-8,2,inf),
				\c1, Pwhite(-4,2,inf),
				\atk, Pwhite(0.001,0.5,inf),
				\rel, Pwhite(0.1, 0.5,inf),
				\sus, Pwhite(0.1,2,inf),
				\rate, Pwhite(0.8, 1.5,inf),
				\dur, Pwhite(0.001,0.6,inf),
				\amp, 1,
				\group, ~mainGrp,
				\out,~bus[\masterNappes],
			).play;
	});


	e.add(\event10 -> {
		~granOizo.stop;
		~mer.stop;
		~chord.stop;
		~snow.set(\relOut, 1, \gate,0);
		//~g.do({ arg n; n.set(\gate, 0) });

		~boucheGran = Pbind(
			\instrument, \gran,
			\buf,~buffers[\humain][2],
			\sync, 0,
			\panRand, 1,
			\gDur, Pwhite(0.25, 0.7, inf),
			\dens, Pwhite(10,30, inf).round(1),
			\pos, exprand(0.1,1),
			\c0, (-2),
			\rel, 0.2,
			\sus, 1,
			\amp, 1,
			\group, ~mainGrp,
			\out,~bus[\masterNappes],
		).play;
	});

	e.add(\event3 -> {
		~granOizo.stop;
		~boucheGran.stop;
		~mer.stop;
		~marimba.stop;
		~chord.stop;

		~chord = Pbind(
			\instrument, \bpfsaw,
			\dur, Pwhite(1,5,inf),
			\midinote, Pxrand([
				[23,35,54,63,64],
				[45,52,54,59,61,64],
				[28,40,47,56,59,63],
				[42,52,57,61,63],
			],inf),
			\detune, Pexprand(0.05,0.2,inf),
			\cfmin, 100,
			\cfmax, 1500,
			\rqmin, Pexprand(0.01, 0.15, inf),
			\atk, Pwhite(2.0,2.5,inf),
			\rel, Pwhite(6.5,10.0,inf),
			\ldb, 6,
			\amp, Pfunc({~volumeSynth}, inf),
			\group, ~mainGrp,
			\out,~bus[\masterNappes],
		).play;
	});

	e.add(\event4 -> {

		~g.do({ arg n; n.set(\gate, 0, \rel, 1) });
		(
			~recBuff.zero;
			~g =  5.collect({
				arg n;
				Synth(\granRadio, [
					\amp, -8,
					\buf, ~recBuff,
					\out, ~bus[\gran_radio],
					\out2,~bus[\satura],
					\atk, 0.01,
					\rel, 0.3,
					\gate, 1,
					\sync, 1,
					\dens, exprand(20,40),
					\baseDur, exprand(0.2, 0.5),
					\durRand, 1,
					\rate, 1,
					\rateRand, 2.midiratio,
					\grainEnv, ~env_grad,
					\ptrBus, ~bus[\ptrBus],
					\ptrSampleDelay, n.linlin(0,4,20000,s.sampleRate*2),
					\ptrRandSamples, 10000,
					\minPtrDelay, 1000
				],~granGrp);
			});
		)

	});

	e.add(\event5 -> {

		~granOizo.stop;
		~boucheGran.stop;
		~chord.stop;
		//~g.do({ arg n; n.set(\gate, 0) });

		~mer = Pbind(
			\instrument, \gran,
			\buf,~buffers[\mer][0],
			\sync, 0,
			\panRand, 1,
			\gDur, Pwhite(5, 10, inf),
			\dens, 1,
			\pos, Pexprand(0.001,1),
			\c0, 5,
			\c1, 5,
			\rel, 0.5,
			\sus, 1,
			\amp, 1,
			\group, ~mainGrp,
			\out,~bus[\masterNappes],
		).play;

		~snow.free;
		~snow = Synth(\highNap, [
			\amp,0.8,
			\out,~bus[\masterNappes],
		], ~mainGrp);
	});

	e.add(\event6 -> {
		(
			~melo.free;
			~melo = Synth(\melo_mono, [
				\buf, ~buffers[\melo][0],
				\loop, 0,
				\out, ~bus[\masterTransi],
				\amp, ~volMelo,
			],~mainGrp);
		)
	});
	// ~masterNappes.set(\pos, 0);
	// ~masterNappes.set(\width, 6);

	e.add(\event11 -> {(
		~medium.stop;
		~masterNappes.set(\width, 6);
		~masterNappes.set(\pos, 0.2);

		~medium = Routine{
			var sustain = 6, transition = 4, overlap = 5;
			var period = transition*2+sustain/overlap;
			1.5.wait;
			inf.do {
				Synth(\medium, [
					\atk, transition,
					\sus, sustain,
					\rel, transition,
					\pan, 1.0.rand2,
					\amp, 0,
					\freqs, {50.0.rrand(5000)}.dup(12),
					\rings, {0.1.rrand(2)}.dup(12),
					\out,~bus[\masterNappes],
				],
				~mainGrp
				);
				period.wait;
			}
		};
		~medium.play;
	)});

	e.add(\event12 -> {(
		~melo.free;
		~melo = Synth(\melo_mono, [
			\buf, ~buffers[\melo][1],
			\loop, 0,
			\out, 0,
			\amp, ~volMelo],
		~mainGrp);
	)});

	e.add(\event13 -> {
		(
			~cri = Routine{
				var period = Array.fill(20, { rrand(1,4) }).choose;
				var sustain = (period/4)-0.15;
				4.do{
					var freq =  Array.fill(20, { rrand(2400, 2500) }).choose.asStream;
					Synth(\cricket, [\amp, 0.1, \sus, sustain, \harmo, freq, \freq, 55, \out, ~bus[\satura]]);
					period.wait;
				};
			};
			~cri.play;
		)
	});

	e.add(\event14 -> {

		~bass.stop;
		(
			~bass = Pbind(
				\instrument, \bass,
				\dur, Pwhite(1,7,inf),
				\midinote, Pxrand([
					[23,35,54,63,64],
					[45,52,54,59,61,64],
					[28,40,47,56,59,63],
					[42,52,57,61,63],
				], 10),
				\detune, Pexprand(0.05,0.2,inf),
				\cfmin, 100,
				\cfmax, 1500,
				\rqmin, Pexprand(0.01, 0.15, inf),
				\atk, Pwhite(2.0,2.5,inf),
				\rel, Pwhite(6.5,10.0,inf),
				\ldb, 6,
				\amp, Pfunc({~volumeSynth}, inf),
				\group, ~mainGrp,
				\out,0,
			).play;
		)
	});

	e.add(\event15 -> {(
		~boucle.stop;
		~cloches = Routine{
			var sustain = 4, transition = 1, overlap = 2;
			var period = transition * 2 + sustain / overlap;
			0.5.wait;            // wait for the synthdef to be sent to the server
			inf.do{
				~masterNappes.set(\width, [2,3,4].choose);
				// ~masterNappes.set(\pos, [-0.2, 0.2, 0.8, 1.2].choose.asStream);
				~masterNappes.set(\pos, ((0..20)/10).choose.asStream);
				~clo = Synth(\cloches, [
					\atk, transition,
					\sus, sustain,
					\rel, transition,
					\pan, 1.0.rand2,
					\amp, -3,
					\switch, ~interp_cloche,
					\freqs, {200.0.rrand(5000)}.dup(12),
					\rings, {0.1.rrand(2)}.dup(12),
					\out, ~bus[\masterNappes],
					\out2, ~bus[\satura]
				], ~mainGrp);
				period.wait;
			}
		};
		~cloches.play;
	)});

	//event page 3
	e.add(\event19 -> {(
		~melo.free;
		~melo = Synth(\melo_mono, [
			\buf, ~buffers[\melo][2],
			\loop, 0,
			\out, 0,
			\num,1,
			\amp, ~volMelo
		],
		~mainGrp);
	)});

	e.add(\event21 -> {(
		~drame_gran.free;
		~drame_gran = Synth.new(\granul, [\buf, ~buffers[\drame][0], \out, -3], ~mainGrp);
			~winenv = Env([0, 1, 0], [0.1, 0.01], [8, -4]);
			z = Buffer.sendCollection(s, ~winenv.discretize, 1);
			~drame_gran.set(\grainEnv, z);
		// ~drame_gran.set(\pan, [1.5,2]);
			~drame_gran_route.stop;
		// PanAz
			~drame_gran_route = Routine{
			inf.do{
				~drame_gran.set(\masse,30);
		// ~z.set(\pos,rrand(0.01,1.000));
				~drame_gran.set(\dur, rrand(0.2,1.5));
				~drame_gran.set(\rate, rrand(0.82,0.8));
				~drame_gran.set(\rateSaw, rrand(0.01,0.001));
				~drame_gran.set(\pan, rrand(0.01,1.99));
					rrand(0.2,2).wait;
				};
			}.play;
	)});

	e.add(\event22 -> {(

		~masterNappes.set(\width, 10);
		~masterNappes.set(\pos, 0.2);

		~gong.stop;
		~gonghigh.stop;

		~gonghigh = Routine{
			var period5 = Array.fill(20, {rrand(7.0,15.0)}).choose.asStream;
			0.5.wait;
			inf.do{
				var freqhigh =  [~fg*10,~fg*11,~fg*12,~fg*13,~fg*14].choose;
				var fact = Array.fill(10, {rrand(0.01,0.05)}).choose.asStream;

				Synth(\gong, [
					freq:freqhigh,
					dur: 5,
					atk:0.1,
					amp: 0.05,
					decay: 5,
					harmofact: 0,
					harmolowfact:fact,
					verbTime:3.5,
					ampdb:-4,
					renfoAtk:0,
					curve:-8,
					hpfHigh:500,
					out: ~bus[\masterNappes],
				],~mainGrp);

				period5.wait;
			}
		};
		~gonghigh.play;

		~gong = Routine{
			var period = [10,10.5,11,11.5,12,12.5,13].choose.asStream;
			0.5.wait;
			inf.do{
				var lowfact = Array.fill(20, {rrand(0.05, 2.5)}).choose.asStream;
				var pan = Array.fill(20, {rrand(0.5,5.0)}).choose;
				Synth(\gong, [
					freq: ~fg,
					dur: period,
					atk:0.01,
					amp: 0.30,
					decay: period,
					harmofact: 0.02,
					harmolowfact:lowfact,
					panRate: pan,
					verbTime:period/2,
					ampdb:4,
					renfoAtk: 0.3,
					out: ~bus[\masterNappes],
				], ~mainGrp);
				period.wait;
			}
		};
		~gong.play;
	)});
	// page 4 event
	e.add(\event26 -> {(

	)});

	e.add(\event27 -> {(

		// ~masterNappes.set(\width, 6);
		// ~masterNappes.set(\pos, 0);

		~bal.free;
		~bal = Synth(\balayage, [
			\amp,(-5),
			\rq, 0.3,
			\notch, 2,
			\sat, 0.999,
			\out, ~bus[\masterNappes]
		], ~mainGrp);
	)});

	e.add(\event28 -> {(

		~masterNappes.set(\lag, 0.001);
		~masterNappes.set(\width, 3.5);
		~noise_boucle.stop;

		~noise_boucle = Routine{
			var f = 0;

			inf.do{
				f = f + 1;
				~masterNappes.set(\pos, ((f%21)/10));
				// ~masterNappes.set(\width, 3.0);
				~often.wait;
				};
		}.play;

		~noise.stop;
		~noise = Routine{

			inf.do{
				~drone = Synth(\, [
					\atk, ~atkNoise,
					\freq,~freqNoise,
					\amp,(~volNappes-15),
					\rate, ~rateNoise,
					// \clip, (0.9..1.6).choose,
					\out, ~bus[\masterNappes],
				], ~mainGrp);
				~atkNoise.wait;
			};
		}.play;
	)});
	// ~drone.set(\amp,-30);

	e.add(\event29 -> {(
		//routine spatial
		~masterNappes.set(\lag, 0.001);
		~boucle.stop;
		~noise_boucle.stop;
		~rand = ((5..15)/100);
		~boucle = Routine{
			var i = 0;

			inf.do{
				i = i + 1;
				~masterNappes.set(\pos, ((i%21)/10) - 2);
				~masterNappes.set(\width, 3.0);
				~rand.choose.wait;
				};
		};
		~boucle.play;

		~subroute.stop;
		~subroute = Routine{
			inf.do{
				// ~d.set(\minDens, 50);
				~sub= Synth(\gran, [
					\buf, ~buffers[\harpe][[0,1,2,3,4,5].choose],
					\sus, 10,
					\gDur,0.9,
					\pos,((0..5)/10).choose,
					\dens, 5,
					\minDens, 50,
					\rate,0.2,
					\durRand, 1,
					\amp,-5,
					\minC, -8,
					\maxC, -8,
					\out, ~bus[\masterNappes],
				], ~mainGrp);
				((30..40)/10).choose.wait;
			};
		}.play;
	)});

	//page 1 boutons
	e.add(\sample1 -> {
		(
			// ~master.set(\out, [-0.2,0.2,0.8,1.2].choose);
			// ~master.set(\width, ((15..25)/10).choose);
			~water=Synth(\audioBuf, [
				\buf, ~buffers[\bateau][0],
				\loop, 0,
				\out, ~bus[\satura],
				\out2, ~bus[\satura_2],
				\bus, ~witchChannel,
				\rate,0.7,
				\amp, 3,
			], ~mainGrp);
		)
	});

	e.add(\sample2 -> {
		(
			// ~master.set(\out, [-0.2,0.2,0.8,1.2].choose);
			// ~master.set(\width, ((15..25)/10).choose);
			Synth(\lectechant, [
				\buf, ~buffers[\puit][(0..4).choose],
				\loop, 0,
				\out, ~bus[\satura],
				\out2, ~bus[\satura_2],
				\bus, ~witchChannel,
				\amp, 3,
			], ~mainGrp);
		)
	});

	e.add(\sample3 -> {
		(
			// ~master.set(\out, [-0.2,0.2,0.8,1.2].choose);
			// ~master.set(\width, ((15..25)/10).choose);
			Synth(\lectechant, [
				\buf, ~buffers[\dolph][[0,1,2,3,4].choose],
				\loop, 0,
				\rate,0.8,
				\out, ~bus[\satura],
				\out2, ~bus[\satura_2],
				\bus, ~witchChannel,
				\amp, 3
			],~mainGrp);
		)
	});
	// ~master.set(\out,0)
	e.add(\sample4 -> {
		(
			Synth(\lectechant, [
				\buf, ~buffers[\harpe][[0,1,2,3,4,5,6,7].choose],
				\loop, 0,
				\out, ~bus[\satura],
				\out2, ~bus[\satura_2],
				\bus, ~witchChannel,
				\amp, 3,
			],~mainGrp);
		)
	});
//vacant
	e.add(\sample5 -> {
		(
			Synth(\lectechant, [
				\buf, ~buffers[\fer][(0..8).choose],
				\loop, 0,
				\out, ~bus[\satura],
				\out2, ~bus[\satura_2],
				\bus, ~witchChannel,
				\amp, 3,
			],~mainGrp);
		)
	});

	e.add(\sample6 -> {
		(
			Synth(\lectechant, [
				\buf, ~buffers[\verrevrac][[0,1,2,3,4,5].choose],
				\loop, 0,
				\out, ~bus[\satura],
				\out2, ~bus[\satura_2],
				\bus, ~witchChannel,
				\amp, 3
			],~mainGrp);
		)
	});

	e.add(\sample7 -> {
		(
			// ~master.set(\out, [-0.2,0.2,0.8,1.2].choose);
			// ~master.set(\width, ((15..25)/10).choose);
			Synth(\lectechant, [
				\buf, ~buffers[\verre][[0,1,2,3].choose],
				\loop, 0,
				\out, ~bus[\satura],
				\out2, ~bus[\satura_2],
				\bus, ~witchChannel,
				\amp, 3
			],~mainGrp);
		)
	});

	e.add(\sample8 -> {
		(
			// ~master.set(\out, [-0.2,0.2,0.8,1.2].choose);
			// ~master.set(\width, ((15..25)/10).choose);
			Synth(\lectechant, [
				\buf, ~buffers[\goutes][[0,1,2,3,4].choose],
				\loop, 0,
				\out, ~bus[\satura],
				\out2, ~bus[\satura_2],
				\bus, ~witchChannel,
				\amp, 3,
			],~mainGrp);
		)
	});


	//page 2 boutons
	e.add(\sample9 -> {
		(
			// ~master.set(\out, [-0.2,0.2,0.8,1.2].choose);
			// ~master.set(\width, ((15..25)/10).choose);
			Synth(\lectechant, [
				\buf, ~buffers[\craque][[0,1,2,3].choose],
				\loop, 0,
				\out, ~bus[\satura],
				\out2, ~bus[\satura_2],
				\bus, ~witchChannel,
				\amp, 3
			], ~mainGrp)
		)
	});

	e.add(\sample10 -> {
		(
			// ~master.set(\out, [-0.2,0.2,0.8,1.2].choose);
			// ~master.set(\width, ((15..25)/10).choose);
			Synth(\lectechant, [
				\buf, ~buffers[\cratch][[0,1,2,3,4,5,6,7].choose],
				\loop, 0,
				\out, ~bus[\satura],
				\out2, ~bus[\satura_2],
				\bus, ~witchChannel,
				\amp, 3
			], ~mainGrp);
		)
	});

	e.add(\sample11 -> {
		(
			Synth(\lectechant, [
				\buf, ~buffers[\rock][[0,1,2,3,4,5].choose],
				\loop, 0,
				\out, ~bus[\satura],
				\out2, ~bus[\satura_2],
				\bus, ~witchChannel,
				\amp, 0
			], ~mainGrp);

			Synth(\lectechant, [
				\buf, ~buffers[\rock_high][[0,1,2,3,4,5,6,7].choose],
				\loop, 0,
				\out, ~bus[\satura],
				\out2, ~bus[\satura_2],
				\bus, ~witchChannel,
				\amp, 0
			], ~mainGrp);
		)
	});

	e.add(\sample12 -> {
		(
			Synth(\lectechant, [
				\buf, ~buffers[\clic][[0,1,2,3].choose],
				\loop, 0,
				\out, ~bus[\satura],
				\out2, ~bus[\satura_2],
				\bus, ~witchChannel,
				\amp, 4
			],~mainGrp);
		)
	});

	e.add(\sample13 -> {
		(
			Synth(\lectechant, [
				\buf, ~buffers[\grenouilles][[0,1,2,3,4,5,6,7].choose],
				\loop, 0,
				\out, ~bus[\satura],
				\out2, ~bus[\satura_2],
				\bus, ~witchChannel,
				\amp, 0,
				\minRate, 0.5,
			],~mainGrp);
	)});

	e.add(\sample14 -> {
		(
			Synth(\lectechant, [
				\buf, ~buffers[\nylonbox][[0,1,2,3,4,5,6,7].choose],
				\loop, 0,
				\out, ~bus[\satura],
				\out2, ~bus[\satura_2],
				\bus, ~witchChannel,
				\amp, 3,
			], ~mainGrp);
		)
	});

	e.add(\sample15 -> {(
		Synth(\lectechant, [
			\buf, ~buffers[\fxoizo][[0,1,2,3,4,5].choose],
			\loop, 0,
			\out, ~bus[\satura],
			\out2, ~bus[\satura_2],
			\bus, ~witchChannel,
			\amp, 0,
			\minRate, 0.5,
			\bpf,5000,
		],~mainGrp);
	)});

	e.add(\sample16 -> {(
		Synth(\lectechant, [\buf, ~buffers[\rideau][[0,1,2,3,4,5,6,7].choose],
			\loop, 0,
			\out, ~bus[\satura],
			\out2, ~bus[\satura_2],
			\bus, ~witchChannel,
			\minRate, 0.4,
			\maxRate, 1,
			\amp, 3,
		], ~mainGrp);
	)});

	//boutons page 3
	e.add(\sample17 -> {
		(
			Synth(\lectechant, [
				\buf, ~buffers[\dog][(0..6).choose],
				\loop, 0,
				\out, ~bus[\satura],
				\out2, ~bus[\satura_2],
				\bus, ~witchChannel,
				\amp, 3
			], ~mainGrp);
		)
	});

	e.add(\sample18 -> {
		(
			Synth(\audioBuf, [
				\buf, ~buffers[\respi][[0,1].choose],
				\loop, 0,
				\out, ~bus[\satura],
				\out2, ~bus[\satura_2],
				\bus, ~witchChannel,
				\amp, 0
			], ~mainGrp);
		)
	});
	e.add(\sample19 -> {
		(
			Synth(\audioBuf, [
				\buf, ~buffers[\expi][[0,1,2,3,4,5,6,7].choose],
				\loop, 0,
				\out, ~bus[\satura],
				\out2, ~bus[\satura_2],
				\bus, ~witchChannel,
				\amp, 0
			], ~mainGrp);
		)
	});

	e.add(\sample20 -> {
		(
			Synth(\lectechant, [
				\buf, ~buffers[\sc_fx][[0,1,2,3,4].choose],
				\loop, 0,
				\out, ~bus[\satura],
				\out2, ~bus[\satura_2],
				\bus, ~witchChannel,
				\amp, 0
			], ~mainGrp);
		)
	});

	e.add(\sample21 -> {
		(
				Synth(\lectechant, [
				\buf, ~buffers[\bar_espace][[0,1,2].choose],
				\loop, 0,
				\out, ~bus[\satura],
				\out2, ~bus[\satura_2],
				\bus, ~witchChannel,
				\amp, 3
			], ~mainGrp);
		)
	});

	e.add(\sample22 -> {
		(
			Synth(\lectechant, [
				\buf, ~buffers[\clavier_roll][[0,1,2,3,4,5,6,7].choose],
				\loop, 0,
				\out, ~bus[\satura],
				\out2, ~bus[\satura_2],
				\bus, ~witchChannel,
				\amp, 3
			], ~mainGrp);
		)
	});

	e.add(\sample23 -> {
		(
		Synth(\audioBuf, [
				\buf, ~buffers[\gameboy][0],
				\loop, 0,
				\out, ~bus[\satura],
				\out2, ~bus[\satura_2],
				\bus, ~witchChannel,
				\amp, 0
			], ~mainGrp);
		)
	});

	e.add(\sample24 -> {
		(
			Synth(\gong, [
				freq:~fg*3.5,
				dur: 2,
				atk:0.2,
				amp: 0.75,
				decay: 2,
				harmofact: 0,
				harmolowfact:0.003,
				verbTime:1.5,
				out: ~bus[\satura],
				\out2, ~bus[\satura_2],
				\bus, ~witchChannel
		]);
	)});
	//page 4 samples
	e.add(\sample25 -> {(
		Synth(\lectechant, [
			\buf, ~buffers[\couine][(0..3).choose],
			\loop, 0,
			\out, ~bus[\satura],
			\out2, ~bus[\satura_2],
			\bus, ~witchChannel,
			\amp, 0,
		], ~mainGrp);
	)});
	e.add(\sample26 -> {(
		Synth(\lectechant, [
			\buf, ~buffers[\dark][(0..9).choose],
			\loop, 0,
			\out, ~bus[\satura],
			\out2, ~bus[\satura_2],
			\bus, ~witchChannel,
			\amp, 0,
			], ~mainGrp);
	)});
	e.add(\sample27 -> {(
		Synth(\lectechant, [
			\buf, ~buffers[\zombie][(0..4).choose],
			\loop, 0,
			\out, ~bus[\satura],
			\out2, ~bus[\satura_2],
			\bus, ~witchChannel,
			\amp, 0,
		], ~mainGrp);
	)});
	e.add(\sample28 -> {(
			/*Synth(\lectechant, [
			\buf, ~buffers[\][[].choose],
				\loop, 0,
				\out, ~bus[\satura],
				\amp, 0,
			], ~mainGrp);*/
	)});

	e.add(\sample29 -> {(
		~voix = Synth(\ou,[
			\rel,(0.5..5).choose,
			\amp,-5,
			\fd,(80..150).choose,
			\atk,(0.7..1.1).choose,
			\f1,[250,300,350].choose,
			\f2,[2250, 750,1250].choose,
			\f3,[2300,2500,3000].choose,
			\pon, 0,
			\fon, 1,
			\don, 1,
			\out,~bus[\satura],
			\out2, ~bus[\satura_2],
			\bus, ~witchChannel,
		], ~mainGrp);

		~voix2 = Synth(\ou,[
			\rel,(2..5).choose,
			\amp,-5,
			\fd,(1..20).choose,
			\atk,(0.4..0.9).choose,
			\f1,[250,300,350].choose,
			\f2,[500,750,1250].choose,
			\f3,[2300,2500,3000],
			\pan, (0.5..5).choose,
			\pon, 1,
			\fon, 1,
			\don,0.2,
			\out, ~bus[\satura],
			\out2, ~bus[\satura_2],
			\bus, ~witchChannel,
		], ~mainGrp);
	)});

	e.add(\sample30 -> {(
			Synth(\lectechant, [
			\buf, ~buffers[\duck][(0..4).choose],
				\loop, 0,
				\out, ~bus[\satura],
				\amp, 0,
			], ~mainGrp);
	)});

	e.add(\sample31 -> {(
			Synth(\lectechant, [
			\buf, ~buffers[\plock][(0..16).choose],
				\loop, 0,
				\out, ~bus[\satura],
				\amp, 0,
			], ~mainGrp);
	)});

	e.add(\quit -> {
		~noise_boucle.stop;
		~boucle.stop;
		~subroute.stop;
		~granOizo.stop;
		~boucheGran.stop;
		~mer.stop;
		~chord.stop;
		~water.free;
		~medium.stop;
		~snow.set(\relOut, 5, \gate, 0);
		~g.do({ arg n; n.set(\gate, 0, \rel, 10) });
		~medium.stop;
		~cloches.stop;
		~bloup.stop;
		~waterBell.stop;
		~bullenap.free;
		~gong.stop;
		~gonghigh.stop;
		~noise.stop;
		~bal.set(\gate,1);
		~melo.free;
		~spat_bull.stop;
		~drame_gran.set(\gate,1);
		~drame_gran_route.stop;
	});

	e.add(\mayday -> {
		// MIDIIn.disconnectAll;
		Server.killAll;
	});

	MIDIdef.noteOn(\controller, {
		arg val, num, chan;

		// "ca spat ou quoi ?!".postln;
		~masterSamples.set(\lag, [0.5,1,2,3,5].choose);
		~masterSamples.set(\lag, [0.5,1,2,3,5].choose);

		~masterSamples.set(\pos, ((0..20)/10).choose);
		~masterSamples_2.set(\pos, ((0..20)/10).choose);
		~masterSamples.set(\width, ((10..40)/10).choose);
		~masterSamples_2.set(\width, ((10..40)/10).choose);

		//test double bus
	/*	~masterSamples.set(\pos, 1.5);
		~masterSamples_2.set(\pos, 0.5);
		~masterSamples.set(\width, 2);
		~masterSamples_2.set(\width, 2);
*/
		~witchChannel.swap(0,1).first;
		~witchChannel.postln;

		case
		//nappes sûr
		{num==76 && val==127 }{e[\event4].value;"Nappe radio".postln;}
		// nappes tableau 1 (41.. = 1 ligne)
		{num==73 && val==127 && chan==1}{e[\event1].value;"nappe eau douce".postln;}
		{num==74 && val==127 && chan==1}{e[\event2].value;"mom".postln;}
		{num==75 && val==127 && chan==1}{e[\event3].value;"Nappe synth".postln;}
		{num==41 && val==127 && chan==1}{e[\event5].value;"Nappe mer".postln;}
		{num==42 && val==127 && chan==1}{e[\event6].value;"Transi harpe".postln;}
		{num==43 && val==127 && chan==1}{e[\event7].value;"vide".postln;}
		{num==44 && val==127 && chan==1}{e[\event8].value;"vide".postln;}
		// nappes tableau 2 (41.. = 1 ligne)
		{num==73 && val==127 && chan==2}{e[\event9].value;"Nappe oiseaux".postln;}
		{num==74 && val==127 && chan==2}{e[\event10].value;"Nappe voix".postln;}
		{num==75 && val==127 && chan==2}{e[\event11].value;"medium".postln;}
		{num==41 && val==127 && chan==2}{e[\event12].value;"pluie".postln;}
		{num==42 && val==127 && chan==2}{e[\event13].value;"Crickets".postln;}
		{num==43 && val==127 && chan==2}{e[\event14].value;"Nappe bass".postln;}
		{num==44 && val==127 && chan==2}{e[\event15].value;"Nappe cloches".postln;}
		// nappes tableau 3 (41.. = 1 ligne)
		{num==73 && val==127 && chan==3}{e[\event16].value;"vide".postln;}
		{num==74 && val==127 && chan==3}{e[\event17].value;"vide".postln;}
		{num==75 && val==127 && chan==3}{e[\event18].value;"vide".postln;}
		{num==41 && val==127 && chan==3}{e[\event19].value;"dog".postln;}
		{num==42 && val==127 && chan==3}{e[\event20].value;"vide".postln;}
		{num==43 && val==127 && chan==3}{e[\event21].value;"drame".postln;}
		{num==44 && val==127 && chan==3}{e[\event22].value;"gong nappe".postln;}
		// nappes tableau 4
		{num==73 && val==127 && chan==4}{e[\event23].value;"vide".postln;}
		{num==74 && val==127 && chan==4}{e[\event24].value;"vide".postln;}
		{num==75 && val==127 && chan==4}{e[\event25].value;"vide".postln;}
		{num==41 && val==127 && chan==4}{e[\event26].value;"vide".postln;}
		{num==42 && val==127 && chan==4}{e[\event27].value;"radio notcher".postln;}
		{num==43 && val==127 && chan==4}{e[\event28].value;"noise".postln;}
		{num==44 && val==127 && chan==4}{e[\event29].value;"sub".postln;}
		// samples tableau 1
		{num==57 && val==127 && chan==1}{e[\sample1].value;"Bateau".postln;}
		{num==58 && val==127 && chan==1}{e[\sample2].value;"Puit".postln;}
		{num==59 && val==127 && chan==1}{e[\sample3].value;"Dauphins".postln;}
		{num==60 && val==127 && chan==1}{e[\sample4].value;"Baleins".postln;}
		{num==89 && val==127 && chan==1}{e[\sample5].value;"Water bell".postln;}
		{num==90 && val==127 && chan==1}{e[\sample6].value;"Verre vrac".postln;}
		{num==91 && val==127 && chan==1}{e[\sample7].value;"Verre".postln;}
		{num==92 && val==127 && chan==1}{e[\sample8].value;"Goutes".postln;}
		// samples tableau 2
		{num==57 && val==127 && chan==2}{e[\sample9].value;"Craquement".postln;}
		{num==58 && val==127 && chan==2}{e[\sample10].value;"Cratch".postln;}
		{num==59 && val==127 && chan==2}{e[\sample11].value;"Pierre".postln;}
		{num==60 && val==127 && chan==2}{e[\sample12].value;"Clic".postln;}
		{num==89 && val==127 && chan==2}{e[\sample13].value;"Grenouilles".postln;}
		{num==90 && val==127 && chan==2}{e[\sample14].value;"NylonBox".postln;}
		{num==91 && val==127 && chan==2}{e[\sample15].value;"Oiseau FX".postln;}
		{num==92 && val==127 && chan==2}{e[\sample16].value;"Rideau".postln;}
		// samples tableau 3
		{num==57 && val==127 && chan==3}{e[\sample17].value;"dog".postln;}
		{num==58 && val==127 && chan==3}{e[\sample18].value;"Rexpi".postln;}
		{num==59 && val==127 && chan==3}{e[\sample19].value;"Expi".postln;}
		{num==60 && val==127 && chan==3}{e[\sample20].value;"SC fx".postln;}
		{num==89 && val==127 && chan==3}{e[\sample21].value;"Space".postln;}
		{num==90 && val==127 && chan==3}{e[\sample22].value;"Roll".postln;}
		{num==91 && val==127 && chan==3}{e[\sample23].value;"bOOOii".postln;}
		{num==92 && val==127 && chan==3}{e[\sample24].value;"medium gong".postln;}
		// samples tableau 4
		{num==57 && val==127 && chan==4}{e[\sample25].value;"couine".postln;}
		{num==58 && val==127 && chan==4}{e[\sample26].value;"dark".postln;}
		{num==59 && val==127 && chan==4}{e[\sample27].value;"zombie".postln;}
		{num==60 && val==127 && chan==4}{e[\sample28].value;"Human bird".postln;}
		{num==89 && val==127 && chan==4}{e[\sample29].value;"Formant".postln;}
		{num==90 && val==127 && chan==4}{e[\sample30].value;"duck".postln;}
		{num==91 && val==127 && chan==4}{e[\sample31].value;"plock".postln;}
		{num==92 && val==127 && chan==4}{e[\sample32].value;"FRONSSONS FM".postln;}
			// samples tableau 5
		{num==57 && val==127 && chan==5}{e[\sample41].value;"1".postln;}
		{num==58 && val==127 && chan==5}{e[\sample42].value;"2".postln;}
		{num==59 && val==127 && chan==5}{e[\sample43].value;"3".postln;}
		{num==60 && val==127 && chan==5}{e[\sample44].value;"4".postln;}
		{num==89 && val==127 && chan==5}{e[\sample45].value;"5".postln;}
		{num==90 && val==127 && chan==5}{e[\sample46].value;"6".postln;}
		{num==91 && val==127 && chan==5}{e[\sample47].value;"7".postln;}
		{num==92 && val==127 && chan==5}{e[\sample48].value;"8".postln;}
		//device (sur launch ctrl XL)
		{num==105 && val==127 }{e[\init].value;"Initialisation".postln;}
		//mute (sur launch ctrl XL)
		{num==106 && val==127 }{e[\quit].value;"quit".postln;}
		//record arm (sur launch ctrl XL)
		{num==108 && val==127 }{e[\mayday].value;"Panique bouton".postln;}
		{num==57 || num==58 || num==59 || num==60 || num==89 || num==90 ||num==91 || num==92 } {}
		{true}{nil};
	});

	MIDIFunc.cc({
		arg val, ccNum, channel;
		[val, ccNum, channel].postln;

		if(ccNum==107, {
			~freeze = val.linexp(0, 127, 0, 1);
			~one.set(\trig, ~freeze);
			"freeze".postln;
		});

		if(ccNum == 77 && channel == 1, {
			~volumeSynth = val.linlin(0, 127, -60, 6).round(0.1);
			"Volume nappes saw".postln;
			~volumeSynth.postln;
		});

		if(ccNum == 77 && channel == 2, {
			~volumeSynth = val.linlin(0, 127, -60, 6).round(0.1);
			"Volume nappes bass".postln;
			~volumeSynth.postln;
		});

		if(ccNum == 77 && channel == 0, {
			~volumeMaster = val.linlin(0, 127, -60, 6).round(0.1);
			~master.set(\amp, ~volumeMaster);
			"Volume Master".postln;
			~volumeMaster.postln;
		});

		if(ccNum == 80 /*&& channel == 1*/, {
			~test = val.linexp(0, 127, -0.70, 0);
		});

		if(ccNum == 83 /*&& channel == 1*/, {
			~mixBrick = val.linexp(0, 127, -1, 1)
		}); // dry/wet du BrickWall

		if(ccNum == 80 /*&& channel == 1*/, {
			~test = val;
			~volValh = val.linlin(0, 127, -20, 9).round(0.1);
			if(~test == 0, {
				~one.set(\amp,-80);
			},{
			~one.set(\amp, ~volValh);
			"Volume Radio".postln;
			~volValh.postln;
			});
		});

		if(ccNum == 79 /*&& channel == 1*/, {
			~mixDel = val.linlin(0, 127, 0, 1).round(0.01);
			~vstDelaySynth.synth.set(\mix, ~mixDel);
			"Mix Delay".postln;
			~mixDel.postln;
		});
		//RQ high nappa
		if(ccNum == 16 /*&& channel == 1*/, {
			~rqHigh = val.linlin(0, 127, 0.01, 0.1).round(0.01);
			~snow.set(\rq, ~rqHigh);
			"Rq snow".postln;
			~rqHigh.postln;
		});
		//interpolation des grain de la chaine d'effet à naturel
		if(ccNum == 29 /*&& channel == 1*/, {
			~interp_gran = val.linlin(0, 127, 0, 1);
			~g.do({ arg n; n.set(\switch, ~interp_gran) });
			"gran interp".postln;
			~interp_gran.postln;
		});
		//interpolation cloche
		if(ccNum == 49 /*&& channel == 1*/, {
			~interp_cloche = val.linlin(0, 127, 0, 1);
			~clo.set(\switch, ~interp_cloche);
			"cloche interp".postln;
			~interp_cloche.postln;
		});

		if(ccNum == 17 /*&& channel == 1*/, {
			~msDel = val.linlin(0, 127, 0, 1).round(0.01);
			~vstDelaySynth.synth.set(\ms, ~msDel);
			"Ms Delay".postln;
			~msDel.postln;
		});

		if(ccNum == 18 /*&& channel == 1*/, {
			~phaseDel = val.linlin(0, 127, 0, 1).round(0.01);
			~vstDelaySynth.synth.set(\phase, ~phaseDel);
			"Phase Delay".postln;
			~phaseDel.postln;
		});

		if(ccNum == 19 /*&& channel == 1*/, {
			~fdbackDel = val.linlin(0, 127, 0, 1).round(0.01);
			~vstDelaySynth.synth.set(\fdback, ~fdbackDel);
			"Feedback Delay".postln;
			~fdbackDel.postln;
		});

		if(ccNum == 20 /*&& channel == 1*/, {
			~lcDel = val.linlin(0, 127, 0, 1).round(0.01);
			~vstDelaySynth.synth.set(\lc, ~lcDel);
			"Lc Delay".postln;
			~lcDel.postln;
		});
		// dry wet reverb plug
		if(ccNum == 78 /*&& channel == 1*/, {
			~mixVerb = val.linlin(0, 127, 0, 1).round(0.01);
			~vstMassiveSynth.synth.set(\mix, ~mixVerb);
			"Verb mix".postln;
			~mixVerb.postln;
		});

		//wipe du filtre brickWall
		if(ccNum == 55 /*&& channel == 1*/, {
			~wipeBrick = val.linexp(0, 127, -0.5, -0.995).round(0.001) ;
			~brickWallSynth.set(\wipe, ~wipeBrick);
			~brickWallSynth_2.set(\wipe, ~wipeBrick);
			"wipe brick".postln;
			~wipeBrick.postln;
		});
		//dry/wet brickWall
		if(ccNum == 83 /*&& channel == 1*/, {
			~mixBrick = val.linlin(0, 127,0, 1).round(0.01);
			~brickWallSynth.set(\mix, ~mixBrick);
			~brickWallSynth_2.set(\mix, ~mixBrick);
			"mix brick".postln;
			~mixBrick.postln;
		});

		//temps de picth modulation
		if(ccNum == 56 /*&& channel == 1*/, {
			~pitch = val.linlin(0, 127, 0.25, 4).round(0.01);
			~pitchSynth.set(\pitch, ~pitch);
			~pitchSynth_2.set(\pitch, ~pitch);
			"pitch".postln;
			~pitch.postln;
		});
		//dry/wet pitch
		if(ccNum == 84 /*&& channel == 1*/, {
			~pitchMix = val.linlin(0, 127, 0.01, 1).round(0.01);
			~pitchSynth.set(\mix, ~pitchMix);
			~pitchSynth_2.set(\mix, ~pitchMix);
			"mix reverb".postln;
			~pitchMix.postln;
		});
		//temps de delay
		if(ccNum == 54 /*&& channel == 0*/, {
			~delTime = val.linlin(0, 127, 0.001, 0.5).round(0.001);
			~delaySynth.set(\min, ~delTime);
			~delaySynth_2.set(\min, ~delTime);
			"delay time".postln;
			~delTime.postln;
		});

		//mix saturation
		if(ccNum == 81 /*&& channel == 1*/, {
			~mixSat = val.linlin(0, 127, 0, 1).round(0.01);
			~saturator.set(\mix, ~mixSat);
			~saturator_2.set(\mix, ~mixSat);
			"Mix Saturation".postln;
			~mixSat.postln;
		});
		//saturation
		if(ccNum == 53 /*&& channel == 1*/, {
			~saturPot = val.linlin(0, 127, 0.2, 15).round(0.01);
			~saturator.set(\saturation, ~saturPot);
			~saturator_2.set(\saturation, ~saturPot);
			"Saturation".postln;
			~saturPot.postln;
		});
		//saturation HPF
		if(ccNum == 33 /*&& channel == 1*/, {
			~hpf = val.linlin(0, 127, 10, 7800).round(10).lag(2);
			~saturator.set(\freqHpf, ~hpf);
			~saturator_2.set(\freqHpf, ~hpf);

			~g.do({ arg n; n.set(\hpf, ~hpf)});
			"Saturation HPF".postln;
			~hpf.postln;
		});

		//dry/wet delay
		if(ccNum == 82 /*&& channel == 1*/, {
			~delMix = val.linlin(0, 127, 0, 1).round(0.01);
			~delaySynth.set(\mix, ~delMix);
			~delaySynth_2.set(\mix, ~delMix);
			"Delay DryWet".postln;
			~delMix.postln;
		});
		//variation granulateur
		if(ccNum == 13 /*&& channel == 1*/,{
			~dur = val.linlin(0,127,0.02,0.25).round(0.01).lag(2);
			~rqGran = val.linexp(0,127,0.15,0.999).round(0.01).lag(1);
			~g.do({ arg n; n.set(\baseDur, ~dur, \rq, ~rqGran) });
			~dur_atk = val.linlin(0,127,0.001,0.7);
			"durée granulateur".postln;
			~dur.postln;
			"rq granulateur".postln;
			~rqGran.postln;
		});
		// variation granulateur
		if(ccNum == 14 /*&& channel == 1*/,{
			~rateGran = val.linlin(0,127,0.7, 1.6).round(0.01).lag(1);
			~freqFilter = val.linlin(0,127,100,7000).round(1).lag(1);
			~g.do({ arg n; n.set(\rate, ~rateGran, \freqFilter, ~freqFilter)});
			"rate granulateur".postln;
			~rateGran.postln;
			"frequence filtre granulateur".postln;
			~freqFilter.postln;
		});
		//master samples || enfin !!
		if (ccNum == 36, {
			~volSamples = val.linlin(0,127,-60,6).round(0.01);
			~masterGranRadio.set(\amp, ~volSamples);
			~saturator.set(\amp, ~volSamples);
			"Master samples".postln;
			~volSamples.postln;
		});
		//master nappes
		if (ccNum == 35, {
			~volNappes = val.linlin(0,127,-60,6).round(0.01);
			~masterNappes.set(\amp, ~volNappes);
			~drame_gran.set(\amp,~volNappes);
			"Master nappes".postln;
			~volNappes.postln;
		});
		//Master melodie harpe || transitions
		if (ccNum == 34, {
			~volMelo = val.linlin(0,127,-60,6).round(0.01);
			~melo.set(\amp, ~volMelo);
			~mom.set(\amp, ~volMelo);
			"Master melodies".postln;
			~volMelo.postln;
		});
		// modulation radio amp par saw
		if (ccNum == 52, {
			~modRad = val.linlin(0,127,0,25).round(0.1);
			~one.set(\mod, ~modRad);
			"Modulation radio".postln;
			~modRad.postln;
		});
		//noise freq
		if (ccNum == 51, {
			~freqNoise = val.linlin(0,127,55,1000).round(1);
			~drone.set(\freq, ~freqNoise);
			"Freq Noise".postln;
			~freqNoise.postln;
		});
		//rate Noise
		if (ccNum == 31, {
			~rateNoise = val.linlin(0,127,0.1,10).round(0.1);
			"Rate Noise".postln;
			~rateNoise.postln;
		});
		//
		if (ccNum == 15, {
			~often = val.linlin(0,127, 0.02, 0.12).round(0.01);
			~atkNoise = val.linlin(0,127,0.1,10).round(0.01);
			"Atk Noise".postln;
			~atkNoise.postln;
		});

		if (ccNum == 30, {
			~sat = val.linlin(0,127,0.98,1.2).round(0.01);
			~bal.set(\sat, ~sat);
			"Sat Notch".postln;
			~sat.postln;
		});

		if (ccNum == 50, {
			~rqF = val.linexp(0,127,0.01,0.4).round(0.01);
			~bal.set(\rqF, ~rqF);
			"Rq balet".postln;
			~rqF.postln;
		});

		if(ccNum == 105 /*&& channel == 1*/,{
			e[\loadPresets].value;"Load Presets".postln;
		});
	});
};
)