NDefines.NGame.MAP_SCALE_PIXEL_TO_KM = 1.793					-- Yes, we did the math

NDefines.NProduction.BASE_FACTORY_MAX_EFFICIENCY_FACTOR = 35
NDefines.NProduction.BASE_FACTORY_START_EFFICIENCY_FACTOR = 7
NDefines.NProduction.BASE_FACTORY_SPEED = 6 			    	-- Base factory speed multiplier (how much hoi3 style IC each factory gives).
NDefines.NProduction.BASE_FACTORY_SPEED_MIL = 6 				-- Base factory speed multiplier (how much hoi3 style IC each factory gives).
NDefines.NProduction.BASE_FACTORY_SPEED_NAV = 3 				-- Base factory speed multiplier (how much hoi3 style IC each factory gives).
NDefines.NCountry.MAJOR_IC_RATIO = 5                            -- difference in total factories needed to be considered major with respect to other nation
NDefines.NCountry.MAJOR_MIN_FACTORIES = 40						-- need at least these many factories to become a major
NDefines.NCountry.MIN_MAJOR_COUNTRIES	= 3						-- MIN_MAJOR_COUNTRIES countries with most factories will be considered as major countries
NDefines.NCountry.ADDITIONAL_MAJOR_COUNTRIES_IC_RATIO = 0.75
NDefines.NBuildings.AIRBASE_CAPACITY_MULT = 150		-- Each level of airbase building multiplied by this, gives capacity (max operational value). Value is int. 1 for each airplane.

NDefines.NBuildings.RADAR_RANGE_BASE = 30
NDefines.NBuildings.RADAR_RANGE_MIN = 30
NDefines.NBuildings.RADAR_RANGE_MAX = 300
NDefines.NBuildings.ANTI_AIR_SUPERIORITY_MULT = 10

NDefines.NMilitary.LAND_AIR_COMBAT_STR_DAMAGE_MODIFIER = 0.2   -- air global damage modifier
NDefines.NMilitary.LAND_AIR_COMBAT_ORG_DAMAGE_MODIFIER = 0.2   -- global damage modifier
NDefines.NMilitary.ENEMY_AIR_SUPERIORITY_IMPACT = -0.40         -- effect on defense due to enemy air superiorty
NDefines.NMilitary.ANTI_AIR_TARGETTING_TO_CHANCE = 0.035		-- Balancing value to determine the chance of ground AA hitting an attacking airplane, affecting both the effective average damage done by AA to airplanes, and the reduction of damage done by airplanes due to AA support
NDefines.NMilitary.ANTI_AIR_ATTACK_TO_AMOUNT = 0.0015			-- Balancing value to convert equipment stat anti_air_attack to the random % value of airplanes being hit.
NDefines.NMilitary.ENEMY_AIR_SUPERIORITY_SPEED_IMPACT = -0.5    -- effect on speed due to enemy air superiority

NDefines.NAir.AIR_WING_MAX_SIZE = 250 							-- Max amount of airplanes in wing
NDefines.NAI.AIR_WING_REINFORCEMENT_LIMIT = 25
NDefines.NAir.DETECT_CHANCE_FROM_RADARS = 0.6 					-- How much the radars in area affects detection chance.
NDefines.NAir.DETECT_CHANCE_FROM_AIRCRAFTS_EFFECTIVE_COUNT = 50 -- Max amount of aircrafts in region to give full detection bonus.
NDefines.NAir.DETECT_CHANCE_FROM_AIRCRAFTS = 2				-- How much aircrafts in region improves air detection (up to effective count).
NDefines.NAir.DETECT_CHANCE_FROM_NIGHT = -0.4					-- How much the night can reduce the air detection. (see static modifiers to check how weather affects it too.)
NDefines.NAir.HOURS_DELAY_AFTER_EACH_COMBAT = 2					-- How many hours needs the wing to be ready for the next combat. Use for tweaking if combats happens too often. (generally used as double because of roundtrip)
NDefines.NAir.FIELD_EXPERIENCE_SCALE = 0.03
NDefines.NAir.FIELD_EXPERIENCE_MAX_PER_DAY = 3					-- Most xp you can gain per day
NDefines.NAir.AIR_WING_COUNTRY_XP_FROM_TRAINING_FACTOR = 0.05	--Factor on country Air XP gained from wing training

NDefines.NMilitary.UNIT_DIGIN_CAP = 10							-- how "deep" you can dig you can dig in until hitting max bonus. Every point counts as 2% entrenchment Vanilla value 5
NDefines.NMilitary.UNIT_DIGIN_SPEED = 0.8							-- how "deep" you can dig a day. vanilla value 1

-- Fuel
NDefines.NGame.FUEL_RESOURCE = "energy"							-- resource that will give country fuel
NDefines.NCountry.FUEL_LEASE_CONVOY_RATIO = 0.00005				-- num convoys needed per fuel land lease
NDefines.NCountry.STARTING_FUEL_RATIO = 0.1						-- starting fuel ratio compared to max fuel for countries
NDefines.NCountry.BASE_FUEL_GAIN_PER_OIL = 0.25				-- base amount of fuel gained hourly per excess oil
NDefines.NCountry.BASE_FUEL_GAIN = 0.25						-- base amount of fuel gained hourly, independent of excess oil
NDefines.NCountry.BASE_FUEL_CAPACITY = 4000						-- base amount of fuel capacity
NDefines.NProduction.ANNEX_FUEL_RATIO = 0.5						-- How much fuel will be transferred on annexation
NDefines.NProduction.CAPITULATE_FUEL_RATIO = 0.5				-- How much fuel will be transferred on capitulation
NDefines.NMilitary.FUEL_PENALTY_START_RATIO = 0.20				-- ratio of fuel in an army to start getting penalties

--NMilitary
NDefines.NMilitary.ARMY_FUEL_COST_MULT = 0.2 					--fuel multiplier for all army missions
NDefines.NMilitary.ARMY_COMBAT_FUEL_MULT =   1.5				-- fuel consumption ratio in combat
NDefines.NMilitary.ARMY_TRAINING_FUEL_MULT = 1.0				-- fuel consumption ratio while training
NDefines.NMilitary.ARMY_MOVEMENT_FUEL_MULT = 1.0				-- fuel consumption ratio while moving
NDefines.NMilitary.ARMY_MAX_FUEL_FLOW_MULT = 4.0				-- max fuel ratio that an army can get per hour, multiplied by supply situation
NDefines.NMilitary.OUT_OF_FUEL_EQUIPMENT_MULT = 0.1				-- ratio of the stats that you get from equipments that uses fuel and you lack it
NDefines.NMilitary.OUT_OF_FUEL_SPEED_MULT = 0.3					-- speed mult that armies get when out of fuel
NDefines.NMilitary.OUT_OF_FUEL_TRAINING_XP_GAIN_MULT = 0.2		-- xp gain mult from training when a unit is out of fuel
NDefines.NMilitary.FUEL_CAPACITY_DEFAULT_HOURS = 120           	-- default capacity if not specified


--NAir
NDefines.NAir.FUEL_COST_MULT = 0.1								--fuel multiplier for all air missions
NDefines.NAir.MISSION_EFFICIENCY_MULT_AT_LACK_OF_FUEL = 0.2 	-- multiplier for mission efficiency when a base lacks fuel

--NNavy
NDefines.NNavy.FUEL_COST_MULT = 0.1								--fuel multiplier for all naval missions
NDefines.NNavy.IN_COMBAT_FUEL_COST = 1.5						-- ships in combat will get this ratio for fuel cost
NDefines.NNavy.MAX_FUEL_FLOW_MULT = 4.0						-- max fuel flow ratio for ships, which will be multiplied by supply
NDefines.NNavy.NAVAL_RANGE_TO_INGAME_DISTANCE = 0.35		-- Scale the ship stats "naval_range" to the ingame distance
