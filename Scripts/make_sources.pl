#!/usr/bin/perl

opendir(ISPLEVER, "../ispLEVER/") || die "Can't open dir ../ispLEVER!";

#while ($dir=readdir(ISPLEVER)) {
#    push(@dirs, $dir);
#}

@vhdl_source_dirs = grep { /\A(\d{2}_.+?|Common_Files|Libraries\Z)/ } readdir(ISPLEVER);
#@vhdl_source_dirs = grep { /^\./ && -f "$some_dir/$_" } @dirs;


$, = "\n";
$\ = "\n";

#print(@vhdl_source_dirs);

closedir ISPLEVER;

if (!( -e "../ROOT_STUD/ispLEVER" || -d "../ROOT_STUD/ispLEVER")) {
    print("Creating ispLEVER directory for students");
    mkdir("../ROOT_STUD/ispLEVER") or die "Can't create Directory"
}

if (!( -e "../ROOT_TUT/ispLEVER" || -d "../ROOT_TUT/ispLEVER")) {
    print("Creating ispLEVER directory for tutors");
    mkdir("../ROOT_TUT/ispLEVER") or die "Can't create Directory"
}

foreach $dir (@vhdl_source_dirs) {
    opendir (SRCDIR, "../ispLEVER/$dir");
    @dir_files = grep { /\A.+?\.vhd\Z/ } readdir(SRCDIR);
    foreach $file (@dir_files) {
	open(READFILE, "< ../ispLEVER/$dir/$file");
	undef $/; 
	$stud_path = "../ROOT_STUD/ispLEVER/$dir";
	if (!( -e $stud_path || -d $stud_path)) {
	    mkdir($stud_path);
	    print("Creating $dir for Students");
	}
	$tut_path = "../ROOT_TUT/ispLEVER/$dir";
	if (!( -e $tut_path || -d $tut_path)) {
	    mkdir($tut_path);
	    print("Creating $dir for Tutors");
	}
	$doc_path = "../Ausarbeitung/Skript/VHDL_SRC/";
	if (!( -e $doc_path || -d $doc_path)) {
	    mkdir($doc_path);
	    print("Creating $dir in Documentation");
	}
	$full_file = <READFILE>;
	$students_file = $full_file;
	$tutors_file = $full_file;
	$doctut_file = $full_file;
	$students_file =~ s/(^[ -]{2,5}STARTL$)(.+?)(^[ -]{2,5}STOPL$)/\n-- WRITE_HERE\n/gms;
#	$tutors_doc =~ s/(\A(--.*?)(library))?(.*?)(^[ -]{2,5}STARTL$)(.+)(^[ -]{2,5}STOPL$)(.*)/$2--Loesung Anfang$6--Loesung Ende/gms;
	$doc_file = $students_file;
	if($doc_file =~ m/STARTD(.*)STOPD/gms) {
	    $doc_file =~ s/(.*?)(^[ -]{2,5}STARTD$)(.+?)(^[ -]{2,5}STOPD$)(.*)/$3/gms;
	    $students_file =~ s/((^[ -]{2,5}STARTD$)|(^[ -]{2,5}STOPD$))//gms;
#	    $doctut_file =~ s/((^[ -]{2,5}STARTD$)|(^[ -]{2,5}STOPD$))//gms;
	}else{
#	    print("In $file sind keine Vorkommen von DOC-Teilen");
	    undef $doc_file;
	}
	$tutors_file =~ s/(^[ -]{2,5}STARTL$)/  -- Musterloesung Anfang/gms;
	$tutors_file =~ s/(^[ -]{2,5}STOPL$)/  -- Musterloesung Ende/gms;
	$doctut_file = $tutors_file;
	if($doctut_file =~ m/STARTD(.*)STOPD/gms) {
#	    $doctut_file =~ s/(.*?)(^[ -]{2,5}STARTL$)(.+?)(^[ -]{2,5}STOPL$)(.*)/--Musterloesung Anfang$3--Musterloesung Ende/gms;
	    $tutors_file =~ s/((^[ -]{2,5}STARTD$)|(^[ -]{2,5}STOPD$))//gms;
	    $doctut_file =~ s/(.*?)(^[ -]{2,5}STARTD$)(.+?)(^[ -]{2,5}STOPD$)(.*)/$3/gms;
	}else{
	    undef $doctut_file;
	}

#	if($file eq "multiplexer.vhd") {
#	    print("FILE: multiplexer.vhd");
#	    print("STUDENTS:");
#	    print($students_file);
#	    print("TUTORS:");
#	    print($tutors_file);
#	    print("DOC:");
#	    print($doc_file);
#	    print("DOC_TUT:");
#	    print($doctut_file);
#	}
	
	if(!($full_file =~ m/--NOCOPY/gms)) {
		if ($students_file) {
    			open (STUDFILE, "> $stud_path/$file");
	    		print STUDFILE $students_file;
	    		close (STUDFILE);
		}
	}
	if ($tutors_file) {
	    open (TUTFILE, "> $tut_path/$file");
	    print TUTFILE $tutors_file;
	    close (TUTFILE);
	}
	if ($doc_file) {
	    open (STUD_DOCFILE, "> $doc_path/stud_$file");
	    open (TUT_DOCFILE, "> $doc_path/tut_$file");
	    print STUD_DOCFILE $doc_file;
	    print TUT_DOCFILE $doctut_file;
	    close (STUD_DOCFILE);
	    close (TUT_DOCFILE);
	}
	close(READFILE);
#	print("\n");
    }
}

$/ = "\n";
print("Waiting for user. Enter to quit.");
$wait_input = <STDIN>;
