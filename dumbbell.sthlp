{smcl}
{* *! version 1.0  31may2026}{...}
{vieweralsosee "twoway rspike" "help twoway rspike"}{...}
{vieweralsosee "twoway scatter" "help twoway scatter"}{...}
{vieweralsosee "reshape" "help reshape"}{...}
{viewerjumpto "Syntax" "dumbbell##syntax"}{...}
{viewerjumpto "Description" "dumbbell##description"}{...}
{viewerjumpto "Options" "dumbbell##options"}{...}
{viewerjumpto "Examples" "dumbbell##examples"}{...}
{viewerjumpto "Author" "dumbbell##author"}{...}
{title:Title}

{phang}
{bf:dumbbell} {hline 2} Dumbbell (connected-dot) plot comparing two time points by category


{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmd:dumbbell}
{it:yvar}
{ifin}
{cmd:,}
{opth over(varname)}
{opth time(varname)}
[{it:options}]

{synoptset 24 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{p2coldent:* {opth over(varname)}}category variable (one row per category-time){p_end}
{p2coldent:* {opth time(varname)}}time/period variable; must take exactly two values{p_end}

{syntab:Sorting}
{synopt:{opt sortby(string)}}sort by {cmd:high} (later period, default) or {cmd:low} (earlier){p_end}
{synopt:{opt des:cending}}largest value at top (default){p_end}
{synopt:{opt asc:ending}}smallest value at top{p_end}

{syntab:Appearance}
{synopt:{opt c1(string)}}color of the EARLIER point; default light blue{p_end}
{synopt:{opt c2(string)}}color of the LATER point; default dark navy{p_end}
{synopt:{opt l:color(string)}}connecting-line color; default {cmd:gs11}{p_end}
{synopt:{opt ms:ize(string)}}marker size; default {cmd:medlarge}{p_end}
{synopt:{opt labs:ize(string)}}category (y) label size; default {cmd:small}{p_end}

{syntab:Titles and axis}
{synopt:{opt title(string)}}graph title{p_end}
{synopt:{opt sub:title(string)}}subtitle{p_end}
{synopt:{opt xtit:le(string)}}x-axis title; default = {it:yvar} label{p_end}
{synopt:{opt xlab:el(string)}}x-axis label spec, e.g. {cmd:0(5)30, grid}{p_end}

{syntab:Legend / saving}
{synopt:{opt l:egend(string)}}{cmd:on} (default) or {cmd:off}{p_end}
{synopt:{opt l1(string)}}legend label for earlier point; default = its value{p_end}
{synopt:{opt l2(string)}}legend label for later point; default = its value{p_end}
{synopt:{opt saving(string)}}export the graph to this path{p_end}
{synopt:{opt name(string)}}graph window name; default {cmd:dumbbell}{p_end}
{synoptline}
{p 4 6 2}* {opt over()} and {opt time()} are required.{p_end}


{marker description}{...}
{title:Description}

{pstd}
{cmd:dumbbell} draws a {bf:dumbbell plot} (also called a connected-dot or
dumbbell chart): for each category it plots the value at two time points as two
markers joined by a line, with categories sorted by one period's value. It is
ideal for showing change between two years across many groups (e.g. country
rankings in {it:year A} vs {it:year B}).

{pstd}
Input is in {bf:long format}: one observation per category-time, with the
outcome in {it:yvar}, the category in {opt over()}, and the period in
{opt time()}. The {opt time()} variable must take exactly two values; the
smaller is treated as the earlier point ({opt c1}, {opt l1}) and the larger as
the later point ({opt c2}, {opt l2}).


{marker options}{...}
{title:Options}

{phang}{opth over(varname)} is the category variable (string or numeric).

{phang}{opth time(varname)} is the two-valued period variable (string or
numeric). Exactly two distinct values are required.

{phang}{opt sortby(string)} chooses which period orders the categories:
{cmd:high} (default, the later period) or {cmd:low} (the earlier period).

{phang}{opt descending} (default) puts the largest value at the top;
{opt ascending} flips it.

{phang}{opt c1(string)} / {opt c2(string)} set the earlier / later marker colors
(any Stata color spec, e.g. {cmd:navy}, {cmd:"149 207 245"}).

{phang}{opt lcolor(string)}, {opt msize(string)}, {opt labsize(string)} control
the line color, marker size, and category-label size.

{phang}{opt title()}, {opt subtitle()}, {opt xtitle()}, {opt xlabel()} set
titles and the x-axis. Surrounding quotes you type are handled automatically.

{phang}{opt legend(string)} turns the legend {cmd:on} (default) or {cmd:off};
{opt l1()} / {opt l2()} override the legend labels.

{phang}{opt saving(string)} exports the graph; {opt name(string)} names the
graph window.


{marker examples}{...}
{title:Examples}

{pstd}Load the bundled practice data (fictional study-hours data, two waves){p_end}
{phang2}{cmd:. use "https://raw.githubusercontent.com/ganma0517/stata_dumbbell/main/dumbbell_demo.dta", clear}{p_end}

{pstd}Basic dumbbell sorted by the later wave{p_end}
{phang2}{cmd:. dumbbell hours, over(school) time(wave)}{p_end}

{pstd}With titles{p_end}
{phang2}{cmd:. dumbbell hours, over(school) time(wave) sortby(high) title("Study hours by university") subtitle("Wave 1 vs Wave 2")}{p_end}

{pstd}Sort by the earlier wave, ascending, custom colors{p_end}
{phang2}{cmd:. dumbbell hours, over(school) time(wave) sortby(low) ascending c1(gs10) c2(cranberry)}{p_end}

{pstd}Custom legend labels{p_end}
{phang2}{cmd:. dumbbell hours, over(school) time(wave) l1("Wave 1") l2("Wave 2")}{p_end}


{marker author}{...}
{title:Author}

{pstd}{bf:Wen-Cheng Lin (林文正)}{break}
PhD student, Department of Political Science, National Chengchi University{break}
Postdoctoral research fellow, Institute of Sociology, Academia Sinica{break}
Email: beck740517@gmail.com{break}
{browse "https://github.com/ganma0517/stata_dumbbell":github.com/ganma0517/stata_dumbbell}{p_end}

{pstd}This package is a collaboration between the author and Claude. It is still
at an experimental stage and is intended mainly for presenting results from
survey-experiment and comparative designs. Questions and feedback are very welcome.{p_end}

{pstd}本套件是作者與 Claude 的協作成果，目前仍屬實驗性階段，主要用於調查實驗法與
比較研究的資訊呈現。若有任何問題，歡迎來信交流。{p_end}
