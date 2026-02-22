NDefines.NSupply.INFRA_TO_SUPPLY = 0.3							-- each level of infra gives this many supply
NDefines.NSupply.VP_TO_SUPPLY_BASE = 0.2							-- Bonus to supply from a VP, no matter the level
NDefines.NSupply.VP_TO_SUPPLY_BONUS_CONVERSION = 0.25			-- Bonus to supply local supplies from Victory Points, multiplied by this aspect and rounded to closest integer
NDefines.NSupply.SUPPLY_FROM_DAMAGED_INFRA = 0.15				-- damaged infrastructure counts as this in supply calcs
NDefines.NSupply.SUPPLY_BASE_MULT = 0.4							-- multiplier on supply base values
NDefines.NSupply.SUPPLY_DISRUPTION_DAILY_RECOVERY = 0.5			-- every day nodes recover this much of their accumulated disruption.
NDefines.NSupply.AVAILABLE_MANPOWER_STATE_SUPPLY = 10.0						--Factor for state supply from max manpower (population) (Fae set to 1.0; 0.18 in Vanillali) (Changed to 10 by garn)
-- The range bonus added to a fully motorized hub. This supply is added on top of the XXX_INITIAL_SUPPLY_FLOW defined above. (Fae changed from 2.2 to 3.0)
NDefines.NSupply.SUPPLY_HUB_FULL_MOTORIZATION_BONUS = 3.0
-- How many trucks does it cost to fully motorize a hub (Fae cut the cost of motorization fo a hub in half)
NDefines.NSupply.SUPPLY_HUB_FULL_MOTORIZATION_TRUCK_COST = 40.0
-- Supply
NDefines.NSupply.MAX_RAILWAY_LEVEL = 5 -- update railway texture as well, each frame corresponds to a level

NDefines.NSupply.LOCAL_SUPPLY_PER_AIR_MISSION = 5 -- each assigned plane gives this much supply at full efficiency


--defines to calculate the capitals supply. This will be also used for max supply of other nodes depending on how well they are connected to capital. Using the formula:
--CapitalSupply = CAPITAL_SUPPLY_BASE + (NumberOfCivilianFactories * CAPITAL_SUPPLY_CIVILIAN_FACTORIES) + (NumberOfMilitaryFactories * CAPITAL_SUPPLY_MILITARY_FACTORIES) + (NumberOfDockyards * CAPITAL_SUPPLY_DOCKYARDS)
-- Faeelin changed capital supply civilian factories from .35 to .5, and supply military factories from .6 to .7
NDefines.NSupply.CAPITAL_SUPPLY_BASE = 10.0 -- base supply for capital
NDefines.NSupply.CAPITAL_SUPPLY_CIVILIAN_FACTORIES = 0.5 -- supply from one civilian factory
NDefines.NSupply.CAPITAL_SUPPLY_MILITARY_FACTORIES = 0.7 -- supply from one military factory
NDefines.NSupply.CAPITAL_SUPPLY_DOCKYARDS = 0.7 --supply from one naval factory

-- defines that are used for supply reach for capital
-- supply flow will start from INITIAL_SUPPLY_FLOW and will be reduced by a penalty on each province it travels (which depends on how far we are from our origin, terrain etc)
-- a supply reach >= 1.0 considered "perfect" and will be able to fully support units on that particular province (assuming you are not over capacity)
NDefines.NSupply.CAPITAL_INITIAL_SUPPLY_FLOW = 5.0 -- starting supply from
NDefines.NSupply.CAPITAL_STARTING_PENALTY_PER_PROVINCE = 0.2 -- starting penalty that will be added as supply moves away from its origin (modified by stuff like terrain)
NDefines.NSupply.CAPITAL_ADDED_PENALTY_PER_PROVINCE = 0.6 -- added penalty as we move away from origin

-- defines that are used for supply reach for built nodes  (Faeelin halfed the penalties)
NDefines.NSupply.NODE_INITIAL_SUPPLY_FLOW = 2.8
NDefines.NSupply.NODE_STARTING_PENALTY_PER_PROVINCE = 0.8
NDefines.NSupply.NODE_ADDED_PENALTY_PER_PROVINCE = 1.2

-- defines that are used for supply reach for dockyards
--Faeelin changed the starting penalty .42 instead of .84, and the added penalty .57 instead of 1.1.
NDefines.NSupply.NAVAL_BASE_INITIAL_SUPPLY_FLOW = 20	-- (changed to 30 from 3.3)
NDefines.NSupply.NAVAL_BASE_STARTING_PENALTY_PER_PROVINCE = 0.42
NDefines.NSupply.NAVAL_BASE_ADDED_PENALTY_PER_PROVINCE = 0.57

-- Node Flow (i.e. province caps) increase by this amount per railway level of the node's bottleneck
--(Faee increased from .34 to .5)
NDefines.NSupply.NODE_FLOW_BONUS_PER_RAIL_LEVEL = 0.35

-- rivers will transfer in between nodes as if they were this level
NDefines.NSupply.RIVER_RAILWAY_LEVEL = 1

-- defines that are used for supply reach for floating harbors
NDefines.NSupply.FLOATING_HARBOR_INITIAL_SUPPLY_FLOW = 26	-- (26 instead of 2.6)
NDefines.NSupply.FLOATING_HARBOR_STARTING_PENALTY_PER_PROVINCE = 0.8
NDefines.NSupply.FLOATING_HARBOR_ADDED_PENALTY_PER_PROVINCE = 0.8

NDefines.NSupply.FLOATING_HARBOR_BASE_SUPPLY = 15.0 -- supply given by a floating harbor
NDefines.NSupply.FLOATING_HARBOR_BASE_DURATION = 21 -- duration of a full hp floating harbor
NDefines.NSupply.FLOATING_HARBOR_DURATION_RATIO_AT_MIN_HP = 0.0  -- duration mult for a harbor that was reduced to 0 hp

NDefines.NSupply.FLOATING_HARBOR_MIN_DECAY = 0.2 -- Always reduce Floating Harbor longevity by this many "hours" per hour
NDefines.NSupply.FLOATING_HARBOR_DECAY_MAX_AIR_BONUS = -0.1 -- At 100% Friendly Air superiourity, change decay rate by this many "hours" per hour
NDefines.NSupply.FLOATING_HARBOR_DECAY_MAX_AIR_PENALTY = 0.4 -- At 100% Enemy Air superiourity, change decay rate by this many "hours" per hour
NDefines.NSupply.FLOATING_HARBOR_DECAY_MAX_NAVAL_BONUS = -0.2 -- At 100% Friendly naval superiourity, change decay rate by this many "hours" per hour
NDefines.NSupply.FLOATING_HARBOR_DECAY_MAX_NAVAL_PENALTY = 0.5 -- At 100% Enemy Naval superiourity, change decay rate by this many "hours" per hour
NDefines.NSupply.FLOATING_HARBOR_DECAY_NO_CONTROL_PENALTY = 1.0 -- If adjacent land province is not held, change decay rate by this many "hours" per hour

NDefines.NSupply.SUPPLY_FLOW_DROP_REDUCTION_AT_MAX_INFRA = 0.30 -- max infrastructure level will reduce the supply flow drop off by this ratio
NDefines.NSupply.SUPPLY_FLOW_PENALTY_CROSSING_RIVERS = 0.05 -- crossing rivers introduces additional penalty (Fae changed from 0.20 to .05)

 -- node flow terrain falloff is scaled by logistics curve based on distance(d) (scalar / (1+e^(-k(d-midpoint))))
NDefines.NSupply.SUPPLY_FLOW_DIST_LOGISTICS_FALLOFF_K = 1.3 -- How steep the curve is
NDefines.NSupply.SUPPLY_FLOW_DIST_LOGISTICS_FALLOFF_MIDPOINT = 2.3 -- sigmoid inflection point
NDefines.NSupply.SUPPLY_FLOW_DIST_LOGISTICS_FALLOFF_SCALAR = 0.9 -- Max Penalty adjustment due to distance
NDefines.NSupply.SUPPLY_FLOW_DIST_LOGISTICS_FALLOFF_MIN_PENALTY_SCALE = 0.25 -- Logistics curve never reduces penalty facor below this limit


-- For each additional level of motorization on a hub (i.e. contry with set motoriazation) reduce max bonus for next level by this amount
NDefines.NSupply.SUPPLY_HUB_MOTORIZATION_MARGINAL_EFFECT_DECAY = 1.6


-- used for calculating "flow" for railways.
NDefines.NSupply.RAILWAY_BASE_FLOW = 10.0 		-- how much base flow railway gives when a node connected to its capital/a naval node by a railway (Changed to 20 from 10)
NDefines.NSupply.RAILWAY_FLOW_PER_LEVEL = 5.0 	-- how much additional flow a railway level gives			(changed to 6, from 5 vanilla. Meaning max supply from hub 30+30)
NDefines.NSupply.RAILWAY_FLOW_PENALTY_PER_DAMAGED = 1.0 -- penalty to flow per damaged railway				(Changed to 3, from 5)
NDefines.NSupply.RAILWAY_MIN_FLOW = 5.0 		-- minimum railway flow can be reduced to					(Changed to 10, from 5)

-- used for calculating "flow" from a naval node to another naval node when it is connected via a convoy route
-- NAVAL_BASE_MAX_SUPPLY_FLOW_FACTOR = 0.9, -- flow of the parent node is factored to this ratio (so at most it can transfer parent naval node flow * this define)
NDefines.NSupply.NAVAL_BASE_FLOW = 20.0 -- max output/input of a naval node is limited by this base value + additional ratio for each level (Changed from 15 to 100, naval stronk)
NDefines.NSupply.NAVAL_FLOW_PER_LEVEL = 20.0 -- max output/input of a naval node is limited by previous base value + this define per its level (Changed from 5 to 20, naval stronk)

NDefines.NSupply.SUPPLY_NODE_MIN_SUPPLY_THRESHOLD = 1.0 -- if supply of a node is below this value it will be set to 0 -- Currently unused?

NDefines.NSupply.RAILWAY_CONVERSION_COOLDOWN = 10 -- railways will be put on cooldown when they are captured by enemy and will not be usable during the cooldown
NDefines.NSupply.RAILWAY_CONVERSION_COOLDOWN_CORE = 5
NDefines.NSupply.RAILWAY_CONVERSION_COOLDOWN_CIVILWAR = 0

NDefines.NSupply.DEFAULT_STARTING_TRUCK_RATIO = 0.9 -- countries get this ratio of starting truck in their buffers compared to their need
NDefines.NSupply.DEFAULT_STARTING_TRAIN_RATIO = 1 -- countries get this ratio of starting trains in their buffers compared to their need

NDefines.NSupply.SUPPLY_POINTS_PER_TRAIN = 2.0  -- old default 1.25 -- Amount of supply that can fit in a train. (Trains distribute supply from capital to a supply node.)
NDefines.NSupply.NUM_RAILWAYS_TRAIN_FACTOR = 0.05 -- the train usage is scaled by railway distance between the supply node and the capital multiplied by this factor

NDefines.NSupply.BASE_SUPPLY_MULT_FOR_TRUCK_DEFAULT_BUFFER = 1.0  -- initial value for wanted buffers over potential truck usage
NDefines.NSupply.BASE_SUPPLY_MULT_FOR_TRUCK_MIN_BUFFER = 0.0 -- min and max values for buffer ratio
NDefines.NSupply.BASE_SUPPLY_MULT_FOR_TRUCK_MAX_BUFFER = 100.0

NDefines.NSupply.TRUCK_ATTRITION = 0.008 -- base truck attrition
NDefines.NSupply.TRUCK_ATTRITION_FACTOR = 0.65 --a scale on total truck attrition

NDefines.NSupply.BASE_TRUCK_HP = 20.0
NDefines.NSupply.TRUCK_HP_PER_ARMOR = 1

NDefines.NSupply.BASE_TRAIN_HP = 80.0
NDefines.NSupply.TRAIN_ARMOR_TARGETING_WEIGHT = 0.01 -- For each health point gained by armor_value, enemy bombers are this much more likely to target

NDefines.NSupply.MIN_TRAIN_SUPPLY_FACTOR = 0.5 -- Having 0 trains in stockpile only applies this penalty factor, scaling up to 1.0 when need is met
NDefines.NSupply.MIN_TRAIN_REQUIREMENT = 2 -- If total train need <= this, then don't apply any supply penalty, even if stockpile is insufficient

NDefines.NSupply.SUPPLY_FLOW_REDUCTION_THRESHOLD = 0.1 -- if supply flow is lower than this, it is not applied

-- following values are used for calculating potential truck usage
-- generally potential is ~= current usage but as units moves along the map
-- they are assigned to different nodes which adds slightly higher usage due to minimum truck needed being 1
NDefines.NSupply.BASE_AIR_SUPPLY_MULT_FOR_TRUCK_BUFFER = 1.0
NDefines.NSupply.BASE_ARMY_SUPPLY_MULT_FOR_TRUCK_BUFFER = 1.0
NDefines.NSupply.BASE_NAVY_SUPPLY_MULT_FOR_TRUCK_BUFFER = 1.0

NDefines.NSupply.CAPITAL_NODE_BASE_SUPPLY_ADD = 0
NDefines.NSupply.BUILT_NODE_BASE_SUPPLY_ADD = 0.6
NDefines.NSupply.LOCAL_NODE_BASE_SUPPLY_ADD = 0.5
NDefines.NSupply.NAVAL_NODE_BASE_SUPPLY_ADD = 0.3
-- ~end

-- armies slowly gains and buffers supply above >100% up to their supply grace if they have efficent supply flow
-- otherwuse they will lose up to 100% supply every day depending on how bad supply flow is
NDefines.NSupply.ARMY_SUPPLY_RATIO_STARTING_GAIN = 0.0
NDefines.NSupply.ARMY_SUPPLY_RATIO_SPEED_GAIN_PER_HOUR = 0.01
NDefines.NSupply.ARMY_MAX_SUPPLY_RATIO_GAIN_PER_HOUR = 0.15

NDefines.NSupply.MIN_SURRENDER_LIMIT_TO_MOVE_SUPPLY_CAPITAL = 0.15 -- country needs to be above thos surrender ratio to be able to move its capital
NDefines.NSupply.COOLDOWN_DAYS_AFTER_MOVING_SUPPLY_CAPITAL = 30 -- cooldown for moving supply again after last move
NDefines.NSupply.DAYS_TO_START_GIVING_SUPPLY_AFTER_MOVING_SUPPLY_CAPITAL = 7  -- the country will start gaining supply after this many days moving its capital
NDefines.NSupply.DAYS_TO_START_GIVING_FULL_SUPPLY_AFTER_MOVING_SUPPLY_CAPITAL =  21 -- the country will reach max supply after this many days moving its capital

NDefines.NSupply.MIN_DIFF_FOR_AUTO_UPDATING_EXISTING_RAILWAYS = 5 -- while building railways, the system will prefer updating existing railway if new railway is close enough to existing one

-- reinforcements depends on distance to capital and following defines are used for calculating reinforcement time
NDefines.NSupply.SUPPLY_PATH_MAX_DISTANCE = 15	-- max time it can take
NDefines.NSupply.RAILWAY_DISTANCE_FACTOR_FOR_REINFORCEMENT_SPEED = 0.3 -- time factor for total railway distance
NDefines.NSupply.TRUCK_DISTANCE_FACTOR_FOR_REINFORCEMENT_SPEED = 0.01 -- time factor for total truck distance
NDefines.NSupply.NAVAL_DISTANCE_FACTOR_FOR_REINFORCEMENT_SPEED = 0.08 -- time factor for total naval distance

NDefines.NSupply.ALERT_VERY_LOW_SUPPLY_LEVEL = 0.3			   -- At which point we show up the low and very low supply level alert. Value is in % of supplies supported vs required.
NDefines.NSupply.ALERT_LOW_SUPPLY_LEVEL = 0.6

NDefines.NSupply.AI_FRONT_MINIMUM_UNITS_PER_PROVINCE_FOR_SUPPLY_CALCULATIONS = 1    -- AI will try to keep this amount of divisions per province as a minimum when evaluating supply limitations for war fronts
NDefines.NSupply.AI_FRONT_DIVISIONS_PER_SUPPLY_POINT = 0.35 -- How many divisions should the AI consider it can supply per available supply point
NDefines.NSupply.AI_FRONT_MAX_UNITS_ENEMY_COUNT_FACTOR = 1.2 -- Make sure AI front MaxNrUnits is at least EnemyCount multiplied by this factor
NDefines.NSupply.SUPPLY_THRESHOLD_FOR_ARMY_ATTRITION = 0.35 -- armies will only get attrition below this supply
NDefines.NSupply.NUMBER_OF_SHOWN_SUPPLY_SOURCES_IN_SUPPLY_MAPMODE = 3 -- number of supply flow sources shown in breakdown tooltip
NDefines.NSupply.ESTIMATED_DIVISION_WEIGHT_FOR_SUPPLY_ESTIMATIONS_GUI = 1.0	--Division supply consumption used for estimating frontline weight for order tooltips
NDefines.NSupply.STORED_SUPPLY_CONSUMPTION_RATE_FACTOR = 0.75				--Multiplies consumption rate of stored supply (more/less easement)
