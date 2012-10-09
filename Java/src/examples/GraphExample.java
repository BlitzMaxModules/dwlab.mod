package examples;
import java.util.LinkedList;
import java.lang.Math;
import dwlab.base.Align;
import dwlab.base.Project;
import dwlab.shapes.LineSegment;
import dwlab.graph.Graph;
import dwlab.visualizers.ContourVisualizer;
import dwlab.shapes.sprites.Sprite;
import dwlab.visualizers.Visualizer;

public static Example example = new Example();
example.execute();

public class Example extends Project {
	public final int pivotsQuantity = 150;
	public final double maxDistance = 3.0;
	public final double minDistance = 1.0;

	public Graph graph = new Graph();
	public Sprite selectedPivot;
	public LinkedList path;
	public Visualizer pivotVisualizer = Visualizer.fromHexColor( "4F4FFF" );
	public Visualizer lineSegmentVisualizer = ContourVisualizer.fromWidthAndHexColor( 0.15, "FF4F4F", , 3.0 );
	public Visualizer pathVisualizer = ContourVisualizer.fromWidthAndHexColor( 0.15, "4FFF4F", , 4.0 );

	public void init() {
		initGraphics();
		cursor = Sprite.fromShape( 0, 0, 0.5, 0.5, Sprite.oval );
		for( int n = 0; n <= pivotsQuantity; n++ ) {
			while( true ) {
				double x = Math.random( -15,15 );
				double y = Math.random( -11, 11 );
				int passed = true;
				for( Sprite pivot : graph.pivots.keySet() ) {
					if( pivot.distanceToPoint( x, y ) < minDistance ) {
						passed = false ;
						break;
					}
				}
				if( passed ) {
					graph.addPivot( Sprite.fromShape( x, y, 0.3, 0.3, Sprite.oval ) );
					break;
				}
			}
		}
		for( Sprite pivot1 : graph.pivots.keySet() ) {
			for( Sprite pivot2 : graph.pivots.keySet() ) {
				if( pivot1 != pivot2 && pivot1.distanceTo( pivot2 ) <= maxDistance ) {
					int passed = true;
					LineSegment newLineSegment = LineSegment.fromPivots( pivot1, pivot2 );
					for( LineSegment lineSegment : graph.lineSegments.keySet() ) {
						if( lineSegment.collidesWithLineSegment( newLineSegment, false ) ) {
							passed = false;
							break;
						}
					}
					if( passed ) graph.addLineSegment( newLineSegment, false );
				}
			}
		}
	}

	public void logic() {
		if( mouseHit( 1 ) ) {
			switch( edPivot = graph.findPivotCollidingWithSprite( cursor ) ) {
			path = null;
		}
		if( mouseHit( 2 ) && selectedPivot ) {
			switch( Sprite edPivot2 = graph.findPivotCollidingWithSprite( cursor ) ) {
			if( selectedPivot2 ) path = graph.findPath( selectedPivot, selectedPivot2 );
		}
		if( appTerminate() || keyHit( key_Escape ) ) exiting = true;
	}

	public void render() {
		graph.drawLineSegmentsUsing( lineSegmentVisualizer );
		Graph.drawPath( path, pathVisualizer );
		graph.drawPivotsUsing( pivotVisualizer );
		if( selectedPivot ) selectedPivot.drawUsingVisualizer( pathVisualizer );
		drawText( "Select first pivot with left mouse button and second with right one", 0, 0 );
		printText( "LTGraph, FindPath, CollidesWithLineSegment example", 0, 12, Align.toCenter, Align.toBottom );
	}
}
