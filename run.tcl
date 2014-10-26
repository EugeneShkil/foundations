#!/usr/bin/tclsh

set PROLOG_FILE [file join . base calculate.pl];

#set OUT_TO_CONSOLE false;
set OUT_TO_CONSOLE true;

set PROLOG_MODULE_NAME [file root [file tail $PROLOG_FILE]];

if { $OUT_TO_CONSOLE } then {
	set OUT "@stdout";
	set ERR "@stderr";
} else {
	set OUT "$PROLOG_MODULE_NAME.out";
	set ERR "$PROLOG_MODULE_NAME.err";
};


proc Run {} {
	global PROLOG_FILE OUT ERR;
	if { [catch {
		exec swipl --quiet -s $PROLOG_FILE -g "calculate:calculate" >$OUT 2>$ERR;
	} E ] } then {
		puts "ERROR: $E";
	};
};

Run;

#if { $OUT_TO_CONSOLE } then { puts "TCL MESSAGE: press Enter to exit"; set X [gets stdin]; };

exit 0;
