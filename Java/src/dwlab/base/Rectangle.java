package dwlab.base;

import dwlab.shapes.Vector;

public class Rectangle extends Vector {
	public double width, height;
	

	public double leftX() {
 		return x - 0.5d * width;
 	}


	public double topY() {
 		return y - 0.5d * height;
 	}


	public double rightX() {
 		return x + 0.5d * width;
 	}


	public double bottomY() {
 		return y + 0.5d * height;
 	}
}
