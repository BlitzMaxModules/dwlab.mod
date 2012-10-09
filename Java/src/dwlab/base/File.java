package dwlab.base;

import java.io.*;
import java.util.logging.Level;
import java.util.logging.Logger;

public class File extends Obj {
	private BufferedReader reader;
	private PrintWriter writer;
	
	
	public static File read( String Filename ) {
		File file = new File();
		InputStream stream = null;
		try {
			stream = new FileInputStream( Filename );
		} catch ( FileNotFoundException ex ) {
			error( "Файл \"" + Filename + "\" не найден."  );
		}
		
		try {
			file.reader = new BufferedReader( new InputStreamReader( stream, "UTF8" ) );
		} catch ( UnsupportedEncodingException ex ) {
			Logger.getLogger( File.class.getName() ).log( Level.SEVERE, null, ex );
		}
		
		return file;
	}
	
	
	public static File write( String Filename ) {
		File file = new File();
		try {
			file.writer = new PrintWriter( new FileWriter( Filename ) );
		} catch ( IOException ex ) {
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
		writer.println( string );
	}
	

	public void close() {
		try {
			if( reader != null ) reader.close();
			if( writer != null ) writer.close();
		} catch ( IOException ex ) {
			Logger.getLogger( File.class.getName() ).log( Level.SEVERE, null, ex );
		}
	}
}
