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
		name = "run_ultimate",
		looping = true,
		sequences = {
			{ "@run_ultimate" }
		},
		addlayer = { "turns" },
		activities = {
				{ name = "ACT_DOTA_RUN", weight = 1 },
				{ name = "haste", weight = 1 }
		}
	}
)