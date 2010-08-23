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
	
	Method SetMouseCoords()
		L_CurrentCamera.ScreenToField( MouseX(), MouseY(), X, Y )
	End Method
	
	
	
	Method MoveTowards( Pivot:LTPivot )
		Local Angle:Float = ATan2( Pivot.Y - Y, Pivot.X - X )
		Local DX:Float = Cos( Angle ) * Velocity * L_DeltaTime
		Local DY:Float = Sin( Angle ) * Velocity * L_DeltaTime
		If Abs( DX ) > Abs( X - Pivot.X ) Or Abs( DY ) > Abs( Y - Pivot.Y ) Then
			X = Pivot.X
			Y = Pivot.Y
		Else
			X :+ DX
			Y :+ DY
		End If
	End Method



	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		XMLObject.ManageFloatAttribute( "x", X )
		XMLObject.ManageFloatAttribute( "y", Y )
	End Method
End Type