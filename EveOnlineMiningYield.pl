use strict;

my @ship_list = ("Venture","Endurance","Prospect", "Procurer", "Retriever", "Covetor", "Skiff", "Mackinaw", "Hulk", "Porpoise", "Orca", "Rorqual", "Rorqual ICT1", "Rorqual ICT2");

my @ore_drone_list = ("Mining Drone I", "Mining Drone II", "Augmented Mining Drone", "Harvester Mining Drone", "Excavator Mining Drone");
my @ice_drone_list = ("Ice Harvesting Drone I", "Ice Harvesting Drone II", "Augmented Ice Harvesting Drone", "Excavator Ice Harvesting Drone");

my @boost_list = ("no Boost", "Porpise Boot", "Orca Boost", "Rorqual Boost", "Rorqual ICT1 Boost", "Rorqual ICT2 Boost");

# ORE
print "\nORE in_game_value\n";
print_ship_table("ORE", "in_game_value");
print "\nORE m3_per_second\n";
print_ship_table("ORE", "m3_per_second");
print "\nORE DRONE in_game_value\n";
print_drone_table("ORE", "in_game_value");
print "\nORE DRONE m3_per_second\n";
print_drone_table("ORE", "m3_per_second");

# ICE
print "\nICE in_game_value\n";
print_ship_table("ICE", "in_game_value");
print "\nICE m3_per_second\n";
print_ship_table("ICE", "m3_per_second");
print "\nICE DRONE in_game_value\n";
print_drone_table("ICE", "in_game_value");
print "\nICE DRONE m3_per_second\n";
print_drone_table("ICE", "m3_per_second");
#

sub print_ship_table
{
	my $mining_type = $_[0];
	my $yield_type = $_[1];
	my $headline_string = "|Ship";
	my $column_separator = "|:-";
	foreach my $boost_type (@boost_list)
	{
		$headline_string.= sprintf("|%s", $boost_type);
		$column_separator.="|:-";
	}
	printf("%s|\n", $headline_string);
	printf("%s|\n", $column_separator);

	foreach my $ship (@ship_list)
	{
		my $out_string = "";
		$out_string.= sprintf("|%12.12s", $ship);
		foreach my $boost_type (@boost_list)
		{
			if ($mining_type eq "ORE")
			{
				$out_string.= sprintf("|%s",  get_ore_mining_amount($boost_type, $yield_type, $ship));
			}
			elsif ($mining_type eq "ICE")
			{
				$out_string.= sprintf("|%s",  get_ice_mining_amount($boost_type, $yield_type, $ship));
			}
		}
		$out_string.="|\n";
		printf($out_string);
	}
}

sub print_drone_table
{
	my $mining_type = $_[0];
	my $yield_type = $_[1];
	my $headline_string = "|Ship";
	my $column_separator = "|:-";

	my @drone_list;
	if ($mining_type eq "ORE")
	{
		@drone_list = @ore_drone_list;
	}
	elsif ($mining_type eq "ICE")
	{
		@drone_list = @ice_drone_list;
	}

	foreach my $drone_type (@drone_list)
	{
		$headline_string.= sprintf("|%s", $drone_type);
		$column_separator.="|:-";
	}

	printf("%s|\n", $headline_string);
	printf("%s|\n", $column_separator);
	foreach my $ship (@ship_list)
	{
		my $out_string = "";
		$out_string.= sprintf("|%12.12s", $ship);

		foreach my $drone_type (@drone_list)
		{
			if ($mining_type eq "ORE")
			{
				$out_string.= sprintf("|%s",  get_ore_drone_amount($drone_type, $yield_type , $ship));
			}
			elsif ($mining_type eq "ICE")
			{
				$out_string.= sprintf("|%s",  get_ice_drone_amount($drone_type, $yield_type , $ship));
			}
		}
		$out_string.="|\n";
		printf($out_string);
	}
}

sub get_boost_factor
{
	my $boost_type              = $_[0];
	my $boost_factor = 0;

	# boost skills
	my $Industrial_Command_Ship_Skill  = 5;
	my $Mining_Director_Skill          = 5;
	my $Capital_Industrial_Ships_Skill = 5;

	# boost factors
	my $Mining_Foreman_Mindlink_bonus_1  = (1+0.25);
	my $Tech_2_Command_Burst_Modules_1   = (1+0.25);
	my $T1_Industrial_Core               = (1+0.30);
	my $T2_Industrial_Core               = (1+0.36);
	my $Mining_Laser_optimization_base_1 = 0.15;

	# caluclate boost factors
	if ($boost_type eq "no Boost")
	{
		$boost_factor = 1;
	}
	elsif ($boost_type eq "Porpise Boot")
	{
		my $porpoise_boost = $Mining_Laser_optimization_base_1
			* $Tech_2_Command_Burst_Modules_1
			* (1+0.1 * $Mining_Director_Skill)
			* $Mining_Foreman_Mindlink_bonus_1
			* (1+0.02*$Industrial_Command_Ship_Skill) ;
		$boost_factor = (1- $porpoise_boost)
	}
	elsif ($boost_type eq "Orca Boost")
	{
		my $orca_boost = $Mining_Laser_optimization_base_1
			* $Tech_2_Command_Burst_Modules_1
			* (1+0.1 * $Mining_Director_Skill)
			* $Mining_Foreman_Mindlink_bonus_1
			* (1+0.03*$Industrial_Command_Ship_Skill) ;
		$boost_factor = (1- $orca_boost);
	}
	elsif ($boost_type eq "Rorqual Boost")
	{
		my $rorqual_boost_nocore = $Mining_Laser_optimization_base_1
			* $Tech_2_Command_Burst_Modules_1
			* 1 # no industrial core active 
			* (1+0.1 * $Mining_Director_Skill)
			* $Mining_Foreman_Mindlink_bonus_1
			* (1+0.05*$Capital_Industrial_Ships_Skill) ;
		$boost_factor = (1- $rorqual_boost_nocore);
	}
	elsif ($boost_type eq "Rorqual ICT1 Boost")
	{
		my $rorqual_boost_t1 = $Mining_Laser_optimization_base_1
			* $Tech_2_Command_Burst_Modules_1
			* $T1_Industrial_Core
			* (1+0.1 * $Mining_Director_Skill)
			* $Mining_Foreman_Mindlink_bonus_1
			* (1+0.05*$Capital_Industrial_Ships_Skill) ;
		$boost_factor = (1- $rorqual_boost_t1);
	}
	elsif ($boost_type eq "Rorqual ICT2 Boost")
	{
		my $rorqual_boost_t2 = $Mining_Laser_optimization_base_1
			* $Tech_2_Command_Burst_Modules_1
			* $T2_Industrial_Core
			* (1+0.1 * $Mining_Director_Skill)
			* $Mining_Foreman_Mindlink_bonus_1
			* (1+0.05*$Capital_Industrial_Ships_Skill) ;
		$boost_factor = (1- $rorqual_boost_t2);
	}

	return $boost_factor;
}

sub get_ore_mining_amount
{
	my $boost_type              = $_[0];
	my $yield_type              = $_[1];
	my $ship_type               = $_[2];

	my $mining_yield_per_second = 0;

	# skills 
	my $Mining_Skill                   = 5;
	my $Astrogeology_Skill             = 5;
	my $Mining_Barge_Skill             = 5;
	my $Exhumer_Skill                  = 5;
	my $Mining_Frigate_Skill          = 5; 
	my $Expedition_Frigates_Skill     = 5;

	# factors 
	my $Highwall_Mining_MX1005_Implant   = (1+0.05);
	my $mining_upgrades_x3               = (1+0.295);
	my $mining_upgrades_x2               = (1+0.189);
	my $mining_upgrades_x4               = (1+0.4116);

	# Modulated Strip Miner II Attribute
	my $Strip_Miner_II_Mining_Amount = 450;
	my $Strip_Miner_II_Cycle_Time    = 180;

	# Minig Crystal II Attribute
	my $Asteroid_Specialization_Yield_Modifier =  1.75;

	# Modulated Deep Core Miner II Attributes
	my $ModulatedDeepCoreMinerII_cycle  = 180;
	my $ModulatedDeepCoreMinerII_amount = 120;


	my $mining_upgrades_x1 = (1+0.09);

	my $boost_factor = get_boost_factor($boost_type);

	my $turret_factor = 2; # number of turrents on the ship

	if  ($ship_type eq "Venture")
	{
		my $Venture_Role_Bonus = 1.00;

		my $venture_base_yield =  
			$ModulatedDeepCoreMinerII_amount 
		  * $Asteroid_Specialization_Yield_Modifier
		  * (1+0.05*$Mining_Frigate_Skill)       # regular skill bonus
		  * (1+0.05*$Mining_Skill)       # regular skill bonus
		  * (1+0.05*$Astrogeology_Skill) # regular skill bonus
		  * (1+$Venture_Role_Bonus)      # role bonus
		  * $Highwall_Mining_MX1005_Implant
		  * $mining_upgrades_x1
		;

		my $venture_base_time = ($ModulatedDeepCoreMinerII_cycle * $boost_factor);


		if ($venture_base_time > 0 )
		{
			$mining_yield_per_second = $venture_base_yield / $venture_base_time ;
		}
	}
	elsif  ($ship_type eq "Endurance")
	{
		my $Endurance_Role_Bonus = 3.00;

		my $endurance_base_yield =  
			$ModulatedDeepCoreMinerII_amount
		  * $Asteroid_Specialization_Yield_Modifier
		  * (1+0.05*$Mining_Frigate_Skill)       # regular skill bonus
		  * (1+0.05*$Mining_Skill)       # regular skill bonus
		  * (1+0.05*$Astrogeology_Skill) # regular skill bonus
		  * (1+$Endurance_Role_Bonus)      # role bonus
		  * $mining_upgrades_x1
		  * $mining_upgrades_x1
		  * $mining_upgrades_x1
		  * $Highwall_Mining_MX1005_Implant
		;

		my $endurance_base_time = ($ModulatedDeepCoreMinerII_cycle * $boost_factor);

		if ($endurance_base_time > 0 )
		{
			$mining_yield_per_second = $endurance_base_yield / $endurance_base_time ;
		}

		$turret_factor = 1; # only one turrent allowed on the endurance
	}
	elsif  ($ship_type eq "Prospect")
	{
		my $Prospect_Role_Bonus = 1.00;

		my $prospect_base_yield =  
			$ModulatedDeepCoreMinerII_amount 
		  * $Asteroid_Specialization_Yield_Modifier
		  * (1+0.05*$Mining_Frigate_Skill)       # regular skill bonus
		  * (1+0.05*$Expedition_Frigates_Skill)       # regular skill bonus
		  * (1+0.05*$Mining_Skill)       # regular skill bonus
		  * (1+0.05*$Astrogeology_Skill) # regular skill bonus
		  * (1+$Prospect_Role_Bonus)      # role bonus
		  * $Highwall_Mining_MX1005_Implant
		  * $mining_upgrades_x1
		  * $mining_upgrades_x1
		  * $mining_upgrades_x1
		  * $mining_upgrades_x1
		;

		my $prospect_base_time = ($ModulatedDeepCoreMinerII_cycle * $boost_factor);


		if ($prospect_base_time > 0 )
		{
			$mining_yield_per_second = $prospect_base_yield / $prospect_base_time ;
		}
	}
	elsif  ($ship_type eq "Procurer")
	{
		my $proc_base_yield =   $Strip_Miner_II_Mining_Amount 
			* $Asteroid_Specialization_Yield_Modifier
			* (1+0.05*$Mining_Skill) 
			* (1+0.05*$Astrogeology_Skill)
			* $Highwall_Mining_MX1005_Implant
			* $mining_upgrades_x2;

		my $proc_base_time = 	$Strip_Miner_II_Cycle_Time 
								* (1-0.02*$Mining_Barge_Skill)
								* $boost_factor;

		$mining_yield_per_second = $proc_base_yield / $proc_base_time;
	}
	elsif  ($ship_type eq "Retriever")
	{
		my $retriever_base_time = 	$Strip_Miner_II_Cycle_Time 
								* (1-0.02*$Mining_Barge_Skill)
								* $boost_factor;

		my $retriever_base_yield =  $Strip_Miner_II_Mining_Amount 
			* $Asteroid_Specialization_Yield_Modifier
			* (1+0.05*$Mining_Skill) 
			* (1+0.05*$Astrogeology_Skill)
			* $Highwall_Mining_MX1005_Implant
			* $mining_upgrades_x3;

		$mining_yield_per_second = $retriever_base_yield / $retriever_base_time;
	}
	elsif  ($ship_type eq "Covetor")
	{
		my $covetor_role_bonus = (1-0.25);

		my $covetor_base_time =     $Strip_Miner_II_Cycle_Time 
			* (1-0.02*$Mining_Barge_Skill)
			* $covetor_role_bonus
			* $boost_factor;

		my $covetor_base_yield = $Strip_Miner_II_Mining_Amount 
			* $Asteroid_Specialization_Yield_Modifier
			* (1+0.05*$Mining_Skill) 
			* (1+0.05*$Astrogeology_Skill)
			* $Highwall_Mining_MX1005_Implant
			* $mining_upgrades_x3;

		$mining_yield_per_second = $covetor_base_yield / $covetor_base_time;
	}
	elsif  ($ship_type eq "Skiff")
	{
		my $skiff_base_yield =  $Strip_Miner_II_Mining_Amount 
			* $Asteroid_Specialization_Yield_Modifier
			* (1+0.05*$Mining_Skill) 
			* (1+0.05*$Astrogeology_Skill)
			* $Highwall_Mining_MX1005_Implant
			* $mining_upgrades_x3;

		my $skiff_base_time =    $Strip_Miner_II_Cycle_Time 
			* (1-0.02*$Mining_Barge_Skill)
			* (1-0.02*$Exhumer_Skill)
			* $boost_factor;

		$mining_yield_per_second = $skiff_base_yield / $skiff_base_time;
	}
	elsif  ($ship_type eq "Mackinaw")
	{
		my $mackinaw_base_yield =  $Strip_Miner_II_Mining_Amount 
			* $Asteroid_Specialization_Yield_Modifier
			* (1+0.05*$Mining_Skill) 
			* (1+0.05*$Astrogeology_Skill)
			* $Highwall_Mining_MX1005_Implant
			* $mining_upgrades_x3;

		my $mackinaw_base_time =    $Strip_Miner_II_Cycle_Time 
			* (1-0.02*$Mining_Barge_Skill)
			* (1-0.02*$Exhumer_Skill)
			* $boost_factor;

		$mining_yield_per_second = $mackinaw_base_yield / $mackinaw_base_time;
	}
	elsif  ($ship_type eq "Hulk")
	{
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

		$mining_yield_per_second = $hulk_base_yield / $hulk_base_time;
	}



	my $out_string = "";
	if ( $mining_yield_per_second == 0)
	{
		 $out_string =  sprintf("%8.8s", "N/A");
	}
	else
	{
		if ($yield_type eq "in_game_value")
		{
			$out_string =sprintf("% 8.2f", $mining_yield_per_second  );
		}
		elsif ($yield_type eq "m3_per_second")
		{
			$out_string =sprintf("% 8.2f", $mining_yield_per_second  * $turret_factor);
		}
		else
		{
			$out_string =sprintf("ERROR");
		}
	}
	return $out_string;
}


sub get_ice_mining_amount
{
	my $boost_type              = $_[0];
	my $yield_type              = $_[1];
	my $ship_type               = $_[2];

	my $Ice_Harvester_Cycle_Time = 0;

	my $Mining_Skill                   = 5;
	my $Astrogeology_Skill             = 5;
	my $Mining_Barge_Skill             = 5;
	my $Exhumer_Skill                  = 5;
	my $Ice_Harvesting_Skill           = 5;

	my $Mining_Frigate_Skill             = 5;
	my $Expedition_Frigates_Skill             = 5;

	# factors
	my $Ice_Harvester_II_Base_Duration = 200;
	my $Ice_Mining_Laser_II_Base_Duration = 330;
	my $Ice_Harvester_Upgrade_II       = 0.09;
	my $Yeti_Harvesting_IH_1005_Implant = 0.05;
	
	my $boost_factor = get_boost_factor($boost_type);

	my $turret_factor = 2; # number of turrents on the ship

	if  ($ship_type eq "Venture")
	{
		# cannot fit ice mining lasers
	}
	elsif ($ship_type eq "Endurance")
	{
		$Ice_Harvester_Cycle_Time = $Ice_Mining_Laser_II_Base_Duration
									* (1 - 0.5) # role bonus
									* (1 - 0.05 * $Mining_Frigate_Skill )
									* (1 - 0.05 * $Expedition_Frigates_Skill ) 
									* (1 - 0.05 * $Ice_Harvesting_Skill )
									* (1 - $Ice_Harvester_Upgrade_II ) 
									* (1 - $Ice_Harvester_Upgrade_II) 
									* (1 - $Ice_Harvester_Upgrade_II ) 
									* (1 - $Yeti_Harvesting_IH_1005_Implant) 
									* $boost_factor;

		$turret_factor = 1; # only one turrent allowed on the endurance
	}
	elsif ($ship_type eq "Prospect")
	{
		$Ice_Harvester_Cycle_Time = $Ice_Mining_Laser_II_Base_Duration
									* (1 - 0.05 * $Ice_Harvesting_Skill )
									* (1 - $Ice_Harvester_Upgrade_II ) 
									* (1 - $Ice_Harvester_Upgrade_II) 
									* (1 - $Ice_Harvester_Upgrade_II ) 
									* (1 - $Ice_Harvester_Upgrade_II ) 
									* (1 - $Yeti_Harvesting_IH_1005_Implant) 
									* $boost_factor;

		#printf("cycle time: %3.2f\n", $Ice_Mining_Laser_II_Base_Duration);
		#printf("cycle time: %3.2f\n", $Ice_Harvester_Cycle_Time);
	}
	elsif  ($ship_type eq "Procurer")
	{
		$Ice_Harvester_Cycle_Time = $Ice_Harvester_II_Base_Duration
									* (1 - 0.02 * $Mining_Barge_Skill )
									* (1 - 0.05 * $Ice_Harvesting_Skill )
									* (1 - 0.12 ) # Medium Ice Harvesting Accelerator I
									* (1 - $Ice_Harvester_Upgrade_II ) 
									* (1 - $Ice_Harvester_Upgrade_II) 
									* (1 - $Yeti_Harvesting_IH_1005_Implant) 
									* $boost_factor;
	}
	elsif  ($ship_type eq "Retriever")
	{
		$Ice_Harvester_Cycle_Time = $Ice_Harvester_II_Base_Duration
									* (1 - 0.02 * $Mining_Barge_Skill )
									* (1 - 0.05 * $Ice_Harvesting_Skill )
									* (1 - 0.12 ) # Medium Ice Harvesting Accelerator I
									* (1 - $Ice_Harvester_Upgrade_II ) 
									* (1 - $Ice_Harvester_Upgrade_II) 
									* (1 - $Ice_Harvester_Upgrade_II) 
									* (1 - $Yeti_Harvesting_IH_1005_Implant) 
									* $boost_factor;
	}
	elsif  ($ship_type eq "Covetor")
	{
		$Ice_Harvester_Cycle_Time = $Ice_Harvester_II_Base_Duration
									* (1 - 0.25) # role bonus
									* (1 - 0.02 * $Mining_Barge_Skill )
									* (1 - 0.05 * $Ice_Harvesting_Skill )
									* (1 - 0.12 ) # Medium Ice Harvesting Accelerator I
									* (1 - $Ice_Harvester_Upgrade_II ) 
									* (1 - $Ice_Harvester_Upgrade_II) 
									* (1 - $Ice_Harvester_Upgrade_II) 
									* (1 - $Yeti_Harvesting_IH_1005_Implant) 
									* $boost_factor;
	}
	elsif  ($ship_type eq "Skiff")
	{
		$Ice_Harvester_Cycle_Time = $Ice_Harvester_II_Base_Duration
									* (1 - 0.02 * $Mining_Barge_Skill )
									* (1 - 0.02 * $Exhumer_Skill )
									* (1 - 0.05 * $Ice_Harvesting_Skill )
									* (1 - 0.12 ) # Medium Ice Harvesting Accelerator I
									* (1 - $Ice_Harvester_Upgrade_II ) 
									* (1 - $Ice_Harvester_Upgrade_II) 
									* (1 - $Ice_Harvester_Upgrade_II) 
									* (1 - $Yeti_Harvesting_IH_1005_Implant) 
									* $boost_factor;
	}
	elsif  ($ship_type eq "Mackinaw")
	{
		$Ice_Harvester_Cycle_Time = $Ice_Harvester_II_Base_Duration
									* (1 - 0.02 * $Mining_Barge_Skill )
									* (1 - 0.02 * $Exhumer_Skill )
									* (1 - 0.05 * $Ice_Harvesting_Skill )
									* (1 - 0.12 ) # Medium Ice Harvesting Accelerator I
									* (1 - $Ice_Harvester_Upgrade_II ) 
									* (1 - $Ice_Harvester_Upgrade_II) 
									* (1 - $Ice_Harvester_Upgrade_II) 
									* (1 - $Yeti_Harvesting_IH_1005_Implant) 
									* $boost_factor;
	}
	elsif  ($ship_type eq "Hulk")
	{
		$Ice_Harvester_Cycle_Time = $Ice_Harvester_II_Base_Duration
									* (1 - 0.25) # role bonus
									* (1 - 0.02 * $Mining_Barge_Skill )
									* (1 - 0.03 * $Exhumer_Skill )
									* (1 - 0.05 * $Ice_Harvesting_Skill )
									* (1 - 0.12 ) # Medium Ice Harvesting Accelerator I
									* (1 - $Ice_Harvester_Upgrade_II ) 
									* (1 - $Ice_Harvester_Upgrade_II) 
									* (1 - $Ice_Harvester_Upgrade_II) 
									* (1 - $Yeti_Harvesting_IH_1005_Implant) 
									* $boost_factor;
	}

	my $out_string = "";
	if ( $Ice_Harvester_Cycle_Time == 0)
	{
		 $out_string =  sprintf("%8.8s", "N/A");
	}
	else
	{
		if ($yield_type eq "in_game_value")
		{
			$out_string =sprintf("% 8.2f", 1000 / $Ice_Harvester_Cycle_Time );
		}
		elsif ($yield_type eq "m3_per_second")
		{
			$out_string =sprintf("% 8.2f", 1000 / $Ice_Harvester_Cycle_Time * $turret_factor );
		}
		else
		{
			$out_string =sprintf("ERROR");
		}
	}
	return $out_string;
}

sub get_ore_drone_amount
{
	my $drone_type = $_[0];
	my $yield_type = $_[1];
	my $ship_type = $_[2];
	my $drone_yield_per_second=0;
	my $drone_base = 0;
	my $number_of_drones=5;

	# skills 
	my $Drone_Interfacing_Skill           = 5;
	my $Mining_Drone_Operation_Skill      = 5;
	

	my $Mining_Drone_Specialization_Skill = 5;

	# exclude drone which do not benefit from Mining_Drone_Specialization_Skill
	if ( ($drone_type eq "Mining Drone I") ||
		($drone_type eq "Harvester Mining Drone") )
	{
		$Mining_Drone_Specialization_Skill = 0;
	}

	my $Industrial_Command_Ships_Skill    = 5;

	if ($drone_type eq "Mining Drone I")
	{
		$drone_base = 25;
	}
	elsif ($drone_type eq "Mining Drone II")
	{
		$drone_base = 33;
	}
	elsif ($drone_type eq "Augmented Mining Drone")
	{
		$drone_base = 37;
	}
	elsif ($drone_type eq "Harvester Mining Drone")
	{
		$drone_base = 42;
	}
	elsif (($drone_type eq "Excavator Mining Drone")&&
				(($ship_type eq "Rorqual")||
				($ship_type eq "Rorqual ICT1")||
				($ship_type eq "Rorqual ICT2")))
	{
		$drone_base = 80;
	}

	if  ($ship_type eq "Venture")
	{
		$drone_yield_per_second =$drone_base
			* (1 + 0.1 * $Drone_Interfacing_Skill)
			* (1 + 0.05 * $Mining_Drone_Operation_Skill)
			* (1 + 0.02 * $Mining_Drone_Specialization_Skill)
			* (1 + 0.15 ) # small mining drone augmentor II
			* (1 + 0.15 ) # small mining drone augmentor II
			* (1 + 0.10 ) # small mining drone augmentor I
			;
		$number_of_drones = 2;
	}
	elsif  ($ship_type eq "Endurance")
	{
		$drone_yield_per_second =$drone_base
			* (1 + 0.1 * $Drone_Interfacing_Skill)
			* (1 + 0.05 * $Mining_Drone_Operation_Skill)
			* (1 + 0.02 * $Mining_Drone_Specialization_Skill)
			* (1 + 0.15 ) # small mining drone augmentor II
			* (1 + 0.15 ) # small mining drone augmentor II
			;
		
		if ($drone_type eq "Harvester Mining Drone") 
		{
			$number_of_drones = 3;
		}
	}
	elsif   (($ship_type eq "Covetor") || ($ship_type eq "Retriever"))
	{
		$drone_yield_per_second =$drone_base
			* (1 + 0.1 * $Drone_Interfacing_Skill)
			* (1 + 0.05 * $Mining_Drone_Operation_Skill)
			* (1 + 0.02 * $Mining_Drone_Specialization_Skill)
			* (1 + 0.15 ) # medium mining drone augmentor II
			* (1 + 0.10 ) # medium mining drone augmentor I
			;
	}
	elsif   ($ship_type eq "Procurer")
	{
		$drone_yield_per_second =$drone_base
			* (1 + 0.1 * $Drone_Interfacing_Skill)
			* (1 + 0.05 * $Mining_Drone_Operation_Skill)
			* (1 + 0.02 * $Mining_Drone_Specialization_Skill)
			* (1 + 0.15 ) # medium mining drone augmentor II
			* (1 + 0.15 ) # medium mining drone augmentor II
			* (1 + 0.10 ) # medium mining drone augmentor I
			;
	}
	elsif   (($ship_type eq "Mackinaw")||
			($ship_type eq "Skiff")||
			($ship_type eq "Hulk"))
	{
		$drone_yield_per_second =$drone_base
			* (1 + 0.1 * $Drone_Interfacing_Skill)
			* (1 + 0.05 * $Mining_Drone_Operation_Skill)
			* (1 + 0.02 * $Mining_Drone_Specialization_Skill)
			* (1 + 0.15 ) # medium mining drone augmentor II
			* (1 + 0.15 ) # medium mining drone augmentor II
			;
	}
	elsif ($ship_type eq "Porpoise")
	{
		$drone_yield_per_second = $drone_base
			* (1 + 0.50)     # role bonus
			* (1 + 0.1 * $Industrial_Command_Ships_Skill)
			* (1 + 0.1 * $Drone_Interfacing_Skill)
			* (1 + 0.05 * $Mining_Drone_Operation_Skill)
			* (1 + 0.02 * $Mining_Drone_Specialization_Skill)
			* (1 + 0.15 ) # drone rig
			* (1 + 0.15 ) # drone rig
			* (1 + 0.10 ) # drone rig
			;
	}
	elsif ($ship_type eq "Orca")
	{
		$drone_yield_per_second =$drone_base
			* (1 + 0.1 * $Industrial_Command_Ships_Skill)
			* (1 + 0.1 * $Drone_Interfacing_Skill)
			* (1 + 0.05 * $Mining_Drone_Operation_Skill)
			* (1 + 0.02 * $Mining_Drone_Specialization_Skill)
			* (1 + 0.15 ) # medium mining drone augmentor II
			* (1 + 0.15 ) # medium mining drone augmentor II
			* (1 + 0.10 ) # medium mining drone augmentor I
			* (1 + 1.00)  # role bonus
		;
	}
	elsif ($ship_type eq "Rorqual")
	{
		$drone_yield_per_second = $drone_base
			* (1 + 0.1 * $Industrial_Command_Ships_Skill)
			* (1 + 0.1 * $Drone_Interfacing_Skill)
			* (1 + 0.05 * $Mining_Drone_Operation_Skill)
			* (1 + 0.02 * $Mining_Drone_Specialization_Skill)
			* (1 + 0.15 ) # medium mining drone augmentor II
			* (1 + 0.15 ) # medium mining drone augmentor II
			* (1 + 0.10 ) # medium mining drone augmentor I
			;
	}
	elsif ($ship_type eq "Rorqual ICT1")
	{
		$drone_yield_per_second = $drone_base
			* (1 + 0.1 * $Industrial_Command_Ships_Skill)
			* (1 + 0.1 * $Drone_Interfacing_Skill)
			* (1 + 0.05 * $Mining_Drone_Operation_Skill)
			* (1 + 0.02 * $Mining_Drone_Specialization_Skill)
			* (1 + 0.15 ) # medium mining drone augmentor II
			* (1 + 0.15 ) # medium mining drone augmentor II
			* (1 + 0.10 ) # medium mining drone augmentor I
			* (1 + 4.00 ) # 400% ic1 bonus
			;
	}
	elsif ($ship_type eq "Rorqual ICT2")
	{
		$drone_yield_per_second = $drone_base
			* (1 + 0.1 * $Industrial_Command_Ships_Skill)
			* (1 + 0.1 * $Drone_Interfacing_Skill)
			* (1 + 0.05 * $Mining_Drone_Operation_Skill)
			* (1 + 0.02 * $Mining_Drone_Specialization_Skill)
			* (1 + 0.15 ) # medium mining drone augmentor II
			* (1 + 0.15 ) # medium mining drone augmentor II
			* (1 + 0.10 ) # medium mining drone augmentor I
			* (1 + 5.00 ) # 400% ic1 bonus
			;
	}
	my $out_string = "";
	if ( $drone_yield_per_second == 0)
	{
		 $out_string =  sprintf("%8.8s", "N/A");
	}
	else
	{
		if ($yield_type eq "m3_per_second")
		{
			$out_string =sprintf("% 8.2f", $drone_yield_per_second * $number_of_drones /60);
		}
		else
		{
			$out_string =sprintf("% 8.2f", $drone_yield_per_second);
		}
		
	}
	return $out_string;
}


sub get_ice_drone_amount
{
	my $drone_type = $_[0];
	my $yield_type = $_[1];
	my $ship_type = $_[2];
	my $drone_cycle_duration=0;
	my $drone_base = 0;
	my $number_of_drones=5;
	my $drone_cycle_duration_base = 0;
	if ($drone_type eq "Ice Harvesting Drone I")
	{
		$drone_cycle_duration_base = 330;
	}
	elsif ($drone_type eq "Ice Harvesting Drone II")
	{
		$drone_cycle_duration_base = 300;
	}
	elsif ($drone_type eq "Augmented Ice Harvesting Drone")
	{
		$drone_cycle_duration_base = 280;
	}
	elsif ($drone_type eq "Excavator Ice Harvesting Drone")
	{
		if ( ( $ship_type eq "Rorqual") || 
			 ( $ship_type eq "Rorqual ICT1") || 
		     ( $ship_type eq "Rorqual ICT2") )
		{
			$drone_cycle_duration_base = 310;
		}
		
	}

	# skills 
	my $Ice_Harvesting_Drone_Operation_Skill = 5;
	my $Ice_Harvesting_Drone_Specialication_Skill = 5;
	my $Industrial_Command_Ships_Skill = 5;
	my $Capital_Industrial_Ships_Skill = 5;

	if  ( ($ship_type eq "Covetor") 

		  )
	{
		$drone_cycle_duration =$drone_cycle_duration_base
			* (1 - 0.05 * $Ice_Harvesting_Drone_Operation_Skill)
			* (1 - 0.02 * $Ice_Harvesting_Drone_Specialication_Skill)
			;
		$number_of_drones = 1;
	}
	if  ( ($ship_type eq "Hulk")||
		($ship_type eq "Mackinaw") )
	{
		$drone_cycle_duration =$drone_cycle_duration_base
			* (1 - 0.05 * $Ice_Harvesting_Drone_Operation_Skill)
			* (1 - 0.02 * $Ice_Harvesting_Drone_Specialication_Skill)
			* (1 - 0.15) # Medium Drone Mining Augmentor II
			;
		$number_of_drones = 1;
	}
	elsif ($ship_type eq "Skiff")
	{
		$drone_cycle_duration =$drone_cycle_duration_base
			* (1 - 0.05 * $Ice_Harvesting_Drone_Operation_Skill)
			* (1 - 0.02 * $Ice_Harvesting_Drone_Specialication_Skill)
			* (1 - 0.15) # Medium Drone Mining Augmentor II
			;
		$number_of_drones = 2;
	}
	elsif ($ship_type eq "Porpoise")
	{
		$drone_cycle_duration =$drone_cycle_duration_base
			* (1 - 0.05 * $Ice_Harvesting_Drone_Operation_Skill)
			* (1 - 0.02 * $Ice_Harvesting_Drone_Specialication_Skill)
			* (1 - 0.10 * $Industrial_Command_Ships_Skill)
			* (1 - 0.10) # Medium Drone Mining Augmentor I
			* (1 - 0.15) # Medium Drone Mining Augmentor II
			* (1 - 0.15) # Medium Drone Mining Augmentor II
			;
		$number_of_drones = 1;
	}
	elsif ($ship_type eq "Orca")
	{
		$drone_cycle_duration =$drone_cycle_duration_base
			* (1 - 0.05 * $Ice_Harvesting_Drone_Operation_Skill)
			* (1 - 0.02 * $Ice_Harvesting_Drone_Specialication_Skill)
			* (1 - 0.10 * $Industrial_Command_Ships_Skill)
			* (1 - 0.25) # Role Bonus
			* (1 - 0.10) # Medium Drone Mining Augmentor I
			* (1 - 0.15) # Medium Drone Mining Augmentor II
			* (1 - 0.15) # Medium Drone Mining Augmentor II
			;
		$number_of_drones = 1;
	}
	#"Rorqual", "Rorqual ICT1", "Rorqual ICT2");
	elsif ($ship_type eq "Rorqual")
	{
		$drone_cycle_duration =$drone_cycle_duration_base
			* (1 - 0.05 * $Ice_Harvesting_Drone_Operation_Skill)
			* (1 - 0.02 * $Ice_Harvesting_Drone_Specialication_Skill)
			* (1 - 0.10 * $Capital_Industrial_Ships_Skill)
			* (1 - 0.10) # Medium Drone Mining Augmentor I
			* (1 - 0.15) # Medium Drone Mining Augmentor II
			* (1 - 0.15) # Medium Drone Mining Augmentor II
			;
		
		$number_of_drones = 2;
		if ($drone_type eq "Excavator Ice Harvesting Drone"){
			$number_of_drones = 5;
		}
	}
	elsif ($ship_type eq "Rorqual ICT1")
	{
		$drone_cycle_duration =$drone_cycle_duration_base
			* (1 - 0.05 * $Ice_Harvesting_Drone_Operation_Skill)
			* (1 - 0.02 * $Ice_Harvesting_Drone_Specialication_Skill)
			* (1 - 0.10 * $Capital_Industrial_Ships_Skill)
			* (1 - 0.75)
			* (1 - 0.10) # Medium Drone Mining Augmentor I
			* (1 - 0.15) # Medium Drone Mining Augmentor II
			* (1 - 0.15) # Medium Drone Mining Augmentor II
			;
		
		$number_of_drones = 2;
		if ($drone_type eq "Excavator Ice Harvesting Drone"){
			$number_of_drones = 5;
		}
	}
	elsif ($ship_type eq "Rorqual ICT2")
	{
		$drone_cycle_duration =$drone_cycle_duration_base
			* (1 - 0.05 * $Ice_Harvesting_Drone_Operation_Skill)
			* (1 - 0.02 * $Ice_Harvesting_Drone_Specialication_Skill)
			* (1 - 0.10 * $Capital_Industrial_Ships_Skill)
			* (1 - 0.80)
			* (1 - 0.10) # Medium Drone Mining Augmentor I
			* (1 - 0.15) # Medium Drone Mining Augmentor II
			* (1 - 0.15) # Medium Drone Mining Augmentor II
			;
		
		$number_of_drones = 2;
		if ($drone_type eq "Excavator Ice Harvesting Drone"){
			$number_of_drones = 5;
		}
	}
	my $out_string = "";
	if ( $drone_cycle_duration == 0)
	{
		 $out_string =  sprintf("%8.8s", "N/A");
	}
	else
	{
		if ($yield_type eq "m3_per_second")
		{
			$out_string =sprintf("% 8.2f", 1000 / $drone_cycle_duration * $number_of_drones);
		}
		else
		{
			$out_string =sprintf("% 8.2f", $drone_cycle_duration );
		}
		
	}
	return $out_string;
}