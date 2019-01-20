# EveOnlineMiningYield
This is a followup to a [reddit post](https://www.reddit.com/r/Eve/comments/5bp0sm/mining_yield_with_the_november_update/) which shows the comparison of the different combinations of mining ships and boost.

Meanwhile the game displays the outcome of mining yield in the hover information of the mining laser. For example when a hulk with is boosted to the maximum possible value it displays a 37.8m3/s value on its mining laser see this example screenshot: 

![in-game-mining-yield](HulkMaxBoost.jpg)

This table shows the different outcome of mining yield with the different ships and boost types with all skills set to 5.

|Ship|no Boost|Porpise Boot|Orca Boost|Rorqual Boost|Rorqual ICT1 Boost|Rorqual ICT2 Boost|
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
	my $Industrial_Command_Ship_Skill  = 5;
	my $Mining_Director_Skill          = 5;
	my $Capital_Industrial_Ships_Skill = 5;
	my $Mining_Barge_Skill             = 5;
	my $Exhumer_Skill                  = 5;

	# factors 
	my $Mining_Foreman_Mindlink_bonus_1  = (1+0.25);
	my $Mining_Laser_optimization_base_1 = 0.15;
	my $Tech_2_Command_Burst_Modules_1   = (1+0.25);
	my $T1_Industrial_Core               = (1+0.25);
	my $T2_Industrial_Core               = (1+0.30);
	my $Highwall_Mining_MX1005_Implant   = (1+0.05);
	my $mining_upgrades_x3               = (1+0.295);
	my $mining_upgrades_x2               = (1+0.189);

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

	printf("%3.2f", $mining_yield_per_second);
```
