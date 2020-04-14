* implemented in SAS Studio;
* data for HW3;
* ods html close; 
* ods preferences;
* ods html newfile=proc;
options nodate nonumber;
title ;
ods rtf file='C:\Stat 448\HW3_results.rtf' nogtitle startpage=no;
ods noproctitle;
data anovafish;
	length widthgroup $7.;
	set sashelp.fish;
	if width>4.4175 then widthgroup='wider';
		else widthgroup='thinner';
	where species='Bream' or species='Perch';
proc sort data=anovafish;
	by species;
run;

* code for exercise 1;
* code for 1a;
proc tabulate data=anovafish;
	class species widthgroup;
	var weight;
	table species*widthgroup, weight*(mean std n);
run;


* code for 1b;
* with only main effects;
proc glm data=anovafish;
	class species widthgroup;
	model weight = species widthgroup;
run;
* switch order;
proc glm data=anovafish;
	class species widthgroup;
	model weight = widthgroup species;
run;
* add interaction;
proc glm data=anovafish;
	class species widthgroup;
	model weight = species | widthgroup;
run;
* remove species;
proc glm data=anovafish;
	class widthgroup;
	model weight = widthgroup;
run;

* code for 1c;
proc glm data=anovafish;
	class species widthgroup;
	model weight = species | widthgroup;
	lsmeans species | widthgroup / pdiff = all cl;
run;

* code for exercise 2;
* code for 2a;
proc reg data=anovafish;
	model weight = length1;
	output out=diagnostics cookd=cd;
run;
* find the unduly influential points;
proc print data=diagnostics;
		where cd > 0.6;
run;
* fit the model using the remaining data;
proc reg data=diagnostics;
	model weight = length1;	
	where cd < 0.6;
run;

* code for 2b;
* no code needed;

* code for exercise 3;
* code for 3a;
* pairwise scatter plot;
proc sgscatter data=anovafish;
	matrix weight--width;
run;
* all predictors and vifs;
proc reg data=anovafish;
	model weight = length1--width/vif;
run;
* remove largest vifs;
proc reg data=anovafish;
	model weight = length1 length3 height width/vif;
run;
* remove largest vifs;
proc reg data=anovafish;
	model weight = length1 height width/vif;
run;
* remove largest vifs;
proc reg data=anovafish;
	model weight = height width/vif;
run;
* stepwise selection;
proc reg data=anovafish;
	model weight = length1--width/selection=stepwise sle=.05 sls=.05;
	ods select SelectionSummary;
run;
* forward selection;
proc reg data=anovafish;
	model weight = length1--width/selection=forward sle=.05;
	ods select SelectionSummary;
run;
* backward selection;
proc reg data=anovafish;
	model weight = length1--width/selection=backward sls=.05;
	ods select SelectionSummary;
run;

* the final model chosen by all selections;
proc reg data=anovafish;
	model weight = length2 height width length3;
	output out=diagnostics2 cookd=cd;
run;
* refit by removing unduly influential point;
proc print data=diagnostics2;
		where cd > 0.4;
run;
proc reg data=diagnostics2;
	model weight = length2 height width length3;
	where cd < 0.4;
run;
* code for 3b;
* no code needed;

* code for exercise 4;
* adding log terms;
data anovafish;
	set anovafish;
	logwe = log(weight);
	logl1 = log(length1);
	logl2 = log(length2);
	logl3 = log(length3);
	logh = log(height);
	logw = log(width);
run;
* repeat the analysis in exercise 3 using log terms;
* stepwise selection;
proc reg data=anovafish;
	model logwe = logl1--logw/selection=stepwise sle=.05 sls=.05;
	ods select SelectionSummary;
run;
* forward selection;
proc reg data=anovafish;
	model logwe = logl1--logw/selection=forward sle=.05;
	ods select SelectionSummary;
run;
* backward selection;
proc reg data=anovafish;
	model logwe = logl1--logw/selection=backward sls=.05;
	ods select SelectionSummary;
run;

* the final model chosen by all selections;
proc reg data=anovafish;
	model logwe = logw logh logl1;
	output out=diagnostics3 cookd=cd;
run;
* refit by removing unduly influential point;
proc print data=diagnostics3;
		where cd > 0.4;
run;
proc reg data=diagnostics3;
	model logwe = logw logh logl1;
	where cd < 0.4;
run;

ods rtf close;












