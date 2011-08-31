'
' Color Lines - Digital Wizard's Lab example
' Copyright (C) 2011, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type TVisualizer Extends LTVisualizer
  Const Empty:Int = 0
  Const Void:Int = 8

  Method DrawTile( TileMap:LTTileMap, X:Double, Y:Double, Width:Double, Height:Double, TileX:Int, TileY:Int )
    Local TileSet:LTTileSet =Tilemap.TileSet
    Local TileValue:Int = TileMap.Value[ TileX, TileY ]
    If TileValue = Void Then Return
    
    Local Image:TImage = TileSet.Image.BMaxImage
    If Not Image Then Return
    
    Local SX:Double, SY:Double
    L_CurrentCamera.FieldToScreen( X, Y, SX, SY )
    
    Local Visualizer:LTVisualizer = TileMap.Visualizer
    SetScale( Width / ImageWidth( Image ), Height / ImageHeight( Image ) )
    
    DrawImage( Image, SX + Visualizer.DX * Width, SY + Visualizer.DY * Height, Empty )
    If TileValue <> Empty Then DrawImage( Image, SX + Visualizer.DX * Width, SY + Visualizer.DY * Height, TileValue )
  End Method
End Type