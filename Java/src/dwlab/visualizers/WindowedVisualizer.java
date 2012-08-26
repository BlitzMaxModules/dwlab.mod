/* Digital Wizard's Lab - game development framework
 * Copyright (C) 2012, Matt Merkulov 

 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
 * http://www.opensource.org/licenses/artistic-license-2.0.php */

package dwlab.visualizers;

import dwlab.base.Image;
import dwlab.base.Graphics;
import dwlab.shapes.Shape;
import dwlab.shapes.Shape.Facing;
import dwlab.shapes.Vector;
import dwlab.shapes.sprites.Sprite;

public class WindowedVisualizer extends Visualizer {
	public Shape viewport;
	public Visualizer visualizer;


	@Override
	public Image getImage() {
		return visualizer.getImage();
	}


	@Override
	public void setImage( Image newImage ) {
		visualizer.setImage( newImage );
	}


	private Vector servicePivot = new Vector();
	private Vector serviceSizes = new Vector();
	
	@Override
	public void drawUsingSprite( Sprite sprite, Sprite spriteShape ) {
		if( ! sprite.visible ) return;

		Graphics.getViewport( servicePivot, serviceSizes );

		viewport.setAsViewport();
		visualizer.drawUsingSprite( sprite, spriteShape );

		Graphics.setViewport( servicePivot, serviceSizes );
	}


	@Override
	public Facing getFacing() {
		return visualizer.getFacing();
	}


	@Override
	public void setFacing( Facing newFacing ) {
		visualizer.setFacing( newFacing );
	}
}
