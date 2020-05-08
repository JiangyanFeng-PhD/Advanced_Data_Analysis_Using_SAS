* implemented in SAS Studio;
* data for HW3;
* ods html close; 
* ods preferences;
* ods html newfile=proc;
options nodate nonumber;
title ;
ods rtf file='C:\Stat 448\HW5_results.rtf' nogtitle startpage=no;
ods noproctitle;

data epil;
    infile 'C:\Stat 448\epi.dat' expandtabs;
    input Id P1 P2 P3 P4 Treat BL Age;
	drop Id P2 P3;
	/* remaining variables are:
		P1 - number of seizures in first two-week period
		P4 - number of seizures in fourth two-week period
		Treat - treament (0 for placebo, 1 for progabide)
		BL - baseline seizure count
		Age - age in years 
	  */
run;

data wine;
	infile 'C:\Stat 448\wine.txt' dlm=',';
	input alcohol malic_acid ash alcalinity_ash magnesium total_phenols flavanoids nonflavanoid_phenols proanthocyanins color hue od280_od315 proline;
run;

* code for exercise 1;
* code for 1a;
* first fit the linear-log model;
proc genmod data=epil;
	model P4=Treat BL P1 Age/dist=poisson link=log type1 type3;
  	ods select ModelInfo ModelFit ParameterEstimates Type1 Type3;
run;
* estimate the scale;
proc genmod data=epil;
	model P4=Treat BL P1 Age/dist=poisson link=log type1 type3 scale=deviance;
  	ods select ModelInfo ModelFit ParameterEstimates Type1 Type3;
run;
* code for 1b;
proc genmod data=epil;
	model P4=BL/dist=poisson link=log type1 type3;
  	ods select ModelInfo ModelFit ParameterEstimates Type1 Type3;
run;

proc genmod data=epil;
	model P4=BL/dist=poisson link=log type1 type3 scale=deviance;
	output out = poisres pred=presp_n stdreschi=presids stdresdev=dresids;
  	ods select ModelInfo ModelFit ParameterEstimates Type1 Type3;
run;
* plot residuals;
proc sgscatter data=poisres;
	compare y = (presids dresids) x=presp_n;
run;

* code for exercise 2;
* code for 2a;
* first fit the linear-log model;
proc genmod data=epil;
	model P1=Treat BL Age/dist=poisson link=log type1 type3;
  	ods select ModelInfo ModelFit ParameterEstimates Type1 Type3;
run;
* estimate the scale;
proc genmod data=epil;
	model P1=Treat BL Age/dist=poisson link=log type1 type3 scale=deviance;
  	ods select ModelInfo ModelFit ParameterEstimates Type1 Type3;
run;

* code for 2b;
proc genmod data=epil;
	model P1=BL Age/dist=poisson link=log type1 type3;
  	ods select ModelInfo ModelFit ParameterEstimates Type1 Type3;
run;
proc genmod data=epil;
	model P1=BL Age/dist=poisson link=log type1 type3 scale=deviance;
	output out = poisres pred=presp_n stdreschi=presids stdresdev=dresids;
  	ods select ModelInfo ModelFit ParameterEstimates Type1 Type3;
run;
* plot residuals;
proc sgscatter data=poisres;
	compare y = (presids dresids) x=presp_n;
run;

* code for exercise 3;
* code for 3a;
proc princomp data=wine;
	var malic_acid--proline;
	id alcohol;
run;
* code for 3b;
* no code needed;

* code for 3c;
proc princomp data=wine plots= score(ellipse ncomp=4);
	id alcohol;
	ods select ScorePlot;
run;

* code for exercise 4;
* code for 4a;
proc princomp data=wine cov; 
	var malic_acid--proline;
	id alcohol;
run;

* code for 4b;
* no code needed;

* code for 4c;
proc princomp data=wine cov plots= score(ellipse ncomp=2);
	id alcohol;
	ods select ScorePlot;
run;

ods rtf close;


