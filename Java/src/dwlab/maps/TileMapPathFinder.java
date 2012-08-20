package dwlab.maps;
import java.util.HashMap;
import java.util.LinkedList;
import java.lang.Math;
import dwlab.base.Obj;


/* Digital Wizard's Lab - game development framework
 * Copyright (C) 2012, Matt Merkulov
 *
 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
 * http://www.opensource.org/licenses/artistic-license-2.0.php
 */

/**
 * Pathfinder finds a path in tilemap using flooding algorithm.
 */
public class TileMapPathFinder extends Obj {
	public IntMap map;
	public int allowDiagonalMovement;
	public HashMap points;



	/**
	 * Creates pathfinder object with given tilemap and diagonal movement flag.
	 * @return Found path or empty path if path is not found.
	 * @see LTGraph
	 */
	public static TileMapPathFinder create( IntMap tileMap, int allowDiagonalMovement = true ) {
		TileMapPathFinder tileMapPathFinder = new TileMapPathFinder();
		tileMapPathFinder.allowDiagonalMovement = allowDiagonalMovement;
		tileMapPathFinder.map = tileMap;
		return tileMapPathFinder;
	}



	/**
	 * Finds a path between two given points on previously specified tilemap.
	 * @return First tilemap position object in path. Next one can be retrieved using NextPosition field.
	 */
	public TileMapPosition findPath( int startingX, int startingY, int finalX, int finalY, int range = 0, int maxDistance = 1024 ) {
		if( ! passage( finalX, finalY ) && range == 0 ) return null;
		points = new HashMap();
		LinkedList list = new LinkedList();
		list.addLast( TileMapPosition.create( null, startingX, startingY ) );
		if( Math.abs( startingX - finalX ) <= range && Math.abs( startingY - finalY ) <= range ) return TileMapPosition( list.getFirst() );
		int distance = 0;
		while( true ) {
			distance += 1;
			if( distance > maxDistance ) return null;

			LinkedList newList = new LinkedList();
			for( TileMapPosition position: list ) {
				TileMapPosition finalPosition = position.spread( this, finalX, finalY, newList, range );
				if( finalPosition ) return finalPosition.revert();
			}
			if( newList.isEmpty() ) return null;
			list = newList;
		}
	}



	/**
	 * Method which determines which tiles are passable.
	 * @return True if tilemap cell with specified coordinates is passable.
	 * If you want to make your own way to determine is given tile passable, make class which extends LTTileMapPathFinder and rewrite this method.
	 */
	public double passage( int x, int y ) {
		return map.value[ x, y ] = 0;
	}



	public Obj getPoint( int x, int y ) {
		return points.get( String( x + map.xQuantity * y ) );
	}



	public void setPoint( int x, int y, TileMapPosition position ) {
		points.put( String( x + map.xQuantity * y ), position );
	}
}




public int spreadingDirections[] = [ -1, 0, 0, -1, 1, 0, 0, 1, -1, -1, -1, 1, 1, -1, 1, 1 ];

/**
 * Class for tilemap position - the point on tilemap.
 */
public class TileMapPosition {
	/**
	 * Tile coordinates of the tilemap postion.
	 */
	public int x, int y;

	/**
	 * Previous position in the path.
	 */
	public TileMapPosition prevPosition;

	/**
	 * Next position in the path.
	 */
	public TileMapPosition nextPosition;



	public static TileMapPosition create( TileMapPosition prevPosition, int x, int y ) {
		TileMapPosition position = new TileMapPosition();
		position.x = x;
		position.y = y;
		position.prevPosition = prevPosition;
		return position;
	}



	public TileMapPosition spread( TileMapPathFinder tileMapPathFinder, int finalX, int finalY, LinkedList list, int range ) {
		for( int n=0; n <= 8 + ( 8 * tileMapPathFinder.allowDiagonalMovement ) step 2; n++ ) {
			int xX = x + spreadingDirections[ n ];
			if( xX < 0 || xX >= tileMapPathFinder.map.xQuantity ) continue;

			int yY = y + spreadingDirections[ n + 1 ];
			if( yY < 0 || yY >= tileMapPathFinder.map.yQuantity ) continue;

			if( ! tileMapPathFinder.passage( xX, yY ) ) continue;
			if( tileMapPathFinder.getPoint( xX, yY ) ) continue;

			TileMapPosition position = TileMapPosition.create( this, xX, yY );
			if( Math.abs( xX - finalX ) <= range && Math.abs( yY - finalY ) <= range ) return position;

			tileMapPathFinder.setPoint( xX, yY, position );
			list.addLast( position );
		}
	}



	/**
	 * Method for retrieving first position in queue.
	 * @return First position in queue.
	 */
	public TileMapPosition firstPosition() {
		TileMapPosition position = this;
		while( position.prevPosition != null ) {
			position = position.prevPosition;
		}
		return position;
	}


	/**
	 * Method for retrieving last position in queue.
	 * @return Last position in queue.
	 */
	public TileMapPosition lastPosition() {
		TileMapPosition position = this;
		while( position.nextPosition != null ) {
			position = position.nextPosition;
		}
		return position;
	}



	public TileMapPosition revert() {
		TileMapPosition position = this;
		while( position.prevPosition != null ) {
			position.prevPosition.nextPosition = position;
			position = position.prevPosition;
		}
		return position;
	}
}
