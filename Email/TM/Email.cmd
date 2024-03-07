%{
  #ifdef SERVER
  #include <time.h>
  #include "nl.h"
  
  void email_report( int level, const char *file, const char *message ) {
    FILE *fp;
    char timebuf[40];
    time_t time_of_day;

    time_of_day = time(0);
    strftime(timebuf, 40, "%a, %d %b %Y %T %z", localtime(&time_of_day));
    fp = fopen( "report.queue", "a" );
    if ( fp == 0 ) msg( 2, "Unable to write to report.queue" );
    else {
      if ( file != 0 ) {
        fprintf( fp, "[%s] %d [%s] %s\n", timebuf, level, file, message );
      } else fprintf( fp, "[%s] %d %s\n", timebuf, level, message );
      fclose(fp);
    }
  }

  #endif /* SERVER */
%}
&command
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
