package dwlab.profiles;

//
// Digital Wizard's Lab - game development framework
// Copyright (C) 2012, Matt Merkulov
//
// All rights reserved. Use of this code is allowed under the
// Artistic License 2.0 terms, as specified in the license.txt
// file distributed with this code, or available from
// http://www.opensource.org/licenses/artistic-license-2.0.php
//

public class Frequency {
	public int hertz;

	public static void add( ColorDepth colorDepth, int hertz ) {
		Frequency frequency = new Frequency();
		frequency.hertz = hertz;
		colorDepth.frequencies.addLast( frequency );
	}

	public static Frequency get( ColorDepth colorDepth, int hertz = 0 ) {
		Frequency maxFrequency = null;
		for( Frequency frequency: colorDepth.frequencies ) {
			if( frequency.hertz == hertz ) return frequency;
			if( ! maxFrequency ) {
				maxFrequency = frequency;
			} else if( frequency.hertz > maxFrequency.hertz then ) {
				maxFrequency = frequency;
			}
		}
		return maxFrequency;
	}
}
