package dwlab.graph;

import dwlab.base.Action;
import dwlab.shapes.LineSegment;

public class AddLineToGraph extends Action {
	public Graph graph;
	public LineSegment lineSegment;


	public static AddLineToGraph create( Graph graph, LineSegment lineSegment ) {
		AddLineToGraph action = new AddLineToGraph();
		action.graph = graph;
		action.lineSegment = lineSegment;
		return action;
	}


	@Override
	public void perform() {
		graph.addLineSegment( lineSegment );
		super.perform();
	}


	@Override
	public void undo() {
		graph.removeLineSegment( lineSegment );
		super.undo();
	}
}