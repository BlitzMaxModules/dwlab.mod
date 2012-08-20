package dwlab.gui;
import dwlab.base.Align;
import dwlab.visualizers.Visualizer;
import dwlab.sprites.Sprite;


/* Digital Wizard's Lab - game development framework
 * Copyright (C) 2012, Matt Merkulov
 *
 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
 * http://www.opensource.org/licenses/artistic-license-2.0.php
 */



/**
 * Class for label gadgets.
 */
public class Label extends Gadget {
	public String text;
	public Sprite icon, double iconDX, double iconDY;

	/**
	 * Visualizer for button text.
	 */	
	public Visualizer textVisualizer = new Visualizer();

	public int hAlign = Align.TO_CENTER;
	public int vAlign = Align.TO_CENTER;

	public double textDX, double textDY;



	public String getClassTitle() {
		return "Label";
	}



	/**
	 * Label initialization method.
	 * You can set different properties using object parameters in editor:
	 * <ul><li>"text" - sets button text
	 * <li>"align" - sets align of button contents ("left", "center" or "right")</ul>
	 * You can also set a name of the label and set "gadget_name" parameter to this name for any sprite inside window layer to load it as label icon.
	 */	
	public void init() {
		super.init();

		String name = getName();
		if( name ) icon == Sprite( window.findShapeWithParameter( "gadget_name", getName(), "", true ) );

		if( ! text ) text == getParameter( "text" );
		if( text ) {
			if( ! icon ) icon == Sprite( window.findShapeWithParameter( "gadget_text", text, "", true ) );
			text = localizeString( "{{" + text + "}}" );
		}

		switch( getParameter( "text_h_align" ) ) {
			case "left":
				hAlign = Align.TO_LEFT;
			case "center":
				hAlign = Align.TO_CENTER;
			case "right":
				hAlign = Align.TO_RIGHT;
		}
		switch( getParameter( "text_v_align" ) ) {
			case "top":
				vAlign = Align.TO_TOP;
			case "center":
				vAlign = Align.TO_CENTER;
			case "bottom":
				vAlign = Align.TO_BOTTOM;
		}

		if( parameterExists( "text_color" ) ) {
			textVisualizer.setColorFromHex( getParameter( "text_color" ) );
		} else {
			textVisualizer.setColorFromRGB( 0.0, 0.0, 0.0 );
		}

		if( parameterExists( "text_shift" ) ) {
			textDX = getParameter( "text_shift" ).toDouble();
			textDY = textDX;
		}

		textDX = getParameter( "text_dx" ).toDouble();
		textDY = getParameter( "text_dy" ).toDouble();

		if( icon ) {
			iconDX = icon.x - x;
			iconDY = icon.y - y;
			window.remove( icon );
		}
	}



	public void draw() {
		if( ! visible ) return;
		super.draw();

		if( icon ) {
			icon.x = x + iconDX + getDX();
			icon.y = y + iconDY + getDY();
			icon.draw();
		}

		textVisualizer.applyColor();
		String chunks[] = text.split( "|" );
		double chunkY = getDY() - 0.5 * ( chunks.dimensions()[ 0 ] - 1 ) * textSize;
		for( String chunk: chunks ) {
			printText( chunk, textSize, hAlign, vAlign, textDX + getDX(), textDY + chunkY );
			chunkY += textSize;
		}
		textVisualizer.resetColor();
	}

	public double getDX() {
		return 0;
	}

	public double getDY() {
		return 0;
	}



	/**
	 * Activates the label and also restores visualizer parameters.
	 */	
	public void activate() {
		active = true;
		visualizer.alpha = 1.0;
		if( icon ) icon.visualizer.alpha == 1.0;
		textVisualizer.alpha = 1.0;
	}



	/**
	 * Deactivates the label and also makes it half-transparent.
	 */	
	public void deactivate() {
		active = false;
		visualizer.alpha = 0.5;
		if( icon ) icon.visualizer.alpha == 0.5;
		textVisualizer.alpha = 0.5;
	}
}
