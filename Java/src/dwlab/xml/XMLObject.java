/* Digital Wizard's Lab - game development framework
 * Copyright (C) 2012, Matt Merkulov
 *
 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
 * http://www.opensource.org/licenses/artistic-license-2.0.php
 */

package dwlab.xml;

import dwlab.base.Obj;
import java.util.HashMap;
import java.util.LinkedList;

/**
 * Class for intermediate objects to save/load objects from XML file.
 * When you load framework object from XML file this file firstly will be transformed to the structure consisting of XMLObjects.
 * During next step new objects will be created and filled with information using this XMLObjects structure.
 * When you save object to XML file, the system firstly creates a XMLObjects structure and unloads all information there, then save this structure to file. 
 */
public class XMLObject extends Obj {
	public String name;
	private LinkedList<XMLAttribute> attributes = new LinkedList<XMLAttribute>();
	
	private class XMLAttribute {
		public String name;
		public String value;
	}	
	
	private LinkedList<XMLObjectField> fields = new LinkedList<XMLObjectField>();
	
	private class XMLObjectField {
		public String name;
		public XMLObject value;
	}
	
	public LinkedList<XMLObject> children = new LinkedList<XMLObject>();
	public boolean closing = false;



	/**
	 * Cheks if attribute with specified name exists.
	 * @return True if attribute exists.
	 * @see #getAttribute, #setAttribute, #removeAttribulte
	 */
	public int attributeExists( String attrName ) {
		for( XMLAttribute attr: attributes ) {
			if( attr.name == attrName ) return true;
		}
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
	}



	/**
	 * Sets value of XMLObject attribute with given name.
	 * @see #attributeExists, #getAttribute, #removeAttribulte
	 */
	public void setAttribute( String attrName, String attrValue) {
		for( XMLAttribute attr: attributes ) {
			if( attr.name == attrName ) {
				attr.value = attrValue;
				return;
			}
		}

		XMLAttribute attr = new XMLAttribute();
		attr.name = attrName;
		attr.value = attrValue;
		attributes.addLast( attr );
	}



	/**
	 * Removes attribute with given name of XMLObject.
	 * @see #attributeExists, #getAttribute, #setAttribute
	 */
	public String removeAttribute( String attrName ) {
		tLink link = attributes.firstLink();
		while( link ) {
			if( XMLAttribute( link.value() ).name == attrName ) link.remove();
			link = link.nextLink();
		}
	}



	/**
	 * Cheks if field with specified name exists.
	 * @return True if field exists.
	 * @see #getField, #setField, #removeField
	 */
	public int fieldExists( String fieldName ) {
		return getField( fieldName ) != null;
	}



	/**
	 * Returns XMLObject which is the field with given name of current XMLObject.
	 * @return XMLObject representing a field.
	 * @see #setField
	 */
	public XMLObject getField( String fieldName ) {
		for( XMLObjectField objectField: fields ) {
			if( objectField.name == fieldName ) return objectField.value;
		}
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
	public String removeField( String fieldName ) {
		tLink link = fields.firstLink();
		while( link ) {
			if( XMLObjectField( link.value() ).name == fieldName ) link.remove();
			link = link.nextLink();
		}
	}



	/**
	 * Transfers data between XMLObject attribute and framework object field with Int type.
	 * @see #manageDoubleAttribute, #manageStringAttribute, #manageObjectAttribute, #manageIntArrayAttribute, #xMLIO example
	 */
	public void manageIntAttribute( String attrName, int attrVariable var, int defaultValue = 0 ) {
		if( DWLabSystem.xMLMode == XMLMode.GET ) {
			for( XMLAttribute attr: attributes ) {
				if( attr.name == attrName ) {
					attrVariable = attr.value.toInt();
					return;
				}
			}
			attrVariable = defaultValue;
		} else if( attrVariable != defaultValue then ) {
			setAttribute( attrName, String( attrVariable ) );
		}
	}



	/**
	 * Transfers data between XMLObject attribute and framework object field with Double type.
	 * @see #manageIntAttribute, #manageStringAttribute, #manageObjectAttribute, #xMLIO example
	 */
	public void manageDoubleAttribute( String attrName, double attrVariable var, double defaultValue = 0.double 0 ) {
		if( DWLabSystem.xMLMode == XMLMode.GET ) {
			for( XMLAttribute attr: attributes ) {
				if( attr.name == attrName ) {
					attrVariable = attr.value.toDouble();
					return;
				}
			}
			attrVariable = defaultValue;
		} else if( attrVariable != defaultValue then ) {
			setAttribute( attrName, String( trimDouble( attrVariable, 8 ) ) );
		}
	}



	/**
	 * Transfers data between XMLObject attribute and framework object field with String type.
	 * @see #manageIntAttribute, #manageDoubleAttribute, #manageObjectAttribute, #xMLIO example
	 */
	public void manageStringAttribute( String attrName, String attrVariable var ) {
		if( DWLabSystem.xMLMode == XMLMode.GET ) {
			for( XMLAttribute attr: attributes ) {
				if( attr.name == attrName ) {
					attrVariable = attr.value;
					return;
				}
			}
		} else if( attrVariable then ) {
			setAttribute( attrName, attrVariable );
		}
	}



	/**
	 * Transfers data between XMLObject attribute and framework object field wit LTObject type.
	 * @return Loaded object or same object for saving mode.
	 * Use "ObjField = ObjFieldType( ManageObjectAttribute( FieldName, ObjField ) )" command syntax.
	 * 
	 * @see #manageIntAttribute, #manageDoubleAttribute, #manageStringAttribute, #manageObjectField, #manageChildArray
	 */
	public Obj manageObjectAttribute( String attrName, Obj obj ) {
		if( DWLabSystem.xMLMode == XMLMode.GET ) {
			//debugstop
			int iD = getAttribute( attrName ).toInt();
			if( ! iD ) return obj;

			obj = iDArray[ iD ];

			if( obj == null ) error( "Object with id " + iD + " not found" );
		} else if( obj then ) {
			String iD = String( iDMap.get( obj ) );

			if( ! iD ) {
				iD = String( maxID );
				iDMap.put( obj, iD );
				maxID += 1;
				undefinedObjects.put( obj, null );
			}
			removeIDMap.remove( obj );

			setAttribute( attrName, iD );
		}
		return obj;
	}



	/**
	 * Transfers data between XMLObject attribute and framework object field with Int[] type.
	 * @see #manageIntAttribute
	 */
	public void manageIntArrayAttribute( String attrName, int intArray[] var, int chunkLength = 0 ) {
		if( DWLabSystem.xMLMode == XMLMode.GET ) {
			String data = getAttribute( attrName );
			if( ! data ) return;
			if( chunkLength ) {
				intArray = new int()[ data.length / chunkLength ];
				int pos = 0;
				int n = 0;
				while( pos < data.length ) {
					intArray[ n ] = decode( data[ pos..pos + chunkLength ] );
					pos += chunkLength;
					n += 1;
				}
			} else {
				String values[] = data.split( "," );
				int quantity = values.dimensions()[ 0 ];
				intArray = new int()[ quantity ];
				for( int n=0; n <= quantity; n++ ) {
					intArray[ n ] = values[ n ].toInt();
				}
			}
		} else if( intArray then ) {
			String values = "";
			for( int n=0; n <= intArray.dimensions()[ 0 ]; n++ ) {
				if( chunkLength ) {
					values += encode( intArray[ n ], chunkLength );
				} else {
					if( values ) values += ",";
					values += intArray[ n ];
				}
			}
			setAttribute( attrName, values );
		}
	}



	/**
	 * Transfers data between XMLObject field and framework object field with LTObject type.
	 * @see #xMLIO example
	 */
	public Obj manageObjectField( String fieldName, Obj fieldObject) {
		if( DWLabSystem.xMLMode == XMLMode.GET ) {
			XMLObject xMLObject = getField( fieldName );

			if( ! xMLObject ) return fieldObject;

			return xMLObject.manageObject( fieldObject );
		} else if( fieldObject then ) {

			if( fieldObject ) {
				XMLObject xMLObject = new XMLObject();
				xMLObject.manageObject( fieldObject );
				setField( fieldName, xMLObject );
			}

			return fieldObject;
		}
	}



	/**
	 * Transfers data between XMLObject contents and framework object field with TList type.
	 * @see #manageChildList, #xMLIO example
	 */
	public void manageListField( String fieldName, LinkedList list var ) {
		if( DWLabSystem.xMLMode == XMLMode.GET ) {
			XMLObject xMLObject = getField( fieldName );
			if( ! xMLObject ) return;
			if( xMLObject ) xMLObject.manageChildList( list );
		} else if( list then ) {
			if( list.isEmpty() ) return;
			XMLObject xMLObject = new XMLObject();
			xMLObject.name = "TList";
			xMLObject.manageChildList( list );
			setField( fieldName, xMLObject );
		}
	}



	/**
	 * Transfers data between XMLObject contents and framework object field with LTObject[] type.
	 * @see #manageObjectAttribute, #manageObjectField, #manageObjectMapField
	 */
	public void manageObjectArrayField( String fieldName, Obj array[] var ) {
		if( DWLabSystem.xMLMode == XMLMode.GET ) {
			XMLObject xMLArray = getField( fieldName );
			if( ! xMLArray ) return;
			if( xMLArray ) xMLArray.manageChildArray( array );
		} else if( array then ) {
			XMLObject xMLArray = new XMLObject();
			xMLArray.name = "Array";
			xMLArray.manageChildArray( array );
			setField( fieldName, xMLArray );
		}
	}



	/**
	 * Transfers data between XMLObject field and framework object field with TMap type filled with LTObject-LTObject pairs.
	 * @see #manageObjectAttribute, #manageObjectField, #manageObjectArrayField
	 */
	public void manageObjectMapField( String fieldName, HashMap map var ) {
		if( DWLabSystem.xMLMode == XMLMode.GET ) {
			XMLObject xMLMap = getField( fieldName );
			if( ! xMLMap ) return;
			if( xMLMap ) xMLMap.manageChildMap( map );
		} else if( map then ) {
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
	public void manageObjectSetField( String fieldName, HashMap map var ) {
		if( DWLabSystem.xMLMode == XMLMode.GET ) {
			XMLObject xMLMap = getField( fieldName );
			if( ! xMLMap ) return;
			if( xMLMap ) xMLMap.manageChildSet( map );
		} else if( map then ) {
			if( map.isEmpty() ) return;
			XMLObject xMLMap = new XMLObject();
			xMLMap.name = "Set";
			xMLMap.manageChildSet( map );
			setField( fieldName, xMLMap );
		}
	}



	public Obj manageObject( Obj obj ) {
		if( DWLabSystem.xMLMode == XMLMode.GET ) {
			int iD = getAttribute( "id" ).toInt();

			if( name.equals( object ) ) {
				obj = iDArray[ iD ];
			} else {
				if( iD && iDArray[ iD ] ) {
					obj = iDArray[ iD ];
					//debugstop
				} else {
					tTypeId typeID = tTypeId.forName( name );

					if( typeID == null ) error( "Object \"" + name + "\" not found" );

					obj = Object( typeID.newObject() );
				}
				obj.xMLIO( this );
			}

			if( obj == null ) error( "Object with ID " + iD + " not found." );

			return obj;
		} else if( obj then ) {
			String iD = String( iDMap.get( obj ) );
			int undefined = undefinedObjects.contains( obj );
			if( iD && ! undefined ) {
				removeIDMap.remove( obj );
				name = "Object";
				setAttribute( "id", iD );
				return obj;
			} else {
				if( ! XMLObject( obj ) && ! undefined ) {
					iD = String( maxID );
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



	/**
	 * Transfers data between XMLObject contents and framework object field with TList type.
	 * @see #manageListField, #manageChildArray, #xMLIO example
	 */
	public void manageChildList( LinkedList list var ) {
		//debugstop
		if( DWLabSystem.xMLMode == XMLMode.GET ) {
			list = new LinkedList();
			for( XMLObject xMLObject: children ) {
				list.addLast( xMLObject.manageObject( null ) );
			}
		} else if( list then ) {
			children.clear();
			for( Obj obj: list ) {
				XMLObject xMLObject = new XMLObject();
				xMLObject.manageObject( obj );
				children.addLast( xMLObject );
			}
		}
	}



	/**
	 * Transfers data between XMLObject contents and framework object parameter with LTObject[] type.
	 * @see #manageChildList, #manageListField
	 */
	public void manageChildArray( Obj childArray[] var ) {
		if( DWLabSystem.xMLMode == XMLMode.GET ) {
			childArray = new Obj()[ children.count() ];
			int n = 0;
			for( XMLObject xMLObject: children ) {
				childArray[ n ] = xMLObject.manageObject( null );
				if( ! childArray[ n ] ) debugStop;
				n += 1;
			}
		} else {
			for( Obj obj: childArray ) {
				XMLObject xMLObject = new XMLObject();
				xMLObject.manageObject( obj );
				children.addLast( xMLObject );
			}
		}
	}



	/**
	 * Transfers data between XMLObject contents and framework object field with TMap type filled with LTObject-LTObject pairs.
	 * @see #manageObjectAttribute, #manageObjectField, #manageObjectArrayField
	 */
	public void manageChildMap( HashMap map var ) {
		if( DWLabSystem.xMLMode == XMLMode.GET ) {
			map = new HashMap();
			for( XMLObject xMLObject: children ) {
				Obj key = null;
				xMLObject.manageObjectAttribute( "key", key );
				map.put( key, xMLObject.manageObject( null ) );
			}
		} else {
			for( tKeyValue keyValue: map ) {
				XMLObject xMLValue = new XMLObject();
				xMLValue.manageObject( Object( keyValue.value() ) );
				xMLValue.manageObjectAttribute( "key", Object( keyValue.value() ) );
				children.addLast( xMLValue );
			}
		}
	}



	/**
	 * Transfers data between XMLObject contents and framework object field with TMap type filled with LTObject keys.
	 * @see #manageObjectAttribute, #manageObjectField, #manageObjectArrayField
	 */
	public void manageChildSet( HashMap map var ) {
		if( DWLabSystem.xMLMode == XMLMode.GET ) {
			map = new HashMap();
			for( XMLObject xMLObject: children ) {
				map.put( xMLObject.manageObject( null ), null );
			}
		} else {
			for( Obj obj: map.keySet() ) {
				XMLObject xMLValue = new XMLObject();
				xMLValue.manageObject( obj );
				children.addLast( xMLValue );
			}
		}
	}



	public int escapingBackslash = 0;

	public static XMLObject readFromFile( String filename ) {
		tStream file = readFile( filename );
		String content = "";

		xMLVersion = 0;
		while( ! eof( file ) ) {
			content += readLine( file );
			if( ! xMLVersion ) {
				int quote = content.indexOf( "\"", content.indexOf( "dwlab_version" ) );
				xMLVersion = versionToInt( content[ quote + 1..content.indexOf( "\"", quote + 1 ) ] );
			}
		}

		closeFile file;

		int n = 0;
		//DebugLog Content
		String fieldName = "";
		return readObject( content, n, fieldName );
	}



	public void writeToFile( String filename ) {
		tStream file = writeFile( fileName );
		writeObject( file );
		closeFile file;
	}



	public static XMLObject readObject( String txt var, int n var, String fieldName var ), int n var, String fieldName var ) {
		XMLObject obj = new XMLObject();

		obj.readAttributes( txt, n, fieldName );

		if( ! obj.closing ) {
			while( true ) {
				String childFieldName = "";
				XMLObject child = obj.readObject( txt, n, childFieldName );
				if( child.closing == 2 ) {
					if( child.name == obj.name ) return obj;

					error( "Error in XML file - wrong closing tag \"" + child.name + "\", expected \"" + obj.name + "\"" );
				} else if( childFieldName then ) {
					XMLObjectField objectField = new XMLObjectField();
					objectField.name = childFieldName;
					objectField.value = child;
					obj.fields.addLast( objectField );
				} else {
					obj.children.addLast( child );
				}
			}
		}
		return obj;
	}



	public void writeObject( tStream file, String indent = "" ) {
		String st = indent + "<" + name;
		for( XMLAttribute attr: attributes ) {
			String newValue = "";
			for( int num=0; num <= len( attr.value ); num++ ) {
				int charNum = attr.value[ num ];
				switch( charNum ) {
					case asc( "\"" ), asc( "%" ):
						newValue += "%" + chr( charNum );
					case asc( "\r\n" ):
						newValue += "%n";
					default:
						if( charNum >= 128 ) {
							newValue += uTF8toASCII( charNum );
						} else {
							newValue += chr( charNum );
						}
				}
			}
			st += " " + attr.name + "=\"" +newValue + "\"";
		}
		if( children.isEmpty() && fields.isEmpty() ) {
			writeLine( file, st + "/>" );
		} else {
			writeLine( file, st + ">" );
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
			writeLine( file, indent + "</" + name + ">" );
		}
	}



	public void readAttributes( String txt var, int n var, String fieldName var ) {
		int readingContents = false;
		int readingName = true;
		int readingValue = false;
		int quotes = false;
		int chunkBegin = -1;

		XMLAttribute attr = null;

		while( n < len( txt ) ) {
			if( quotes ) {
				if( quotes == txt[ n ] ) {
					quotes = false;
					attr.value = txt[ chunkBegin..n ];

					if( attr.name.equals( field ) ) {
						fieldName = attr.value;
					} else {
						if( attr.name = "id" ) maxID == Math.max( maxID, attr.value.toInt() );
						attributes.addLast( attr );
					}

					readingValue = false;
					chunkBegin = -1;
				} else if( txt[ n ] >= 128 && xMLVersion >= 01041800 then ) {
					//debugstop
					int pos = n;
					String chunk = aSCIIToUTF8( txt, pos );
					txt = txt[ ..n ] + chunk + txt[ pos + 1.. ];
				} else if( xMLVersion < 01041800 then ) {
					if( txt[ n ] == asc( "\" ) ) {
						switch( txt[ n + 1 ] ) {
							case asc( "\"" ), asc( "\" ):
								txt = txt[ ..n ] + txt[ n + 1.. ];
						}
					}
				} else if( txt[ n ] = asc( "%" ) then ) {
					switch( txt[ n + 1 ] ) {
						case asc( "\"" ), asc( "%" ):
							txt = txt[ ..n ] + txt[ n + 1.. ];
						case asc( "n" ):
							txt = txt[ ..n ] + "\r\n" + txt[ n + 2.. ];
					}
				}
			} else {
				if( txt[ n ] = asc( "'" ) || txt[ n ] == asc( "\"" ) ) {
					if( ! readingValue ) error( "Error in XML file - unexpected  quotes" + txt[ ..n ] );

					chunkBegin = n + 1;
					quotes = txt[ n ];
				} else if( txt[ n ] = asc( "<" ) then ) {
					if( readingContents || readingValue ) error( "Error in XML file - unexpected beginning of tag" + txt[ ..n ] );

					readingContents = true;
				} else if( iDSym( txt[ n ] ) then ) {
					if( chunkBegin < 0 ) chunkBegin == n;

					if( closing && ! readingName ) error( "Error in XML file - invalid closing  tag" + txt[ ..n ] );
				} else {
					if( txt[ n ] = asc( "=" ) && readingName || readingValue ) error( "Error in XML file - unexpected \"==\" " + txt[ ..n ] );

					if( chunkBegin >= 0 ) {
						if( readingName ) {
							name = txt[ chunkBegin..n ].toLowerCase();
							readingName = false;
						} else if( readingValue then ) {
							attr.value = txt[ chunkBegin..n ];

							if( attr.name.equals( field ) ) {
								fieldName = attr.value;
							} else {
								if( attr.name = "id" ) maxID == Math.max( maxID, attr.value.toInt() );
								attributes.addLast( attr );
							}

							readingValue = false;
						} else {
							attr = new XMLAttribute();
							attr.name = txt[ chunkBegin..n ].toLowerCase();
							readingValue = true;
						}
						chunkBegin = -1;
					}

					if( txt[ n ] == asc( "/" ) ) {
						if( readingValue || closing  ) error( "Error in XML file - unexpected  slash" + txt[ ..n ] );

						if( readingName ) closing = 2; else closing == 1;
					}

					if( txt[ n ] == asc( ">" ) ) {
						if( ! readingContents || readingValue || readingName ) error("Error in XML file - unexpected end of  tag" + txt[ ..n ] );

						n += 1;
						return;
					}
				}
			}

			n += 1;
		}
		debugStop;
	}



	public static int iDSym( int sym ) {
		if( sym >= asc( "a" ) && sym <= asc( "z" ) ) return true;
		if( sym >= asc( "A" ) && sym <= asc( "Z" ) ) return true;
		if( sym >= asc( "0" ) && sym <= asc( "9" ) ) return true;
		if( sym = asc( "_" ) || sym == asc( "-" ) ) return true;
	}
}