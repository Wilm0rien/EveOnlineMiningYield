use strict;
use GD;
use GD::Graph::lines;
use Data::Dumper;

my $m3_in_anom = (12171+13157+14802+9868+15734+18548+20467+21106+21746+23025+25584+25584+362+445+501+557+612+724)*16;

my $graph = new GD::Graph::lines(800, 600);
my $y_max = $m3_in_anom;
my $image_name = "residue_graph.png";
my $title = sprintf("%3.1fM m3 Colossal Asteroid Cluster. 3 Hulks + Rorq Boost with 6 Mining lasers  ", $m3_in_anom / 1000000);

$graph->set(
	title             => $title,
	x_label           => 'time in minutes',
	y_label           => 'ore in m3',
	y_max_value       => $y_max,
	y_min_value       => 0,
	y_tick_number     => 8,
	x_all_ticks       => 1,
	y_all_ticks       => 0,
	x_label_skip      => 10,
	transparent       => 0,
	bgclr             => 'white',
	boxclr            => 'white',
	fgclr             => 'black',
	cycle_clrs        => '1',
	legend_placement => 'BL',
);

my $crystal;
$crystal->{TypeA}->{mining_hold_over_time}=[];
$crystal->{TypeB}->{mining_hold_over_time}=[];

sub new_crystal_obj
{
	my $obj;
	my (%args) = @_;
	$obj->{mining_hold_over_time} = [];
	$obj->{anomaly_storage}       = $m3_in_anom;
	$obj->{mining_hold}           = 0;
	$obj->{cycle_cnt}             = 0;
	$obj->{cycle_time}            = $args{cycle_time};
	$obj->{miner_amount}          = $args{miner_amount};
	$obj->{residue_prob}          = $args{residue_prob};
	$obj->{last_time}             = 0;
	return $obj;
}

my $crystal_type_A = new_crystal_obj(cycle_time =>50.04, miner_amount =>2744.32, residue_prob=>0.376);
my $crystal_type_B = new_crystal_obj(cycle_time =>40.03, miner_amount =>2744.32, residue_prob=>0.64);

my $number_of_mining_lasers = 6;

my $time_s = 0;
my @time_line;
my $counter = 0;
while ( ($crystal_type_A->{anomaly_storage} > $crystal_type_A->{miner_amount}) || 
        ($crystal_type_B->{anomaly_storage} > $crystal_type_B->{miner_amount}) )
{
	$time_s += 0.1; # increment one per second
	process_yield(\$crystal_type_A, $time_s);
	process_yield(\$crystal_type_B, $time_s);
	if (($counter % 600)==0)
	{
		push @time_line, int($time_s/60);
		push @{$crystal_type_A->{mining_hold_over_time}}, $crystal_type_A->{mining_hold};
		push @{$crystal_type_B->{mining_hold_over_time}}, $crystal_type_B->{mining_hold};
	}
	$counter++;
}



printf("Crystal_Type_A_II duration: %d mins; ore mined %3.3fM\n",
       $crystal_type_A->{last_time}/60, $crystal_type_A->{mining_hold}/1000000);
printf("Crystal_Type_B_II duration: %d mins; ore mined %3.3fM\n",
       $crystal_type_B->{last_time}/60, $crystal_type_B->{mining_hold}/1000000);

my $ore_preserved     = $crystal_type_A->{mining_hold} - $crystal_type_B->{mining_hold};
my $ore_pre_percent = $crystal_type_B->{mining_hold}  / $crystal_type_A->{mining_hold};

my $extra_time = ($crystal_type_A->{last_time}) -  ($crystal_type_B->{last_time});
my $extra_time_percent =  ($crystal_type_B->{last_time}) / ($crystal_type_A->{last_time});

printf("Additional Ore preserved with type A: %3.3fM (%3.2f%%)\n", 
        $ore_preserved/1000000,  (1- $ore_pre_percent)*100);
printf("Additional Time needed with type A: %d min (%3.2f%%)\n", 
        ($extra_time /60),  (1- $extra_time_percent)*100);

my $graph_data = [ \@time_line,
                   $crystal_type_A->{mining_hold_over_time}, 
                   $crystal_type_B->{mining_hold_over_time} ];

$graph->set_legend(qw(Crystal_Type_A_II Crystal_Type_B_II));
my $gd = $graph->plot( $graph_data );

if (defined $gd )
{
	if (open OUT, ">$image_name")
	{
		binmode(OUT);
		print OUT $gd->png( );
		close OUT;
	}
}

sub process_yield
{
	my $c_ref = $_[0];
	my $time  = $_[1];
	$$c_ref->{cycle_cnt}+=0.1;
	if ($$c_ref->{cycle_cnt} >= $$c_ref->{cycle_time})
	{
		$$c_ref->{cycle_cnt}   = 0;

		for (my $i = 0; $i<$number_of_mining_lasers; $i++)
		{
			if ($$c_ref->{anomaly_storage} >=$$c_ref->{miner_amount})
			{
				$$c_ref->{last_time}   = $time;
				$$c_ref->{anomaly_storage} -= $$c_ref->{miner_amount};
				$$c_ref->{mining_hold}     += $$c_ref->{miner_amount};
				if (int(rand(100) < ($$c_ref->{residue_prob} * 100)))
				{
					$$c_ref->{anomaly_storage} -= $$c_ref->{miner_amount};
				}
			}
		}
	}
}
