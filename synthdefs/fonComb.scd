(
//
SynthDef(\fonComb, {
	arg in, out=0, amp=0, freq=200, freq0=50,freq1=50,rq=1, multiple=24;
	var sig,dry,ampfollow, band, comb0, comb1, comb2, comb3, comb4, comb5, verb0, verb1, verb2;

	dry = In.ar(in, numChannels:2);
	band = 12;
	multiple = multiple.lag(30);

	ampfollow = Amplitude.ar(dry, 0.01, 2.5, 0.6);

	freq0 = freq0.lag(40);
	freq1 = freq1.lag(40);

	comb0 = BPF.ar(
		in: dry[0],
		freq: (0..band-1).linexp(0, band, freq0, freq0 * multiple),
		rq: rq/1000,
		mul: 1.1
	).sum;

	comb0 = comb0 + BPF.ar(
		in: dry[0],
		freq: (0..band-1).linexp(0, band, freq0*10, 10 * freq0 * multiple),
		rq: rq/1000,
		mul: ampfollow
	).sum;

	comb1 = BPF.ar(
		in: dry[1],
		freq: (0..band-1).linexp(0,band,freq,freq * multiple),
		rq: rq/800,
		mul: 1.1
	).sum;

	comb1 = comb1 + BPF.ar(
		in: dry[0],
		freq: (0..band-1).linexp(0, band, freq1*10, 10 * freq1 * multiple),
		rq: rq/800,
		mul: ampfollow
	).sum;

	comb2 = BPF.ar(
		in: dry[0],
		freq: (0..band-1).linexp(0,band,freq,freq * multiple),
		rq: rq/100,
		mul: 0.5
	).sum;

	comb3 = BPF.ar(
		in: dry[1],
		freq: (0..band-1).linexp(0,band,freq,freq * multiple),
		rq: rq/100,
		mul: 0.5
	).sum;

	comb4 = BPF.ar(
		in: dry[0],
		freq: (0..band-1).linexp(0,band,freq,freq*multiple),
		rq: rq/100,
		mul: 0.5
	).sum;

	comb5 = BPF.ar(
		in: dry[1],
		freq: (0..band-1).linexp(0,band,freq,freq*multiple),
		rq: rq/100,
		mul: 0.5
	).sum;

	verb0 = MiVerb.ar([comb0, comb1]);
	verb1 = MiVerb.ar([comb2, comb3]);
	verb2 = MiVerb.ar([comb4, comb5]);
	sig = verb0 ++ verb1 ++ verb2;
	sig = sig * amp.dbamp.lag(3);
	Out.ar(out, sig);
}).add;

)