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

SynthDef(\, {
arg freq = 50, rate=2, amp=(-15), clip=1.01, atk=1, out=0;
var sig, sig2, env, curve;

	curve = atk.linlin(0.1,10,-4,2);
	env = EnvGen.ar(Env.new([0,1,0], [atk.lag(0.2)/4,(atk.lag(0.2))], [curve,1]), doneAction:2);

	sig = Ringz.ar(LFCub.ar(freq.lag(50) * (1 + (0..3)*0.654)), freq*0.654, atk, 0.3);
	sig2 = SinOsc.ar(freq.lag(50) * ((1+(0..3))*0.654), (LFNoise2.ar(1).linexp(-1,1,0,2pi))!3, 0.6);
	sig = sig +sig2;

3.do{
		sig = (sig*0.9) + RLPF.ar(sig, LFNoise2.ar(rate*0.5).linexp(-1,1,250,4000).lag(Rand(1,5)), Rand(0.1,1).lag(0.5), 0.4);
		sig =(sig*0.8) + BPF.ar(sig, (0..8).linexp(0,8, 250,5000),Rand(0.01,0.2).lag(1), 0.2);
		sig = (sig * LFNoise2.ar(0.2).linexp(-1,1,1,1.2)).tanh;
};

	sig = sig + CombL.ar(sig,0.2,LFNoise2.ar((rate+1)/10).linexp(-1,1,0.001,0.1),atk, 0.3);
	sig = sig + RHPF.ar(sig, freq, 0.05, 0.2);
	sig = sig + Formlet.ar(sig, freq * ((1..5)*543), atk/4,0.1, mul:0.15);
	sig = LPF.ar(sig, freq*10);
	sig = sig.tanh;
	sig = Splay.ar(sig,0.5).sum;
	// sig = Limiter.ar(sig, 1);
	sig = sig * env* amp.dbamp;

	// sig = Pan2.ar(sig, LFNoise2.kr(Rand(0.1,10)));
Out.ar(out, sig);
}).add;


SynthDef(\ou, {
	arg out=0, pan=0, f1=300, f2=750,f3=2300,fd=90, pon=0,fon=0, atk=0.01,rel=0.5,amp=(-5), don=0;
	var sig, env, sig2;

	env = EnvGen.kr(Env.new([0, 1,0],[atk,rel],[4,-2]),doneAction:2);
	sig = Formant.ar(SelectX.kr(fon,[fd, XLine.ar(fd, 5,(rel+atk))]),[f1,f2,f3], fd*2, 0.3).sum;
	sig = sig + CombC.ar(sig, LFNoise2.kr(2).linexp(-1,1,0.001,0.5), 0.5, rel, don);

	sig = FreeVerb.ar(sig,0.3,0.5, 0.5);
	sig = LPF.ar(sig, 4000);
	sig = sig*env*amp.dbamp;
	// sig = Pan2.ar(sig,SelectX.kr(pon,[0,SinOsc.kr(pan,0.5)]));
	Out.ar(out,sig);
}).add;


SynthDef(\audioBuf, {
	arg buf, out, amp=(-1), pos=0, t_trig=1, rate=1, loop=0, rev=0, pan=0, curve=0, atk=0.001;
    var sig, env;

	env = EnvGen.kr(Env.new([0,1,1],[atk,1],curve));
    sig = PlayBuf.ar(1, buf, BufRateScale.kr(buf) * rate, t_trig, BufFrames.kr(buf) * pos, loop: loop, doneAction:2);
	sig = sig * env * amp.dbamp.lag(2);
	//sig = Pan2.ar(sig, pan);
	Out.ar(out, sig);
}).add;

SynthDef(\audioBufste, {
	arg buf, out, amp=(-1), pos=0, t_trig=1, rate=1, loop=0, rev=0, pan=0, curve=0, atk=0.001;
    var sig, env;

	env = EnvGen.kr(Env.new([0,1,1],[atk,1],curve));
    sig = PlayBuf.ar(2, buf, BufRateScale.kr(buf) * rate, t_trig, BufFrames.kr(buf) * pos, loop: loop, doneAction:2);
	sig = sig * env * amp.dbamp.lag(1);
	// sig = Pan2.ar(sig, pan);
	Out.ar(out, sig);
}).add;

SynthDef(\melo_mono, {
	arg buf, out, amp=(-1), pos=0, t_trig=1, rate=1, loop=0, rev=0, pan=0, curve=0, atk=0.001, num=1;
    var sig, env;

	env = EnvGen.kr(Env.new([0,1,1],[atk,1],curve));
    sig = PlayBuf.ar(1, buf, BufRateScale.kr(buf) * rate, t_trig, BufFrames.kr(buf) * pos, loop: loop, doneAction:2);
	sig = sig * env * amp.dbamp.lag(1);
	sig = Pan4.ar(sig);
	Out.ar(out, sig);
}).add;

SynthDef(\master, {
	arg in, out=0, amp=(-3), width=4.0, pos=0, lag=0.05, pan=0;
	var sig;

	sig = In.ar(in,1);
	sig = sig * amp.dbamp.lag(1);
	sig = PanAz.ar(4,sig,pos.lag(lag),1.0,width.lag(lag),1);

	Out.ar(out, sig);
}).add;

SynthDef(\master_spat, {
	arg in, out=0, amp=0;
	var sig;

	sig = In.ar(in,4);
	sig = sig * amp.dbamp.lag(1);

	Out.ar(out, sig);
}).add;

SynthDef(\radio_expend, {
	arg in, out=0,out2=2, amp=0;
	var sig;

	sig = In.ar(in,2);
	sig = sig * amp.dbamp.lag(1);

	Out.ar(out, sig);
	Out.ar(out2,sig);
}).add;

SynthDef(\AudioInputMono, {
	arg input = 0, out = 0, amp = (-3),  freqHpf=0;
    var sig;
	sig = SoundIn.ar(input) * amp.dbamp.lag(1); // entrée carte son
	sig = HPF.ar(sig, freqHpf);
	Out.ar(out, sig); //sortie directe a un bus
}).add;

SynthDef(\steIn, {
	arg buf, out = 0,out2=2, amp=(-1), pos=0, t_trig=1, rate=1, loop=0, rev=0, pan=0, curve=0, atk=2;
    var sig, env;

	env = EnvGen.kr(Env.new([0,1,1],[atk,1],curve));
    sig = PlayBuf.ar(2, buf, BufRateScale.kr(buf) * rate, t_trig, BufFrames.kr(buf) * pos, loop: loop, doneAction:2);
	sig = sig * env * amp.dbamp.lag(1);
	// sig = Pan2.ar(sig, pan);
	Out.ar(out, sig);
	Out.ar(out2,sig);
}).add;

SynthDef(\lectechant, {
	arg buf, out,out2, amp=(-1), pos=0, t_trig=1, rate=1, loop=0, rev=0, pan=0, curve=0, atk=0.001, varEnv=1, rel=1, bpf=15000,minRate=0.6, maxRate=1.2, bus=0;
    var sig, env, lfoAtk, lfoRel,lfoRate;

	lfoAtk = SinOsc.ar(1).round(0.01).range(0.001,0.2);
	lfoRel = SinOsc.ar(0.5).round(0.01).range(0.5,1);
	lfoRate = LFNoise1.ar(0.5).round(0.01).range(minRate,maxRate);

	if(varEnv == 0, {
		env = EnvGen.kr(Env.new([0,1,1],[atk,rel],curve));
	},{
	env = EnvGen.kr(Env.new([0,1,1],[lfoAtk,lfoRel],curve));
	});

	sig = PlayBuf.ar(1, buf, BufRateScale.kr(buf) * lfoRate, t_trig, BufFrames.kr(buf) * pos, loop: loop, doneAction:2);
	sig = sig * env * amp.dbamp.lag(1);
	// sig = BPF.ar(sig, bpf);
	//sig = Pan2.ar(sig, pan);
	Out.ar(out, sig * (bus-1));
	Out.ar(out2, sig * bus);
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

//GONG

SynthDef(\gong, {
	arg freq = 200, dur = 4, amp = 0.5, decay = 1, out, harmofact=0.05, panRate=0.8,  harmolowfact=0.15, verbTime=1.5, atk=0.001, wetDelay=(-1), delayTime=0.1, renfoAtk=0.3, ampdb=(-3), hpfHigh=0, brfHigh=1700;
    var atkHarmo, noise, envelopedSound, sig, harmo, harmo2, delay, frappe, envdel, envHPF;

	atkHarmo = EnvGen.kr(Env.new([0,0.8,0.8,0],[0.3,1,dur],2));

	harmo = Formant.ar(freq/4, freq/1.5, freq/2) * harmolowfact * atkHarmo;
	harmo2 = Formant.ar(freq/2, freq*4, freq) * harmofact * atkHarmo;
	harmo = harmo + harmo2;
	harmo = FreeVerb.ar(harmo, 0.7, 0.9, 0.7) * EnvGen.kr(Env.new([0,1,1,0],[0.2,1,dur*1.5],(-8)),doneAction: 2);
	//harmo = Pan2.ar(harmo, SinOsc.ar(panRate,mul:0.3));

	frappe = DelayL.ar((SinOsc.ar(freq, mul: amp-0.1) + SinOsc.ar(freq*0.1, renfoAtk)) * EnvGen.kr(Env.perc(0.001, 1), 0.01));
	envdel =  EnvGen.kr(Env.new([0,1,0], [0.2,decay], 4));

	sig = DelayL.ar(SinOsc.ar(freq, mul: amp) * envdel,  0.2);
	envelopedSound = sig * DelayL.ar(SinOsc.ar(9, mul:XLine.kr(0.2, 0, dur+1)), 0.02, 0.2);
	sig = sig * EnvGen.kr(Env.new([0,1,0],[atk, dur*verbTime], [8,-8]));
	sig = sig + envelopedSound;
	sig = LPF.ar(sig, 100);
//	sig = Pan2.ar(sig);
	sig = sig + harmo + frappe;

	envHPF = EnvGen.kr(Env.new([freq+20,300], dur, (-3)));
	sig = HPF.ar(sig, 1*envHPF);
	sig = HPF.ar(sig,hpfHigh);

    Out.ar(out, sig*ampdb.dbamp.lag(1));
}).add;


//Bruit Blanc Mer

SynthDef(\highNap, {
	arg freq=2000, lfoRate=0.05, out=0, amp=0.7, rq=0.04, lpf=7000, disto=80, relOut=0, gate=1;
	var sig, lfo1, lfo2, env;

	env = EnvGen.kr(Env.asr(5, 1, relOut, 5),gate, doneAction:2);
	freq = freq+(2000*(SinOsc.kr(0.01)+1));
	lfo1 = 500*SinOsc.kr(lfoRate);
	lfo2 = 500*SinOsc.kr(lfoRate+lfoRate);

	sig = BPF.ar(
		[PinkNoise.ar, PinkNoise.ar],
		[freq+(lfo1), freq+100+(lfo2)],
		rq,);// a moduler
	sig = (sig*Lag.kr(LFNoise1.kr(100).exprange(1,disto).round(0.01), 10)).softclip*0.1; //de 0.025 à 0.05
	sig = sig*env*amp;
	sig = LPF.ar(sig, lpf);
	Out.ar(out, sig);
}).add;

//synthé pluk

SynthDef(\bpfsaw, {
	arg atk=2, sus=0,rel=3, c1=1, c2=(-1), freq=500, detune=0.2, cfhzmin=0.1, cfhzmax=0.3, cfmin=500, cfmax=2000, rqmin=0.1, rqmax=0.2, lsf=200, ldb=0, amp=(-3), out=0, pan=0;
	var sig, env;
	env = EnvGen.kr(Env([0,1,1,0],[atk,sus,rel], [c1,0,c2]),doneAction:2);
	sig =  Saw.ar(freq * {LFNoise1.kr(0.5, detune).midiratio}!2);
	sig = BPF.ar(
		sig,
		{LFNoise1.kr(
			LFNoise1.kr(4).exprange(cfhzmin, cfhzmax)).exprange(cfmin, cfmax)}!2,
		{LFNoise1.kr(0.1).exprange(rqmin, rqmax)}!2
	);
	sig = BLowShelf.ar(sig, lsf, 0.5, ldb);
	sig = Balance2.ar(sig[0], sig[1], pan);
	sig = sig * env * amp.dbamp;
	sig = LPF.ar(sig, 10000);
	Out.ar(out,sig);
}).add;

SynthDef(\bass, {
	arg atk=2, sus=0,rel=3, c1=1, c2=(-1), freq=500, detune=0.2, cfhzmin=0.1, cfhzmax=0.3, cfmin=500, cfmax=2000, rqmin=0.1, rqmax=0.2, lsf=200, ldb=6, amp=(-1), out=0, pan=0;
	var sig, env;
	env = EnvGen.kr(Env([0,1,1,0],[atk,sus,rel], [c1,0,c2]),doneAction:2);
	sig =  Saw.ar(freq * {LFNoise1.kr(0.5, detune)}!4);
	sig = BPF.ar(
		sig,
		{LFNoise1.kr(
			LFNoise1.kr(4).exprange(cfhzmin, cfhzmax)).exprange(cfmin, cfmax)}!2,
		{LFNoise1.kr(0.1).exprange(rqmin, rqmax)}!2
	);
	sig = BLowShelf.ar(sig, lsf, 0.5, ldb);
	// sig = Balance2.ar(sig[0], sig[1], pan);
	sig = sig * env * amp.dbamp;
	sig = LPF.ar(sig, 10000);
	Out.ar(out,sig);
}).add;

//nappes cloches
SynthDef(\cloches, {
arg out=0,out2=0, amp=0, freqs=#[0,0,0,0,0,0,0,0,0,0,0,0], rings=#[0,0,0,0,0,0,0,0,0,0,0,0], atk=5, sus=7, rel=6, switch=1;
var sig,send, env, trig;

	env = EnvGen.kr(Env.linen(atk, sus, rel, 1, 4), doneAction: Done.freeSelf);
	trig = Decay.ar(Impulse.ar(Rand(0.3, 1)), 0.03, ClipNoise.ar(0.01));

	sig = Klank.ar(
		`[freqs, nil, rings],    // '=tableau de tableau
		trig                    // trigger de cloches
    );

	send = sig * amp.dbamp * (1 - switch);
	sig = sig * amp.dbamp * 1;
	// sig = Pan2.ar(sig*env, pan);

	Out.ar(out, sig);
	Out.ar(out2, send);
}).add;

//nappes douces
SynthDef(\medium,{
arg out=0, freqs=#[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], rings=#[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], atk=5, sus=8, rel=5, pan=0, amp=0;
    var env, sig, input;
env = EnvGen.kr(Env.linen(atk, sus, rel,2, 4), doneAction: Done.freeSelf);
input = BrownNoise.ar(0.0005);
sig = Klank.ar(
        `[freqs, nil, rings],     // specs
        input                 // input
    );
	sig = sig * env * amp.dbamp;

    Out.ar(out, sig);
}).add;

//Granulateurs
SynthDef(\gran,{
	arg sync=1, dens=20, gDur=0.1, durRand=1, buf=0, rate=1, pos=0, posSpeed=0, posRand=0, grainEnv=(-1), pan=0, panHz=0.1, panRand=0, atk=1, sus=1, rel=1, c0=1, c1=2, amp=(-5), out=0, rq=1, minDens=1, freqFilter=1500, maxC=(-8), minC=4, trig=0;

	var sig, env, densCtrl, durCtrl, posCtrl, panCtrl, density, fade;

	c0 = XLine.kr(maxC,minC,sus/4);
	density = XLine.kr(dens,minDens,sus);

	env = EnvGen.ar(Env.new([0,1,0], [atk,sus,rel], [c0,c1]), doneAction:2);
	fade =  EnvGen.ar(Env.new([1,1,0], [0.001,1], [c0,-4]), trig,  doneAction:2);

	densCtrl = Select.ar(sync, [Dust.ar(density), Impulse.ar(density)]);

	durCtrl = gDur * LFNoise1.kr(100).exprange(1/durRand,durRand);

	posCtrl = Phasor.ar(0, posSpeed * BufRateScale.ir(buf), 0, BufSamples.ir(buf)-1);
	posCtrl = posCtrl + LFNoise1.kr(100).bipolar(posRand*SampleRate.ir);
	posCtrl = posCtrl / BufSamples.ir(buf);
	posCtrl = posCtrl + pos;

	panCtrl = pan + LFNoise1.kr(panHz).bipolar(panRand);

	sig = GrainBuf.ar (
		4,
		densCtrl,
		durCtrl,
		buf,
		rate,
		posCtrl,
		2,
		panCtrl,
		grainEnv
	);

	// sig = BPF.ar(sig, freqFilter, rq);
	sig = sig * env * amp.dbamp;
	sig = sig * (1 * fade);
	Out.ar(out,sig);
}).add;

//Env.asr(0.001, 0.5, 1, -10).test(2).plot;

SynthDef(\granRadio,{
	arg sync=1, dens=20, baseDur=0.05, durRand=1, buf=0, rate=1, rateRand=1, grainEnv=(-1), panHz=0.1, panRand=0, atk=1, rel=1, amp=(-3), gate=1, out=0,out2=0, ptrBus=0, ptrSampleDelay=20000, ptrRandSamples=5000, minPtrDelay=1000, curve=(-8), hpf=50, switch=1, rq=0.5, freqFilter=2700;

	var sig, env, densCtrl, durCtrl, panCtrl, rateCtrl, ptr, ptrRand, totalDelay, maxGrainDur, pan, sig2, start;

	// start = EnvGen.kr(Env.new([0,1], [0.2],2));
	env = EnvGen.ar(Env.asr(atk,1,rel,[4,curve]), gate, doneAction:2);
	densCtrl = Select.ar(sync, [Dust.ar(dens), Impulse.ar(dens)]);
	durCtrl = baseDur * LFNoise1.kr(100).exprange(1/durRand,durRand);
	rateCtrl = rate * LFNoise1.ar(100).exprange(1/rateRand, rateRand);
	//panCtrl = pan + LFNoise1.kr(panHz).bipolar(panRand);

	ptrRand = LFNoise1.ar(100).bipolar(ptrRandSamples);
	totalDelay = max(ptrSampleDelay - ptrRand, minPtrDelay);

	ptr = In.ar(ptrBus, 1);
	ptr = ptr - totalDelay;
	ptr = ptr / BufFrames.kr(buf);

	maxGrainDur = (totalDelay / rateCtrl) / SampleRate.ir;
	durCtrl = min(durCtrl, maxGrainDur);

	pan = LFNoise2.ar(0.2);

	sig = GrainBuf.ar (
		4,
		densCtrl,
		durCtrl,
		buf,
		rateCtrl,
		ptr,
		2,
		pan,
		grainEnv
	);

	sig2 = GrainBuf.ar (
		1,
		densCtrl,
		durCtrl,
		buf,
		rateCtrl,
		ptr,
		2,
		pan,
		grainEnv
	);

	switch = switch.lag(3);

	sig = HPF.ar(sig, hpf.lag(3));
	// sig = RLPF.ar(sig, freqFilter.lag(2), rq);
	sig = sig * env * amp.dbamp.lag(2) * switch;
	sig2 = sig2 * env * amp.dbamp.lag(2) * (1 - switch);

	Out.ar(out, sig);
	Out.ar(out2, sig2);
}).add;

SynthDef(\granul, {
	arg buf=0, out=0, amp=0, atk=1, rel=1, rate=1, pan=0, pos=0.2, grainEnv=(-1), masse=10, dur=0.1, drive=1.15, rateSaw=1, gate=0;
	var sig, env;

	env = EnvGen.kr(Env.new([1,0], [rel], -3), gate);

	pos = LFSaw.kr(rateSaw, 1);

	sig = GrainBuf.ar(
		4,
		Impulse.ar(masse.lag(2)),
		dur.lag(2),
		buf,
		rate.lag(2),
		pos.lag(0.2),
		4,
		pan,
		grainEnv,
		512,
	);
	sig = (sig * drive.lag(2)).tanh;
	sig = sig * amp.dbamp.lag(2) * env;
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

SynthDef(\vstDelay, {
	arg in, out, mix, ms, phase, fdback, lc;
	var sig;

	sig = In.ar(in, 2);
	Out.ar(out, VSTPlugin.ar(sig, 2, id: \vstDelay, params: [0, mix, 2, ms, 1, phase, 4, fdback, 5, lc]));
}).add;

SynthDef(\vstMassive, {
	arg in, out, amp=1, mix=0;
	var sig;

	sig = In.ar(in, 2);
	sig = sig * amp;
	Out.ar(out, VSTPlugin.ar(sig, 2, id: \vstMassive, params: [0, mix]));
}).add;


//Brick wall (sorte de lpf) de -1 à 0 le wipe
SynthDef(\brickWall,{
	//arg buf, wipe=0, amp=0.5, out; // il faut le réintégrer au module
	arg in, amp=(-3), wipe=0, mix=0.5, out=0;
	var dry, wet, sig, chain, size=2048;

	dry = In.ar(in, 1);

	chain = FFT(LocalBuf(size, 1).clear, dry);
	chain = PV_BrickWall(chain, wipe);
	wet = IFFT(chain);

	sig = XFade2.ar(dry, wet, mix*2-1, amp.dbamp.lag(1));

	Out.ar(out, sig);
}).add;

//Delay
//à styliser avec une enveloppe || spatialiser
SynthDef(\delay, {
	arg in, out=0, amp=(-3), mix=0.3, decay=3, min=0.3;
	var sig, dry, wet;

	dry = In.ar(in, 1);
	// wet = CombL.ar(dry, 0.5, LFNoise2.kr(0.2).linlin(-1,1, minDel+0.001,minDel+(minDel*3)), decay);

	wet = dry + CombL.ar(dry, 0.5, (min.lag(3) + (LFNoise2.kr(0.5).linlin(-1,1,0.001,0.01)).lag(2)), decay, 0.8);
	// wet = PanAz.ar(wet,  LFNoise2.kr(1).linlin(-1,1,-0.2,1.2));

	sig = XFade2.ar(dry, wet, mix*2-1, amp.dbamp.lag(1));
	// sig = Pan2.ar(sig);

	Out.ar(out,sig);
}).add;
// 0.3*60
//Pitchshifting
SynthDef(\pitch, {
	arg in, pitch=1.0, lpf=4500, mix=0, amp=(-3), out=0;
	var dry, wet, temp, sig;

	dry = In.ar(in, 1);
	/*temp = In.ar(in, 1);*/

	wet = PitchShift.ar(dry, 0.2, pitch.lag(1.5), LFNoise2.ar(0.2).linlin(-1,1,0.0,0.2));
	sig = XFade2.ar(dry, wet, mix*2-1, amp.dbamp.lag(1));
	// sig = wet *amp.dbamp.lag(1);

	Out.ar(out,sig);
}).add;

//saturation
SynthDef(\satu, {
	arg in, amp=(-3), out=0, saturation=1.1, mix=0, freqLpf=10000, freqHpf=40;
	var dry, wet, sig;

	dry = In.ar(in, 1);
	wet = (dry * saturation).tanh(1);

	sig = XFade2.ar(dry, wet, mix*2-1);
	sig = LPF.ar(sig, freqLpf);
	sig = HPF.ar(sig, freqHpf);
	sig = sig*amp.dbamp.lag(2);

	Out.ar(out,sig);
}).add;

(
//Freeze
SynthDef(\radio, {
	arg amp=(-5), trig=0, in=0, out=0, sizes=2048, freqHpf=0, mod=1, test=0;
	var sig, chain, env, gate, dry, wet, mags, phases, modAmp;

    dry = SoundIn.ar(in, 1);

    chain = FFT(LocalBuf(sizes, 1), dry);
	chain = PV_MagFreeze(chain, trig);
	chain = PV_Diffuser(chain, trig);
	chain = PV_BrickWall(chain, -0.80);

	wet = IFFT(chain)* 0.dbamp;
	wet = wet + HPF.ar(wet, 1000, 1);
	wet = FreeVerb.ar(wet, 0.2, 0.2, 0.2);

	sig = XFade2.ar(dry, wet, trig.exprange(-1,1));
	modAmp = Saw.kr(mod).linexp(-1,1,-60, -1);
	sig = HPF.ar(sig, freqHpf);

	//stutter radio
	if (mod != 0,{
		sig = sig * modAmp.dbamp*amp.dbamp.lag(1);
	},
	{sig = sig * 1.5 * amp.dbamp.lag(1) }
	);

	sig = Pan2.ar(sig);

	Out.ar(out, sig);
}).add;
)

// ~one.set(\test, 0);
