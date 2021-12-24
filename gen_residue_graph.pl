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

my $crystal_type_A = new_crystal_obj(cycle_time =>50.04, miner_amount =>2744.32, residue_prob=>0.376, name =>"Crystal_Type_A_II");
my $crystal_type_B = new_crystal_obj(cycle_time =>40.03, miner_amount =>2744.32, residue_prob=>0.64, name => "Crystal_Type_B_II");
my $strip_miner_I  = new_crystal_obj(cycle_time =>50.04, miner_amount =>1905.77, residue_prob=>0.0, name => "strip_miner_I");

my $number_of_mining_lasers = 6;

my $time_s = 0;
my @time_line;
my $counter = 0;
while ( ($crystal_type_A->{anomaly_storage} > $crystal_type_A->{miner_amount}) || 
	($crystal_type_B->{anomaly_storage} > $crystal_type_B->{miner_amount}) ||
	($strip_miner_I->{anomaly_storage} > $strip_miner_I->{miner_amount}) )
{
	$time_s += 0.1; # increment one per second
	process_yield(\$crystal_type_A, $time_s);
	process_yield(\$crystal_type_B, $time_s);
	process_yield(\$strip_miner_I, $time_s);
	if (($counter % 600)==0)
	{
		push @time_line, int($time_s/60);
		push @{$crystal_type_A->{mining_hold_over_time}}, $crystal_type_A->{mining_hold};
		push @{$crystal_type_B->{mining_hold_over_time}}, $crystal_type_B->{mining_hold};
		push @{$strip_miner_I->{mining_hold_over_time}}, $strip_miner_I->{mining_hold};
	}
	$counter++;
}

printf("|Crystal Type|Cluster Depleted|Ore Mined|\n");
printf("|:-|:-|:-|\n");
foreach my $elem ($strip_miner_I, $crystal_type_A, $crystal_type_B)
{
	printf("|%s|%d min| %3.3f m3|\n", $elem->{name}, $elem->{last_time}/60, $elem->{mining_hold}/1000000)
}
printf("\n");

foreach my $elem ($crystal_type_A,  $strip_miner_I)
{
	my ($x_time_s, $x_time_per) = extra_time($crystal_type_B, $elem);
	my $x_time_min = $x_time_s / 60;
	my ($x_ore_m3, $x_ore_per) = ore_preserved($crystal_type_B, $elem);
	printf("Additional time needed to deplete the ore site with %s: %d min (%3.2f%%)\n", 
	         $elem->{name}, $x_time_min, $x_time_per);
	printf("Additional ore gathered after completing the mining operation with %s: %3.3fM (%3.2f%%)\n", 
	        $elem->{name},$x_ore_m3, $x_ore_per );
	my $type_B_gathered = ($x_time_s * $crystal_type_B->{miner_amount} /  $crystal_type_B->{cycle_time}*$number_of_mining_lasers);
	printf("Ore that would have been gathered in the same time (%d min) with Crystal_Type_B_II in another cluster %3.3fM (%3.2f%%)\n", 
	        $x_time_min, $type_B_gathered/1000000,  ($type_B_gathered /  $crystal_type_B->{mining_hold})*100);
}

my $graph_data = [ \@time_line,
                   $strip_miner_I->{mining_hold_over_time},
                   $crystal_type_A->{mining_hold_over_time}, 
                   $crystal_type_B->{mining_hold_over_time} ];

$graph->set_legend(qw(Strip_Miner_I Crystal_Type_A_II Crystal_Type_B_II));
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
	$obj->{name}                  = $args{name};
	return $obj;
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

sub ore_preserved
{
	my $ref_obj  = $_[0];
	my $comp_obj = $_[1];
	my $ore_preserved   = ($comp_obj->{mining_hold} - $ref_obj->{mining_hold}) / 1000000;
	my $ore_pre_per   = (1-( ($ref_obj->{mining_hold}  / $comp_obj->{mining_hold})))*100;
	return $ore_preserved, $ore_pre_per;
}

sub extra_time
{
	my $ref_obj  = $_[0];
	my $comp_obj = $_[1];
	my $extra_time = (($comp_obj->{last_time}) -  ($ref_obj->{last_time})) ;
	my $x_time_per =  (1-(($ref_obj->{last_time}) / ($comp_obj->{last_time})))*100;
	return $extra_time, $x_time_per;
}