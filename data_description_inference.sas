* implemented in SAS Studio;
* data for HW1;
* ods html close; 
* ods preferences;
* ods html newfile=proc;
options nodate nonumber;
title ;
ods rtf file='/home/jf800/HW/HW1/HW1_results.rtf' nogtitle startpage=no;
ods noproctitle;

data seeds;
	infile 'C:\Stat 448\seeds_dataset.txt' expandtabs;
	input area perimeter compactness length width 
		asymmetry groovelength variety $;
	if variety = '1' then variety = 'Kama';
	if variety = '2' then variety = 'Rosa';
 	if variety = '3' then variety = 'Canadian';
run;

* code for exercise 1;
* code for 1a;
proc univariate data = seeds;
	var area;
	ods select Moments BasicMeasures;
run;

* code for 1b;
* sort the data by varitety first;
proc sort data = seeds;
	by variety;
run;
proc univariate data = seeds;
	var area;
	by variety;
	ods select Moments BasicMeasures;
run;

* code for exercise 2;
* code for 2a;
proc univariate data = seeds normaltest;
	var area;
	histogram area / normal;
	probplot area;
	ods select TestsForNormality Histogram ProbPlot;
run;

* code for 2b;
* sort the data by varitety first;
proc sort data = seeds;
	by variety;
run;
proc univariate data = seeds normaltest;
	var area;
	by variety;
	histogram area / normal;
	probplot area;
	ods select TestsForNormality Histogram ProbPlot;
run;

* code for exercise 3;
* code for 3a;
proc univariate data = seeds mu0 = 14;
	var area;
	ods select TestsForLocation;
run;

* code for 3b;
* select the data where varitey is not Canadian;
data seeds2;
  set seeds;
  where variety ~= 'Canadian';
run;
* compare Rosa vs. Kama;
proc npar1way data = seeds2 WILCOXON;
	class variety;
	var area;
	ods exclude KruskalWallisTest;
run;

* code for exercise 4;
* code for 4a;
proc corr data = seeds pearson spearman;
	var area compactness width;
	ods select PearsonCorr SpearmanCorr;
run;

* code for 4b;
proc corr data = seeds pearson spearman;
	var area compactness width;
	by variety;
	ods select PearsonCorr SpearmanCorr;
run;
ods rtf close;




