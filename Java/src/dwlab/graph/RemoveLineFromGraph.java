package dwlab.graph;

import dwlab.base.Action;
import dwlab.shapes.LineSegment;

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


	@Override
	public void perform() {
		graph.removeLineSegment( lineSegment );
	}


	@Override
	public void undo() {
		graph.addLineSegment( lineSegment );
	}
}