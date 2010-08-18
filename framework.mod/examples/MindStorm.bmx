' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
' Distrbuted under GNU General Public License version 3
' You can read it at http://www.gnu.org/licenses/gpl.txt

Include "../framework.bmx"

Local World:LTWorld = LTWorld.Create( 256, 256 )



LTWASDControl.AddButtons()

Player:LTGroup = LTGroup.Create()

Local Player:LTActor
Player.SetModel = New LTCircle
LTPivot.Create().SetFor( Player )

LTWASDControl.AddTo( Player )
LTAimAtMouse.AddTo( Player )

Local Brain:LTVisual = LTImage.Load( "media/brain.png" )
LTUseColor.CreateFromHex( "AACCFF" ).AddTo( Brain )

Local Visor:LTVisual = LTImage.Load( "media/visor#.png" )
LTUseColor.CreateFromHex( "CCAAFF" ).AddTo( Visor )
LTUseAlpha.Create().AddTo( Visor )

Local Mouse:LTShape = LTPoint.Create()
Mouse.SetModel( New LTDot )

Local Tiles:LTVisual = LTImage

'Logic

Mouse.OperateWith( LTJumpToMouseCursor.Create() )

PlayerShape.OperateWith( LTWASDControl.Create() )
PlayerShape.OperateWith( LTAimAt.Create( Mouse ) )

'Render

TileMap.Draw()
PlayerBullets.Draw()
Player.Draw()
Mouse.Draw()



World.Execute()

Type PlayerFireBullet Extends LTBehavior
	Method Execute
		If KeyDown( 57 ) Then
	End Method
End Type