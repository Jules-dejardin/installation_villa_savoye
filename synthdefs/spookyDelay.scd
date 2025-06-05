
(
// Delay
SynthDef(\spookyDelay, {
	arg in, out=0, amp=0, freq=200, rq=1, atk=0.1, rel=1;
	var sig, dry, env, delayTime;

	delayTime = Rand(0.05,0.15);
	env = EnvGen.kr(Env([0,1,0],[atk, rel], [-4,-4]), doneAction:2);
	dry = In.ar(in, 2);

	sig = HPF.ar(dry, freq.lag(3));

	sig = Decimator.ar(sig, 12000, 8);

	sig = (sig * 0.5) + CombC.ar(sig, 0.5, delayTime * XLine.ar(1,2, rel),1.5);

	sig = sig * env * amp.dbamp.lag(2);

	Out.ar(out, sig);
}).add;

)

// ~delay = Synth(\spookyDelay, [\in, ~bus[\djBus],\freq, 1500, \out, 0, \rel, 3, \atk, 3, \amp, -10], ~mainGrp);
