package dwlab.profiles;
import java.util.LinkedList;


/* Digital Wizard's Lab - game development framework
 * Copyright (C) 2012, Matt Merkulov 

 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
 * http://www.opensource.org/licenses/artistic-license-2.0.php */




public class ColorDepth {
	public int bits;
	public LinkedList frequencies = new LinkedList();

	public static void add( ScreenResolution resolution, int bits, int hertz ) {
		for( ColorDepth colorDepth: resolution.colorDepths ) {
			if( colorDepth.bits == bits ) {
				Frequency.add( colorDepth, hertz );
				return;
			}
		}

		ColorDepth colorDepth = new ColorDepth();
		colorDepth.bits = bits;
		resolution.colorDepths.addLast( colorDepth );
		Frequency.add( colorDepth, hertz );
	}

	public static ColorDepth get( ScreenResolution resolution, int bits = 0 ) {
		ColorDepth maxDepth = null;
		for( ColorDepth depth: resolution.colorDepths ) {
			if( depth.bits == bits ) return depth;
			if( ! maxDepth ) {
				maxDepth = depth;
			} else if( depth.bits > maxDepth.bits then ) {
				maxDepth = depth;
			}
		}
		return maxDepth;
	}
}
