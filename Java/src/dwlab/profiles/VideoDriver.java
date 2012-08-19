package dwlab.profiles;
import java.util.LinkedList;

//
// Digital Wizard's Lab - game development framework
// Copyright (C) 2012, Matt Merkulov
//
// All rights reserved. Use of this code is allowed under the
// Artistic License 2.0 terms, as specified in the license.txt
// file distributed with this code, or available from
// http://www.opensource.org/licenses/artistic-license-2.0.php
//

public LinkedList videoDrivers = new LinkedList();

public class VideoDriver {
	public String name;
	public tMax2dDriver driver;

	public static VideoDriver get( String name ="" ) {
		for( VideoDriver driver: videoDrivers ) {
			if( driver.name == name ) return driver;
		}
		return VideoDriver( videoDrivers.getFirst() );
	}
}
