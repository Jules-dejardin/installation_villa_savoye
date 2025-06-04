(

~makeBusses = {

	~bus = Dictionary.new;

	~bus.add(\djBus -> Bus.audio(s, 2));

	~bus.add(\ptrBus -> Bus.audio(s, 1));
	~bus.add(\sampBus -> Bus.audio(s, 1));
	~bus.add(\ptrBusSamp -> Bus.audio(s, 1));

	~bus.add(\gran_dj -> Bus.audio(s, 6));
	~bus.add(\comb -> Bus.audio(s, 6)); //4 pour spat
	~bus.add(\delay -> Bus.audio(s, 6)); //4 pour spat

	~bus.add(\master -> Bus.audio(s,6)); //4 pour spat


};

)
