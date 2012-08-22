package dwlab.gui;
import dwlab.base.Align;
import dwlab.shapes.Shape;
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
	public Shape icon;
	double iconDX, iconDY;

	/**
	 * Visualizer for button text.
	 */	
	public Visualizer textVisualizer = new Visualizer();

	public Align hAlign = Align.TO_CENTER;
	public Align vAlign = Align.TO_CENTER;

	public double textDX, textDY;


	@Override
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
	@Override
	public void init() {
		super.init();

		String name = getName();
		if( !name.isEmpty() ) icon = Window.current.findShape( "gadget_name", getName() );

		if( text.isEmpty() ) text = getParameter( "text" );
				
		if( !text.isEmpty() ) if( icon == null ) icon = Window.current.findShape( "gadget_text", text );

		String horizontalAlign = getParameter( "text_h_align" );
		if( horizontalAlign.equals( "left" ) ) {
			hAlign = Align.TO_LEFT;
		} else if( horizontalAlign.equals( "center" ) ) {
			hAlign = Align.TO_CENTER;
		} else if( horizontalAlign.equals( "right" ) ) {
			hAlign = Align.TO_RIGHT;
		}
		
		String verticalAlign = getParameter( "text_v_align" );
		if( verticalAlign.equals( "top" ) ) {
			vAlign = Align.TO_TOP;
		} else if( verticalAlign.equals( "center" ) ) {
			vAlign = Align.TO_CENTER;
		} else if( verticalAlign.equals( "bottom" ) ) {
			vAlign = Align.TO_BOTTOM;
		}

		if( parameterExists( "text_color" ) ) {
			textVisualizer.setColorFromHex( getParameter( "text_color" ) );
		} else {
			textVisualizer.setColorFromRGB( 0.0, 0.0, 0.0 );
		}

		if( parameterExists( "text_shift" ) ) {
			textDX = getDoubleParameter( "text_shift" );
			textDY = textDX;
		}

		textDX = getDoubleParameter( "text_dx" );
		textDY = getDoubleParameter( "text_dy" );

		if( icon != null ) {
			iconDX = icon.getX() - x;
			iconDY = icon.getY() - y;
			Window.current.remove( icon );
		}
	}


	@Override
	public void draw() {
		if( ! visible ) return;
		super.draw();

		if( icon != null ) {
			icon.setCoords( x + iconDX + getDX(), y + iconDY + getDY() );
			icon.draw();
		}

		String chunks[] = text.split( "|" );
		double chunkY = getDY() - 0.5 * ( chunks.length - 1 ) * textSize;
		for( String chunk: chunks ) {
			printText( chunk, textSize, textVisualizer, hAlign, vAlign, textDX + getDX(), textDY + chunkY );
			chunkY += textSize;
		}
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
		visualizer.alpha = 1.0d;
		if( icon != null ) icon.visualizer.alpha = 1.0d;
		textVisualizer.alpha = 1.0d;
	}


	/**
	 * Deactivates the label and also makes it half-transparent.
	 */	
	public void deactivate() {
		active = false;
		visualizer.alpha = 0.5d;
		if( icon != null ) icon.visualizer.alpha = 0.5d;
		textVisualizer.alpha = 0.5d;
	}
}
