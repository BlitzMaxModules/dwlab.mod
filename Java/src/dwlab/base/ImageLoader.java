package dwlab.base;


import java.awt.Color;
import java.awt.Graphics;
import java.awt.color.ColorSpace;
import java.awt.image.*;
import java.io.BufferedInputStream;
import java.io.IOException;
import java.net.URL;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.nio.IntBuffer;
import java.util.HashMap;
import java.util.Hashtable;
import javax.imageio.ImageIO;
import org.lwjgl.opengl.GL11;

/**
 * A utility class to load images for JOGL. This source is based
 * on a image that can be found in the Java Gaming ( www.javagaming.org )
 * Wiki. It has been simplified slightly for explicit 2D graphics use.
 * 
 * OpenGL uses a particular image format. Since the images that are 
 * loaded from disk may not match this format this loader introduces
 * a intermediate image which the source image is copied into. In turn,
 * this image is used as source for the OpenGL image.
 *
 * @author Kevin Glass
 * @author Brian Matzon
 */
public class ImageLoader {
    /** The table of images that have been loaded in this loader */
    private HashMap<String, Image> table = new HashMap<String, Image>();

    /** The colour model including alpha for the GL image */
    private ColorModel glAlphaColorModel;
    
    /** The colour model for the GL image */
    private ColorModel glColorModel;
    
    /** 
     * Create a new image loader based on the game panel
     *
     * @param gl The GL content in which the images should be loaded
     */
    public ImageLoader() {
        glAlphaColorModel = new ComponentColorModel( ColorSpace.getInstance( ColorSpace.CS_sRGB ),
                                            new int[] {8,8,8,8},
                                            true,
                                            false,
                                            ComponentColorModel.TRANSLUCENT,
                                            DataBuffer.TYPE_BYTE );
                                            
        glColorModel = new ComponentColorModel( ColorSpace.getInstance( ColorSpace.CS_sRGB ),
                                            new int[] {8,8,8,0},
                                            false,
                                            false,
                                            ComponentColorModel.OPAQUE,
                                            DataBuffer.TYPE_BYTE );
    }
    
    /**
     * Create a new image ID 
     *
     * @return A new image ID
     */
    private int createImageID() 
    { 
       IntBuffer tmp = createIntBuffer( 1 ); 
       GL11.glGenTextures( tmp ); 
       return tmp.get( 0 );
    } 
    
    /**
     * Load a image
     *
     * @param resourceName The location of the resource to load
     * @return The loaded image
     * @throws IOException Indicates a failure to access the resource
     */
    public Image getImage( String resourceName ) throws IOException {
        Image img = table.get( resourceName );
        
        if ( img != null ) {
            return img;
        }
        
        img = getImage( resourceName,
                         GL11.GL_TEXTURE_2D, // target

                         GL11.GL_RGBA,     // dst pixel format

                         GL11.GL_LINEAR, // min filter ( unused )

                         GL11.GL_LINEAR );
        
        table.put( resourceName,img );
        
        return img;
    }
    
    /**
     * Load a image into OpenGL from a image reference on
     * disk.
     *
     * @param resourceName The location of the resource to load
     * @param target The GL target to load the image against
     * @param dstPixelFormat The pixel format of the screen
     * @param minFilter The minimising filter
     * @param magFilter The magnification filter
     * @return The loaded image
     * @throws IOException Indicates a failure to access the resource
     */
    public Image getImage( String resourceName, 
                              int target, 
                              int dstPixelFormat, 
                              int minFilter, 
                              int magFilter ) throws IOException 
    { 
        int srcPixelFormat = 0;
        
        // create the image ID for this image 

        int imageID = createImageID(); 
        Image image = new Image( target, imageID ); 
        
        // bind this image 

        GL11.glBindTexture( target, imageID ); 
 
        BufferedImage bufferedImage = loadImage( resourceName ); 
        image.textureWidth = bufferedImage.getWidth();
        image.textureHeight = bufferedImage.getHeight();
        
        if ( bufferedImage.getColorModel().hasAlpha() ) {
            srcPixelFormat = GL11.GL_RGBA;
        } else {
            srcPixelFormat = GL11.GL_RGB;
        }

        // convert that image into a byte buffer of image data 

        ByteBuffer imageBuffer = convertImageData( bufferedImage,image ); 
        
        if ( target == GL11.GL_TEXTURE_2D ) 
        { 
            GL11.glTexParameteri( target, GL11.GL_TEXTURE_MIN_FILTER, minFilter ); 
            GL11.glTexParameteri( target, GL11.GL_TEXTURE_MAG_FILTER, magFilter ); 
        } 
 
        // produce a image from the byte buffer

        GL11.glTexImage2D( target, 
                      0, 
                      dstPixelFormat, 
                      get2Fold( bufferedImage.getWidth() ), 
                      get2Fold( bufferedImage.getHeight() ), 
                      0, 
                      srcPixelFormat, 
                      GL11.GL_UNSIGNED_BYTE, 
                      imageBuffer  ); 
        
        return image; 
    } 
    
    /**
     * Get the closest greater power of 2 to the fold number
     * 
     * @param fold The target number
     * @return The power of 2
     */
    private int get2Fold( int fold ) {
        int ret = 2;
        while ( ret < fold ) {
            ret *= 2;
        }
        return ret;
    } 
    
    /**
     * Convert the buffered image to a image
     *
     * @param bufferedImage The image to convert to a image
     * @param image The image to store the data into
     * @return A buffer containing the data
     */
    private ByteBuffer convertImageData( BufferedImage bufferedImage,Image image ) { 
        ByteBuffer imageBuffer = null; 
        WritableRaster raster;
        BufferedImage imgImage;
        
        int imgWidth = 2;
        int imgHeight = 2;
        
        // find the closest power of 2 for the width and height

        // of the produced image

        while ( imgWidth < bufferedImage.getWidth() ) {
            imgWidth *= 2;
        }
        while ( imgHeight < bufferedImage.getHeight() ) {
            imgHeight *= 2;
        }
        
        image.textureWidth = imgHeight;
        image.textureHeight = imgWidth;
        
        // create a raster that can be used by OpenGL as a source

        // for a image

        if ( bufferedImage.getColorModel().hasAlpha() ) {
            raster = Raster.createInterleavedRaster( DataBuffer.TYPE_BYTE,imgWidth,imgHeight,4,null );
            imgImage = new BufferedImage( glAlphaColorModel,raster,false,new Hashtable() );
        } else {
            raster = Raster.createInterleavedRaster( DataBuffer.TYPE_BYTE,imgWidth,imgHeight,3,null );
            imgImage = new BufferedImage( glColorModel,raster,false,new Hashtable() );
        }
            
        // copy the source image into the produced image

        Graphics g = imgImage.getGraphics();
        g.setColor( new Color( 0f,0f,0f,0f ) );
        g.fillRect( 0,0,imgWidth,imgHeight );
        g.drawImage( bufferedImage,0,0,null );
        
        // build a byte buffer from the temporary image 

        // that be used by OpenGL to produce a image.

        byte[] data = ( ( DataBufferByte ) imgImage.getRaster().getDataBuffer() ).getData(); 

        imageBuffer = ByteBuffer.allocateDirect( data.length ); 
        imageBuffer.order( ByteOrder.nativeOrder() ); 
        imageBuffer.put( data, 0, data.length ); 
        imageBuffer.flip();
        
        return imageBuffer; 
    } 
    
    /** 
     * Load a given resource as a buffered image
     * 
     * @param ref The location of the resource to load
     * @return The loaded buffered image
     * @throws IOException Indicates a failure to find a resource
     */
    private BufferedImage loadImage( String ref ) throws IOException 
    { 
        URL url = ImageLoader.class.getClassLoader().getResource( ref );
        
        if ( url == null ) {
            throw new IOException( "Cannot find: "+ref );
        }
        
        BufferedImage bufferedImage = ImageIO.read( new BufferedInputStream( getClass().getClassLoader().getResourceAsStream( ref ) ) ); 
 
        return bufferedImage;
    }
    
    /**
     * Creates an integer buffer to hold specified ints
     * - strictly a utility method
     *
     * @param size how many int to contain
     * @return created IntBuffer
     */
    protected IntBuffer createIntBuffer( int size ) {
      ByteBuffer temp = ByteBuffer.allocateDirect( 4 * size );
      temp.order( ByteOrder.nativeOrder() );

      return temp.asIntBuffer();
    }    
}