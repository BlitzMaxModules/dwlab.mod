/* Digital Wizard's Lab - game development framework
 * Copyright (C) 2012, Matt Merkulov
 *
 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
 * http://www.opensource.org/licenses/artistic-license-2.0.php
 */

package dwlab.base;

import dwlab.visualizers.Color;
import java.awt.image.BufferedImage;
import java.nio.ByteBuffer;
import java.nio.IntBuffer;
import org.lwjgl.opengl.GL11;

/**
 * Image class.
 */
public class Image extends ImageTemplate {
	public Image() {
	}
	
	public Image( int width, int height ) {
		if( Sys.debug ) if( xCells <= 0 || yCells <= 0 ) error( "Cells quantity must be 1 or more" );
		if( Sys.debug ) if( width <= 0 || height <= 0 ) error( "Cell sizes must be more than 0" );
		
		this.width = width;
		this.height = height;
		this.xCells = 1;
		this.yCells = 1;
	}
	
	public Image( int xCells, int yCells, int width, int height ) {
		if( Sys.debug ) if( xCells <= 0 || yCells <= 0 ) error( "Cells quantity must be 1 or more" );
		if( Sys.debug ) if( width <= 0 || height <= 0 ) error( "Cell sizes must be more than 0" );
		
		this.textureNum = createTexture( width, height );
		this.xCells = xCells;
		this.yCells = yCells;
		this.width = width;
		this.height = height;
	}
	
	/**
	 * Creates new image from file with specified cell quantities for splitting.
	 * @return New image (LTImage).
	 */
	public Image( String filename, int xCells, int yCells ) {
		if( Sys.debug ) if( xCells <= 0 || yCells <= 0 ) error( "Cells quantity must be 1 or more" );

		this.filename = filename;
		this.xCells = xCells;
		this.yCells = yCells;
		this.init();
	}

	public Image( String filename ) {
		this.filename = filename;
		this.xCells = 1;
		this.yCells = 1;
		this.init();
	}


	/**
	 * Initializes image.
	 * Splits image by XCells x YCells grid. Will be executed after loading image object from XML file.
	 */
	@Override
	public final void initImage() {
		if( filename.isEmpty() ) {
			width = Math.round( width );
			height = Math.round( height );
			textureNum = createTexture( (int) width, (int) height, ByteBuffer.allocate( (int) ( 4d * width * height ) ) );
 		} else {
			java.awt.Image image = ( new javax.swing.ImageIcon( filename ) ).getImage();
			BufferedImage tex = new BufferedImage( image.getWidth( null ), image.getHeight( null ), BufferedImage.TYPE_4BYTE_ABGR );
			ByteBuffer scratch = ByteBuffer.allocateDirect( 4 * tex.getWidth() * tex.getHeight() );
			scratch.clear();
			scratch.put( (byte[]) tex.getRaster().getDataElements(0, 0, tex.getWidth(), tex.getHeight(), null) );
			scratch.rewind();
			textureNum = createTexture( (int) width, (int) height, scratch );
		}
	}
	
	
	public static int createTexture( int width, int height, ByteBuffer buffer ) {
		lastNum++;
		GL11.glBindTexture( GL11.GL_TEXTURE_2D, lastNum );
		GL11.glPixelStorei( GL11.GL_UNPACK_ALIGNMENT, 1 );
		GL11.glTexParameteri( GL11.GL_TEXTURE_2D, GL11.GL_TEXTURE_WRAP_S, GL11.GL_CLAMP );
		GL11.glTexParameteri( GL11.GL_TEXTURE_2D, GL11.GL_TEXTURE_WRAP_T, GL11.GL_CLAMP );
		GL11.glTexParameteri( GL11.GL_TEXTURE_2D, GL11.GL_TEXTURE_MAG_FILTER, GL11.GL_LINEAR );
		GL11.glTexParameteri( GL11.GL_TEXTURE_2D, GL11.GL_TEXTURE_MIN_FILTER, GL11.GL_LINEAR );
		GL11.glTexEnvi( GL11.GL_TEXTURE_ENV, GL11.GL_TEXTURE_ENV_MODE, GL11.GL_MODULATE );
		GL11.glTexImage2D( GL11.GL_TEXTURE_2D, 0, GL11.GL_RGBA, width, height, 0, GL11.GL_RGBA, GL11.GL_UNSIGNED_INT, buffer );
		return lastNum;
	}
	
	
	private static ByteBuffer buffer = ByteBuffer.allocateDirect( 4 );

	@Override
	public Color getPixel( int frame, int x, int y, Color color ) {
		GL11.glReadPixels( x, y, 1, 1, GL11.GL_RGBA, GL11.GL_UNSIGNED_INT, buffer );
		color.red = buffer.get( 0 ) / 255d;
		color.green = buffer.get( 1 ) / 255d;
		color.blue = buffer.get( 2 ) / 255d;
		color.alpha = buffer.get( 3 ) / 255d;
		return color;
	}
	
	@Override
	public void setPixel( int x, int y, Color color ) {
		buffer.put( 0, (byte) ( 255d * color.red ) );
		buffer.put( 1, (byte) ( 255d * color.green ) );
		buffer.put( 2, (byte) ( 255d * color.blue ) );
		buffer.put( 3, (byte) ( 255d * color.alpha ) );
		GL11.glDrawPixels( x, y, GL11.GL_RGBA, GL11.GL_UNSIGNED_INT, buffer );
	}
	
	
	public int getPixel( int x, int y ) {
		GL11.glReadPixels( x, y, 1, 1, GL11.GL_RGBA, GL11.GL_UNSIGNED_INT, intBuffer );
		return intBuffer.get( 0 );
	}
	
	private static IntBuffer intBuffer = IntBuffer.allocate( 1 );
	public void setPixel( int x, int y, int color ) {
		intBuffer.put( 0, color );
		GL11.glDrawPixels( x, y, GL11.GL_RGBA, GL11.GL_UNSIGNED_INT, buffer );
	}
	
	
	@Override
	public void draw( int frame, double x, double y, double width, double height, double angle, Color color ){
		width *= 0.5d ;
		height *= 0.5d ;
		double tx = width * ( frame % xCells );
		double ty = height * Math.floor( frame / xCells );
		GL11.glBegin( GL11.GL_QUADS );
			GL11.glColor4d( color.red, color.green, color.blue, color.alpha );
			GL11.glTexCoord2d( tx, ty );
			GL11.glVertex2d(	x - width, y - height );
			GL11.glTexCoord2d( tx + width - 1, ty );
			GL11.glVertex2d(	x + width, y - height );
			GL11.glTexCoord2d( tx + width - 1, ty + height -1 );
			GL11.glVertex2d(	x + width, y + height );
			GL11.glTexCoord2d( tx, ty + height -1 );
			GL11.glVertex2d(	x - width, y + height );
		GL11.glEnd();
	}

	
	@Override
	public boolean collides( int frame1, double x1, double y1, Image image2, int frame2, double x2, double y2 ) {
		throw new UnsupportedOperationException( "Not yet implemented" );
	}
	
	@Override
	public boolean collides( int frame1, double x1, double y1, double width1, double height1,
			Image image2, int frame2, double x2, double y2, double width2, double height2 ) {
		throw new UnsupportedOperationException( "Not yet implemented" );
	}

	@Override
	public boolean collides( int frame1, double x1, double y1, double width1, double height1, double angle1,
			Image image2, int frame2, double x2, double y2, double width2, double height2, double angle2 ) {
		throw new UnsupportedOperationException( "Not yet implemented" );
	}
}
