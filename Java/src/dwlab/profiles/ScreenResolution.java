package dwlab.profiles;
import java.util.LinkedList;


/* Digital Wizard's Lab - game development framework
 * Copyright (C) 2012, Matt Merkulov 

 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
// http://www.opensource.org/licenses/artistic-license-2.0.php




public LinkedList screenResolutions = new LinkedList();

public class ScreenResolution {
	public int width;
	public int height;
	public LinkedList colorDepths = new LinkedList();

	public static void add( int width, int height, int bits, int hertz ) {
		for( ScreenResolution resolution: screenResolutions ) {
			if( resolution.width = width && resolution.height == height ) {
				ColorDepth.add( resolution, bits, hertz );
				return;
			}
		}

		ScreenResolution resolution = new ScreenResolution();
		resolution.width = width;
		resolution.height = height;
		screenResolutions.addLast( resolution );
		ColorDepth.add( resolution, bits, hertz );
	}

	public static ScreenResolution get( int width = 0, int height = 0 ) {
		ScreenResolution maxResolution = null;
		for( ScreenResolution resolution: screenResolutions ) {
			if( width ) {
				if( resolution.width = currentProfile.screenWidth && resolution.height == currentProfile.screenHeight ) return resolution;
			}
			if( ! maxResolution ) {
				maxResolution = resolution;
			} else if( resolution.width >= maxResolution.width && resolution.height >= maxResolution.height then ) {
				maxResolution = resolution;
			}
		}
		return maxResolution;
	}
}
