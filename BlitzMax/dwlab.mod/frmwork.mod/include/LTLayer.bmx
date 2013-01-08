'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Include "LTWorld.bmx"

Rem
bbdoc: Layer is the group of sprites which have bounds.
about: See also #DirectTo example.
End Rem
Type LTLayer Extends LTShape
	Rem
	bbdoc: List of shapes.
	End Rem
	Field Children:TList = New TList
	
	Rem
	bbdoc: Rectangular shape of layer bounds.
	End Rem
	Field Bounds:LTShape
	
	Rem
	bbdoc: Flag which defines if layer content should be mixed while displaying.
	about: Some conditions should be met to display mixed content correctly:
	<ul><li>Mixed content layer should contain at least one tile map.
	<li>All maps in layer should have equal tile/cell size.
	<li>All tile maps in layer should have equal corner coordinates like ( N * CellWidth, M * CellHeight ) where N and M is integer.
	<li>All tile maps in layer should have equal horizontal and vertical size in tiles.</ul>
	If this layer contains sprites or other layers they will not be drawn.
	End Rem
	Field MixContent:Int
	
	
	
	Method GetClassTitle:String()
		Return "Layer"
	End Method
	
	' ==================== Drawing ===================	
	
	Method Draw( DrawingAlpha:Double = 1.0 )
		DrawUsingVisualizer( Visualizer, DrawingAlpha * Visualizer.Alpha )
	End Method
	
	
	
	Method DrawUsingVisualizer( Vis:LTVisualizer, DrawingAlpha:Double = 1.0 )
		If Not Visible Then Return
		
		If MixContent Then
			Local Shapes:TList = New TList
			Local MainTileMap:LTTileMap
			For Local Shape:LTShape = EachIn Children
				Local TileMap:LTTileMap = LTTileMap( Shape )
				If TileMap Then
					If TileMap.TileSet.Image Then
						MainTileMap = LTTileMap( Shape )
						Shapes.AddLast( Shape )
					End If
				ElseIf LTSpriteMap( Shape ) Then
					Shapes.AddLast( Shape )
				End If
			Next
			If MainTileMap Then
				If Shapes.Count() = 1 Then Shapes = Null
				Vis.DrawUsingTileMap( MainTileMap, Shapes, DrawingAlpha )
				Return
			End If
		End If
		
		If Vis = Visualizer Then
			For Local Shape:LTShape = Eachin Children
				Shape.Draw( DrawingAlpha )
			Next
		Else
			For Local Shape:LTShape = Eachin Children
				Shape.DrawUsingVisualizer( Vis, DrawingAlpha )
			Next
		End If
	End Method
	
	' ==================== Managing ===================
	
	Rem
	bbdoc: Initialization method.
	about: Every child shape will be initialized by default.
	End Rem
	Method Init()
		For Local Obj:LTShape = Eachin Children
			Obj.Init()
		Next
	End Method
	
	

	Rem
	bbdoc: Acting method.
	about: Every child shape will be acted.
	End Rem
	Method Act()
		If Active Then
			Super.Act()
			For Local Obj:LTShape = Eachin Children
				If Obj.Active Then
					?debug
					L_SpriteActed = False
					?
					
					Obj.Act()
					
					?debug
					If LTSprite( Obj ) And Not L_SpriteActed Then L_SpritesActed :+ 1
					?
				End If
			Next
		End If
	End Method
	
	
	
	Method Update()
		For Local Obj:LTShape = Eachin Children
			Obj.Update()
		Next
	End Method
	
	' ==================== Collisions ===================
	
	Method LayerFirstSpriteCollision:LTSprite( Sprite:LTSprite )
		Return Sprite.FirstCollidedSpriteOfLayer( Self )
	End Method
	
	
	
	Method SpriteLayerCollisions( Sprite:LTSprite, Handler:LTSpriteCollisionHandler )
		Sprite.CollisionsWithLayer( Self, Handler )
	End Method
	
	

	Method TileShapeCollisionsWithSprite( Sprite:LTSprite, X:Double, Y:Double, XScale:Double, YScale:Double, TileMap:LTTileMap, TileX:Int, TileY:Int, ..
			Handler:LTSpriteAndTileCollisionHandler )
		For Local GroupSprite:LTSprite = Eachin Children
			If Sprite.CollidesWithSprite( GroupSprite.ShapeType.GetTileSprite( GroupSprite, X, Y, XScale, YScale ) ) Then
				Handler.HandleCollision( Sprite, TileMap, TileX, TileY, GroupSprite )
				Return
			End If
		Next
	End Method	
	
	' ==================== Other ===================	

	Method SetCoords( NewX:Double, NewY:Double )
		For Local Shape:LTShape = Eachin Children
			Shape.SetCoords( Shape.X + NewX - X, Shape.Y + NewY - Y )
		Next
		X = NewX
		Y = NewY
		Update()
	End Method
	
	
		
	Rem
	bbdoc: Sets the bounds of layer to given shape.
	End Rem
	Method SetBounds( Shape:LTShape )
		If Not Bounds Then
			Bounds = New LTShape
			Bounds.Visualizer = Null
		End If
		Bounds.X = Shape.X
		Bounds.Y = Shape.Y
		Bounds.Width = Shape.Width
		Bounds.Height = Shape.Height
	End Method

	
	
	Rem
	bbdoc: Counts quantity of sprites inside the layer.
	returns: Quantity of sprites inside layer and included layers.
	about: 
	End Rem
	Method CountSprites:Int()
		Local Count:Int = 0
		For Local Shape:LTShape = EachIn Children
			If LTSprite( Shape ) Then
				Count :+ 1
			ElseIf LTLayer( Shape ) Then
				Count :+ LTLayer( Shape ).CountSprites()
			End If
		Next
		Return Count
	End Method
	
	
	
	Rem
	bbdoc: Shows all behavior models attached to shape with their status.
	End Rem
	Method ShowModels:Int( Y:Int = 0, Shift:String = "" )
		If BehaviorModels.IsEmpty() Then 
			If Children.IsEmpty() Then Return Y
			DrawText( Shift + GetTitle() + ":", 0, Y )
	    	Y :+ 16
		Else
			Y = Super.ShowModels( Y, Shift )
		End If
		For Local Shape:LTShape = Eachin Children
			Y = Shape.ShowModels( Y, Shift + " " )
		Next
		Return Y
	End Method
		
	' ==================== List wrapping methods ====================
	
	Method AddFirst:TLink( Shape:LTShape )
		Return Children.AddFirst( Shape )
	End Method
	
	
	
	
	Method AddLast:TLink( Shape:LTShape )
		Return Children.AddLast( Shape )
	End Method
	
	
	
	Method Clear()
		Children.Clear()
	End Method
	
	
	
	Method ValueAtIndex:LTShape( Index:Int )
		Return LTShape( Children.ValueAtIndex( Index ) )
	End Method
	
	
	
	Method ObjectEnumerator:TListEnum()
		Return Children.ObjectEnumerator()
	End Method
	
	' ==================== Shape management ====================
	
	Method Load:LTShape()
		Local NewLayer:LTLayer = LTLayer( LoadShape() )
		For Local Shape:LTShape = Eachin Children
			NewLayer.AddLast( Shape.Load() )
		Next
		Return NewLayer
	End Method
	
	
	
	Method FindShapeWithParameterID:LTShape( ParameterName:String, ParameterValue:String, ShapeTypeID:TTypeID, IgnoreError:Int = False )
		For Local ChildShape:LTShape = EachIn Children
			If Not ShapeTypeID Or TTypeId.ForObject( ChildShape ) = ShapeTypeID Then
				If Not ParameterName Or ChildShape.GetParameter( ParameterName ) = ParameterValue Then Return ChildShape
			End If
			
			Local Shape:LTShape = ChildShape.FindShapeWithParameterID( ParameterName, ParameterValue, ShapeTypeID, True )
			If Shape Then Return Shape
		Next
		
		Super.FindShapeWithParameterID( ParameterName, ParameterValue, ShapeTypeID, IgnoreError )
	End Method
	
	
	
	Method InsertShape:Int( Shape:LTShape = Null, ShapesList:TList = Null, PivotShape:LTShape, Relativity:Int )
		Local Link:TLink = Children.FirstLink()
		While Link <> Null
			Local Value:Object = Link.Value()
			If Value = PivotShape Then
				Select Relativity
					Case Before, InsteadOf
						If Shape Then
							Children.InsertBeforeLink( Shape, Link )
						ElseIf ShapesList Then
							For Local ListShape:LTSprite =Eachin ShapesList
								Children.InsertBeforeLink( ListShape, Link )
							Next
						End If
						If Relativity = InsteadOf Then Link.Remove()
					Case After
						If Shape Then
							Children.InsertAfterLink( Shape, Link )
						ElseIf ShapesList Then
							For Local ListShape:LTSprite =Eachin ShapesList
								Link = Children.InsertAfterLink( ListShape, Link )
							Next
						End If
				End Select
				Return True
			Else
				If LTShape( Value ).InsertShape( Shape, ShapesList, PivotShape, Relativity ) Then Return True
			End If
			Link = Link.NextLink()
		Wend
	End Method
	
	
	
	Method Remove( Shape:LTShape )
		Local Link:TLink = Children.FirstLink()
		While Link <> Null
			Local Value:Object = Link.Value()
			If Value = Shape Then
				Link.Remove()
			Else
				LTShape( Value ).Remove( Shape )
			End If
			Link = Link.NextLink()
		Wend
	End Method
	
	
	
	Method RemoveAllOfTypeID( TypeID:TTypeID )
		Local Link:TLink = Children.FirstLink()
		While Link <> Null
			Local Value:Object = Link.Value()
			If TTypeId.ForObject( Value ) = TypeID Then
				Link.Remove()
			Else
				LTShape( Value ).RemoveAllOfTypeID( TypeID )
			End If
			Link = Link.NextLink()
		Wend
	End Method
	
	' ==================== Cloning ===================	
	
	Method Clone:LTShape()
		Local NewLayer:LTLayer = New LTLayer
		CopyLayerTo( NewLayer )
		For Local Shape:LTShape = Eachin Children
			NewLayer.Children.AddLast( Shape.Clone() )
		Next
		Return NewLayer
	End Method
	
	
	
	Method CopyLayerTo( Layer:LTLayer )
		CopyShapeTo( Layer )
		
		If Bounds Then
			Layer.Bounds = New LTShape
			Bounds.CopyTo( Layer.Bounds )
		End If
		Layer.MixContent = MixContent
	End Method
	
	
	
	Method CopyTo( Shape:LTShape )
		Local Layer:LTLayer = LTLayer( Shape )
		
		?debug
		If Not Layer Then L_Error( "Trying to copy layer ~q" + Shape.GetName() + "~q data to non-layer" )
		?
		
		CopyLayerTo( Layer )
	End Method	
	
	' ==================== Saving / loading ===================

	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		
		XMLObject.ManageChildList( Children )
		Bounds = LTShape( XMLObject.ManageObjectField( "bounds", Bounds ) )
		XMLObject.ManageIntAttribute( "mix-content", MixContent )
	End Method
End Type