package dwlab.visualizers;
import dwlab.shapes.Shape;
import dwlab.sprites.Sprite;


/* Digital Wizard's Lab - game development framework
 * Copyright (C) 2012, Matt Merkulov 

 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
 * http://www.opensource.org/licenses/artistic-license-2.0.php\r\n */


public class WindowedVisualizer extends Visualizer {
	public Shape viewport;
	public Visualizer visualizer;



	public Image getImage() {
		return visualizer.getImage();
	}



	public void setImage( Image newImage ) {
		visualizer.setImage( newImage );
	}



	public void drawUsingSprite( Sprite sprite, Sprite spriteShape = null ) {
		if( ! sprite.visible ) return;

		int x, int y, int width, int height;
		getViewport( x, y, width, height );

		viewport.setAsViewport();
		visualizer.drawUsingSprite( sprite, spriteShape );

		setViewport( x, y, width, height );
	}



	public double getFacing() {
		return visualizer.getFacing();
	}



	public void setFacing( double newFacing ) {
		visualizer.setFacing( newFacing );
	}
}
