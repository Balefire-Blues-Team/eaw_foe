NDefines.NMilitary.NEW_COMMANDER_RANDOM_PERSONALITY_TRAIT_CHANCES = {		-- chances to gain a personality trait for new generals
	1, -- 100% for first trait
	0.25,  -- 25% for second trait after that
	0.05 -- 5% for third trait after that
}
NDefines.NMilitary.NEW_COMMANDER_RANDOM_BASIC_TRAIT_CHANCES = {				-- chances to gain a basic trait for new generals
	0.2, -- 20% for first trait
	0.05 -- 5% for fourth trait after that
}
NDefines.NMilitary.CORPS_COMMANDER_ASSIGNABLE_TRAIT_NUM = 6					-- maximum number of traits that can be assigned to corps commanders
NDefines.NMilitary.FIELD_MARSHAL_ASSIGNABLE_TRAIT_NUM = 8					-- maximum number of traits that can be assigned to field marshalls
NDefines.NMilitary.COMMANDER_LEVEL_UP_STAT_COUNT = 2						-- num stats gained on level up
NDefines.NMilitary.UNIT_LEADER_INITIAL_TRAIT_SLOT = {						-- trait slot for 0 level leader
	1.0, -- field marshal
	1.0, -- corps commander
	0.0  -- navy general
}

NDefines.NMilitary.BASE_FEMALE_DIVISIONAL_COMMANDER_CHANCE = 0.5 -- 50% of time by default, female_divisional_commander_chance modifier is additive
NDefines.NCountry.FEMALE_UNIT_LEADER_BASE_CHANCE = {
	-- applies as a factor to female unit leader randomization
	-- the values needs to be zero if you don't actually have random portraits
	0.5, -- country leaders
    0.5, -- army leaders
    0.5, -- navy leaders
    0.5, -- air leaders
    0.5, -- operatives
} --Go Girlbosses! before Apr 5, 2024 random country, army, and navy leaders were set to always be female in code. -Laundry
