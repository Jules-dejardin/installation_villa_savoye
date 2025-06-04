(
~makeNodes = {

	s.bind({
		~mainGrp = Group.new;
			~djGrp = Group.after(~mainGrp);
			~ptrGrp = Group.after(~djGrp);
			~recGrp = Group.after(~ptrGrp);


			~fxGrp = Group.after(~recGrp);
			~spatGrp = Group.after(~fxGrp);
			~masterGrp = Group.after(~spatGrp);


		~granulation = Synth.new(
			\master_spat,
			[
				\amp,0,
				\in, ~bus[\gran_dj],
				\out, ~bus[\master],//normalement master
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
		////////////////////////////////////
		///tous les master se réunissent ici
		~master = Synth.new(
			\master_spat,
			[
				\amp, 0,
				\in, ~bus[\masterSpat],
				\out, 0,
			],
			~masterGrpSpat
		);
	});
};
)

