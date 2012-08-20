package dwlab.shapes;

import dwlab.base.Obj;

/* Digital Wizard's Lab - game development framework
 * Copyright (C) 2012, Matt Merkulov 

 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
 * http://www.opensource.org/licenses/artistic-license-2.0.php
 */

public class Vector extends Obj {
	public double x, y;
		
	public Vector set( double x, double y ) {
		this.x = x;
		this.y = y;
		return this;
	}
}
