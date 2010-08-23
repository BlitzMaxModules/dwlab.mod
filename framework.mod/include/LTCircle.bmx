' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
' Distrbuted under GNU General Public License version 3
' You can read it at http://www.gnu.org/licenses/gpl.txt

Type LTCircle Extends LTPivot
	Field Diameter:Float
	
	
	
	Method Draw()
		debugstop
		Visual.DrawUsingCircle( Self )
	End Method
	
	
	
	Method DrawUsingVisual( Vis:LTVisual )
		debugstop
		Vis.DrawUsingCircle( Self )
	End Method

	' ==================== Collidess ===================
	
	Method CollidesWith:Int( Model:LTModel )
		Return Model.CollidesWithCircle( Self )
	End Method

	
	
	Method CollidesWithPivot:Int( Piv:LTPivot )
		If L_PivotWithCircle( Piv, Self ) Then Return True
	End Method

	
	
	Method CollidesWithCircle:Int( Circ:LTCircle )
		If L_CircleWithCircle( Circ, Self ) Then Return True
	End Method
	
	
	
	Method CollidesWithRectangle:Int( Rectangle:LTRectangle )
		If L_CircleWithRectangle( Self, Rectangle ) Then Return True
	End Method
	
	' ==================== Pushing ====================
	
	Method Push( Model:LTModel )
		Model.PushCircle( Self )
	End Method


	
	Method PushCircle( Circ:LTCircle )
		Local DX:Float = Circ.X - X
		Local DY:Float = Circ.Y - Y
		Local K:Float = 0.5 * ( Circ.Diameter + Diameter ) / Sqr( DX * DX + DY * DY ) - 1.0
		
		Local MassSum:Float = Mass + Circ.Mass
		Local K1:Float, K2:Float
		If MassSum Then
			K1 = K * ( Mass / MassSum )
			K2 = K * ( Circ.Mass / MassSum )
		Else
			K1 = K * 0.5
			K2 = K * 0.5
		End If
		
		'debugstop
		
		Circ.X :+ K1 * DX
		Circ.Y :+ K1 * DY
		X = X - K2 * DX
		Y = Y - K2 * DY
	End Method

	
	
	Method PushRectangle( Rectangle:LTRectangle )
		Local DX:Float, DY:Float
		
		If X > Rectangle.X - 0.5 * Rectangle.XSize And X < Rectangle.X + 0.5 * Rectangle.XSize Then
			DY = ( 0.5 * ( Rectangle.YSize + Diameter ) - Abs( Rectangle.Y - Y ) ) * Sgn( Rectangle.Y - Y )
		ElseIf Y > Rectangle.Y - 0.5 * Rectangle.YSize And Y < Rectangle.Y + 0.5 * Rectangle.YSize Then
			DX = ( 0.5 * ( Rectangle.XSize + Diameter ) - Abs( Rectangle.X - X ) ) * Sgn( Rectangle.X - X )
		Else
			Local PX:Float = Rectangle.X + 0.5 * Rectangle.XSize * Sgn( X - Rectangle.X )
			Local PY:Float = Rectangle.Y + 0.5 * Rectangle.YSize * Sgn( Y - Rectangle.Y )
			Local K:Float = 1.0 - 0.5 * Diameter / Sqr( ( X - PX ) * ( X - PX ) + ( Y - PY ) * ( Y - PY ) )
			DX = ( X - PX ) * K
			DY = ( Y - PY ) * K
		End If
		
		Local MassSum:Float = Rectangle.Mass + Mass
		Local K1:Float, K2:Float
		
		If MassSum Then
			K1 = Mass / MassSum
			K2 = Rectangle.Mass / MassSum
		Else
			K1 = 0.5
			K2 = 0.5
		End If
		
		'debugstop
		
		Rectangle.X :+ K1 * DX
		Rectangle.Y :+ K1 * DY
		X = X - K2 * DX
		Y = Y - K2 * DY
	End Method



	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		XMLObject.ManageFloatAttribute( "diameter", Diameter )
	End Method
End Type
