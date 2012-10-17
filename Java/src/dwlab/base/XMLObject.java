/* Digital Wizard's Lab - game development framework
 * Copyright (C) 2012, Matt Merkulov
 *
 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.text
 * file distributed with this code, or available from
 * http://www.opensource.org/licenses/artistic-license-2.0.php
 */

package dwlab.base;

import java.lang.reflect.Array;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.Map.Entry;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Class for intermediate objects to save/load objects from XML file.
 * When you load framework object from XML file this file firstly will be transformed to the structure consisting of XMLObjects.
 * During next step new objects will be created and filled with information using this XMLObjects structure.
 * When you save object to XML file, the system firstly creates a XMLObjects structure and unloads all information there, then save this structure to file. 
 */
public class XMLObject extends Obj {
	public static int version;
	
	public enum Type {
		NORMAL,
		CLOSED,
		EMPTY
	}
	
	public String name;
	public LinkedList<XMLAttribute> attributes = new LinkedList<XMLAttribute>();
	
	public static class XMLAttribute {
		public String name;
		public String value;
	}	
	
	public LinkedList<XMLObjectField> fields = new LinkedList<XMLObjectField>();
	
	public static class XMLObjectField {
		public String name;
		public XMLObject value;
	}
	
	public LinkedList<XMLObject> children = new LinkedList<XMLObject>();
	private Type type = Type.NORMAL;
	
	private static int textPos;


	/**
	 * Cheks if attribute with specified name exists.
	 * @return True if attribute exists.
	 * @see #getAttribute, #setAttribute, #removeAttribulte
	 */
	public boolean attributeExists( String attrName ) {
		for( XMLAttribute attr: attributes ) {
			if( attr.name.equals( attrName ) ) return true;
		}
		return false;
	}


	/**
	 * Returns value of XMLObject attribute with given name.
	 * @return Attribute string value.
	 * @see #attributeExists, #setAttribute, #removeAttribulte
	 */
	public String getAttribute( String attrName ) {
		for( XMLAttribute attr: attributes ) {
			if( attr.name.equals( attrName ) ) return attr.value;
		}
		return "";
	}

	private int getIntegerAttribute( String attrName ) {
		String attrValue = getAttribute( attrName );
		if( attrValue.isEmpty() ) return 0; else return Integer.parseInt( attrValue );
	}

	private double getDoubleAttribute( String attrName ) {
		String attrValue = getAttribute( attrName );
		if( attrValue.isEmpty() ) return 0; else return Double.parseDouble( getAttribute( attrName ) );
	}


	/**
	 * Sets value of XMLObject attribute with given name.
	 * @see #attributeExists, #getAttribute, #removeAttribulte
	 */
	public void setAttribute( String attrName, String attrValue) {
		for( XMLAttribute attr: attributes ) {
			if( attr.name.equals( attrName ) ) {
				attr.value = attrValue;
				return;
			}
		}

		XMLAttribute attr = new XMLAttribute();
		attr.name = attrName;
		attr.value = attrValue;
		attributes.addLast( attr );
	}
	
	public void setAttribute( String attrName, int attrValue) {
		setAttribute( attrName, String.valueOf( attrValue ) );
	}
	
	public void setAttribute( String attrName, double attrValue) {
		setAttribute( attrName, Service.trim( attrValue ) );
	}


	/**
	 * Removes attribute with given name of XMLObject.
	 * @see #attributeExists, #getAttribute, #setAttribute
	 */
	public void removeAttribute( String attrName ) {
		for ( Iterator<XMLAttribute> iterator = attributes.iterator(); iterator.hasNext(); ) {
			if( iterator.next().name.equals( attrName ) ) iterator.remove();
		}
	}


	/**
	 * Cheks if field with specified name exists.
	 * @return True if field exists.
	 * @see #getField, #setField, #removeField
	 */
	public boolean fieldExists( String fieldName ) {
		for( XMLObjectField objectField: fields ) {
			if( objectField.name.equals( fieldName ) ) return true;
		}
		return false;
	}


	/**
	 * Returns XMLObject which is the field with given name of current XMLObject.
	 * @return XMLObject representing a field.
	 * @see #setField
	 */
	public XMLObject getField( String fieldName ) {
		for( XMLObjectField objectField: fields ) {
			if( objectField.name.equals( fieldName ) ) return objectField.value;
		}
		return null;
	}


	/**
	 * Sets value of the field with given name to given XMLObject.
	 * @see #getField
	 */
	public XMLObjectField setField( String fieldName, XMLObject xMLObject ) {
		XMLObjectField objectField = new XMLObjectField();
		objectField.name = fieldName;
		objectField.value = xMLObject;
		fields.addLast( objectField );
		return objectField;
	}


	/**
	 * Removes field with given name of XMLObject.
	 * @see #fieldExists, #getField, #setField
	 */
	public void removeField( String fieldName ) {
		for ( Iterator<XMLObjectField> iterator = fields.iterator(); iterator.hasNext(); ) {
			if( iterator.next().name.equals( fieldName ) ) iterator.remove();
		}
	}


	/**
	 * Transfers data between XMLObject attribute and framework object field with Int type.
	 * @see #manageDoubleAttribute, #manageStringAttribute, #manageObjectAttribute, #manageIntArrayAttribute, #xMLIO example
	 */
	public boolean manageBooleanAttribute( String attrName, boolean attrValue, boolean defaultValue ) {
		if( Sys.xMLGetMode() ) {
			for( XMLAttribute attr: attributes ) {
				if( attr.name.equals( attrName ) ) return attr.value.equals( "0" ) ? false : true;
			}
			return defaultValue;
		} else if( attrValue != defaultValue ) {
			setAttribute( attrName, attrValue ? "1" : "0" );
		}
		return attrValue;
	}
	
	public boolean manageBooleanAttribute( String attrName, boolean attrValue ) {
		return manageBooleanAttribute( attrName, attrValue, false );
	}


	/**
	 * Transfers data between XMLObject attribute and framework object field with Int type.
	 * @see #manageDoubleAttribute, #manageStringAttribute, #manageObjectAttribute, #manageIntArrayAttribute, #xMLIO example
	 */
	public int manageIntAttribute( String attrName, int attrValue, int defaultValue ) {
		if( Sys.xMLGetMode() ) {
			for( XMLAttribute attr: attributes ) {
				if( attr.name.equals( attrName ) ) return Integer.parseInt( attr.value );
			}
			return defaultValue;
		} else if( attrValue != defaultValue ) {
			setAttribute( attrName, String.valueOf( attrValue ) );
		}
		return attrValue;
	}
	
	public int manageIntAttribute( String attrName, int attrValue ) {
		return manageIntAttribute( attrName, attrValue, 0 );
	}


	/**
	 * Transfers data between XMLObject attribute and framework object field with Double type.
	 * @see #manageIntAttribute, #manageStringAttribute, #manageObjectAttribute, #xMLIO example
	 */
	public double manageDoubleAttribute( String attrName, double attrValue, double defaultValue ) {
		if( Sys.xMLGetMode() ) {
			for( XMLAttribute attr: attributes ) {
				if( attr.name.equals( attrName ) ) return Double.parseDouble( attr.value );
			}
			return defaultValue;
		} else if( attrValue != defaultValue ) {
			setAttribute( attrName, Service.trim( attrValue, 8 ) );
		}
		return attrValue;
	}
	
	public double manageDoubleAttribute( String attrName, double attrValue ) {
		return manageDoubleAttribute( attrName, attrValue, 0d );
	}


	/**
	 * Transfers data between XMLObject attribute and framework object field with String type.
	 * @see #manageIntAttribute, #manageDoubleAttribute, #manageObjectAttribute, #xMLIO example
	 */
	public String manageStringAttribute( String attrName, String attrValue ) {
		if( Sys.xMLGetMode() ) {
			for( XMLAttribute attr: attributes ) {
				if( attr.name.equals( attrName ) ) return attr.value;
			}
		} else if( !attrValue.isEmpty() ) {
			setAttribute( attrName, attrValue );
		}
		return attrValue;
	}


	/**
	 * Transfers data between XMLObject attribute and framework object field with String type.
	 * @see #manageIntAttribute, #manageDoubleAttribute, #manageObjectAttribute, #xMLIO example
	 */
	public <E extends Enum> E manageEnumAttribute( String attrName, E attrValue ) {
		if( Sys.xMLGetMode() ) {
			for( XMLAttribute attr: attributes ) {
				if( attr.name.equals( attrName ) ) return (E) Enum.valueOf( attrValue.getClass(), attr.value );
			}
		} else if( attrValue != null ) {
			setAttribute( attrName, attrValue.toString() );
		}
		return attrValue;
	}


	/**
	 * Transfers data between XMLObject attribute and framework object field wit LTObject type.
	 * @return Loaded object or same object for saving mode.
	 * Use "ObjField = ObjFieldType( ManageObjectAttribute( FieldName, ObjField ) )" command syntax.
	 * 
	 * @see #manageIntAttribute, #manageDoubleAttribute, #manageStringAttribute, #manageObjectField, #manageChildArray
	 */
	public <E extends Obj> E manageObjectAttribute( String attrName, E obj ) {
		if( Sys.xMLGetMode() ) {
			int iD = getIntegerAttribute( attrName );
			if( iD > 0 ) return obj;

			obj = (E) iDArray[ iD ];

			if( obj == null ) error( "Object with id " + iD + " not found" );
		} else if( obj != null ) {
			int iD = iDMap.get( obj );

			if( iD == 0 ) {
				iD = maxID;
				iDMap.put( obj, iD );
				maxID += 1;
				undefinedObjects.add( obj );
			}
			removeIDMap.remove( obj );

			setAttribute( attrName, String.valueOf( iD ) );
		}
		return obj;
	}


	/**
	 * Transfers data between XMLObject attribute and framework object field with int[] type.
	 * @see #manageIntAttribute
	 */
	public int[] manageIntArrayAttribute( String attrName, int[] array, int chunkLength ) {
		if( Sys.xMLGetMode() ) {
			String data = getAttribute( attrName );
			if( !attributeExists( attrName ) ) return array;
			if( chunkLength > 0 ) {
				array = new int[ data.length() / chunkLength ];
				int pos = 0;
				int n = 0;
				while( pos < data.length() ) {
					array[ n ] = Service.decode( data.substring( pos, pos + chunkLength ) );
					pos += chunkLength;
					n += 1;
				}
			} else {
				String values[] = data.split( "," );
				int quantity = values.length;
				array = new int[ quantity ];
				for( int n=0; n <= quantity; n++ ) {
					array[ n ] = Integer.parseInt( values[ n ] );
				}
			}
		} else if( array != null ) {
			String values = "";
			for( int n=0; n <= array.length; n++ ) {
				if( chunkLength > 0 ) {
					values += Service.encode( array[ n ], chunkLength );
				} else {
					if( !values.isEmpty() ) values += ",";
					values += array[ n ];
				}
			}
			setAttribute( attrName, values );
		}
		return array;
	}
	
	public int[] manageIntArrayAttribute( String attrName, int[] array ) {
		return manageIntArrayAttribute( attrName, array, 0 );
	}


	/**
	 * Transfers data between XMLObject field and framework object field with LTObject type.
	 * @see #xMLIO example
	 */
	public <E extends Obj> E manageObjectField( String fieldName, E fieldObject ) {
		if( Sys.xMLGetMode() ) {
			XMLObject xMLObject = getField( fieldName );
			if( xMLObject != null ) return xMLObject.manageObject( fieldObject );
		} else if( fieldObject != null ) {
			XMLObject xMLObject = new XMLObject();
			xMLObject.manageObject( fieldObject );
			setField( fieldName, xMLObject );
		}
		return fieldObject;
	}


	/**
	 * Transfers data between XMLObject contents and framework object field with TList type.
	 * @see #manageChildList, #xMLIO example
	 */
	public <E extends Obj> LinkedList<E> manageListField( String fieldName, LinkedList<E> list ) {
		if( Sys.xMLGetMode() ) {
			XMLObject xMLObject = getField( fieldName );
			if( xMLObject != null ) xMLObject.manageChildList( list );
		} else if( list != null ) {
			if( list.isEmpty() ) return list;
			XMLObject xMLObject = new XMLObject();
			xMLObject.name = "TList";
			xMLObject.manageChildList( list );
			setField( fieldName, xMLObject );
		}
		return list;
	}


	/**
	 * Transfers data between XMLObject contents and framework object field with LTObject[] type.
	 * @see #manageObjectAttribute, #manageObjectField, #manageObjectMapField
	 */
	public <E extends Obj> E[] manageObjectArrayField( String fieldName, E[] array ) {
		if( Sys.xMLGetMode() ) {
			XMLObject xMLArray = getField( fieldName );
			if( xMLArray != null ) xMLArray.manageChildArray( array );
		} else if( array != null ) {
			XMLObject xMLArray = new XMLObject();
			xMLArray.name = "Array";
			xMLArray.manageChildArray( array );
			setField( fieldName, xMLArray );
		}
		return array;
	}



	/**
	 * Transfers data between XMLObject field and framework object field with TMap type filled with LTObject-LTObject pairs.
	 * @see #manageObjectAttribute, #manageObjectField, #manageObjectArrayField
	 */
	public <E extends Obj, F extends Obj> void manageObjectMapField( String fieldName, HashMap<E, F> map ) {
		if( Sys.xMLGetMode() ) {
			XMLObject xMLMap = getField( fieldName );
			if( xMLMap != null ) xMLMap.manageChildMap( map );
		} else if( map != null ) {
			if( map.isEmpty() ) return;
			XMLObject xMLMap = new XMLObject();
			xMLMap.name = "Map";
			xMLMap.manageChildMap( map );
			setField( fieldName, xMLMap );
		}
	}



	/**
	 * Transfers data between XMLObject field and framework object field with TMap type filled with LTObject-LTObject pairs.
	 * @see #manageObjectAttribute, #manageObjectField, #manageObjectArrayField
	 */
	public <E extends Obj> void manageObjectSetField( String fieldName, HashSet<E> set ) {
		if( Sys.xMLGetMode() ) {
			XMLObject xMLSet = getField( fieldName );
			if( xMLSet != null ) xMLSet.manageChildSet( set );
		} else if( set != null ) {
			if( set.isEmpty() ) return;
			XMLObject xMLMap = new XMLObject();
			xMLMap.name = "Set";
			xMLMap.manageChildSet( set );
			setField( fieldName, xMLMap );
		}
	}



	/**
	 * Transfers data between XMLObject contents and framework object field with TList type.
	 * @see #manageListField, #manageChildArray, #xMLIO example
	 */
	public <E extends Obj> LinkedList<E> manageChildList( LinkedList<E> list ) {
		if( Sys.xMLGetMode() ) {
			list = new LinkedList<E>();
			for( XMLObject xMLObject: children ) {
				list.addLast( xMLObject.manageObject( (E) null ) );
			}
		} else if( list != null ) {
			children.clear();
			for( Obj obj: list ) {
				XMLObject xMLObject = new XMLObject();
				xMLObject.manageObject( obj );
				children.addLast( xMLObject );
			}
		}
		return list;
 	}



	/**
	 * Transfers data between XMLObject contents and framework object parameter with LTObject[] type.
	 * @see #manageChildList, #manageListField
	 */
	public <E extends Obj> E[] manageChildArray( E[] childArray ) {
		if( Sys.xMLGetMode() ) {
			childArray = (E[]) Array.newInstance( childArray.getClass(), children.size() );
			int n = 0;
			for( XMLObject xMLObject: children ) {
				childArray[ n ] = (E) xMLObject.manageObject( null );
				n += 1;
			}
		} else {
			for( Obj obj: childArray ) {
				XMLObject xMLObject = new XMLObject();
				xMLObject.manageObject( obj );
				children.addLast( xMLObject );
			}
		}
		return childArray;
	}



	/**
	 * Transfers data between XMLObject contents and framework object field with TMap type filled with LTObject-LTObject pairs.
	 * @see #manageObjectAttribute, #manageObjectField, #manageObjectArrayField
	 */
	public <E extends Obj, F extends Obj> HashMap<E, F> manageChildMap( HashMap<E, F> map ) {
		if( Sys.xMLGetMode() ) {
			map = new HashMap();
			for( XMLObject xMLObject: children ) {
				E key = null;
				xMLObject.manageObjectAttribute( "key", key );
				map.put( key, xMLObject.manageObject( (F) null ) );
			}
		} else {
			for( Entry<E, F> entry: map.entrySet() ) {
				XMLObject xMLValue = new XMLObject();
				xMLValue.manageObject( entry.getValue() );
				xMLValue.manageObjectAttribute( "key", entry.getKey() );
				children.addLast( xMLValue );
			}
		}
		return map;
	}



	/**
	 * Transfers data between XMLObject contents and framework object field with TMap type filled with LTObject keys.
	 * @see #manageObjectAttribute, #manageObjectField, #manageObjectArrayField
	 */
	public <E extends Obj> HashSet<E> manageChildSet( HashSet<E> set ) {
		if( Sys.xMLGetMode() ) {
			set = new HashSet<E>();
			for( XMLObject xMLObject: children ) {
				set.add( xMLObject.manageObject( (E) null ) );
			}
		} else {
			for( Obj obj: set ) {
				XMLObject xMLValue = new XMLObject();
				xMLValue.manageObject( obj );
				children.addLast( xMLValue );
			}
		}
		return set;
	}



	public <E extends Obj> E manageObject( E obj ) {
		if( Sys.xMLGetMode() ) {
			int iD = getIntegerAttribute( "id" );

			if( name.equals( "object" ) ) {
				obj = ( E ) iDArray[ iD ];
			} else {
				if( iD > 0 && iDArray[ iD ] != null ) {
					obj = ( E ) iDArray[ iD ];
				} else {
					try {
						Class objectClass = classes.get( name );;
						if( objectClass == null ) error( "Object \"" + name + "\" not found" );

						obj = ( E ) objectClass.newInstance();
					} catch ( InstantiationException ex ) {
						Logger.getLogger( XMLObject.class.getName() ).log( Level.SEVERE, null, ex );
					} catch ( IllegalAccessException ex ) {
						Logger.getLogger( XMLObject.class.getName() ).log( Level.SEVERE, null, ex );
					}
				}
				obj.xMLIO( this );
			}

			if( obj == null ) error( "Object with ID " + iD + " not found." );
		} else if( obj != null ) {
			int iD = 0;
			Object iDObj = iDMap.get( obj );
			if( iDObj != null ) iD = (Integer) iDObj;
			boolean undefined = undefinedObjects.contains( obj );
			if( iD > 0 && ! undefined ) {
				removeIDMap.remove( obj );
				name = "Object";
				setAttribute( "id", iD );
				return obj;
			} else {
				if( !undefined ) {
					iD = maxID;
					iDMap.put( obj, iD );
					maxID += 1;
					removeIDMap.put( obj, this );
				}

				setAttribute( "id", iD );

				obj.xMLIO( this );
			}
		}

		return obj;
	}



	public int escapingBackslash = 0;
	private static String text;
					
	public static XMLObject readFromFile( String fileName ) {
		File file = File.read( fileName );
		text = "";

		version = 0;
		while( true ) {
			String string = file.readLine();
			if( string == null ) break;
			text += string;
			if( version == 0 ) {
				int quote = text.indexOf( "\"", text.indexOf( "dwlab_version" ) );
				version = Service.versionToInt( text.substring( quote + 1, text.indexOf( "\"", quote + 1 ) ) );
			}
		}

		file.close();

		textPos = 0;
		return readObject( new StringWrapper( "" ) );
	}



	public void writeToFile( String fileName ) {
		File file = File.write( fileName );
		writeObject( file, "" );
		file.close();
	}



	public static XMLObject readObject( StringWrapper fieldName ) {
		XMLObject obj = new XMLObject();

		obj.readAttributes( fieldName );

		if( obj.type == Type.NORMAL ) {
			while( true ) {
				StringWrapper childFieldName = new StringWrapper( "" );
				XMLObject child = readObject( childFieldName );
				if( child.type == Type.EMPTY ) {
					if( child.name.equals( obj.name ) ) return obj;
					error( "Error in XML file - wrong closing tag \"" + child.name + "\", expected \"" + obj.name + "\"" );
				} else if( !childFieldName.value.isEmpty() ) {
					XMLObjectField objectField = new XMLObjectField();
					objectField.name = childFieldName.value;
					objectField.value = child;
					obj.fields.addLast( objectField );
				} else {
					obj.children.addLast( child );
				}
			}
		}
		return obj;
	}



	public void writeObject( File file, String indent ) {
		String st = indent + "<" + name;
		for( XMLAttribute attr: attributes ) {
			String newValue = "";
			for( int num=0; num < attr.value.length(); num++ ) {
				char character = attr.value.charAt( num );
				switch( character ) {
					case '\"':
					case '%':
						newValue += "%" + character;
						break;
					case '\n':
						newValue += "%n";
						break;
					default:
						newValue += character;
				}
			}
			st += " " + attr.name + "=\"" +newValue + "\"";
		}
		if( children.isEmpty() && fields.isEmpty() ) {
			file.writeLine( st + "/>" );
		} else {
			file.writeLine( st + ">" );
			//debugstop
			for( XMLObjectField objectField: fields ) {
				XMLAttribute attr = new XMLAttribute();
				attr.name = "field";
				attr.value = objectField.name;
				objectField.value.attributes.addFirst( attr );
				objectField.value.writeObject( file, indent + "\t" );
			}
			for( XMLObject xMLObject: children ) {
				xMLObject.writeObject( file, indent + "\t" );
			}
			file.writeLine( indent + "</" + name + ">" );
		}
	}



	public void readAttributes( StringWrapper fieldName ) {
		boolean readingContents = false;
		boolean readingName = true;
		boolean readingValue = false;
		char quotes = '0';
		int chunkBegin = -1;

		XMLAttribute attr = null;
		while( textPos < text.length() ) {
			if( quotes != '0' ) {
				if( quotes == text.charAt( textPos ) ) {
					quotes = '0';
					attr.value = text.substring( chunkBegin, textPos );

					if( attr.name.equals( "field" ) ) {
						fieldName.value = attr.value;
					} else {
						if( attr.name.equals( "id" ) ) maxID = Math.max( maxID, Integer.parseInt( attr.value ) );
						attributes.addLast( attr );
					}

					readingValue = false;
					chunkBegin = -1;
				} else if( text.charAt( textPos ) == '%' ) {
					switch( text.charAt( textPos + 1 ) ) {
						case '\"':
						case '%':
							text = text.substring( 0, textPos ) + text.substring( textPos + 1);
							break;
						case 'n' :
							text = text.substring( 0, textPos ) + "\r\n" + text.substring( textPos + 2 );
							break;
					}
				}
			} else {
				if( text.charAt( textPos ) == '\'' || text.charAt( textPos ) == '\"' ) {
					if( ! readingValue ) error( "Error in XML file - unexpected  quotes" + text.substring( 0, textPos ) );

					chunkBegin = textPos + 1;
					quotes = text.charAt( textPos );
				} else if( text.charAt( textPos ) == '<' ) {
					if( readingContents || readingValue ) error( "Error in XML file - unexpected beginning of tag" + text.substring( 0, textPos ) );

					readingContents = true;
				} else if( iDSym( text.charAt( textPos ) ) ) {
					if( chunkBegin < 0 ) chunkBegin = textPos;

					if( type != Type.NORMAL && ! readingName ) error( "Error in XML file - invalid closing  tag" + text.substring( 0, textPos ) );
				} else {
					if( text.charAt( textPos ) == '=' && readingName || readingValue ) error( "Error in XML file - unexpected \"=\" " + text.substring( 0, textPos ) );

					if( chunkBegin >= 0 ) {
						if( readingName ) {
							name = text.substring( chunkBegin, textPos );
							readingName = false;
						} else if( readingValue ) {
							attr.value = text.substring( chunkBegin, textPos );

							if( attr.name.equals( "field" ) ) {
								fieldName.value = attr.value;
							} else {
								if( attr.name.equals( "id" ) ) maxID = Math.max( maxID, Integer.parseInt( attr.value ) );
								attributes.addLast( attr );
							}

							readingValue = false;
						} else {
							attr = new XMLAttribute();
							attr.name = text.substring( chunkBegin, textPos );
							readingValue = true;
						}
						chunkBegin = -1;
					}

					if( text.charAt( textPos ) == '/' ) {
						if( readingValue || type != Type.NORMAL  ) error( "Error in XML file - unexpected  slash" + text.substring( 0, textPos ) );

						if( readingName ) type = Type.EMPTY; else type = Type.CLOSED;
					}

					if( text.charAt( textPos ) == '>' ) {
						if( ! readingContents || readingValue || readingName ) error("Error in XML file - unexpected end of  tag" + text.substring( 0, textPos ) );

						textPos += 1;
						return;
					}
				}
			}

			textPos += 1;
		}
	}


	public static boolean iDSym( char sym ) {
		if( sym >= 'a' && sym <= 'z' ) return true;
		if( sym >= 'A' && sym <= 'Z' ) return true;
		if( sym >= '0' && sym <= '9' ) return true;
		if( sym == '_' || sym == '-' ) return true;
		return false;
	}
	
	
	public static class StringWrapper {
		String value;
		
		StringWrapper( String value ) {
			this.value = value;
		}
	}
}