%{
  #ifdef SERVER
  #include "nl.h"
  
  void write_savelog( char *s ) {
    FILE *fp;
    fp = fopen( "saverun.log", "a" );
    if ( fp == 0 ) msg( 2, "Unable to write to saverun.log" );
    else {
      fprintf( fp, "%s\n", s );
      fclose( fp );
    }
  }
  #endif /* SERVER */
%}
&command
  : SaveLog %s (Enter Log Message) * { write_savelog( $2 ); }
  ;
