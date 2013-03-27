#!/usr/bin/perl -w

use strict;
use warnings;

use POSIX;
use DBI;
use DBD::mysql;
use List::Util qw(min max);

#
# Config Options
# 

my %db = (
  host => '127.0.0.1',
  port => '3306',
  user => 'redux',
  pass => 'PASSWORD',
  name => 'redux'
);

# A list of potential breakable parts for all vehicle types
my @baseparts = qw(
	palivo
	motor
	karoserie
	wheel_1_1_steering
	wheel_1_2_steering
	wheel_2_1_steering
	wheel_2_2_steering
	glass1
	glass2
	glass3
	glass4
);
my @boatparts = qw(motor);
my @busparts = qw(
	palivo
	motor
	karoserie
	wheel_1_1_steering
	wheel_1_2_steering
	wheel_2_1_steering
	wheel_2_2_steering
	glass1
	glass2
	glass3
	glass4
	glass5
	glass6
);
my @bigtruckparts = qw(
	palivo
	motor
	karoserie
	wheel_1_1_steering
	wheel_1_2_steering
	wheel_1_3_steering
	wheel_2_1_steering
	wheel_2_2_steering
	wheel_2_3_steering
	glass1
	glass2
	glass3
	glass4
);
my @motorcycleparts = (
	'palivo',
	'motor',
	'karoserie',
	'pravy zadni tlumic',
	'pravy predni tlumic',
);
my @atvparts = qw(
	palivo
	motor
	karoserie
	wheel_1_1_steering
	wheel_1_2_steering
	wheel_2_1_steering
	wheel_2_2_steering	
);
my @bicycleparts = ();
my @tractorparts = qw(
	palivo
	motor
	karoserie
	wheel_1_1_damper
	wheel_1_2_damper
	wheel_2_1_damper
	wheel_2_2_damper
	glass1
	glass2
	glass3
	glass4
);
my @landroverparts = qw(
	palivo
	motor
	karoserie
	wheel_1_1_steering
	wheel_1_2_steering
	wheel_2_1_steering
	wheel_2_2_steering
	glass1
	glass2
	glass3
);
my @hueyparts = (
	'motor',
	'elektronika',
	'mala vrtule',
	'velka vrtule',
	'munice',
	'trup',
	'glass1',
	'glass2',
	'glass3',
	'glass4',
	'glass5',
);
my @lilbirdparts = (
	'motor',
	'elektronika',
	'mala vrtule',
	'velka vrtule',
	'munice',
	'trup',
	'glass1',
	'glass2',
	'glass3',
	'glass4',
);


# A list of all parent vehicle types, their possible spawns, and their spawn "Weights"
my $vehicles = {
  smallcar => {
    min => 0,
    max => 5,
    chance => 0.4,
    parts => \@baseparts,
    spawns => {
      Skeet     => 1, #Skoda
      SkeetR    => 1, #SkodaRed
      SkeetG    => 1, #SkodaGreen
      SkeetB    => 1, #SkodaBlue
      Cahr_hat  => 2, #car_hatchback
      Cahr_sehd => 2, #car_sedan
      LahdahT1  => 2, #Lada1_TK_CIV_EP1
      LahdahT1  => 0, #Lada1_TK_CIV_EP1
    },
    loot => '[[["ItemWatch"],[1]],[["FoodCanPasta"],[1]],[[],[]]]',
  },
  bigcar => {
    min => 0,
    max => 5,
    chance => 0.4,
    parts => \@baseparts,
    spawns => {
      GeeEhZee1   => 2, #Volha_1_TK_CIV_EP1
      GeeEhZee2   => 2, #Volha_2_TK_CIV_EP1
      GeeEhZeeLim => 1, #VolhaLimo_TK_CIV_EP1
    },
    loot => '[[[],[]],[["ItemSodaEmpty","HandRoadFlare"],[1,1]],[["DZ_Patrol_Pack_EP1"],[1]]]',
  },
  suv => {
    min => 0,
    max => 2,
    chance => 0.25,
    parts => \@baseparts,
    spawns => {
      EssYouVee => 1, #SUV_TK_CIV_EP1
    },
    loot => '[[["ItemMap","Binocular","ItemFlashlightRed"],[1,1,1]],[["ItemChloroform"],[1]],[[],[]]]',
  },
  motorcycle => {
    min => 5,
    max => 10,
    chance => 0.5,
    parts => \@motorcycleparts,
    spawns => {
      MBykeI   => 2, #TT650_Ins
      MBykeT   => 3, #TT650_TK_CIV_EP1
      MBykeM10 => 1, #M1030
      MBykeOld => 3, #Old_moto_TK_Civ_EP1
    },
    loot => '[[[],[]],[["ItemJerrycanEmpty"],[1]],[[],[]]]',
  },
  bicycle => {
    min => 30,
    max => 60,
    chance => 0.5,
    parts => \@bicycleparts,
    spawns => {
      BykeC => 1, #Old_bike_base_EP1
      BykeMtn => 1, #MMT_Civ
    },
    loot => '[[[],[]],[[],[]],[[],[]]]',
  },
  smalltruck => {
    min => 0,
    max => 6,
    chance => 0.45,
    parts => \@baseparts,
    spawns => {
      Highlux1 => 1, #hilux1_civil_1_open
      Highlux2 => 1, #hilux1_civil_2_covered
      Highlux3 => 1, #hilux1_civil_3_open
      Dahtson1 => 1, #datsun1_civil_1_open
      Dahtson2 => 1, #datsun1_civil_2_covered
      Dahtson3 => 1, #datsun1_civil_3_open
    },
    loot => '[[["ItemHatchet","Colt1911"],[1,1]],[[],[]],[[],[]]]',
  },
  bus => {
    min => 0,
    max => 5,
    chance => 0.45,
    parts => \@busparts,
    spawns => {
      Boos  => 1, #Ikarus
      BoosT => 0, #Ikarus_TV_CIV_EP1
    },
    loot => '[[[],[]],[["PartWheel","ItemSodaPepsi"],[1,2]],[["CZ_VestPouch_EP1"],[2]]]',
  },
  tractor => {
    min => 0,
    max => 6,
    chance => 0.6,
    parts => \@tractorparts,
    spawns => {
      Traktore => 1, #Tractor
    },
    loot => '[[["MR43"],[1]],[["TrashJackDaniels","FoodCanBakedBeans","2Rnd_shotgun_74Pellets"],[1,1,3]],[[],[]]]',
  },
  van => {
    min => 0,
    max => 4,
    chance => 0.45,
    parts => \@baseparts,
    spawns => {
      ShitboxVan => 1, #S1203_TK_CIV_EP1
      EssYouVee  => 0,  #SUV_TK_CIV_EP1
    },
    loot => '[[["ItemCompass"],[1]],[["ItemWaterbottleUnfilled","ItemWaterbottle"],[1,1]],[[],[]]]',
  },
  bigtruck => {
    min => 0,
    max => 3,
    chance => 0.35,
    parts => \@bigtruckparts,
    spawns => {
      VeeThreeSiv       => 1, #V3S_Civ
      VeeThreeTeeKay    => 1, #V3S_Open_TK_EP1
      VeeThreeTeeKaySiv => 1, #V3S_Open_TK_CIV_EP1
      YerallSiv         => 1, #UralCivil
      YerallYouEn       => 1, #Ural_UN_EP1
      YerallTeeKay      => 1, #Ural_TK_CIV_EP1
      Camahz 		=> 2, #Kamaz
      CamahzO		=> 2, #KamazOpen
    },
    loot => '[[["ItemEtool"],[1]],[["PartWheel"],[2]],[[],[]]]',
  },
  humvee => {
    min => 0,
    max => 3,
    chance => 0.45,
    parts => \@baseparts,
    spawns => {
      HumVee => 1, #HMMWV
    },
    loot => '[[["MP5A5"],[1]],[["30Rnd_9x19_MP5","ItemSandbag"],[3,2]],[[],[]]]',
  },
  vodnik => {
    min => 0,
    max => 1,
    chance => 0.3,
    parts => \@baseparts,
    spawns => {
      Vahdnick => 1, #GAZ_Vodnik_MedEvac
    },
    loot => '[[[],[]],[["ItemBloodbag","ItemBandage","ItemPainkiller","ItemMorphine","ItemEpinephrine"],[2,2,2,2,2]],[[],[]]]',
  },
  landrover => {
    min => 0,
    max => 3,
    chance => 0.4,
    parts => \@landroverparts,
    spawns => {
      RovahCZ => 1, #LandRover_CZ_EP1
      RovahTK => 1, #LandRover_TK_CIV_EP1
    },
    loot => '[[["M4A1_Aim"],[1]],[["HandGrenade_west"],[3]],[[],[]]]',
  },
  huey => {
    min => 0,
    max => 1,
    chance => 0.2,
    parts => \@hueyparts,
    spawns => {
      HH_RX    => 1, #UH1H_TK_GUE_EP1
      BHawk_RX => 0, #UH60M_MEV_EP1
    },
    loot => '[[[],[]],[["ItemAntibiotic","Skin_Camo1_DZ"],[1,1]],[[],[]]]',
  },
  littlebird => {
    min => 0,
    max => 2,
    chance => 0.3,
    parts => \@lilbirdparts,
    spawns => {
      LilBird_RX => 1, #MH6J_EP1
    },
    loot => '[[["M9"],[1]],[["15Rnd_9x19_M9","ItemSodaPepsi","FoodCanBakedBeans"],[3,1,1]],[[],[]]]',
  },
  pbx => {
    min => 5,
    max => 10,
    chance => 0.6,
    parts => \@boatparts,
    spawns => {
      PeeBeeRX => 1, #PBX
    },
    loot => '[[[],[]],[[],[]],[[],[]]]',
  },
  uaz => {
    min => 0,
    max => 4,
    chance => 0.4,
    parts => \@baseparts,
    spawns => {
      YouZed_TeeKay  => 1, #UAZ_Unarmed_TK_EP1
      YouZed_Siv     => 1, #UAZ_Unarmed_TK_CIV_EP1
      YouZed_YouEn   => 1, #UAZ_Unarmed_UN_EP1
      YouZed_Rooskie => 1, #UAZ_RU
    },
    loot => '[[["M16A2","ItemKnife"],[1,1]],[["ItemTent"],[1]],[[],[]]]',
  },
  atv => {
    min => 2,
    max => 8,
    chance => 0.55,
    parts => \@atvparts,
    spawns => {
      EhTeeVeeU => 1, #ATV_US_EP1
    },
    loot => '[[["Makarov"],[1]],[["TrapBear","ItemWaterbottle","8Rnd_9x18_Makarov"],[2,1,2]],[[],[]]]',
  },
};


#
# End Config
#

print "INFO: DayZ Redux Vehicle Spawn/Maintenance Script v1.0\n\n";

print "INFO: Connecting to $db{'host'}:$db{'name'} as user $db{'user'}\n";

# Connect to MySQL
my $dbh = DBI->connect(
	"dbi:mysql:$db{'name'}:$db{'host'}:$db{'port'}",
	$db{'user'},
	$db{'pass'}
) or die "FATAL: Could not connect to MySQL -  " . DBI->errstr . "\n";

print "INFO: Cleaning up damaged vehicles and old buildables\n";
# Clean up damaged vehicles and old objects
my $dmgclean = $dbh->prepare(<<EndSQL
DELETE FROM
  object_data
WHERE
  damage >= 0.95
  OR (classname = 'Wire_cat1' and last_updated < now() - interval 3 day)
  OR (classname = 'Hedgehog_DZ' and last_updated < now() - interval 4 day)
  OR (classname = 'TrapBear' and last_updated < now() - interval 5 day)
  OR (classname = 'Sandbag1_DZ' and last_updated < now() - interval 8 day)
EndSQL
) or die "FATAL: SQL Error - " . DBI->errstr . "\n";
$dmgclean->execute() or die "FATAL: Could not clean up damaged/old objects - " . $dmgclean->errstr . "\n";
$dmgclean->finish();

print "INFO: Cleaning up damaged bicycles\n";
# Clean up damaged bicycles
my $bikeclean = $dbh->prepare(<<EndSQL
DELETE FROM
  object_data
WHERE
  classname like "Byke%"
  AND Hitpoints REGEXP '",[^0]'
EndSQL
) or die "FATAL: SQL Error - " . DBI->errstr . "\n";
$bikeclean->execute() or die "FATAL: Could not clean up damaged bicycles - " . $bikeclean->errstr . "\n";
$bikeclean->finish();

print "INFO: Cleaning up abandoned broken vehicles (36+ hours old)\n";
# Clean up abandoned broken vehicles
my $abandonclean = $dbh->prepare(<<EndSQL
DELETE FROM
  object_data
WHERE
  CharacterID = 0
  AND Hitpoints REGEXP '(steering|motor|karoserie|palivo|damper|vrtule|elektronika|munice)",[^0]'
  AND last_updated < DATE_SUB(now(), INTERVAL 36 hour)
  AND last_updated != Datestamp
EndSQL
) or die "FATAL: SQL Error - " . DBI->errstr . "\n";
$abandonclean->execute() or die "FATAL: Could not clean up abandoned broken vehicles - " . $abandonclean->errstr . "\n";
$abandonclean->finish();

print "INFO: Cleaning up old vehicles (72+ hours old)\n";
# clean up old vehicles
my $oldvehicles = $dbh->prepare(<<EndSQL
DELETE FROM
  object_data
WHERE
  CharacterID = 0
  AND last_updated < DATE_SUB(now(), INTERVAL 72 hour)
  AND last_updated != Datestamp
EndSQL
) or die "FATAL: SQL Error - " . DBI->errstr . "\n";
$oldvehicles->execute() or die "FATAL: Could not clean up old vehicles - " . $oldvehicles->errstr . "\n";
$oldvehicles->finish();

print "INFO: Cleaning up undiscovered vehicles\n";
# clean up undiscovered vehicles
my $undiscvehicles = $dbh->prepare(<<EndSQL
DELETE FROM
  object_data
WHERE
  CharacterID = 0
  AND last_updated = Datestamp
  AND classname NOT REGEXP '^(HH_RX|BHawk_RX|LilBird_RX|Vahdnick)\$'
EndSQL
) or die "FATAL: SQL Error - " . DBI->errstr . "\n";
$undiscvehicles->execute() or die "FATAL: Could not clean up undiscovered vehicles - " . $undiscvehicles->errstr . "\n";
$undiscvehicles->finish();

print "INFO: Cleaning up old tents\n";
my $oldtents = $dbh->prepare(<<EndSQL
DELETE FROM
  object_data USING object_data
  INNER JOIN Character_Data on object_data.CharacterID = Character_Data.CharacterID and Character_Data.is_dead = 1
WHERE
  (object_data.classname = 'Land_Cont_RX' OR object_data.classname = 'Land_Cont2_RX' OR object_data.classname = 'Land_Mag_RX')
  AND object_data.last_updated < now() - interval 7 day
EndSQL
) or die "FATAL: SQL Error - " . DBI->errstr . "\n";
$oldtents->execute() or die "FATAL: Could not clean up old tents - " . $oldtents->errstr . "\n";
$oldtents->finish();

print "INFO: Cleaning up old tents 2\n";
my $oldtents2 = $dbh->prepare(<<EndSQL
DELETE FROM
  object_data USING object_data
  INNER JOIN Character_Data on object_data.CharacterID = Character_Data.CharacterID and Character_Data.is_dead = 0
WHERE
  (object_data.classname = 'Land_Cont_RX' OR object_data.classname = 'Land_Cont2_RX' OR object_data.classname = 'Land_Mag_RX')
  AND object_data.last_updated < now() - interval 14 day
EndSQL
) or die "FATAL: SQL Error - " . DBI->errstr . "\n";
$oldtents2->execute() or die "FATAL: Could not clean up old tents - " . $oldtents2->errstr . "\n";
$oldtents2->finish();

print "INFO: Starting boundary check for objects\n";
my $boundaryclean = $dbh->prepare("select ObjectID,Worldspace,classname,CharacterID from object_data");
$boundaryclean->execute() or die "Couldn't get list of object positions\n";
while (my $row = $boundaryclean->fetchrow_hashref()) {
	$row->{Worldspace} =~ s/[\[\]\s]//g;
	$row->{Worldspace} =~ s/\|/,/g;
	my $classname = $row->{classname};
	my $CharacterID = $row->{CharacterID};
	my @Worldspace = split(',', $row->{Worldspace});
	my $valid = 1;

	if ($Worldspace[1] < 0 || $Worldspace[2] < 0 || $Worldspace[1] > 15360 || $Worldspace[2] > 15360) {
		$valid = 0;
	}

	if ($valid == 0) {
		my $delboundaryclean = $dbh->prepare("delete from object_data where ObjectID = $row->{ObjectID}");
		$delboundaryclean->execute() or die "Failed while deleting an out-of-bounds object";
		$delboundaryclean->finish();
		print "Vehicle $classname at $Worldspace[1], $Worldspace[2] was OUT OF BOUNDS and was deleted (owner: $CharacterID)\n";
	}
}
$boundaryclean->finish();

print "INFO: Starting anti \"helicopter on building\" check for objects\n";
my $antihelibuilding = $dbh->prepare("select object_data.ObjectID,object_data.Worldspace,object_spawns.Worldspace AS spawn,object_data.classname,object_data.ObjectUID from object_data LEFT JOIN object_spawns ON object_data.ObjectUID=object_spawns.id WHERE classname REGEXP '^(HH|BHawk|Lilbird)_RX\$'");
$antihelibuilding->execute() or die "Couldn't get list of heli object positions\n";
while (my $row = $antihelibuilding->fetchrow_hashref()) {

	$row->{Worldspace} =~ s/[\[\]\s]//g;
	$row->{Worldspace} =~ s/\|/,/g;
	my @Worldspace = split(',', $row->{Worldspace});

	$row->{spawn} =~ s/[\[\]\s]//g;
	$row->{spawn} =~ s/\|/,/g;
	my @spawn = split(',', $row->{spawn});

	my $classname = $row->{classname};

	my $x_variance = abs($Worldspace[1] - $spawn[1]);
	my $y_variance = abs($Worldspace[2] - $spawn[2]);

	if ($Worldspace[3] > 2 && ($x_variance > 10 || $y_variance > 10)) {
		my $delantihelibuilding = $dbh->prepare("delete from object_data where ObjectID = $row->{ObjectID}");
		$delantihelibuilding->execute() or die "Failed while deleting an illegally parked helicopter";
		$delantihelibuilding->finish();
		print "Helicopter $classname at $Worldspace[1], $Worldspace[2], $Worldspace[3] was above the terrain and not near its natural spawn ($spawn[1], $spawn[2]. $spawn[3]), so it was deleted\n";
	}
}
$antihelibuilding->finish();

print "INFO: Fetching spawn information\n";
my $available = $dbh->prepare(<<EndSQL
SELECT
  object_spawns.ObjectUID,
  object_spawns.Worldspace,
  object_spawns.type
FROM
  object_spawns
  LEFT JOIN object_data on object_spawns.ObjectUID = object_data.ObjectUID
WHERE
  object_spawns.type = ?
  AND object_data.ObjectUID IS NULL
EndSQL
) or die "FATAL: SQL Error - " . DBI->errstr . "\n";

my $spawned = $dbh->prepare(<<EndSQL
SELECT
  object_spawns.ObjectUID,
  object_spawns.Worldspace,
  object_spawns.type
FROM
  object_spawns
  LEFT JOIN object_data on object_spawns.ObjectUID = object_data.ObjectUID
WHERE
  object_spawns.type = ?
  AND object_data.ObjectUID IS NOT NULL
EndSQL
) or die "FATAL: SQL Error - " . DBI->errstr . "\n";

my $insert = $dbh->prepare(<<EndSQL
INSERT INTO
  object_data (ObjectUID, Worldspace, inventory, Hitpoints, damage, fuel, classname, instance, Datestamp)
VALUES (?, ?, ?, ?, ?, ?, ?, 1, CURRENT_TIMESTAMP())
EndSQL
) or die "FATAL: SQL Error - " . DBI->errstr . "\n";

my $spawnCount = 0;
# Loop through each spawn
foreach my $vehicle (keys %{$vehicles}) {
	my $cur_spawned = $spawned->execute($vehicle);
	if ($cur_spawned eq '0E0') {
		$cur_spawned = 0;
	}

	my $avail_count = $available->execute($vehicle);
	next if $avail_count eq '0E0';

	my $avail_array = $available->fetchall_arrayref();

	my $min_spawn = $vehicles->{$vehicle}->{'min'};
	my $max_spawn = $vehicles->{$vehicle}->{'max'};
	my $chance    = ($vehicles->{$vehicle}->{'chance'} * 100);

	print "Ensuring at least $min_spawn of $vehicle exist\n";
	while ($cur_spawned < $min_spawn) {
		spawn_vehicle($vehicle, $vehicles->{$vehicle}, $avail_array);
		$cur_spawned++;
		$spawnCount++;
	}

	print "Chancing up to $max_spawn total $vehicle\n";
	my $spawnchances = $max_spawn - $cur_spawned;
	for (my $attempt = 0; $attempt < $spawnchances; $attempt++) {
		my $random = int(rand(100));
		if ($random < $chance) {
			spawn_vehicle($vehicle, $vehicles->{$vehicle}, $avail_array);
			$cur_spawned++;
			$spawnCount++;
		}
	}

	# Debug to spawn ALL spawns!
	#while ($cur_spawned < $avail_count) {
	#	spawn_vehicle($vehicle, $vehicles->{$vehicle}, $avail_array);
	#	$cur_spawned++;
	#	$spawnCount++;
	#}

	print "Total $vehicle: $cur_spawned\n";
}

sub spawn_vehicle {
	my ($veh_cat, $vehicle, $avail_veh) = @_;

	my $vehtype = pick_vehicle($vehicle->{'spawns'});

	my @parts;
	if ($vehtype =~ /^((HH|LilBird)_RX|Vahdnick)$/) {
		@parts = @{$vehicle->{'parts'}};
	}
	else {
		@parts = break_parts(@{$vehicle->{'parts'}});
	}

	my $Hitpoints = '';
	my $brokecount = 0;
	foreach my $part (@parts) {
		next if ($part =~ /^glass[3-4]$/ && $vehtype eq 'Dahtson2');
		if ($Hitpoints ne '') {
			$Hitpoints .= ',';
		}
		$Hitpoints .= qq{["$part",1]};
		$brokecount++;
	}
	$Hitpoints = "[$Hitpoints]";

	my $inventory = $vehicle->{'loot'};

	my $partcount = scalar @{$vehicle->{'parts'}};
	$partcount = max($partcount, 1);

	my $avgdamage = $brokecount / $partcount;
	my $damage = $avgdamage * 0.75;

	my $fuel = ($veh_cat eq 'bicycle') ? 0 : sprintf("%.3f", min(max(rand(), 0.2), 0.8));

	my $availsize = scalar(@{$avail_veh});
	my $random = floor(rand($availsize));

	my $ObjectUID = @{$avail_veh}[$random]->[0];
	my $Worldspace = @{$avail_veh}[$random]->[1];

	splice(@{$avail_veh}, $random, 1);

	$insert->execute($ObjectUID, $Worldspace, $inventory, $Hitpoints, $damage, $fuel, $vehtype);
	#print "SPAWNING: $ObjectUID, $Worldspace, $Hitpoints, $damage, $fuel, $vehtype\n";
	print "($ObjectUID) $vehtype, Parts: $brokecount\n";

	return;
}

sub break_parts {
	my (@parts) = @_;

	my @brokenparts;

	foreach my $part (@parts) {
		
		my $random = int(rand(100));
		if ($random < 40) {
			push @brokenparts, $part;
		}
	}

	return @brokenparts;
}

sub pick_vehicle {
	my ($spawns) = @_;

	my @pool;

	foreach my $vehicle (keys %{$spawns}) {
		my $weight = $spawns->{$vehicle};
		for (my $i = 0; $i < $weight; $i++) {
			push @pool, $vehicle;
		};
	};

	my $poolsize = (scalar @pool);

	my $random = floor(rand($poolsize));

	return $pool[$random];	
}

$spawned->finish();
$available->finish();
$insert->finish();
$dbh->disconnect();

print "INFO: Spawned $spawnCount vehicles!\n";