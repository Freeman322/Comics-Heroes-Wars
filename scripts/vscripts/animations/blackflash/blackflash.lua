model:CreateSequence(
	{
		name = "run",
		sequences = {
			{ "@run" }
		},
		addlayer = {
			"turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "run_angry",
		sequences = {
			{ "@run_angry" }
		},
		addlayer = {
			"turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "haste", weight = 1 }
		}
	}
)

model:CreateSequence(
	{
		name = "run_injured",
		sequences = {
			{ "@run_injured" }
		},
		addlayer = {
			"turns"
		},
		activities = {
			{ name = "ACT_DOTA_RUN", weight = 1 },
			{ name = "injured", weight = 1 }
		}
	}
)
