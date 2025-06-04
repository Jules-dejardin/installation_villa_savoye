(
~makeEvents = {
	// MIDIClient.init;
	// MIDIIn.connectAll;

	e = Dictionary.new;

	e.add(\init -> {
		~one = Synth(\dj, [\in, 0, \out, 6, \amp, -60], ~mainGrp);//dj
		~recBuff = Buffer.alloc(s, s.sampleRate * 5, 1);
		// ~recBuff_samp = Buffer.alloc(s, s.sampleRate * 5, 1);
		// ~recBuff_2 = Buffer.alloc(s, s.sampleRate * 40, 1);
		//~recBuff.plot;
		~djRead = Synth(\AudioInputStereo, [\input, 0, \out, ~bus[\djBus], \amp, 0], ~djGrp);
		~djPtr = Synth(\ptr, [\buf, ~recBuff, \out, ~bus[\ptrBus]], ~ptrGrp);

		~djRecord = Synth(\rec, [\ptrIn, ~bus[\ptrBus], \micIn, ~bus[\djBus], \buf, ~recBuff], ~recGrp);

		~env_grad= Buffer.sendCollection(s, Env([0, 1,0.5,0], [0.001, 0.1,0.2], [-4,-4, -2]).discretize, 1);
	});
	// Compander
	// ~vstMassiveSynth.editor;

	e.add(\loadPresets-> {

	});

	e.add(\event1 -> {

	});

	e.add(\event2 -> {

	});

	e.add(\event3 -> {

	});

	e.add(\event4 -> {

		~g.do({ arg n; n.set(\gate, 0, \rel, 1) });

		(
			~recBuff.zero;
			~g =  5.collect({
				arg n;
				Synth(\granDj, [
					\amp, 0,
					\buf, ~recBuff,
					\out, ~bus[\gran_dj],
					// \out2,~bus[\satura],
					\atk, 0.01,
					\rel, 0.3,
					\gate, 1,
					\sync, 1,
					\dens, exprand(20,40),
					\baseDur, exprand(0.2, 0.5),
					\durRand, 1,
					\rate, 1,
					\rateRand, 2.midiratio,
					// \bufIndex, ~bufenv[0].bufnum,
					\grainEnv, ~bufenv[0],
					\ptrBus, ~bus[\ptrBus],
					\ptrSampleDelay, n.linlin(0,4,20000,s.sampleRate*2),
					\ptrRandSamples, 10000,
					\minPtrDelay, 1000
				],~granGrp);
			});
		)
	});

	e.add(\event5 -> {

	});

	e.add(\event6 -> {

	});

	e.add(\event9 -> {

	});

	e.add(\event10 -> {

	});


	e.add(\event11 -> {

	});

	e.add(\event12 -> {

	});

	e.add(\event13 -> {

	});

	e.add(\event14 -> {

	});

	e.add(\event15 -> {

	});

	//event page 3

	e.add(\event16 -> {});

	e.add(\event19 -> {});

	e.add(\event20 -> {});

	e.add(\event21 -> {});

	e.add(\event22 -> {});
	// page 4 event
	e.add(\event26 -> {});
	// 60.midicps
	e.add(\event24 -> {});

	e.add(\event27 -> {});

	e.add(\event28 -> {});
	// ~drone.set(\amp,-30);

	e.add(\event29 -> {});

	e.add(\event23 -> {});

	//page 1 boutons
	e.add(\sample1 -> {});

	e.add(\sample2 -> {});

	e.add(\sample3 -> {});

	e.add(\sample4 -> {});

	e.add(\sample5 -> {});

	e.add(\sample6 -> {});

	e.add(\sample7 -> {});

	e.add(\sample8 -> {});

	e.add(\sample9 -> {});

	e.add(\sample10 -> {});

	e.add(\sample11 -> {});

	e.add(\sample12 -> {});

	e.add(\sample13 -> {});

	e.add(\sample14 -> {});

	e.add(\sample15 -> {});

	e.add(\sample16 -> {});

	//boutons page 3
	e.add(\sample17 -> {});
	e.add(\sample18 -> {});
	e.add(\sample19 -> {});
	e.add(\sample20 -> {});
	e.add(\sample21 -> {});
	e.add(\sample22 -> {});
	e.add(\sample23 -> {});
	e.add(\sample24 -> {});

	e.add(\quit -> {});

	e.add(\mayday -> {
		// MIDIIn.disconnectAll;
		Server.killAll;
	});

	MIDIdef.noteOn(\controller, {
		arg val, num, chan;
		[val, num, chan].postln;

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
		{num==73 && val==127 && chan==4}{e[\event23].value;"blast".postln;}
		{num==74 && val==127 && chan==4}{e[\event24].value;"wowoah".postln;}
		{num==75 && val==127 && chan==4}{e[\event25].value;"vide".postln;}
		{num==41 && val==127 && chan==4}{e[\event26].value;"radio trick".postln;}
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
		// [val, ccNum, channel].postln;

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
			~mixDel = val;
			m.control(1,20, ~mixDel);
			// ~vstDelaySynth.synth.set(\mix, ~mixDel);
			"Mix Delay".postln;
			~mixDel.postln;
			~radio_expend_zero.set(\amp2,0,\amp3, 0,\amp4, 0);
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
			~msDel = val;
			m.control(1,23,~msDel);
			// m.control(1,23,1);//init
			"Ms Delay".postln;
			~msDel.postln;
		});

		if(ccNum == 18 /*&& channel == 1*/, {
			~phaseDel = val;
			m.control(1,21, ~phaseDel);
			// m.control(1,21, 1);//init
			"Phase Delay".postln;
			~phaseDel.postln;
		});

		if(ccNum == 19 /*&& channel == 1*/, {
			~fdbackDel = val;
			m.control(1,22,~fdbackDel);
			// m.control(1,22,1);//init
			"Feedback Delay".postln;
			~fdbackDel.postln;
		});

		if(ccNum == 20 /*&& channel == 1*/, {
			~lcDel = val;
			m.control(1,24,~lcDel);
			// m.control(1,24,1); //init
			"Lc Delay".postln;
			~lcDel.postln;
		});
		// dry wet reverb plug
		if(ccNum == 78 /*&& channel == 1*/, {
			~mixVerb = val;
			m.control(1,25,~mixVerb);
			// m.control(1,25,1);//init
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
			~dur = val.linexp(0,127,0.005,0.8).round(0.001).lag(1); //0.02,0.25
			~index = val.linlin(0,127, 0,3).round(1);
			~panRate = val.linlin(0,127,5,0.6).round(0.1).lag(1);
			~rqGran = val.linexp(0,127,0.15,0.999).round(0.01).lag(1);
			~g.do({ arg n; n.set(\baseDur, ~dur, \rq, ~rqGran, \grainEnv, ~bufenv[~index]) });
			~dur_atk = val.linlin(0,127,0.001,0.3).round(0.001);
			// "durée granulateur".postln;
			~dur.postln;
			// "rq granulateur".postln;
			// ~rqGran.postln;
			// ~index.postln;
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
			~gs.do({ arg n; n.set(\amp, ~volSamples-6) });
			~masterGranRadio.set(\amp, ~volSamples);
			~saturator.set(\amp, ~volSamples);
			~saturator_2.set(\amp, ~volSamples);
			"Master samples".postln;
			~volSamples.postln;
		});
		//master nappes
		if (ccNum == 35, {
			~volNappes = val.linlin(0,127,-60,6).round(0.01);
			~masterNappes_bspat.set(\amp, ~volNappes);
			~drame_slow.set(\amp, ~volNappes);
			~clo.set(\amp, ~volNappes);
			~cloche_vol = ~volNappes;
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
			~divergence = val;
			m.control(1,30, ~divergence);
			// ~bal.set(\sat, ~sat);
			"Divergence radio".postln;
			~divergence.postln;
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