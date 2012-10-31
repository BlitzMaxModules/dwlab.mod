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
	Field Count:Int
	
	Method GetBallIcon:Int()
		Return 0
	End Method
	
	Method GetTileIcon:Int()
		Return 0
	End Method
		
	Method Draw( X:Double, BallShape:LTSprite, TileIcon:LTSprite, BallIcon:LTSprite, CountShape:LTLabel )
		TileIcon.SetX( X - 0.5 * TileIcon.Width )
		TileIcon.Frame = GetTileIcon()
		TileIcon.Draw()
		
		BallIcon.SetX( X - 0.5 * BallIcon.Width )
		BallIcon.Frame = GetBallIcon()
		BallIcon.Draw()
		
		CountShape.SetX( X + 0.5 * CountShape.Width )
		CountShape.Text = " x" + Count
		CountShape.Draw()
	End Method
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		XMLObject.ManageIntAttribute( "count", Count )
	End Method
End Type



Type TPutBallsInHoles Extends TGoal
	Method GetBallIcon:Int()
		Return Profile.BlackBall
	End Method
	
	Function Create( BallsQuantity:Int )
		Local Goal:TPutBallsInHoles = New TPutBallsInHoles
		Goal.Count = BallsQuantity
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
	
	Method GetBallIcon:Int()
		Return BallType
	End Method
	
	Function Create( BallType:Int, Quantity:Int )
		Local Goal:TRemoveBalls = New TRemoveBalls
		Goal.BallType = BallType
		Goal.Count = Quantity
		Profile.Goals.AddLast( Goal )
	End Function
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		XMLObject.ManageIntAttribute( "ball-type", BallType )
	End Method
End Type



Type TRemoveLights Extends TGoal
	Method GetBallIcon:Int()
		Return Profile.Lights
	End Method
	
	Function Create( Quantity:Int )
		Local Goal:TRemoveLights = New TRemoveLights
		Goal.Count = Quantity
		Profile.Goals.AddLast( Goal )
	End Function
End Type



Type TRemoveCombinations Extends TGoal
	Field BallType:Int
	Field LineBallsQuantity:Int
	
	Method Draw( X:Double, BallShape:LTSprite, TileIcon:LTSprite, BallIcon:LTSprite, CountShape:LTLabel )
		TileIcon.Frame = 0
		BallIcon.Frame = 0
		Super.Draw( X, BallShape, TileIcon, BallIcon, CountShape )
		TileIcon.SetX( X - 0.5 * TileIcon.Width )
		
		BallShape.Frame = BallType
		BallShape.SetDiameter( 0.3 )
		For Local K:Int = -1 To 1
			BallShape.SetCoords( TileIcon.X + 0.2 * K, TileIcon.Y + 0.2 * K )
			BallShape.Draw()
		Next
		BallShape.SetDiameter( 0.65 )
		BallShape.SetCoords( TileIcon.X, TileIcon.Y )
		
		SetColor( 0, 0, 0 )
		TileIcon.PrintText( LineBallsQuantity, 0.3, LTAlign.ToLeft, LTAlign.ToBottom )
		LTColor.ResetColor()
	End Method
	
	Function Create( BallType:Int, LineBallsQuantity:Int, Quantity:Int )
		Local Goal:TRemoveCombinations = New TRemoveCombinations
		Goal.BallType = BallType
		Goal.LineBallsQuantity = LineBallsQuantity
		Goal.Count = Quantity
		Profile.Goals.AddLast( Goal )
	End Function
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		XMLObject.ManageIntAttribute( "ball-type", BallType )
		XMLObject.ManageIntAttribute( "line-balls-quantity", LineBallsQuantity )
	End Method
End Type



Type TRemoveIce Extends TGoal
	Method GetBallIcon:Int()
		Return 14
	End Method
	
	Function Create( Quantity:Int )
		Local Goal:TRemoveIce = New TRemoveIce
		Goal.Count = Quantity
		Profile.Goals.AddLast( Goal )
	End Function
End Type