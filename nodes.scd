(
~makeNodes = {

	s.bind({
		~djGrp = Group.new;
		~ptrGrp = Group.after(~djGrp);
		~recGrp = Group.after(~ptrGrp);

		~mainGrp = Group.after(~recGrp);

		~fxGrp = Group.after(~mainGrp);
		~spatGrp = Group.after(~fxGrp);
		~masterGrp = Group.after(~spatGrp);

		~dj = Synth.new(
			\dj,
			[
				\amp, -60,
				\in, 0,
				\out, ~bus[\djBus]
			]
			, ~djGrp);

		~granulation = Synth.new(
			\master_spat,
			[
				\amp,0,
				\lag, 5,
				\in, ~bus[\gran_dj],
				\out, ~bus[\gran_spat],//normalement master
			],
			~fxGrp
		);

		~comb = Synth.new(
			\master_spat,
			[
				\amp, 0,
				\in, ~bus[\comb],
				\out, ~bus[\master],//normalement master
			],
			~fxGrp
		);

		~delay = Synth.new(
			\master_spat,
			[
				\amp, 0,
				\in, ~bus[\delay],
				\out, ~bus[\master],
			],
			~fxGrp
		);

		~spatialisation_gran = Synth.new(
			\mono_to_sept,
			[
				\amp,0,
				\lag, 2,
				\pos,0,
				\width, 2.0,
				\in, ~bus[\gran_spat],
				\out, ~bus[\master],//normalement master
			],
			~spatGrp
		);
		////////////////////////////////////
		///tous les master se réunissent ici
		~master = Synth.new(
			\master_spat,
			[
				\amp, 0,
				\in, ~bus[\master],
				\out, 0,
			],
			~masterGrp
		);
	});
};
)

