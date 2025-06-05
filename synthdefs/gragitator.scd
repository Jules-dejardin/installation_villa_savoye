

// Réception a partir d'un bus du signal qui va être écrit dans le buffer pour granulation
SynthDef(\bufInput, {
	arg in_1, in_2, out, amp=0;
	var sig;
	sig = (In.ar(in_1, 1) + In.ar(in_2, 1))* amp.dbamp;
	Out.ar(out,sig);
}).add;

// Pointeur de lecture pour ecrire dans le buffer de granulation a l'aide de rec
SynthDef(\ptr, {
	arg out=0, buf=0, rate=1;
	var sig;
	sig = Phasor.ar(0, BufRateScale.kr(buf)*rate, 0, BufFrames.kr(buf));
	Out.ar(out, sig);
}).add;

// Ecrit dans un buffer le signal reçu de \bufInput suivant \ptr la tete de lecture
SynthDef(\rec, {
	arg ptrIn=0, micIn=0, buf=0;
	var sig, ptr;
	ptr = In.ar(ptrIn, 1);
	sig = In.ar(micIn, 1);
	BufWr.ar(sig, buf, ptr);
}).add;

// Synthdef de granulation principal (à partir du buffer de rec)
SynthDef(\gragitator,{
	arg sync=1, dens=20, baseDur=0.05, durRand=1, buf=0, rate=1, rateRand=1, grainEnv=(-1), panHz=0.1, panRand=0, atk=1, rel=1, amp=(-3), gate=1, out=0,out2=0, ptrBus=0, ptrSampleDelay=20000, ptrRandSamples=5000, minPtrDelay=1000, curve=(-8), hpf=90, switch=1, rq=0.5, freqFilter=2700, bufIndex=0, bufpos=0, panRate=0.5;

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

	sig = HPF.ar(sig, hpf.lag(3));
	// sig = RLPF.ar(sig, freqFilter.lag(2), rq);
	sig = sig * env * amp.dbamp.lag(2) * switch * start;
	// sig2 = (sig2 * env * amp.dbamp.lag(2)) * (1 - switch);

	Out.ar(out, sig);
	// Out.ar(out2, sig2);
}).add;
