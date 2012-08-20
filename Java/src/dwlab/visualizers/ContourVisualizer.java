package dwlab.visualizers;
import dwlab.shapes.LineSegment;
import dwlab.sprites.Sprite;


/* Digital Wizard's Lab - game development framework
 * Copyright (C) 2012, Matt Merkulov 

 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
// http://www.opensource.org/licenses/artistic-license-2.0.php


/**
 * This visualizer draws contours of the shape.
 */
public class ContourVisualizer extends Visualizer {
	/**
	 * Width of contour lines.
	 */
	public double lineWidth = 1.0;
	public int drawPivot1 = true;
	public int drawPivot2 = true;
	public double pivotScale = 1.0;



	/**
	 * Creates new contour visualizer using given RGB color components and transparency.
	 * @return New visualizer.
	 * @see #fromFile, #fromImage
	 */
	public static ContourVisualizer fromWidthAndRGBColor( double width, double red = 1.0, double green = 1.0, double blue = 1.0, double alpha = 1.0, double pivotScale = 1.0, int scaling = true ) {
		ContourVisualizer visualizer = new ContourVisualizer();
		visualizer.setColorFromRGB( red, green, blue );
		visualizer.alpha = alpha;
		visualizer.lineWidth = width;
		visualizer.pivotScale = pivotScale;
		visualizer.scaling = scaling;
		return visualizer;
	}



	/**
	 * Creates new contour visualizer using given hexadecimal color representation and transparency.
	 * @return New visualizer.
	 * @see #fromFile, #fromImage
	 */
	public static ContourVisualizer fromWidthAndHexColor( double width, String hexColor = "FFFFFF", double alpha = 1.0, double pivotScale = 1.0, int scaling = true ) {
		ContourVisualizer visualizer = new ContourVisualizer();
		visualizer.setColorFromHex( hexColor );
		visualizer.alpha = alpha;
		visualizer.lineWidth = width;
		visualizer.pivotScale = pivotScale;
		visualizer.scaling = scaling;
		return visualizer;
	}



	public void drawUsingSprite( Sprite sprite, Sprite spriteShape = null ) {
		if( ! spriteShape ) spriteShape == sprite;

		if( ! sprite.visible ) return;

		setColor 255.0 * red, 255.0 * green, 255.0 * blue;
		setAlpha( alpha );
		setProperLineWidth();

		double sX, double sY, double sWidth, double sHeight;
		Camera.current.fieldToScreen( spriteShape.x, spriteShape.y, sX, sY );
		Camera.current.sizeFieldToScreen( spriteShape.width * xScale, spriteShape.height * yScale, sWidth, sHeight );
		drawEmptyRect( sX - 0.5 * sWidth, sY - 0.5 * sHeight, sWidth, sHeight );

		setLineWidth( 1.0 );
		setColor( 255, 255, 255 );
		setAlpha( 1.0 );
	}



	public void drawUsingLineSegment( LineSegment lineSegment ) {
		if( ! lineSegment.visible ) return;

		setColor 255.0 * red, 255.0 * green, 255.0 * blue;
		setAlpha( alpha );
		setProperLineWidth();

		double sX1, double sY1, double sX2, double sY2;
		Camera.current.fieldToScreen( lineSegment.pivot[ 0 ].x, lineSegment.pivot[ 0 ].y, sX1, sY1 );
		Camera.current.fieldToScreen( lineSegment.pivot[ 1 ].x, lineSegment.pivot[ 1 ].y, sX2, sY2 );
		drawLine( sX1, sY1, sX2, sY2 );

		double radius =pivotScale ;
		if( scaling ) radius == Camera.current.distFieldToScreen( lineWidth ) * pivotScale;
		if( drawPivot1 ) drawOval( sX1 - 0.5 * radius, sY1 - 0.5 * radius, radius, radius );
		if( drawPivot2 ) drawOval( sX2 - 0.5 * radius, sY2 - 0.5 * radius, radius, radius );

		setLineWidth( 1.0 );
		setColor( 255, 255, 255 );
		setAlpha( 1.0 );
	}



	public void setProperLineWidth() {
		if( scaling ) {
			setLineWidth( Camera.current.distFieldToScreen( lineWidth ) );
		} else {
			setLineWidth( lineWidth );
		}
	}
}
