'
' Color Lines - Digital Wizard's Lab example
' Copyright (C) 2011, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type TGoal Extends LTObject
	Field Icon:Int
	Field Count:Int
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		XMLObject.ManageIntAttribute( "count", Count )
	End Method
End Type



Type TPutBallsInHoles Extends TGoal
	Function Create( BallsQuantity:Int )
		Local Goal:TPutBallsInHoles = New TPutBallsInHoles
		Goal.Count = BallsQuantity
		Goal.Icon = 0
		Profile.Goals.AddLast( Goal )
	End Function
End Type



Type TGetScore Extends TGoal
	Function Create( Score:Int )
		Local Goal:TGetScore = New TGetScore
		Goal.Count = Score
		Profile.Goals.AddLast( Goal )
	End Function
End Type



Type TRemoveBalls Extends TGoal
	Field BallType:Int
	
	Function Create( BallType:Int, Quantity:Int )
		Local Goal:TRemoveBalls = New TRemoveBalls
		Goal.BallType = BallType
		Goal.Count = Quantity
		Profile.Goals.AddLast( Goal )
	End Function
End Type



Type TRemoveCombinations Extends TGoal
	Field BallType:Int
	Field LineBallsQuantity:Int
	
	Function Create( BallType:Int, LineBallsQuantity:Int, Quantity:Int )
		Local Goal:TRemoveCombinations = New TRemoveCombinations
		Goal.LineBallsQuantity = LineBallsQuantity
		Goal.Count = Quantity
		Profile.Goals.AddLast( Goal )
	End Function
End Type



Type TRemoveGlue Extends TGoal
	Function Create( Quantity:Int )
		Local Goal:TRemoveGlue = New TRemoveGlue
		Goal.Count = Quantity
		Profile.Goals.AddLast( Goal )
	End Function
End Type