* implemented in SAS Studio;
* data for HW6;
* ods html close; 
* ods preferences;
* ods html newfile=proc;
options nodate nonumber;
title ;
ods rtf file='C:\Stat 448\HW6_results.rtf' nogtitle startpage=no;
ods noproctitle;

data wine;
	infile 'C:\Stat 448\wine.txt' dlm=',';
	input alcohol malic_acid ash alcalinity_ash magnesium total_phenols flavanoids nonflavanoid_phenols proanthocyanins color hue od280_od315 proline;
run;

* code for exercise 1;
* code for 1a;
proc cluster data=wine method=average std ccc pseudo print=15 plots=all;
	var malic_acid--proline;
	copy alcohol;
	ods select ClusterHistory Dendrogram CccPsfAndPsTSqPlot;
run;

* code for 1b;
proc tree noprint ncl=9 out=out;
	copy alcohol malic_acid--proline;
run;
proc sort data=out;
	by cluster;
run;
proc freq data=out;
	tables cluster*alcohol / nopercent norow nocol;
run;
proc means data=out;
	var malic_acid--proline;
	by cluster;
run;

* code for exercise 2;
* code for 2a;
proc princomp data=out n=2 out=pcout;
	var malic_acid--proline;
run;
proc sgplot data=pcout;
	scatter y=prin1 x=prin2 /markerchar=alcohol;
run;

* code for 2b;
proc cluster data=pcout method=average std ccc pseudo print=15 plots=all;
	var prin1 prin2;
	copy alcohol;
	ods select ClusterHistory Dendrogram CccPsfAndPsTSqPlot;
run;

* code for 2c;
proc tree noprint ncl=4 out=out2;
	copy alcohol;
run;
proc sort data=out2;
	by cluster;
run;
proc freq data=out2;
	tables cluster*alcohol / nopercent norow nocol;
run;

* code for exercise 3;
* code for 3a;
proc discrim data=wine out=outresub outd=outdens pool=test manova;
	class alcohol;
	var malic_acid--proline;
run;

* code for 3b;
proc discrim data=wine pool=test crossvalidate manova;
	class alcohol;
	var malic_acid--proline;
run;

* code for exercise 4;
* code for 4a;
proc stepdisc data=wine sle=.05 sls=.05;
	class alcohol;
	var malic_acid--proline;
	ods select Summary;
run;

proc discrim data=wine pool=test crossvalidate manova;
	class alcohol;
	var nonflavanoid_phenols hue malic_acid magnesium alcalinity_ash od280_od315 proline ash proanthocyanins;
run;

* code for 4b;
* no code needed;

ods rtf close;


