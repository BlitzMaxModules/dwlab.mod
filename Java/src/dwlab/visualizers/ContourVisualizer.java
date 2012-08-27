package dwlab.visualizers;
import dwlab.base.Graphics;
import dwlab.shapes.LineSegment;
import dwlab.base.Vector;
import dwlab.shapes.sprites.Camera;
import dwlab.shapes.sprites.Sprite;


/* Digital Wizard's Lab - game development framework
 * Copyright (C) 2012, Matt Merkulov 

 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
 * http://www.opensource.org/licenses/artistic-license-2.0.php */


/**
 * This visualizer draws contours of the shape.
 */
public class ContourVisualizer extends Visualizer {
	/**
	 * Width of contour lines.
	 */
	public double lineWidth = 1.0;
	public double pivotScale = 1.0;



	/**
	 * Creates new contour visualizer using given RGB color components and transparency.
	 * @return New visualizer.
	 * @see #fromFile, #fromImage
	 */
	public ContourVisualizer( double lineWidth, double red, double green, double blue, double alpha, double pivotScale, boolean scaling ) {
		set( red, green, blue, alpha );
		this.lineWidth = lineWidth;
		this.pivotScale = pivotScale;
		this.scaling = scaling;
	}



	/**
	 * Creates new contour visualizer using given hexadecimal color representation and transparency.
	 * @return New visualizer.
	 * @see #fromFile, #fromImage
	 */
	public ContourVisualizer( double lineWidth, String hexColor, double pivotScale, boolean scaling ) {
		set( hexColor );
		this.lineWidth = lineWidth;
		this.pivotScale = pivotScale;
		this.scaling = scaling;
	}


	private static Vector serviceVector1 = new Vector();
	private static Vector serviceVector2 = new Vector();
	
	@Override
	public void drawUsingSprite( Sprite sprite, Sprite spriteShape ) {
		if( ! sprite.visible ) return;

		Camera.current.fieldToScreen( spriteShape.getX(), spriteShape.getY(), serviceVector1 );
		Camera.current.sizeFieldToScreen( spriteShape.getWidth() * xScale, spriteShape.getHeight() * yScale, serviceVector2 );
		Graphics.drawRectangle( serviceVector1.x - 0.5 * serviceVector2.x, serviceVector1.x - 0.5 * serviceVector2.y, serviceVector2.x, serviceVector2.y, 
				0d, this, true );
	}
	
	@Override
	public void drawUsingSprite( Sprite sprite ) {
		drawUsingSprite( sprite, sprite );
	}


	@Override
	public void drawUsingLineSegment( LineSegment lineSegment ) {
		if( ! lineSegment.visible ) return;

		Camera.current.fieldToScreen( lineSegment.pivot[ 0 ].getX(), lineSegment.pivot[ 0 ].getY(), serviceVector1 );
		Camera.current.fieldToScreen( lineSegment.pivot[ 1 ].getX(), lineSegment.pivot[ 1 ].getY(), serviceVector2 );
		Graphics.drawLine( serviceVector1.x, serviceVector1.y, serviceVector2.x, serviceVector2.y, realLineWidth(), this );

		double radius =pivotScale ;
		if( scaling ) radius = Camera.current.distFieldToScreen( lineWidth ) * pivotScale;
		Graphics.drawOval( serviceVector1.x - 0.5d * radius, serviceVector1.y - 0.5d * radius, radius, radius, 0d, this, false );
		Graphics.drawOval( serviceVector2.x - 0.5d * radius, serviceVector2.y - 0.5d * radius, radius, radius, 0d, this, false );
	}



	public double realLineWidth() {
		if( scaling ) {
			return Camera.current.distFieldToScreen( lineWidth );
		} else {
			return lineWidth;
		}
	}
}
