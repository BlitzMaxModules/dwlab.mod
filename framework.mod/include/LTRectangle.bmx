' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
' Distrbuted under GNU General Public License version 3
' You can read it at http://www.gnu.org/licenses/gpl.txt

Type LTRectangle Extends LTPivot
	Field XSize:Float
	Field YSize:Float
	
	
	
	Method Draw()
		Visual.DrawUsingRectangle( Self )
	End Method
	
	
	
	Method DrawUsingVisual( Vis:LTVisual )
		Vis.DrawUsingRectangle( Self )
	End Method

	' ==================== Collidess ===================
	
	Method Collides:Int( Model:LTModel )
		Return Model.CollidesWithRectangle( Self )
	End Method

	
	
	Method CollidesWithPivot:Int( Piv:LTPivot )
		If L_PivotWithRectangle( Piv, Self ) Then Return True
	End Method

	
	
	Method CollidesWithCircle:Int( Circ:LTCircle )
		If L_CircleWithRectangle( Circ, Self ) Then Return True
	End Method
	
	
	
	Method CollidesWithRectangle:Int( Rectangle:LTRectangle )
		If L_RectangleWithRectangle( Rectangle, Self ) Then Return True
	End Method
	
	' ==================== Pushing ====================
	
	Method Push( Mdl:LTModel )
		Mdl.PushRectangle( Self )
	End Method


	
	Method PushCircle( Circ:LTCircle )
		Circ.PushRectangle( Self )
	End Method

	
	
	Method PushRectangle( Rectangle:LTRectangle )
		Local DX:Float = 0.5 * ( Rectangle.XSize + XSize ) - Abs( Rectangle.X - X )
		Local DY:Float = 0.5 * ( Rectangle.YSize + YSize ) - Abs( Rectangle.Y - Y )
		
		Local MassSum:Float = Mass + Rectangle.Mass
		Local K1:Float = 0.5
		Local K2:Float = 0.5		
		If MassSum Then
			K1 = Mass / MassSum
			K2 = Rectangle.Mass / MassSum
		End If
		
		'debugstop
		If DX < DY Then
			Rectangle.X :+ K1 * DX * Sgn( Rectangle.X - X )
			X :- K2 * DX * Sgn( Rectangle.X - X )
		Else
			Rectangle.Y :+ K1 * DY * Sgn( Rectangle.Y - Y )
			Y :- K2 * DY * Sgn( Rectangle.Y - Y )
		End If
	End Method



	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		XMLObject.ManageFloatAttribute( "xsize", XSize )
		XMLObject.ManageFloatAttribute( "ysize", YSize )
	End Method
End Type