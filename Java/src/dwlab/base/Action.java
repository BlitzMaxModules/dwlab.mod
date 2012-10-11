/* Digital Wizard's Lab - game development framework
 * Copyright (C) 2012, Matt Merkulov
 *
 * All rights reserved. Use of this code is allowed under the
 * Artistic License 2.0 terms, as specified in the license.txt
 * file distributed with this code, or available from
 * http://www.opensource.org/licenses/artistic-license-2.0.php
 */

package dwlab.base;

import java.util.LinkedList;

/**
 * Action class for implementing Undo/Redo technology.
 */
public class Action extends Obj {
	private static LinkedList<LinkedList<Action>> undoStack = new LinkedList<LinkedList<Action>>();
	private static LinkedList<Action> currentUndoList = new LinkedList<Action>();
	private static LinkedList<LinkedList<Action>> redoStack = new LinkedList<LinkedList<Action>>();
	private static LinkedList<Action> currentRedoList = new LinkedList<Action>();

	
	/**
	 * Action performing method.
	 * Execute it when you want to perform an action of this type.
	 * Fill this method with action initialization commands (which also need to store information for Undo operation).
	 * Also it can be executed automatically when you will execute L_Redo function.
	 */
	public void perform() {
		currentUndoList.addFirst( this );
	}


	/**
	 * Action undoing method.
	 * Fill it with commands which will perform rolling back changes done by Do() method.
	 * Can be executed automatically when you will execute L_Undo function.
	 */
	public void undo() {
		currentRedoList.addFirst( this );
	}

	
	/**
	* Function for finalizing current action list as single step and pushing it to Undo stack.
	* @see #lTAction example
	*/
	public static void pushActionsList() {
		if( !currentUndoList.isEmpty() ) {
			undoStack.addFirst( currentUndoList );
			currentUndoList = new LinkedList<Action>();
		}
	}


	/**
	* Function for performing single step of Undo.
	* Executes all Undo() methods for every action in head action list of Undo stack and moves this list to Redo stack.

	* @see #lTAction example
	*/
	public static void undoStep() {
		if( undoStack.isEmpty() ) return;
		LinkedList<Action> undoList = undoStack.getFirst();
		for( Action action: undoList ) {
			action.undo();
		}
		redoStack.addFirst( undoList );
		undoStack.removeFirst();
	}


	/**
	* Function for performing single step of Redo.
	* Executes all Redo() methods for every action in head action list of Redo stack and moves this list to Undo stack.

	* @see #lTAction example
	*/
	public static void redoStep() {
		if( redoStack.isEmpty() ) return;
		LinkedList<Action> redoList = redoStack.getFirst();
		for( Action action: redoList ) {
			action.perform();
		}
		undoStack.addFirst( redoList );
		redoStack.removeFirst();
	}

}