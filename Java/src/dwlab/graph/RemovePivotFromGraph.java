package dwlab.graph;

import dwlab.base.Action;
import dwlab.shapes.LineSegment;
import dwlab.shapes.sprites.Sprite;
import java.util.LinkedList;

public class RemovePivotFromGraph extends Action {
	public Graph graph;
	public Sprite pivot;
	public LinkedList<LineSegment> lineSegments;


	public static RemovePivotFromGraph create( Graph graph, Sprite pivot ) {
		if( ! graph.containsPivot( pivot ) ) error( "Cannot find pivot in the graph" );
		RemovePivotFromGraph action = new RemovePivotFromGraph();
		action.graph = graph;
		action.pivot = pivot;
		return action;
	}


	@Override
	public void perform() {
		lineSegments = graph.contents.get( pivot );
		graph.removePivot( pivot );
		super.perform();
	}


	@Override
	public void undo() {
		graph.addPivot( pivot );
		for( LineSegment lineSegment: lineSegments ) {
			graph.addLineSegment( lineSegment );
		}
		super.undo();
	}
}