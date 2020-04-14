* implemented in SAS Studio;
* data for HW3;
* ods html close; 
* ods preferences;
* ods html newfile=proc;
options nodate nonumber;
title ;
ods rtf file='C:\Stat 448\HW4_results.rtf' nogtitle startpage=no;
ods noproctitle;

proc import datafile="C:\Stat 448\Indian Liver Patient Dataset (ILPD).csv"
	out= liver
	dbms = csv
	replace;
	getnames=no;
run;
/* after importing, rename the variables to match the data description */
data liver;
	set liver;
	Age=VAR1; Gender=VAR2; TB=VAR3;	DB=VAR4; Alkphos=VAR5;
	Alamine=VAR6; Aspartate=VAR7; TP=VAR8; ALB=VAR9; AGRatio=VAR10;
	if VAR11=1 then LiverPatient=1;
		Else LiverPatient=0;
	drop VAR1--VAR11;
run;

* code for exercise 1;
* code for 1a;
* backward selection;
proc logistic data = liver desc;
	class Gender / param=reference;
	model LiverPatient = Age -- AGRatio / selection=backward;
run;

* build model based on selection results and check unduly influential points;
proc logistic data = liver desc;
	model LiverPatient = Age DB Alamine TP ALB / influence lackfit;
	output out=diagnostics cbar=cbar;
	ods select OddsRatios ParameterEstimates 
		GlobalTests ModelInfo FitStatistics InfluencePlots;
run;

* find the unduly influential points;
proc print data=diagnostics;
	where cbar >= 0.1;
run;

* reselect;
proc logistic data = diagnostics desc;
	class Gender / param=reference;
	where cbar < 0.1;
	model LiverPatient = Age -- AGRatio / selection=backward;
run;

* refit based on selection results;
proc logistic data = diagnostics desc;
	model LiverPatient = Age DB Alkphos Alamine TP ALB / influence lackfit;
	where cbar < 0.1;
	ods select OddsRatios ParameterEstimates 
		GlobalTests ModelInfo FitStatistics InfluencePlots lackfitpartition lackfitchisq;
run;

* code for 1b;
* no code needed;

* code for 1c;
* no code needed;

* code for exercise 2;
* code for 2a;
* create a female only data;
data liverf;
	set liver;
	where Gender = 'Female';
run;

* backward selection;
proc logistic data = liverf desc;
	class Gender / param=reference;
	model LiverPatient = Age -- AGRatio / selection=backward;
run;
* build model based on selection results and check unduly influential points;
proc logistic data = liverf desc;
	model LiverPatient = Aspartate TP ALB / influence lackfit;
	output out=diagnostics cbar=cbar;
	ods select OddsRatios ParameterEstimates 
		GlobalTests ModelInfo FitStatistics InfluencePlots lackfitpartition lackfitchisq;
run;

* code for 2b;
* no code needed;

* code for 2c;
* no code needed;

* code for exercise 3;
* code for 3a;
* create a male only data;
data liverm;
	set liver;
	where Gender = 'Male';
run;
* backward selection;
proc logistic data = liverm desc;
	class Gender / param=reference;
	model LiverPatient = Age -- AGRatio / selection=backward;
run;
proc logistic data = liverm desc;
	model LiverPatient = Age DB Alamine / influence lackfit;
	output out=diagnostics cbar=cbar;
	ods select OddsRatios ParameterEstimates 
		GlobalTests ModelInfo FitStatistics InfluencePlots lackfitpartition lackfitchisq;
run;
* find the unduly influential points;
proc print data=diagnostics;
	where cbar >= 0.2;
run;
* reselect;
proc logistic data = diagnostics desc;
	class Gender / param=reference;
	where cbar < 0.2;
	model LiverPatient = Age -- AGRatio / selection=backward;
run;
* refit based on selection results;
proc logistic data = diagnostics desc;
	model LiverPatient = Age DB Alkphos Alamine / influence lackfit;
	where cbar < 0.2;
	output out=diagnostics cbar=cbar;
	ods select OddsRatios ParameterEstimates 
		GlobalTests ModelInfo FitStatistics InfluencePlots lackfitpartition lackfitchisq;
run;


* code for 3b;
* no code needed;

* code for 3c;
* no code needed;
ods rtf close;












