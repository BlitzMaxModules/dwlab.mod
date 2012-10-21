package examples;

superStrict // Skip




for( double n = 0; n <= 3.1; n += 0.3 ) {
	print "L_Round( " + trimDouble( n ) + " ) = " + round( n );
}

rem output;
round( 0 ) = 0;
round( 0.3 ) = 0;
round( 0.6 ) = 1;
round( 0.9 ) = 1;
round( 1.2 ) = 1;
round( 1.5 ) = 2;
round( 1.8 ) = 2;
round( 2.1 ) = 2;
round( 2.4 ) = 2;
round( 2.7 ) = 3;
round( 3 ) = 3;
endRem;
