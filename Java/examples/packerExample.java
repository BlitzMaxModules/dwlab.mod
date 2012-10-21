package examples;
import java.util.LinkedList;

String equalNames[] = [ "Example", "TCursor", "TBall", "TKolobok", "TCollisionHandler", "TBullet", "TVerticalCollisionHandler" ];

tStream all = writeFile( "all.bmx" );
writeLine( all, "SuperStrict" );
writeLine( all, "Framework brl.basic" );
writeLine( all, "Import dwlab.frmwork" );
writeLine( all, "Import dwlab.graphicsdrivers" );
writeLine( all, "Import dwlab.audiodrivers" );
writeLine( all, "L_InitGraphics()" );
writeLine( all, "L_PrintText( \"Press ESC to switch examples\", 0, 0, LTAlign.ToCenter, LTAlign.ToCenter )" );
writeLine( all, "Flip" );
writeLine( all, "Waitkey" );


int dir = readDir( currentDir() );
int num = 1;
LinkedList incbins = new LinkedList();
while( true ) {
	String fileName = nextFile( dir );
	if( ! fileName ) break;

	if( extractExt( fileName ) != "bmx" ) continue;
	if( LinkedList.fromArray( [ "packer.bmx", ".bmx", "LTSpring.bmx", "all.bmx" ] ).contains( fileName ) ) continue;

	tStream file = readFile( fileName );
	int typeArea = -1;
	LinkedList consts = new LinkedList();

	while( ! eOF( file ) ) {
		String line = readLine( file );
		if( line.startsWith( "SuperStrict" ) ) {
			 if( line.endsWith( "Skip" ) ) break;
			 continue;
		}
		if( line.startsWith( "Framework" ) || line.startsWith( "Import" ) ) continue;

		if( line.startsWith( "Const" ) ) {
			String constName = line[ 6..line.indexOf( " " ) ];
			writeLine( all, line.replaceAll( constName, constName + num ) );
			consts.addLast( constName );
			continue;
		}

		if( line.startsWith( "Incbin" ) ) {
			if( incbins.contains( line ) ) continue;

			writeLine( all, line );
			continue;
		}

		line = line.replaceAll( "L_InitGraphics()", "L_CurrentCamera = LTCamera.Create()" );

		if( trim( line ) && ! line.startsWith( "'" ) ) {
			if( typeArea == -1 ) {
				writeLine( all, "'" + fileName );
				writeLine( all, "L_CurrentCamera = LTCamera.Create()" );
				if( line.startsWith( "Global Example" ) || line.startsWith( "Local Example" ) ) {
					typeArea = 1;
				} else {
					writeLine( all, "Ex" + num + "()" );
					writeLine( all, "Function Ex" + num + "()" );
					typeArea = 0;
				}
			}

			if( ! typeArea && ( line.startsWith( "Type" ) || line.startsWith( "Function" ) ) ) {
				writeLine( all, "End Function" );
				typeArea = true;
			}

			for( String equalName : equalNames ) {
				line = line.replaceAll( equalName, equalName + num );
			}
			for( String constName : consts ) {
				line = line.replaceAll( constName, constName + num );
			}
		}
		writeLine( all, line );
	}
	closeFile( file );
	if( typeArea == 0 ) writeLine( all, "End Function" );
	if typeArea >= 0 writeLine( all, "Cls" ); num += 1then;
}

writeLine( all, "L_PrintText( \"Press ESC to end\", 0, 0, LTAlign.ToCenter, LTAlign.ToCenter )" );
writeLine( all, "Flip" );
writeLine( all, "Waitkey" );
closeFile( all );
