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
	
	Method Draw( X:Double, IconShape:LTSprite, BallShape:LTSprite, CountShape:LTLabel )
		If IconShape Then
			IconShape.SetX( X - 0.5 * IconShape.Width )
			IconShape.Frame = Icon
			IconShape.Draw()
		End If
		
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
	Method Draw( X:Double, IconShape:LTSprite, BallShape:LTSprite, CountShape:LTLabel )
		Super.Draw( X, Null, Null, CountShape )
		BallShape.SetX( IconShape.X )
		BallShape.Frame = TGameProfile.BlackBall
		BallShape.Draw()
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
		Goal.Icon = 0
		Profile.Goals.AddLast( Goal )
	End Function
End Type



Type TRemoveBalls Extends TGoal
	Field BallType:Int
	
	Method Draw( X:Double, IconShape:LTSprite, BallShape:LTSprite, CountShape:LTLabel )
		Super.Draw( X, Null, Null, CountShape )
		BallShape.SetX( IconShape.X )
		BallShape.Frame = BallType
		BallShape.Draw()
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



Type TRemoveCombinations Extends TGoal
	Field BallType:Int
	Field LineBallsQuantity:Int
	
	Method Draw( X:Double, IconShape:LTSprite, BallShape:LTSprite, CountShape:LTLabel )
		Super.Draw( X, Null, Null, CountShape )
		IconShape.SetX( X - 0.5 * IconShape.Width )
		
		BallShape.Frame = BallType
		BallShape.SetDiameter( 0.3 )
		For Local K:Int = -1 To 1
			BallShape.SetCoords( IconShape.X + 0.2 * K, IconShape.Y + 0.2 * K )
			BallShape.Draw()
		Next
		BallShape.SetDiameter( 0.65 )
		BallShape.SetCoords( IconShape.X, IconShape.Y )
		
		SetColor( 0, 0, 0 )
		IconShape.PrintText( LineBallsQuantity, 0.3, LTAlign.ToLeft, LTAlign.ToBottom )
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



Type TRemoveGlue Extends TGoal
	Function Create( Quantity:Int )
		Local Goal:TRemoveGlue = New TRemoveGlue
		Goal.Count = Quantity
		Goal.Icon = 1
		Profile.Goals.AddLast( Goal )
	End Function
End Type