
(
// Delay
SynthDef(\spookyDelay, {
	arg in, out=0, amp=0, freq=100, rq=1;
	var sig, band, comb0, comb1, comb2, comb3, comb4, comb5;

	sig = [comb0, comb1, comb2, comb3, comb4, comb5];

	Out.ar(out, sig);
}).add;

)