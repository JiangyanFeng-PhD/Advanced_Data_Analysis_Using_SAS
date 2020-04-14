* implemented in SAS Studio;
* data for HW2;
* ods html close; 
* ods preferences;
* ods html newfile=proc;
options nodate nonumber;
title ;
ods rtf file='C:\Stat 448\HW2_results.rtf' nogtitle startpage=no;
ods noproctitle;
data cardata;
	infile 'C:\Stat 448\car.data' dlm=',';
	input buy $ maintain $ doors $ persons $ lug_boot $ safety $ acceptable $;
	if acceptable ne 'unacc' then acceptyesno = 'yes';
	if acceptyesno ne 'yes' then acceptyesno = 'no';
	if acceptable = 'unacc' then acclevel=1;
	if acceptable = 'acc' then acclevel=2;
	if acceptable = 'good' then acclevel=3;
	if acceptable = 'vgood' then acclevel=4;
run;
/* data is sorted here so the data is in order of increasing acceptability rating */
proc sort data=cardata;
	by acclevel;
run;

data bupa;
	infile 'C:\Stat 448\bupa.data' dlm=',';
	input mcv alkphos sgpt sgot gammagt drinks selector;
	drinkgroup = "less than 1";
	If 1<=drinks<3 then drinkgroup = "1 or 2";
	If 3<=drinks<6 then drinkgroup = "3 to 5";
	If 6<=drinks<9 then drinkgroup = "6 to 8";
	If 9<=drinks then drinkgroup ="9 or more";
run;

* code for exercise 1;
* code for 1a;
proc freq data=cardata order=data;
	tables safety*acceptable/nopercent norow nocol expected;
run;
* code for 1b;
proc freq data=cardata order=data;
	tables safety*acceptable/nopercent norow nocol expected chisq;
run;
* code for 1c;
proc freq data=cardata order=data;
	tables safety*acceptyesno/nopercent norow nocol expected chisq;
run;



* code for exercise 2;
* first, remove safety=low in data;
data cardata2;
  set cardata;
  where safety ~= 'low';
run;
proc sort data=cardata2;
	by acclevel;
run;
* code for 2a;
proc freq data=cardata2 order=data;
	tables safety*acceptable/nopercent norow nocol expected;
run;
* code for 2b;
proc freq data=cardata2 order=data;
	tables safety*acceptable/nopercent norow nocol expected chisq;
run;
* code for 2c;
proc freq data=cardata2 order=data;
	tables safety*acceptyesno/nopercent norow nocol expected chisq riskdiff;
run;


* code for exercise 3;
* code for 3a;	
* test equal variance using Tukey's comparison;
* one-way anova model;
proc anova data=bupa;
	class drinkgroup;
	model sgpt = drinkgroup;
	means drinkgroup /hovtest;
run;

* code for 3b;
* check significant differences of group means using Tukey's comparison;
proc anova data=bupa;
	class drinkgroup;
	model sgpt = drinkgroup;
	means drinkgroup /tukey cldiff;
run;


* code for exercise 4;
* code for 4a;
proc anova data=bupa;
	class drinkgroup;
	model gammagt = drinkgroup;
	means drinkgroup /hovtest;
run;

* code for 4b;
proc anova data=bupa;
	class drinkgroup;
	model gammagt = drinkgroup;
	means drinkgroup /tukey cldiff;
run;

ods rtf close;































