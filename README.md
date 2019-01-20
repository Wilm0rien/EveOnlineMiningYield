# EveOnlineMiningYield
This is a followup to a [reddit post](https://www.reddit.com/r/Eve/comments/5bp0sm/mining_yield_with_the_november_update/) which shows the comparison of the different combinations of mining ships and boost.

## Mining Ship Yields
Meanwhile the game displays the outcome of mining yield in the hover information of the mining laser. For example when a hulk with is boosted to the maximum possible value it displays a 37.8m3/s value on its mining laser see this example screenshot: 

![in-game-mining-yield](HulkMaxBoost.jpg)

This table shows the different outcome of mining yield with the different ships and boost types with all skills set to 5.

|Ship|No Boost|Porpise Boot|Orca Boost|Rorqual Boost|Rorqual ICT1 Boost|Rorqual ICT2 Boost|
|:-|:-|:-|:-|:-|:-|:-|
|     Venture|    4.26|    6.94|    7.15|    7.60|    9.45|    9.93|
|    Procurer|    9.48|   15.46|   15.92|   16.92|   21.04|   22.12|
|   Retriever|   10.33|   16.84|   17.34|   18.42|   22.92|   24.09|
|     Covetor|   13.77|   22.45|   23.12|   24.57|   30.55|   32.12|
|       Skiff|   11.48|   18.71|   19.26|   20.47|   25.46|   26.77|
|    Mackinaw|   11.48|   18.71|   19.26|   20.47|   25.46|   26.77|
|        Hulk|   16.20|   26.42|   27.20|   28.90|   35.95|   37.79|

The formular behind this table is calculated as followed:

```perl
	# skills 
	my $Mining_Skill                   = 5;
	my $Astrogeology_Skill             = 5;
	my $Mining_Director_Skill          = 5;
	my $Capital_Industrial_Ships_Skill = 5;
	my $Mining_Barge_Skill             = 5;
	my $Exhumer_Skill                  = 5;

	# factors 
	my $Mining_Foreman_Mindlink_bonus_1  = (1+0.25);
	my $Mining_Laser_optimization_base_1 = 0.15;
	my $Tech_2_Command_Burst_Modules_1   = (1+0.25);
	my $T2_Industrial_Core               = (1+0.30);
	my $Highwall_Mining_MX1005_Implant   = (1+0.05);
	my $mining_upgrades_x3               = (1+0.295);

	# Minig Crystal II Attribute
	my $Asteroid_Specialization_Yield_Modifier =  1.75;

	# Modulated Strip Miner II Attribute
	my $Strip_Miner_II_Mining_Amount = 450;
	my $Strip_Miner_II_Cycle_Time    = 180;

	my $rorqual_boost_t2 = $Mining_Laser_optimization_base_1
		* $Tech_2_Command_Burst_Modules_1
		* $T2_Industrial_Core
		* (1+0.1 * $Mining_Director_Skill)
		* $Mining_Foreman_Mindlink_bonus_1
		* (1+0.05*$Capital_Industrial_Ships_Skill) ;
	
	my $boost_factor = (1- $rorqual_boost_t2);

	my $hulk_base_yield =  $Strip_Miner_II_Mining_Amount 
		* $Asteroid_Specialization_Yield_Modifier
		* (1+0.05*$Mining_Skill) 
		* (1+0.05*$Astrogeology_Skill)
		* $Highwall_Mining_MX1005_Implant
		* $mining_upgrades_x3;

	my $hulk_base_time =    $Strip_Miner_II_Cycle_Time 
		* (1-0.02*$Mining_Barge_Skill)
		* (1-0.03*$Exhumer_Skill)
		* (1-0.25)  # role bonus
		* $boost_factor;

	my $mining_yield_per_second = $hulk_base_yield / $hulk_base_time;

	printf("%3.2f", $mining_yield_per_second); # prints 37.79
```
## Mining Drone Yields
The Mining amount of ore collected via drones is listed in the attributes section of the info window for each drone.

In this example it is 2651.28 m3

![in-game-drone-yield](ExcavatorDroneMaxBoost.jpg)

This value is calculated as followed:
```perl
	# skills 
	my $Drone_Interfacing_Skill           = 5;
	my $Mining_Drone_Operation_Skill      = 5;
	my $Mining_Drone_Specialization_Skill = 4; # example value not maxed.
	my $Industrial_Command_Ships_Skill    = 5;

	# Excavator Mining Drone base yield
	my $drone_base = 100;
	my $drone_yield_per_second = $drone_base
		* (1 + 0.1 * $Industrial_Command_Ships_Skill)
		* (1 + 0.1 * $Drone_Interfacing_Skill)
		* (1 + 0.05 * $Mining_Drone_Operation_Skill)
		* (1 + 0.02 * $Mining_Drone_Specialization_Skill)
		* (1 + 0.15 ) # medium mining drone augmentor II
		* (1 + 0.15 ) # medium mining drone augmentor II
		* (1 + 0.10 ) # medium mining drone augmentor I
		* (1 + 5.00 ); # 500% ic2 bonus

	printf("%3.2f", $drone_yield_per_second); # prints 2651.28
```

The outcome for all kinds of mining drones is this. 
Note that that the venture can only operate two drones while all other ships run up to five drones.

|Ship|Mining Drone I|Mining Drone II|Augmented Mining Drone|Harvester Mining Drone|Excavator Mining Drone|
|:-|:-|:-|:-|:-|:-|
|     Venture|   75.01|   99.01|  111.02|  126.02|     N/A|
|    Procurer|   75.01|   99.01|  111.02|  126.02|     N/A|
|   Retriever|   75.01|   99.01|  111.02|  126.02|     N/A|
|     Covetor|   75.01|   99.01|  111.02|  126.02|     N/A|
|       Skiff|   68.19|   90.01|  100.92|  114.56|     N/A|
|    Mackinaw|   68.19|   90.01|  100.92|  114.56|     N/A|
|        Hulk|   68.19|   90.01|  100.92|  114.56|     N/A|
|    Porpoise|  168.77|  222.78|  249.79|  283.54|     N/A|
|        Orca|  225.03|  297.04|  333.05|  378.05|     N/A|
|     Rorqual|  112.52|  148.52|  166.52|  189.03|  450.06|
|Rorqual ICT1|  562.58|  742.60|  832.62|  945.13| 2250.32|
|Rorqual ICT2|  675.09|  891.13|  999.14| 1134.16| 2700.38|
