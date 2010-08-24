' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
' Distrbuted under GNU General Public License version 3
' You can read it at http://www.gnu.org/licenses/gpl.txt

Type LTPivot Extends LTModel
	Field X:Float, Y:Float
	
	
	
	Method Draw()
		Visual.DrawUsingPivot( Self )
	End Method
	
	
	
	Method DrawUsingVisual( Vis:LTVisual )
		Vis.DrawUsingPivot( Self )
	End Method
	
	' ==================== Collidess ===================
	
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
	
	' ==================== Other ====================
	
	Method DistanceTo:Float( Pivot:LTPivot )
		Local DX:Float = X - Pivot.X
		Local DY:Float = Y - Pivot.Y
		Return Sqr( DX * DX + DY * DY )
	End Method
	
	
	
	Method IsAtPositionOf:Int( Pivot:LTPivot )
		If Pivot.X = X And Pivot.Y = Y Then Return True
	End Method
	
	
	
	Method JumpTo( Pivot:LTPivot )
		X = Pivot.X
		Y = Pivot.Y
	End Method
	
	
	
	Method SetMouseCoords()
		L_CurrentCamera.ScreenToField( MouseX(), MouseY(), X, Y )
	End Method
	
	
	
	Method MoveTowards( Pivot:LTPivot )
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
	End Method
	
	
	
	Method DirectTo( Pivot:LTPivot )
		Angle = ATan2( Pivot.Y - Y, Pivot.X - X )
	End Method
	
	
	
	Method Turn( TurnSpeed:Float )
		Angle :+ L_DeltaTime * TurnSpeed
	End Method



	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		XMLObject.ManageFloatAttribute( "x", X )
		XMLObject.ManageFloatAttribute( "y", Y )
	End Method
End Type