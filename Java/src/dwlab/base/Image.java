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
import java.io.IOException;
import java.nio.ByteBuffer;
import java.nio.IntBuffer;
import java.util.logging.Level;
import java.util.logging.Logger;
import static org.lwjgl.opengl.GL11.*;
import org.newdawn.slick.opengl.Texture;
import org.newdawn.slick.opengl.TextureLoader;
import org.newdawn.slick.util.ResourceLoader;
	
/**
 * Image class.
 */
public class Image extends ImageTemplate {
	Texture texture;
		
	public Image() {
	}
	
	public Image( int width, int height ) {
		if( Sys.debug ) if( xCells <= 0 || yCells <= 0 ) error( "Cells quantity must be 1 or more" );
		if( Sys.debug ) if( width <= 0 || height <= 0 ) error( "Cell sizes must be more than 0" );
		
		this.frameWidth = width;
		this.frameHeight = height;
		this.xCells = 1;
		this.yCells = 1;
	}
	
	public Image( int xCells, int yCells, int width, int height ) {
		if( Sys.debug ) if( xCells <= 0 || yCells <= 0 ) error( "Cells quantity must be 1 or more" );
		if( Sys.debug ) if( width <= 0 || height <= 0 ) error( "Cell sizes must be more than 0" );
		
		this.texture = null;
		this.xCells = xCells;
		this.yCells = yCells;
		this.frameWidth = width;
		this.frameHeight = height;
	}
	
	/**
	 * Creates new image from file with specified cell quantities for splitting.
	 * @return New image (LTImage).
	 */
	public Image( String fileName, int xCells, int yCells ) {
		if( Sys.debug ) if( xCells <= 0 || yCells <= 0 ) error( "Cells quantity must be 1 or more" );

		this.fileName = fileName;
		this.xCells = xCells;
		this.yCells = yCells;
		this.init();
	}

	public Image( String fileName ) {
		this.fileName = fileName;
		this.xCells = 1;
		this.yCells = 1;
		this.init();
	}


	/**
	 * Initializes image.
	 * Splits image by XCells x YCells grid. Will be executed after loading image object from XML file.
	 */
	@Override
	public final void init() {
		try {
			texture = TextureLoader.getTexture( fileName.substring( fileName.length() - 3 ).toUpperCase(), 
					ResourceLoader.getResourceAsStream( fileName ) );
		} catch ( IOException ex ) {
			Logger.getLogger( Image.class.getName() ).log( Level.SEVERE, null, ex );
		}
		frameWidth = texture.getTextureWidth() / xCells;
		frameHeight = texture.getTextureWidth() / yCells;
	}
	
	private static ByteBuffer buffer = ByteBuffer.allocateDirect( 4 );

	@Override
	public Color getPixel( int frame, int x, int y, Color color ) {
		glReadPixels( x, y, 1, 1, GL_RGBA, GL_UNSIGNED_INT, buffer );
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
		glDrawPixels( x, y, GL_RGBA, GL_UNSIGNED_INT, buffer );
	}
	
	
	public int getPixel( int x, int y ) {
		glReadPixels( x, y, 1, 1, GL_RGBA, GL_UNSIGNED_INT, intBuffer );
		return intBuffer.get( 0 );
	}
	
	private static IntBuffer intBuffer = IntBuffer.allocate( 1 );
	public void setPixel( int x, int y, int color ) {
		intBuffer.put( 0, color );
		glDrawPixels( x, y, GL_RGBA, GL_UNSIGNED_INT, buffer );
	}
	
	
	@Override
	public void draw( int frame, double x, double y, double width, double height, double angle, Color color ){
		double width2 = 0.5d * width ;
		double height2 = 0.5d * height;
		double tx = frameWidth * ( frame % xCells );
		double ty = frameHeight * Math.floor( frame / xCells );
		double kx = 1d / getTextureWidth();
		double ky = 1d / getTextureHeight();
		
		texture.bind();
		
		glColor4d( color.red, color.green, color.blue, color.alpha );
		glBindTexture( GL_TEXTURE_2D, texture.getTextureID() );
		glBegin( GL_QUADS );
			glColor4d( color.red, color.green, color.blue, color.alpha );
			glTexCoord2d( tx * kx, ty * kx );
			glVertex2d( x - width2, y - height2 );
			glTexCoord2d( ( tx + frameWidth ) * kx, ty * ky );
			glVertex2d( x + width2, y - height2 );
			glTexCoord2d( ( tx + frameWidth ) * kx, ( ty + frameHeight ) * ky );
			glVertex2d( x + width2, y + height2 );
			glTexCoord2d( tx * kx, ( ty + frameHeight ) * ky );
			glVertex2d( x - width2, y + height2 );
		glEnd();
	}
	
	
	public void draw( int frame, double x, double y, double width, double height, int tx1, int ty1, int tx2, int ty2, Color color ){
		double width2 = 0.5d * width ;
		double height2 = 0.5d * height;
		double tx = frameWidth * ( frame % xCells );
		double ty = frameHeight * Math.floor( frame / xCells );
		double kx = 1d / getTextureWidth();
		double ky = 1d / getTextureHeight();
		
		texture.bind();
		
		glColor4d( color.red, color.green, color.blue, color.alpha );
		glBegin( GL_QUADS );
			glColor4d( color.red, color.green, color.blue, color.alpha );
			glTexCoord2d( ( tx + tx1 * frameWidth ) * kx, ( ty + ty1 * frameHeight ) * kx );
			glVertex2d( x - width2, y - height2 );
			glTexCoord2d( ( tx + tx2 * frameWidth ) * kx, ( ty + ty1 * frameHeight ) * ky );
			glVertex2d( x + width2, y - height2 );
			glTexCoord2d( ( tx + tx2 * frameWidth ) * kx, ( ty + ty2 * frameHeight ) * ky );
			glVertex2d( x + width2, y + height2 );
			glTexCoord2d( ( tx + tx1 * frameWidth ) * kx, ( ty + ty2 * frameHeight ) * ky );
			glVertex2d( x - width2, y + height2 );
		glEnd();
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

	private double getTextureWidth() {
		return texture.getImageWidth();
	}

	private double getTextureHeight() {
		return texture.getImageHeight();
	}
}
