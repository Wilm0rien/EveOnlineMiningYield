use strict;

my @ship_list = ("Venture", "Procurer", "Retriever", "Covetor", "Skiff", "Mackinaw", "Hulk", "Porpoise", "Orca", "Rorqual", "Rorqual ICT1", "Rorqual ICT2");

my @drone_list = ("Mining Drone I", "Mining Drone II", "Augmented Mining Drone", "Harvester Mining Drone", "Excavator Mining Drone");

my @boost_list = ("no Boost", "Porpise Boot", "Orca Boost", "Rorqual Boost", "Rorqual ICT1 Boost", "Rorqual ICT2 Boost");

print_drone_table();
print "\n";
print_ship_table();

sub print_ship_table
{
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
			$out_string.= sprintf("|%s",  get_mining_amount($boost_type, $ship));
			#$out_string.= sprintf("|%s",  "N/A");
		}
		$out_string.="|\n";
		printf($out_string);
	}
}

sub print_drone_table
{
	#printf("|corv      |% 8.2f|\n", $drone_amount_cov);
	my $headline_string = "|Ship";
	my $column_separator = "|:-";
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
			$out_string.= sprintf("|%s",  get_drone_amount($drone_type, $ship));
		}
		$out_string.="|\n";
		printf($out_string);
	}
}

sub get_mining_amount
{
	my $boost_type              = $_[0];
	my $ship_type               = $_[1];

	my $mining_yield_per_second = 0;

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

	# Modulated Strip Miner II Attribute
	my $Strip_Miner_II_Mining_Amount = 450;
	my $Strip_Miner_II_Cycle_Time    = 180;

	# Minig Crystal II Attribute
	my $Asteroid_Specialization_Yield_Modifier =  1.75;

	my $boost_factor = 0;

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


	if  ($ship_type eq "Venture")
	{
		my $MinerII_amount     = 60;
		my $Venture_Role_Bonus = 1.00;
		my $MinerII_cycle      = 60;
		my $mining_upgrades_x1 = 0.09;

		my $venture_base_yield =  $MinerII_amount 
		  * (1+0.05*$Mining_Skill)       # role bonus
		  * (1+0.05*$Mining_Skill)       # regular skill bonus
		  * (1+0.05*$Astrogeology_Skill) # regular skill bonus
		  * (1+$Venture_Role_Bonus)      # role bonus
		  * (1+$mining_upgrades_x1);

		my $venture_base_time = ($MinerII_cycle * $boost_factor);

		if ($venture_base_time > 0 )
		{
			$mining_yield_per_second = $venture_base_yield / $venture_base_time;
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
		$out_string =sprintf("% 8.2f", $mining_yield_per_second);
	}
	return $out_string;
}

sub get_drone_amount
{
	my $drone_type = $_[0];
	my $ship_type = $_[1];
	my $drone_yield_per_second=0;
	my $drone_base = 0;

	# skills 
	my $Drone_Interfacing_Skill           = 5;
	my $Mining_Drone_Operation_Skill      = 5;
	my $Mining_Drone_Specialization_Skill = 5;
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
	}

	elsif  ( ($ship_type eq "Covetor") ||
		  ($ship_type eq "Procurer")||
		  ($ship_type eq "Retriever"))
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
		$out_string =sprintf("% 8.2f", $drone_yield_per_second);
	}
	return $out_string;
}