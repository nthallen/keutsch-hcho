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
  
  void email_report( int level, char *file, char *msgtxt ) {
    FILE *fp;
    fp = fopen( "report.queue", "a" );
    if ( fp == 0 ) msg( 2, "Unable to write to report.queue" );
    else {
      if ( file != 0 ) {
        fprintf( fp, "%d [%s] %s\n", level, file, msgtxt );
      } else fprintf( fp, "%d %s\n", level, msgtxt );
      fclose(fp);
    }
  }
  #endif /* SERVER */
%}
&command
  : SaveLog %s (Enter Log Message) * { write_savelog( $2 ); }
  : Email &rpt_level File %w (Enter Filename)
              %s (Enter Message) * {
      email_report( $2, $4, $5 );
    }
  : Email &rpt_level Message %s (Enter Message) * {
      email_report( $2, 0, $4 );
    }
  ;
&rpt_level <int>
  : Report { $0 = 0; }
  : Warning { $0 = 1; }
  : Error { $0 = 2; }
  ;
