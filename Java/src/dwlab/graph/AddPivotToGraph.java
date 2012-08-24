package dwlab.graph;

import dwlab.base.Action;
import dwlab.shapes.sprites.Sprite;

public class AddPivotToGraph extends Action {
	public Graph graph;
	public Sprite pivot;


	public static AddPivotToGraph create( Graph graph, Sprite pivot ) {
		AddPivotToGraph action = new AddPivotToGraph();
		action.graph = graph;
		action.pivot = pivot;
		return action;
	}


	@Override
	public void perform() {
		graph.addPivot( pivot );
		super.perform();
	}


	@Override
	public void undo() {
		graph.removePivot( pivot );
		super.undo();
	}
}