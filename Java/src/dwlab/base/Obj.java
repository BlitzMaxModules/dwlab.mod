/* Digital Wizard's Lab - game development framework
 * Copyright (C) 2012, Matt Merkulov
 *
 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
 * http://www.opensource.org/licenses/artistic-license-2.0.php
 */

package dwlab.base;

import dwlab.base.Sys.XMLMode;
import dwlab.base.XMLObject.XMLAttribute;
import dwlab.base.XMLObject.XMLObjectField;
import dwlab.shapes.layers.Layer;
import dwlab.shapes.maps.SpriteMap;
import dwlab.shapes.maps.TileMap;
import dwlab.shapes.sprites.Sprite;
import dwlab.shapes.sprites.VectorSprite;
import dwlab.visualizers.Visualizer;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import org.reflections.Reflections;

/**
 * Global object class
 */
public class Obj {
	public static HashMap<String, Class<Obj>> classes = new HashMap<String, Class<Obj>>();
	public static HashMap<Obj, Integer> iDMap;
	public static HashMap<Obj, XMLObject> removeIDMap;
	public static int maxID;
	public static Obj iDArray[];
	public static HashSet<Obj> undefinedObjects;
	

	public Layer toLayer() {
		return null;
	}
	
	public Sprite toSprite() {
		return null;
	}
	
	public VectorSprite toVectorSprite() {
		return null;
	}

	public TileMap toTileMap() {
		return null;
	}

	public SpriteMap toSpriteMap() {
		return null;
	}

	// ==================== Drawing ===================

	/**
	 * Draws the shape.
	 * You can fill it with drawing commands for object and its parts.
	 * 
	 * @see #drawUsingVisualizer, #lTVisualizer
	 */
	public void draw() {
	}


	/**
	 * Draws the shape using another visualizer.
	 * You can fill it with drawing commands for object and its parts using another visualizer.
	 * 
	 * @see #draw, #lTVisualizer
	 */
	public void drawUsingVisualizer( Visualizer vis ) {
	}


	/**
	 * Draws the contour of the object.
	 */
	public void drawContour( double lineWidth ) {
	}

	// ==================== Management ===================

	/**
	 * Initialization method of the object.
	 * Fill it with object initialization commands.
	 */
	public void init() {
	}
	
	
	/**
	 * Acting method of object.
	 * Fill it with the object acting commands.
	 */
	public void act() {
	}


	/**
	 * Method for updating object.
	 * Fill it with the object updating commands.
	 */
	public void update() {
	}
	
	
	/**
	 * Method called before destruction of object.
	 * Fill it with the commands which should be executed before object destruction.
	 */
	public void destroy() {
	}

	// ==================== Loading / saving ===================

	/**
	 * Method for loading / saving object.
	 * This method is for storing object fields into XML object for saving and retrieving object fields from XML object for loading.
	 * You can put different XMLObject commands and your own algorithms for loading / saving data structures here.
	 * 
	 * @see #manageChildArray, #manageChildList, #manageDoubleAttribute, #manageIntArrayAttribute
	 * #manageIntAttribute, #manageListField, #manageObjectArrayField, #manageObjectAttribute, #manageObjectField
	 * #manageObjectMapField, #manageStringAttribute 
	 */
	public void xMLIO( XMLObject xMLObject ) {
		if( Sys.xMLSetMode() ) xMLObject.name = getClass().getSimpleName();
	}



	/**
	 * Loads object with all contents from file.
	 * @see #saveToFile, #xMLIO
	 */
	public static Obj loadFromFile( String fileName, XMLObject xMLObject ) {
		if( classes.isEmpty() ) {
			Reflections reflections = new Reflections("");
			for( Class objectClass : reflections.getSubTypesOf( Obj.class ) ) {
				if( objectClass != null ) classes.put( objectClass.getSimpleName(), objectClass );
			}
		}
		
		if( xMLObject == null ) {
			maxID = 0;
			xMLObject = XMLObject.readFromFile( fileName );
		}

		iDArray = new Obj[ maxID + 1 ];
		fillIDArray( xMLObject );
		
		Obj object = null;
		Class<Obj> objectClass = classes.get( xMLObject.name );
		if( objectClass == null ) error( "Class \"" + xMLObject.name + "\" not found" );
		try {
			object = objectClass.newInstance();
		} catch ( InstantiationException ex ) {
			error( "\"" + xMLObject.name + "\" is abstract class or interface" );
		} catch ( IllegalAccessException ex ) {
			error( "Class \"" + xMLObject.name + "\" is unaccessible" );
		}

		Sys.xMLMode = XMLMode.GET;
		object.xMLIO( xMLObject );

		return object;
	}
	
	public static Obj loadFromFile( String fileName ) {
		 return loadFromFile( fileName, null );
	}
	

	public static void fillIDArray( XMLObject xMLObject ) {
		if( xMLObject.name.equals( "Object" ) ) return;
		int iD = 0;
		if( xMLObject.attributeExists( "id" ) ) iD = Integer.parseInt( xMLObject.getAttribute( "id" ) );
		
		Class objectClass = classes.get( xMLObject.name );
		if( objectClass == null ) error( "Class \"" + xMLObject.name + "\" not found" );
						
		if( iD > 0 ) try {
			iDArray[ iD ] = (Obj) objectClass.newInstance();
		} catch ( InstantiationException ex ) {
			error( "\"" + xMLObject.name + "\" is abstract class or interface" );
		} catch ( IllegalAccessException ex ) {
			error( "Class \"" + xMLObject.name + "\" is unaccessible" );
		}
		
		for( XMLObject child: xMLObject.children ) {
			fillIDArray( child );
		}
		for( XMLObjectField objectField: xMLObject.fields ) {
			fillIDArray( objectField.value );
		}
	}



	/**
	 * Saves object with all contents to file.
	 * @see #loadFromFile, #xMLIO
	 */
	public void saveToFile( String fileName ) {
		iDMap = new HashMap<Obj, Integer>();
		removeIDMap = new HashMap<Obj, XMLObject>();
		maxID = 1;

		Sys.xMLMode = XMLMode.SET;
		XMLObject xMLObject = new XMLObject();
		undefinedObjects = new HashSet<Obj>();
		xMLIO( xMLObject );

		xMLObject.setAttribute( "dwlab_version", String.valueOf( Sys.version ) );

		for( XMLObject xMLObject2: removeIDMap.values() ) {
			for ( Iterator<XMLAttribute> iterator = xMLObject2.attributes.iterator(); iterator.hasNext(); ) {
				XMLAttribute attr = iterator.next();
				if( attr.name.equals( "id" ) ) iterator.remove();
			}
		}

		iDMap = null;
		removeIDMap = null;

		xMLObject.writeToFile( fileName );
	}
	
	
	public static void error( String Text ) {
		System.out.println( Text );
		System.exit( 0 );
	}
}
