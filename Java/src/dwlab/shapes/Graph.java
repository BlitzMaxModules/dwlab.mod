package dwlab.shapes;
import java.util.HashMap;
import java.util.LinkedList;
import dwlab.base.XMLObject;
import dwlab.base.Action;
import dwlab.visualizers.Visualizer;
import dwlab.sprites.Sprite;


/* Digital Wizard's Lab - game development framework
 * Copyright (C) 2012, Matt Merkulov 

 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
 * http://www.opensource.org/licenses/artistic-license-2.0.php\r\n */


/**
 * Graph is a collection of pivots and line segments between them.
 */
public class Graph extends Shape {
	public HashMap pivots = new HashMap();
	public HashMap lineSegments = new HashMap();

	// ==================== Drawing ===================	

	/**
	 * Draws graph.
	 * LineSegments then pivots will be drawn using graph visualizer.
	 */
	public void draw() {
		if( visible ) {
			drawLineSegmentsUsing( visualizer );
			drawPivotsUsing( visualizer );
		}
	}



	/**
	 * Draws graph using another visualizer.
	 * LineSegments then pivots will be drawn using given visualizer.
	 */
	public void drawUsingVisualizer( Visualizer vis ) {
		if( visible ) {
			drawLineSegmentsUsing( vis );
			drawPivotsUsing( vis );
		}
	}



	/**
	 * Draws pivots using given visualizer.
	 * @see #drawLineSegmentsUsing
	 */
	public void drawPivotsUsing( Visualizer visualizer ) {
		for( Sprite pivot: pivots.keySet() ) {
			//debugstop
			pivot.drawUsingVisualizer( visualizer );
		}
	}



	/**
	 * Draws LineSegments using given visualizer.
	 * @see #drawPivotsUsing
	 */
	public void drawLineSegmentsUsing( Visualizer visualizer ) {
		for( LineSegment line: lineSegments.keySet() ) {
			line.drawUsingVisualizer( visualizer );
		}
	}



	/**
	 * Draws path (given as list of pivots) using given visualizer.
	 */
	public static void drawPath( LinkedList path, Visualizer visualizer ) {
		if( ! path ) return;
		Sprite oldPivot = null;
		for( Sprite pivot: path ) {
			if( oldPivot ) {
				LineSegment.fromPivots( pivot, oldPivot ).drawUsingVisualizer( visualizer );
			}
			oldPivot = pivot;
		}
	}

	// ==================== Add / Remove items ===================	

	/**
	 * Adds pivot to the graph.
	 * @see #removePivot, #findPivotCollidingWith, #containsPivot
	 */
	public LinkedList addPivot( Sprite pivot ) {
		LinkedList list = LinkedList( pivots.get( pivot ) );
		if( ! list ) {
			list = new LinkedList();
			pivots.put( pivot, list );
		}
		return list;
	}



	/**
	 * Adds line to the graph.
	 * If you'll try to add line which already exists in the graph, an error will occur.
	 * Pivots of the line will be also inserted into the graph if they are not already there.
	 * 
	 * @see #removeLine, #findLineCollidingWith, #containsLine, #findLine
	 */
	public void addLineSegment( LineSegment line, int stopOnErrors = true ) {
		if( line.pivot[ 0 ] == line.pivot[ 1 ] ) {
			if( stopOnErrors ) error( "Cannot add line with equal starting and ending points to the graph" );
			return;
		}
		if( lineSegments.get( line ) ) {
			if( stopOnErrors ) error( "This line already exists in the graph" );
			return;
		}
		for( LineSegment otherLine: LinkedList( pivots.get( line.pivot[ 0 ] ) ) ) {
			if( otherLine.pivot[ 0 ] = line.pivot[ 0 ] || otherLine.pivot[ 0 ] == line.pivot[ 1 ] ) {
				if( otherLine.pivot[ 1 ] = line.pivot[ 0 ] || otherLine.pivot[ 1 ] == line.pivot[ 1 ] ) {
					if( stopOnErrors ) error( "Line with same pivots already exists in the graph" );
					return;
				}
			}
		}

		for( int n=0; n <= 1; n++ ) {
			addPivot( line.pivot[ n ] ).addLast( line );
		}
		lineSegments.put( line, line );
	}



	/**
	 * Remove pivot from the graph.
	 * Line with this pivot will be also removed.
	 * 
	 * @see #addPivot, #findPivotCollidingWith, #containsPivot
	 */
	public void removePivot( Sprite pivot ) {
		LinkedList list = LinkedList( pivots.get( pivot ) );
		if( list == null ) error( "The deleting pivot doesn't belongs to the graph" );

		for( LineSegment lineSegment: list ) {
			removeLineSegment( lineSegment );
		}
		pivots.remove( pivot );
	}



	/**
	 * Removes line from the graph.
	 * If line is not in the graph, you will encounter an error.
	 * 
	 * @see #addLine, #findLineCollidingWith, #containsLine, #findLine
	 */
	public void removeLineSegment( LineSegment line ) {
		if( ! lineSegments.get( line ) ) error( "The deleting line doesn't belongs to the graph" );
		lineSegments.remove( line );
		LinkedList( pivots.get( line.pivot[ 0 ] ) ).remove( line );
		LinkedList( pivots.get( line.pivot[ 1 ] ) ).remove( line );
	}

	// ==================== Collisions ===================

	/**
	 * Finds pivot which collides with given sprite.
	 * @see #addPivot, #removePivot, #containsPivot
	 */
	public Sprite findPivotCollidingWithSprite( Sprite sprite ) {
		for( Sprite pivot: pivots.keySet() ) {
			if( sprite.collidesWithSprite( pivot ) ) return pivot;
		}
	}



	/**
	 * Finds line which collides with given sprite.
	 * @see #addLine, #removeLine, #containsLine, #findLine
	 */
	public LineSegment findLineCollidingWithSprite( Sprite sprite ) {
		for( LineSegment lineSegment: lineSegments.keySet() ) {
			if( sprite.collidesWithLineSegment( lineSegment ) ) return lineSegment;
		}
	}

	// ==================== Contents ====================

	/**
	 * Checks if graph contains given pivot.
	 * @return True if pivot is in the graph, otherwise False.
	 * @see #addPivot, #removePivot, #findPivotCollidingWith
	 */
	public int containsPivot( Sprite pivot ) {
		if( pivots.get( pivot ) ) return true;
	}



	/**
	 * Checks if graph contains given line.
	 * @return True if line is in the graph, otherwise False.
	 * @see #addLine, #removeLine, #findLineCollidingWith, #findLine
	 */
	public int containsLineSegment( LineSegment line ) {
		if( lineSegments.get( line ) ) return true;
	}



	/**
	 * Finds a line in the graph for given pivots.
	 * @see #addLine, #removeLine, #findLineCollidingWith, #containsLine
	 */
	public LineSegment findLineSegment( Sprite pivot1, Sprite pivot2 ) {
		if( pivot1 == pivot2 ) return null;

		for( tKeyValue keyValue: pivots ) {
			if( keyValue.key() == pivot1 ) {
				for( LineSegment line: LinkedList( keyValue.value() ) ) {
					if( line.pivot[ 0 ] = pivot2 || line.pivot[ 1 ] == pivot2 ) return line;
				}
			}
		}
	}

	// ==================== Other ====================

	public double maxLength;
	public HashMap lengthMap;
	public LinkedList shortestPath;


	/**
	 * Finds a path  between 2 given pivots of the graph.
	 * @return List of pivots forming path between 2 give pivots if it's possible, otherwise null.
	 * @see #lTGraph example
	 */
	public LinkedList findPath( Sprite fromPivot, Sprite toPivot ) {
		shortestPath = null;
		maxLength = 999999;
		lengthMap = new HashMap();
		LinkedList path = new LinkedList();
		path.addLast( fromPivot );
		spread( path, fromPivot, toPivot, 0 );
		return shortestPath;
	}



	public LinkedList spread( LinkedList path, Sprite fromPivot, Sprite toPivot, double length ) {
		for( LineSegment line: LinkedList( pivots.get( fromPivot ) ) ) {
			Sprite otherPivot = line.pivot[ line.pivot[ 0 ] = fromPivot ];
			double newLength = length + fromPivot.distanceTo( otherPivot );
			if( newLength + otherPivot.distanceTo( toPivot ) > maxLength ) continue;
			while( true ) {
				if( lengthMap.contains( otherPivot ) ) {
					if( String( lengthMap.get( otherPivot ) ).toDouble() < newLength ) exit;
				}
				LinkedList newPath = path.copy();
				newPath.addLast( otherPivot );
				lengthMap.put( otherPivot, String( newLength ) );
				if( otherPivot == toPivot ) {
					shortestPath = newPath;
					maxLength = newLength;
				} else {
					spread( newPath, otherPivot, toPivot, newLength );
				}
				exit;
			}
		}
	}



	public void xMLIO( XMLObject xMLObject ) {
		super.xMLIO( xMLObject );
		HashMap map = null;
		if( DWLabSystem.xMLMode == XMLMode.GET ) {
			xMLObject.manageObjectSetField( "pivots", map );
			for( Sprite piv: map.keySet() ) {
				addPivot( piv );
			}

			xMLObject.manageObjectSetField( "lines", map );
			for( LineSegment lineSegment: map.keySet() ) {
				addLineSegment( lineSegment );
			}
		} else {
			xMLObject.manageObjectSetField( "pivots", pivots );
			xMLObject.manageObjectSetField( "lines", lineSegments );
		}
	}
}





public class AddPivotToGraph extends Action {
	public Graph graph;
	public Sprite pivot;



	public static AddPivotToGraph create( Graph graph, Sprite pivot ) {
		AddPivotToGraph action = new AddPivotToGraph();
		action.graph = graph;
		action.pivot = pivot;
		return action;
	}



	public void do() {
		graph.addPivot( pivot );
		super.do();
	}



	public void undo() {
		graph.removePivot( pivot );
		super.undo();
	}
}





public class AddLineToGraph extends Action {
	public Graph graph;
	public LineSegment lineSegment;



	public static AddLineToGraph create( Graph graph, LineSegment lineSegment ) {
		AddLineToGraph action = new AddLineToGraph();
		action.graph = graph;
		action.lineSegment = lineSegment;
		return action;
	}



	public void do() {
		graph.addLineSegment( lineSegment );
		super.do();
	}



	public void undo() {
		graph.removeLineSegment( lineSegment );
		super.undo();
	}
}





public class RemovePivotFromGraph extends Action {
	public Graph graph;
	public Sprite pivot;
	public LinkedList lineSegments;



	public static RemovePivotFromGraph create( Graph graph, Sprite pivot ) {
		if( ! graph.containsPivot( pivot ) ) error( "Cannot find pivot in the graph" );
		RemovePivotFromGraph action = new RemovePivotFromGraph();
		action.graph = graph;
		action.pivot = pivot;
		return action;
	}



	public void do() {
		lineSegments = LinkedList( graph.pivots.get( pivot ) ).copy();
		graph.removePivot( pivot );
		super.undo();
	}



	public void undo() {
		graph.addPivot( pivot );
		for( LineSegment lineSegment: lineSegments ) {
			graph.addLineSegment( lineSegment );
		}
		super.do();
	}
}





public class RemoveLineFromGraph extends Action {
	public Graph graph;
	public LineSegment lineSegment;



	public static RemoveLineFromGraph create( Graph graph, LineSegment lineSegment ) {
		if( ! graph.containsLineSegment( lineSegment ) ) error( "Cannot find line in the graph" );
		RemoveLineFromGraph action = new RemoveLineFromGraph();
		action.graph = graph;
		action.lineSegment = lineSegment;
		return action;
	}



	public void do() {
		graph.removeLineSegment( lineSegment );
		currentUndoList.addFirst( this );
	}



	public void undo() {
		graph.addLineSegment( lineSegment );
		currentRedoList.addFirst( this );
	}
}


