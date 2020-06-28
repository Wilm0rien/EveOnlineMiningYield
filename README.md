# EveOnlineMiningYield
This is a followup to a [reddit post](https://www.reddit.com/r/Eve/comments/5bp0sm/mining_yield_with_the_november_update/) which shows the comparison of the different combinations of mining ships and boost.

This page is currently limited to ore yields (except Mercoxit) but will be extended to ice and gas.

# Ore Mining Yield

## Mining Ship Yields
The game displays the outcome of mining yield in the hover information of the mining laser. For example when a hulk with is boosted to the maximum possible value it displays a 37.8m3/s value on its mining laser see this example screenshot: 

![in-game-mining-yield](HulkMaxBoost.jpg)

This table shows the different outcome of mining yield with the different ships and boost types with all skills set to 5.


All numbers in m3/s per mining laser (ingame values listed for proving the numbers to be correct)

|Ship|No Boost|Porpise Boot|Orca Boost|Rorqual Boost|Rorqual ICT1 Boost|Rorqual ICT2 Boost|
|:-|:-|:-|:-|:-|:-|:-|
|     Venture|    4.47|    7.29|    7.50|    7.98|   10.43|   11.11|
|   Endurance|   10.62|   17.32|   17.83|   18.95|   24.78|   26.40|
|    Prospect|    7.24|   11.80|   12.15|   12.91|   16.88|   17.99|
|    Procurer|    9.48|   15.46|   15.92|   16.92|   22.12|   23.57|
|   Retriever|   10.33|   16.84|   17.34|   18.42|   24.09|   25.67|
|     Covetor|   13.77|   22.45|   23.12|   24.57|   32.12|   34.23|
|       Skiff|   11.48|   18.71|   19.26|   20.47|   26.77|   28.52|
|    Mackinaw|   11.48|   18.71|   19.26|   20.47|   26.77|   28.52|
|        Hulk|   16.20|   26.42|   27.20|   28.90|   37.79|   40.27|

All numbers in m3/s per ship (yield multiplied with number of turrets)

|Ship|No Boost|Porpise Boot|Orca Boost|Rorqual Boost|Rorqual ICT1 Boost|Rorqual ICT2 Boost|
|:-|:-|:-|:-|:-|:-|:-|
|     Venture|    8.94|   14.58|   15.01|   15.95|   20.86|   22.22|
|   Endurance|   10.62|   17.32|   17.83|   18.95|   24.78|   26.40|
|    Prospect|   14.47|   23.60|   24.30|   25.82|   33.76|   35.98|
|    Procurer|   18.97|   30.92|   31.84|   33.83|   44.24|   47.14|
|   Retriever|   20.66|   33.68|   34.67|   36.85|   48.18|   51.34|
|     Covetor|   27.54|   44.91|   46.23|   49.13|   64.24|   68.45|
|       Skiff|   22.95|   37.42|   38.53|   40.94|   53.53|   57.04|
|    Mackinaw|   22.95|   37.42|   38.53|   40.94|   53.53|   57.04|
|        Hulk|   32.40|   52.83|   54.39|   57.80|   75.58|   80.53|

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
	my $T2_Industrial_Core               = (1+0.36);
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

	printf("%3.2f", $mining_yield_per_second); # prints 40.27
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

|Ship|Fitting Note|
|:-|:-|
|Venture|Can only operate two drones.|
|Prospect|Does not have a Drone Bay|
|Endurance|2 x Mining Drone Augmentor II + three harvester drones and five of all other drone types.|
|Covetor+Retreiver|1 x Mining Drone Augmentor II and 1 x Mining Drone Augmentor I|
|Procurer|2 x Mining Drone Augmentor II and 1 x Mining Drone Augmentor I|
|Skiff+Mack+Hulk|2 x Mining Drone Augmentor II|

Note2: the Mining Drone I and Harvester Mining Drone do not get a bonus from the Mining Drone Specialization Skill

All numbers in m3 per 60s cycle per drone (ingame values listed for proving the numbers to be correct)

|Ship|Mining Drone I|Mining Drone II|Augmented Mining Drone|Harvester Mining Drone|Excavator Mining Drone|
|:-|:-|:-|:-|:-|:-|
|     Venture|   68.19|   99.01|  111.02|  114.56|     N/A|
|   Endurance|   61.99|   90.01|  100.92|  104.15|     N/A|
|    Prospect|     N/A|     N/A|     N/A|     N/A|     N/A|
|    Procurer|   68.19|   99.01|  111.02|  114.56|     N/A|
|   Retriever|   59.30|   86.10|   96.54|   99.62|     N/A|
|     Covetor|   59.30|   86.10|   96.54|   99.62|     N/A|
|       Skiff|   61.99|   90.01|  100.92|  104.15|     N/A|
|    Mackinaw|   61.99|   90.01|  100.92|  104.15|     N/A|
|        Hulk|   61.99|   90.01|  100.92|  104.15|     N/A|
|    Porpoise|  153.43|  222.78|  249.79|  257.76|     N/A|
|        Orca|  204.57|  297.04|  333.05|  343.68|     N/A|
|     Rorqual|  102.29|  148.52|  166.52|  171.84|  360.05|
|Rorqual ICT1|  511.44|  742.60|  832.62|  859.21| 1800.25|
|Rorqual ICT2|  613.72|  891.13|  999.14| 1031.05| 2160.30|


[eXistence_42](https://www.reddit.com/user/eXistence_42) [requested](https://www.reddit.com/r/Eve/comments/ai2oy4/eveonlineminingyield_calculation_only_for_ore/eekm9bu) the mining yield for the drones to be comparable to the ship yield numbers. For this purpose the yield value is multiplied by the number of drones (2 for the venture and 5 for other ships) and divided by the 60s cycle duration. Note that it leaves out the travel time between the drones and the ship, so the real numbers will be lower than listed here.

All numbers in m3/s per ship with max drones (converted values for better comparability)

|Ship|Mining Drone I|Mining Drone II|Augmented Mining Drone|Harvester Mining Drone|Excavator Mining Drone|
|:-|:-|:-|:-|:-|:-|
|     Venture|    2.27|    3.30|    3.70|    3.82|     N/A|
|   Endurance|    5.17|    7.50|    8.41|    5.21|     N/A|
|    Prospect|     N/A|     N/A|     N/A|     N/A|     N/A|
|    Procurer|    5.68|    8.25|    9.25|    9.55|     N/A|
|   Retriever|    4.94|    7.17|    8.04|    8.30|     N/A|
|     Covetor|    4.94|    7.17|    8.04|    8.30|     N/A|
|       Skiff|    5.17|    7.50|    8.41|    8.68|     N/A|
|    Mackinaw|    5.17|    7.50|    8.41|    8.68|     N/A|
|        Hulk|    5.17|    7.50|    8.41|    8.68|     N/A|
|    Porpoise|   12.79|   18.57|   20.82|   21.48|     N/A|
|        Orca|   17.05|   24.75|   27.75|   28.64|     N/A|
|     Rorqual|    8.52|   12.38|   13.88|   14.32|   30.00|
|Rorqual ICT1|   42.62|   61.88|   69.38|   71.60|  150.02|
|Rorqual ICT2|   51.14|   74.26|   83.26|   85.92|  180.03|

## Code
The code to generate these tables is [here](EveOnlineMiningYield.pl)

# Ice Mining Yield

All numbers in m3/s per ice harvester (ingame values listed for proving the numbers to be correct)

![ice-in-game-mining-yield](HulkMaxBoostIce.jpg)

|Ship|No Boost|Porpise Boot|Orca Boost|Rorqual Boost|Rorqual ICT1 Boost|Rorqual ICT2 Boost|
|:-|:-|:-|:-|:-|:-|:-|
|     Venture|     N/A|     N/A|     N/A|     N/A|     N/A|     N/A|
|   Endurance|   20.07|   32.72|   33.69|   35.80|   46.81|   49.88|
|    Prospect|    6.20|   10.11|   10.41|   11.06|   14.47|   15.41|
|    Procurer|   10.70|   17.45|   17.96|   19.09|   24.96|   26.59|
|   Retriever|   11.76|   19.17|   19.74|   20.98|   27.43|   29.22|
|     Covetor|   15.68|   25.56|   26.32|   27.97|   36.57|   38.97|
|       Skiff|   13.06|   21.30|   21.93|   23.31|   30.47|   32.47|
|    Mackinaw|   13.06|   21.30|   21.93|   23.31|   30.47|   32.47|
|        Hulk|   18.44|   30.07|   30.96|   32.90|   43.02|   45.84|

All numbers in m3/s per ship (yield multiplied with number of turrets)

|Ship|No Boost|Porpise Boot|Orca Boost|Rorqual Boost|Rorqual ICT1 Boost|Rorqual ICT2 Boost|
|:-|:-|:-|:-|:-|:-|:-|
|     Venture|     N/A|     N/A|     N/A|     N/A|     N/A|     N/A|
|   Endurance|   20.07|   32.72|   33.69|   35.80|   46.81|   49.88|
|    Prospect|   12.40|   20.23|   20.82|   22.13|   28.93|   30.83|
|    Procurer|   21.40|   34.89|   35.92|   38.18|   49.92|   53.19|
|   Retriever|   23.52|   38.34|   39.48|   41.95|   54.85|   58.45|
|     Covetor|   31.35|   51.13|   52.64|   55.94|   73.14|   77.93|
|       Skiff|   26.13|   42.61|   43.86|   46.61|   60.95|   64.94|
|    Mackinaw|   26.13|   42.61|   43.86|   46.61|   60.95|   64.94|
|        Hulk|   36.89|   60.15|   61.92|   65.81|   86.04|   91.68|

# Gas Mining Yield
*To be done*

# COPYRIGHT NOTICE
EVE Online and the EVE logo are the registered trademarks of CCP hf. All rights are reserved worldwide. All other trademarks are the property of their respective owners. EVE Online, the EVE logo, EVE and all associated logos and designs are the intellectual property of CCP hf. All artwork, screenshots, characters, vehicles, storylines, world facts or other recognizable features of the intellectual property relating to these trademarks are likewise the intellectual property of CCP hf. CCP hf. has granted permission to EveOnlineMiningYield to use EVE Online and all associated logos and designs for promotional and information purposes on its website but does not endorse, and is not in any way affiliated with, EveOnlineMiningYield. CCP is in no way responsible for the content on or functioning of this website, nor can it be liable for any damage arising from the use of this website.
