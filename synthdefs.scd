

// [2] ++ [0.2,0.8,0.65,0.45, 0.3].scramble
//Générateurs de sons
SynthDef(\balayage, {
	arg out=0, pan=0, in=0, amp=(-5), freq=220, rq=0.1, rqF=0.2, sat=1, notch=0.7, gate=0,relOut=5;
	var sig, env, envout;

	envout = EnvGen.kr(Env.new([1,0], [relOut], -2),gate, doneAction:2);
	env = EnvGen.kr(Env.new([0,1],[10],4));

	sig = SoundIn.ar(in);
	sig = Notch.ar(sig, LFNoise2.kr(6).linlin(-1,1,500,750),rq.lag(2),notch.lag(2));
	sig = Notch.ar(sig, LFNoise2.kr(3).linlin(-1,1,550,1500),rq.lag(3),notch.lag(2));
	sig = Notch.ar(sig, LFNoise2.kr(0.52).linlin(-1,1,1550,2500),rq.lag(4),notch.lag(2));
	sig = Notch.ar(sig, LFNoise2.kr(0.1).linlin(-1,1,2550,5500),rq.lag(5),notch.lag(7));

	4.do{
		sig = RLPF.ar(sig, LFNoise2.ar(0.5).linexp(-1,1,250,5000),rqF.lag(5), 0.5);
		sig = (sig*sat.lag(5)).tanh;
	};

	sig = Decimator.ar(sig, LFNoise2.ar(0.4).linlin(-1,1,2500,30000), LFNoise2.ar(1.2).linlin(-1,1,12,24));
	sig = Limiter.ar(sig);
	sig = HPF.ar(sig, 200);
	sig = sig*env*amp.dbamp.lag(5)*envout;
	Out.ar(out,sig);
}).add;

SynthDef(\radio_bounce, {
	arg buf, out=0, amp=(-5), pos=0, t_trig=1, rateS=1,rateE=0.5, rev=0, pan=0, curve=(4), atk=0.2, rel=2.5, loop=1, which=0, vitloop=0.1;
    var sig, env;

	env = EnvGen.kr(Env.new([0,1,0],[atk,rel],[curve, 4]),  doneAction:2);
	sig = PlayBuf.ar(
		1,
		buf,
		BufRateScale.kr(buf) * XLine.ar(rateS,
		rateE, rel/2),
		t_trig, BufFrames.kr(buf) * pos,
		trigger: Select.kr(which,[1, Trig.ar(SinOsc.ar(50),vitloop+LFNoise2.ar(0.5).linlin(-1,1,0.05,0.2))]),
		loop: loop);
	sig = LPF.ar(sig, 8500);
	sig = sig * env * amp.dbamp.lag(1) * XLine.ar(1, 1.3, rel);
	sig = Pan2.ar(sig, pan);
	Out.ar(out, sig);
}).add;

SynthDef(\master, {
	arg in, out=0, amp=(-3), width=4.0, pos=0, lag=0.05, pan=0;
	var sig;

	sig = In.ar(in,1);
	sig = sig * amp.dbamp.lag(1);
	sig = PanAz.ar(8, sig, pos.lag(lag), 1.0,width.lag(lag), 0.5);

	Out.ar(out, sig);
}).add;

SynthDef(\master_spat, {
	arg in, out=0, amp=0, duck=0, tresh=0.5, clamp=0.015, relax=0.015;
	var sig;

	sig = In.ar(in,6);
	sig = sig * amp.dbamp.lag(1);
	sig = Limiter.ar(sig, 0.998);
	// sig = Compander.ar(sig, duck, tresh, 1, 1/28, clamp, relax);

	Out.ar(out, sig);
}).add;

SynthDef(\AudioInputStereo, {
	arg in1=0, in2=0, out = 0, amp = (-3),  freqHpf=0;
    var sig;
	sig = SoundIn.ar([in1, in2]) * amp.dbamp.lag(1); // entrée carte son
	sig = sig.sum;
	sig = HPF.ar(sig, freqHpf);
	Out.ar(out, sig); //sortie directe a un bus
}).add;

SynthDef(\ptr, {
	arg out=0, buf=0, rate=1;
	var sig;
	sig = Phasor.ar(0, BufRateScale.kr(buf)*rate, 0, BufFrames.kr(buf));
	Out.ar(out, sig);
}).add;

SynthDef(\rec, {
	arg ptrIn=0, micIn=0, buf=0;
	var sig, ptr;
	ptr = In.ar(ptrIn, 1);
	sig = In.ar(micIn, 1);
	BufWr.ar(sig, buf, ptr);
}).add;

SynthDef(\in, {
	arg in_1, in_2, out, amp=0;
	var sig;
	sig = (In.ar(in_1, 1) + In.ar(in_2, 1))* amp.dbamp;
	Out.ar(out,sig);
}).add;

//Env.asr(0.001, 0.5, 1, -10).test(2).plot;

SynthDef(\granDj,{
	arg sync=1, dens=20, baseDur=0.05, durRand=1, buf=0, rate=1, rateRand=1, grainEnv=(-1), panHz=0.1, panRand=0, atk=1, rel=1, amp=(-3), gate=1, out=0,out2=0, ptrBus=0, ptrSampleDelay=20000, ptrRandSamples=5000, minPtrDelay=1000, curve=(-8), hpf=25, switch=1, rq=0.5, freqFilter=2700, bufIndex=0, bufpos=0, panRate=0.5;

	var sig, env, densCtrl, durCtrl, panCtrl, rateCtrl, ptr, ptrRand, totalDelay, maxGrainDur, pan, sig2, start;

	start = EnvGen.kr(Env.new([0,1], [0.2],2));
	env = EnvGen.ar(Env.asr(atk,1,rel,[4,curve]), gate, doneAction:2);
	densCtrl = Select.ar(sync, [Dust.ar(dens), Impulse.ar(dens)]);
	durCtrl = baseDur * LFNoise1.kr(100).exprange(1/durRand,durRand);
	rateCtrl = rate.lag(1) * LFNoise1.ar(100).exprange(1/rateRand, rateRand);
	//panCtrl = pan + LFNoise1.kr(panHz).bipolar(panRand);

	ptrRand = LFNoise1.ar(100).bipolar(ptrRandSamples);
	totalDelay = max(ptrSampleDelay - ptrRand, minPtrDelay);

	ptr = In.ar(ptrBus, 1);
	ptr = ptr - totalDelay;
	ptr = ptr / BufFrames.kr(buf);

	maxGrainDur = (totalDelay / rateCtrl) / SampleRate.ir;
	durCtrl = min(durCtrl, maxGrainDur);
	pan = LFNoise2.ar(panRate);

	sig = GrainBuf.ar (
		6,
		densCtrl,
		durCtrl,
		buf,
		rateCtrl,
		ptr,
		2,
		pan,
		grainEnv
	);

	// sig2 = GrainBuf.ar (
	// 	1,
	// 	densCtrl,
	// 	durCtrl,
	// 	buf,
	// 	rateCtrl,
	// 	ptr,
	// 	2,
	// 	pan,
	// 	grainEnv
	// );

	// switch = switch.lag(3);

	sig = HPF.ar(sig, hpf.lag(3));
	// sig = RLPF.ar(sig, freqFilter.lag(2), rq);
	sig = sig * env * amp.dbamp.lag(2) * switch * start;
	// sig2 = (sig2 * env * amp.dbamp.lag(2)) * (1 - switch);

	Out.ar(out, sig);
	// Out.ar(out2, sig2);
}).add;

SynthDef(\kick, {
    arg out=0, amp=(-10), freq=50;
    var sig, env;
    env = Env.perc(0.001, 0.8).ar(Done.freeSelf); //env globale

    sig = SinOsc.ar(freq * (1+(8 * Env.perc(0, 0.13, curve:-8).ar))); //swipe du kick
    sig = sig + (SinOsc.ar(XLine.ar(8000, 100, 0.01)) * Env.perc(0.0001,0.01).ar * -8.dbamp); // ajout du clic
    sig = sig +(BPF.ar(WhiteNoise.ar, 10120, 0.5)*Env.perc(0.0001, 0.03).ar * -8.dbamp);
    sig = (sig*20.dbamp).tanh; // plus ca disto plus c'est gabber
    sig = sig * env * amp.dbamp;
    sig = Pan2.ar(sig);
    Out.ar(out,sig);
}).add;
//---------------------------------EFFETS-----------------------------------------------//

//VSTPlugin.pluginList(s);
SynthDef(\cricket, {
	arg freq=55, amp=0.1, out=0, pan=0, gate=1, harmo=2500, sus=0.2;
	var sig, env, sig1, sig2, sig3, sig4, band1, band2, band3, band4;

	env = EnvGen.ar(Env([0,1,1,0],[0.1,sus,0.1], -5),  gate, doneAction:2);

/*	freq = Rand(45, 75);
	harmo = Rand(2450, 2800);*/

	sig1 = Formant.ar(freq, harmo, 77)*0.5;
	band1 = BPF.ar(sig1, 50, 0.01);
	sig2 = Formant.ar(freq, harmo, 77)*0.3;
	band2 = BPF.ar(sig2, 2500, 0.01);
	sig3 = Formant.ar(freq, 8000, 100)*0.3;
	band3 = BPF.ar(sig3, 8000, 0.02);
	sig4 = Formant.ar(freq, harmo, 50)*0.2;
	band4 = BPF.ar(sig4, 12000, 0.02);

	sig = (sig1+sig2+sig3+sig4) * env * amp;
	// sig = Pan2.ar(sig);

	Out.ar(out, sig);

}).add;

SynthDef(\dj, {
	arg amp=(-5), trig=0, in1=0,in2=0, out=0, sizes=2048, freqHpf=100, mod=1, test=0, sidechain=0;
	var sig, chain, env, gate, dry, wet, mags, phases, modAmp;

	dry = SoundIn.ar([in1,in2]);
	sig = dry;
	Out.ar(out, sig);
}).add;


// ~one.set(\test, 0);

//
// //Granulateurs
// SynthDef(\gran,{
// 	arg sync=1, dens=20, gDur=0.1, durRand=1, buf=0, rate=1, pos=0, posSpeed=0, posRand=0, grainEnv=(-1), pan=0, panHz=0.1, panRand=0, atk=1, sus=1, rel=1, c0=1, c1=2, amp=(-5), out=0, rq=1, minDens=1, freqFilter=1500, maxC=(-8), minC=4, trig=0;
//
// 	var sig, env, densCtrl, durCtrl, posCtrl, panCtrl, density, fade;
//
// 	c0 = XLine.kr(maxC,minC,sus/4);
// 	density = XLine.kr(dens,minDens,sus);
//
// 	env = EnvGen.ar(Env.new([0,1,0], [atk,sus,rel], [c0,c1]), doneAction:2);
// 	fade =  EnvGen.ar(Env.new([1,1,0], [0.001,1], [c0,-4]), trig,  doneAction:2);
//
// 	densCtrl = Select.ar(sync, [Dust.ar(density), Impulse.ar(density)]);
//
// 	durCtrl = gDur * LFNoise1.kr(100).exprange(1/durRand,durRand);
//
// 	posCtrl = Phasor.ar(0, posSpeed * BufRateScale.ir(buf), 0, BufSamples.ir(buf)-1);
// 	posCtrl = posCtrl + LFNoise1.kr(100).bipolar(posRand*SampleRate.ir);
// 	posCtrl = posCtrl / BufSamples.ir(buf);
// 	posCtrl = posCtrl + pos;
//
// 	panCtrl = pan + LFNoise1.kr(panHz).bipolar(panRand);
//
// 	sig = GrainBuf.ar (
// 		8,
// 		densCtrl,
// 		durCtrl,
// 		buf,
// 		rate,
// 		posCtrl,
// 		2,
// 		panCtrl,
// 		grainEnv
// 	);
//
// 	// sig = BPF.ar(sig, freqFilter, rq);
// 	sig = sig * env * amp.dbamp;
// 	sig = sig * (1 * fade);
// 	Out.ar(out,sig);
// }).add;

/*
SynthDef(\granul_2, {
	arg buf=0, out=0, amp=0, atk=3, rel=1, rate=1, pan=0, pos=0.2, grainEnv=(-1), masse=10, dur=0.1, drive=1.15, rateSaw=1, gate=0, gateout;
	var sig, env, envout;

	envout = EnvGen.kr(Env.new([1,0], [rel/2], [-4]), gateout, doneAction:2);
	env = EnvGen.kr(Env.new([0,1,1,0], [atk,2,rel], [4,2]),1, doneAction:2);

	pos = LFSaw.kr(rateSaw, 1);

	sig = GrainBuf.ar(
		2,
		Impulse.ar(masse.lag(2)),
		dur.lag(2),
		buf,
		rate.lag(2),
		pos.lag(0.2),
		4,
		LFNoise2.ar(0.2).linlin(-1,1,-0.6,0.6),
		grainEnv,
		512,
	);

	sig =  RHPF.ar(Compander.ar(sig, sig, 1, 1, 0.5, 0.01,0.2), 150, 0.4);
	sig = sig + RHPF.ar(sig, LFNoise2.ar(0.2).linlin(-1,1,50,100), 0.001, 0.7);
	sig = sig + CombL.ar(sig, 0.2, LFNoise2.ar(3).linlin(-1,1,0.002,0.003), 1, 0.2);

	sig = (sig * drive.lag(2)).tanh;
	sig = Limiter.ar(sig, 0.99);
	sig = sig * amp.dbamp.lag(2) * env;
	Out.ar(out,sig);
}).add;*/