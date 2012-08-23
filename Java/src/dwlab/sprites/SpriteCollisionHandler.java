/* Digital Wizard's Lab - game development framework
 * Copyright (C) 2012, Matt Merkulov
 *
 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
 * http://www.opensource.org/licenses/artistic-license-2.0.php
 */

package dwlab.sprites;

import dwlab.base.Obj;
import dwlab.sprites.Sprite;

/**
 * Sprite collision handling class.
 * Sprite collision check method with specified collision handler will execute this handler's method on collision one sprite with another.

 * @see #active example
 */
public class SpriteCollisionHandler extends Obj {
	public void handleCollision( Sprite sprite1, Sprite sprite2 ) {
	}
}