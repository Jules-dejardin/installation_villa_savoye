
(
//
SynthDef(\fonComb, {
	arg in, out=0, amp=0, freq=100, rq=1;
	var sig, band, comb0, comb1, comb2, comb3, comb4, comb5;

	sig = In.ar(in, numChannels:2);
	band=12;

	comb0 = BPF.ar(
		in: sig[0],
		freq: (0..band).linexp(0, band, freq, freq*12),
		rq: rq/100,
		mul: 0.5
	).sum;

	comb1 = BPF.ar(
		in: sig[1],
		freq: (0..band).linexp(0,band,freq,freq*12),
		rq: rq/100,
		mul: 0.5
	).sum;

	comb2 = BPF.ar(
		in: sig[0],
		freq: (0..band).élinexp(0,band,freq,freq*12),
		rq: rq/100,
		mul: 0.5
	).sum;

	comb3 = BPF.ar(
		in: sig[1],
		freq: (0..band).linexp(0,band,freq,freq*12),
		rq: rq/100,
		mul: 0.5
	).sum;

	comb4 = BPF.ar(
		in: sig[0],
		freq: (0..band).linexp(0,band,freq,freq*12),
		rq: rq/100,
		mul: 0.5
	).sum;

	comb5 = BPF.ar(
		in: sig[1],
		freq: (0..band).linexp(0,band,freq,freq*12),
		rq: rq/100,
		mul: 0.5
	).sum;

	sig = [comb0, comb1, comb2, comb3, comb4, comb5];
	Out.ar(out, sig);
}).add;

)