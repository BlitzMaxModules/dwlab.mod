'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTPivot Extends LTModel
	Field X:Float, Y:Float
	
	' ==================== Drawing ===================	
	
	Method Draw()
		Visual.DrawUsingPivot( Self )
	End Method
	
	
	
	Method DrawUsingVisual( Vis:LTVisual )
		Vis.DrawUsingPivot( Self )
	End Method
	
	' ==================== Collisions ===================
	
	Method CollidesWith:Int( Model:LTModel )
		Return Model.CollidesWithPivot( Self )
	End Method

	
	
	Method CollidesWithPivot:Int( Piv:LTPivot )
		If L_PivotWithPivot( Self, Piv ) Then Return True
	End Method

	
	
	Method CollidesWithCircle:Int( Circ:LTCircle )
		If L_PivotWithCircle( Self, Circ ) Then Return True
	End Method
	
	
	
	Method CollidesWithRectangle:Int( Rectangle:LTRectangle )
		If L_PivotWithRectangle( Self, Rectangle ) Then Return True
	End Method
	
	' ==================== Position ====================
	
	Method DistanceToPivot:Float( Pivot:LTPivot )
		Local DX:Float = X - Pivot.X
		Local DY:Float = Y - Pivot.Y
		Return Sqr( DX * DX + DY * DY )
	End Method
	
	
	
	Method IsAtPositionOfPivot:Int( Pivot:LTPivot )
		If Pivot.X = X And Pivot.Y = Y Then Return True
	End Method
	
	
	
	Method SetCoords( NewX:Float, NewY:Float )
		X = NewX
		Y = NewY
		Update()
	End Method
	
	
	
	Method SetRelativeCoords( Pivot:LTPivot, NewX:Float, NewY:Float )
		Local Angle:Float = ATan2( NewY, NewX ) + Pivot.Angle
		Local Radius:Float = Sqr( NewX * NewX + NewY * NewY )
		X = Pivot.X + Radius * Cos( Angle )
		Y = Pivot.Y + Radius * Sin( Angle )
		Update()
	End Method
	
	
	
	Method JumpToPivot( Pivot:LTPivot )
		X = Pivot.X
		Y = Pivot.Y
		Update()
	End Method
	
	
	
	Method SetMouseCoords()
		L_CurrentCamera.ScreenToField( MouseX(), MouseY(), X, Y )
		Update()
	End Method
	
	
	
	Method MoveTowardsPivot( Pivot:LTPivot )
		Local Angle:Float = ATan2( Pivot.Y - Y, Pivot.X - X )
		Local DX:Float = Cos( Angle ) * Velocity * L_DeltaTime
		Local DY:Float = Sin( Angle ) * Velocity * L_DeltaTime
		If Abs( DX ) >= Abs( X - Pivot.X ) And Abs( DY ) >= Abs( Y - Pivot.Y ) Then
			X = Pivot.X
			Y = Pivot.Y
		Else
			X :+ DX
			Y :+ DY
		End If
		Update()
	End Method
	
	
	
	Method MoveUsingWSAD()
		Local DX:Float = KeyDown( Key_D ) - KeyDown( Key_A )
		Local DY:Float = KeyDown( Key_S ) - KeyDown( Key_W )
		If DX * DY Then
			DX :/ Sqr(2)
			DY :/ Sqr(2)
		End If
		X :+ DX * Velocity * L_DeltaTime
		Y :+ DY * Velocity * L_DeltaTime
		Update()
	End Method
	
	' ==================== Angle ====================
	
	Method DirectToPivot( Pivot:LTPivot )
		Angle = ATan2( Pivot.Y - Y, Pivot.X - X )
	End Method
	
	
	
	Method Turn( TurnSpeed:Float )
		Angle :+ L_DeltaTime * TurnSpeed
	End Method

	' ==================== Other ====================

	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		XMLObject.ManageFloatAttribute( "x", X )
		XMLObject.ManageFloatAttribute( "y", Y )
	End Method
End Type





Type LTMovePivot Extends LTAction
	Field Pivot:LTPivot
	Field OldX:Float, OldY:Float
	Field NewX:Float, NewY:Float
	
	
	
	Function Create:LTMovePivot( Pivot:LTPivot, X:Float = 0, Y:Float = 0 )
		Local Action:LTMovePivot = New LTMovePivot
		Action.Pivot = Pivot
		Action.OldX = Pivot.X
		Action.OldY = Pivot.Y
		Action.NewX = X
		Action.NewY = Y
		Return Action
	End Function
	
	
	
	Method Do()
		Pivot.X = NewX
		Pivot.Y = NewY
		L_CurrentUndoList.AddFirst( Self )
	End Method
	
	
	
	Method Undo()
		Pivot.X = OldX
		Pivot.Y = OldY
		L_CurrentRedoList.AddFirst( Self )
	End Method
End Type