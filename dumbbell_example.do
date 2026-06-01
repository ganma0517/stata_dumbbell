*===============================================================*
* dumbbell — example / tutorial do-file
* Uses the bundled practice data (fictional; no real-world source):
* average weekly study hours at 12 imaginary universities, two waves.
* Long format: school, wave, hours.
*===============================================================*
clear all
set more off

* load practice data from the repo (no install needed)
use "https://raw.githubusercontent.com/ganma0517/stata_dumbbell/main/dumbbell_demo.dta", clear

* 1) Basic: sorted by the later wave
dumbbell hours, over(school) time(wave)

* 2) With titles and an x-axis title
dumbbell hours, over(school) time(wave) sortby(high) ///
    xtitle("Average weekly study hours") ///
    title("Study hours rose at most universities") ///
    subtitle("Wave 1 vs Wave 2 (fictional data)")

* 3) Sort by the earlier wave, ascending
dumbbell hours, over(school) time(wave) sortby(low) ascending

* 4) Custom colors and legend labels
dumbbell hours, over(school) time(wave) ///
    c1(gs10) c2(cranberry) l1("Wave 1") l2("Wave 2") ///
    title("Custom colors")

* 5) Export to PNG
dumbbell hours, over(school) time(wave) sortby(high) ///
    saving("dumbbell_demo.png")

display as result "dumbbell tutorial finished — see help dumbbell."
