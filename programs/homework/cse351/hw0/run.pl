#!/usr/bin/perl

use strict;

my $TIME = 'time';

my $cmd = [ { name => 'Java int',
	      cmd => "javac -Xlint hw0.java && $TIME java -Xmx640M -cp . hw0 2>&1",
	    },
	    { name => 'Java Integer',
	      cmd => "javac -Xlint hw0Integer.java && $TIME java -Xmx640M -cp . hw0Integer 2>&1",
	    },
	    { name => 'Java Integer Integer',
	      cmd => "javac -Xlint hw0IntegerInteger.java && $TIME java -Xmx640M -cp . hw0IntegerInteger 2>&1",
	    },
	    { name => 'C',
	      cmd => "gcc -Wall hw0.c && $TIME ./a.out 2>&1",
	    },
	    { name => 'Optimized C',
	      cmd => "gcc -Wall -O2 hw0.c && $TIME ./a.out 2>&1",
	    },
	  ];

foreach my $entry (@{$cmd}) {
  open(my $fh, "$entry->{cmd}|") || die "Couldn't open '$entry->{cmd}'";
  my $totalTime = 0;
  my $output = '';
  while (<$fh>) {
    $output .= $_;
    $totalTime += $1 if m/(\d+\.\d+)\s*user/;
    $totalTime += $1 if m/(\d+\.\d+)\s*system/;
  }
  close($fh);
  print sprintf("%20s  %f\n", $entry->{name}, $totalTime);
  print "That execution failed: $output" if $? >> 8;
}
