SynthDef(\mono_to_sept, {
	arg in, out=0, amp=(-3), width=4.0, pos=0, lag=0.05, pan=0;
	var sig;

	sig = In.ar(in,1);
	sig = sig * amp.dbamp.lag(1);
	sig = PanAz.ar(7, sig, pos.lag(lag), 1.0,width.lag(lag), 0.5);

	Out.ar(out, sig);
}).add;

SynthDef(\master_spat, {
	arg in, out=0, amp=0, duck=0, tresh=0.5, clamp=0.015, relax=0.015, lag=1;
	var sig;

	sig = In.ar(in,6);
	sig = sig * amp.dbamp.lag(lag);
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


SynthDef(\dj, {
	arg amp=(-5), trig=0, in1=0,in2=0, out=0, sizes=2048, freqHpf=100, mod=1, test=0, sidechain=0;
	var sig, chain, env, gate, dry, wet, mags, phases, modAmp;

	dry = SoundIn.ar([in1,in2]);
	sig = dry * amp.dbamp;
	Out.ar(out, sig);
}).add;

