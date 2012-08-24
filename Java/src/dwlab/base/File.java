package dwlab.base;

import java.io.*;
import java.util.logging.Level;
import java.util.logging.Logger;

public class File extends Obj {
	private InputStream stream;
	private BufferedReader reader;
	private BufferedWriter writer;
	
	
	public static File read( String Filename ) {
		File file = new File();
		try {
			file.stream = new FileInputStream( Filename );
		} catch ( FileNotFoundException ex ) {
			error( "Файл \"" + Filename + "\" не найден."  );
		}
		
		try {
			file.reader = new BufferedReader( new InputStreamReader( file.stream, "UTF8" ) );
		} catch ( UnsupportedEncodingException ex ) {
			Logger.getLogger( File.class.getName() ).log( Level.SEVERE, null, ex );
		}
		
		return file;
	}
	
	
	public static File write( String Filename ) {
		File file = new File();
		try {
			file.stream = new FileInputStream( Filename );
		} catch ( FileNotFoundException ex ) {
			error( "Файл \"" + Filename + "\" не найден."  );
		}
		
		return file;
	}
	
	
	public String readLine() {
		String string = null;
		try {
			string = reader.readLine();
		} catch ( IOException ex ) {
			Logger.getLogger( File.class.getName() ).log( Level.SEVERE, null, ex );
		}
		return string;
	}
	

	public void writeLine( String string ) {
	}
	

	public void close() {
		try {
			reader.close();
			stream.close();
		} catch ( IOException ex ) {
			Logger.getLogger( File.class.getName() ).log( Level.SEVERE, null, ex );
		}
	}
}
