*! dumbbell v1.1  8Jun2026
*! Dumbbell (connected-dot) plot: one row per category, two time points joined
*! by a line, sorted by one period's value. Long-format input.
*!
*! Syntax:
*!   dumbbell yvar , over(catvar) time(timevar) [ options ]
*!
*! ---- required ----
*!   over(varname)      category variable (one row per category-time)
*!   time(varname)      two-valued time/period variable (numeric or string)
*!
*! ---- sort order ----
*!   sortby(string)     "high" (default) or "low": which period's value to sort by
*!                      (high = the larger time value, e.g. 2023; low = smaller)
*!   descending         sort largest at top (default); ascending flips it
*!   ascending
*!
*! ---- colours, markers, line ----
*!   c1(string)         colour of the EARLIER time point (default "149 207 245")
*!   c2(string)         colour of the LATER time point   (default "26 43 76")
*!   lcolor(string)     connecting-line colour (default gs11)
*!   msize(string)      marker size (default medlarge)
*!
*! ---- axes, titles, legend ----
*!   xtitle(string)     x-axis title (default = yvar label)
*!   xlabel(string)     full x-axis label spec (e.g. "0(5)30, grid")
*!   labsize(string)    category (y) label text size (default small)
*!   title(string)      graph title
*!   subtitle(string)   subtitle
*!   legend(string)     "on" (default) or "off"
*!   l1(string)         legend label for earlier time (default = its value)
*!   l2(string)         legend label for later time   (default = its value)
*!
*! ---- output ----
*!   saving(string)     export path (e.g. "fig.png")
*!   name(string)       graph window name (default dumbbell)

program define dumbbell
    version 16.0
    syntax varname(numeric) , Over(varname) Time(varname)                ///
        [                                                                ///
          SORTby(string) DEScending ASCending                           /// sort
          C1(string) C2(string) Lcolor(string) MSize(string)            /// colours/markers
          XTITle(string asis) XLABel(string asis) LABSize(string)       /// axes
          title(string asis) SUBtitle(string asis)                      /// titles
          Legend(string) L1(string asis) L2(string asis)               /// legend
          saving(string) name(string) ]

    marksample touse
    * markout time (numeric); do NOT markout `over' if it is a string,
    * because markout drops every row when given a string variable.
    markout `touse' `time'
    capture confirm numeric variable `over'
    if !_rc markout `touse' `over'
    local y `varlist'

    * ---- defaults ----
    if "`c1'"     == "" local c1 "149 207 245"
    if "`c2'"     == "" local c2 "26 43 76"
    if "`lcolor'" == "" local lcolor "gs11"
    if "`msize'"  == "" local msize "medlarge"
    if "`labsize'"== "" local labsize "small"
    if "`name'"   == "" local name "dumbbell"
    if "`legend'" == "" local legend "on"
    if "`sortby'" == "" local sortby "high"
    if !inlist("`sortby'","high","low") {
        di as error "sortby() must be high or low"
        exit 198
    }
    if `"`xtitle'"' == "" {
        local xtl : variable label `y'
        if `"`xtl'"' == "" local xtl "`y'"
        local xtitle `"`xtl'"'
    }
    * strip a single layer of surrounding double quotes the user may have typed
    foreach t in title subtitle xtitle {
        local tv `"``t''"'
        if substr(`"`tv'"',1,1)==`"""' & substr(`"`tv'"',-1,1)==`"""' {
            local `t' = substr(`"`tv'"',2,length(`"`tv'"')-2)
        }
    }

    preserve
    quietly keep if `touse'

    * ---- numeric time key (handles string time too) ----
    capture confirm numeric variable `time'
    if _rc {
        tempvar tvar
        quietly egen `tvar' = group(`time'), label
    }
    else {
        tempvar tvar
        quietly gen double `tvar' = `time'
    }

    quietly levelsof `tvar', local(tvals)
    local nt : word count `tvals'
    if `nt' != 2 {
        di as error "time() must take exactly two values (found `nt')"
        exit 198
    }
    local tlo : word 1 of `tvals'   // earlier
    local thi : word 2 of `tvals'   // later

    * legend labels default to the original time values / their value labels
    if `"`l1'"' == "" {
        local l1lab : label (`time') `tlo'
        if `"`l1lab'"' != "" & "`l1lab'" != "`tlo'" local l1 `"`l1lab'"'
        else local l1 "`tlo'"
    }
    if `"`l2'"' == "" {
        local l2lab : label (`time') `thi'
        if `"`l2lab'"' != "" & "`l2lab'" != "`thi'" local l2 `"`l2lab'"'
        else local l2 "`thi'"
    }

    * ---- category key (string-safe) ----
    tempvar catid
    capture confirm numeric variable `over'
    if _rc {
        quietly egen `catid' = group(`over')
    }
    else {
        quietly gen double `catid' = `over'
    }

    * keep only what we need; build wide table by collapsing each time point
    quietly keep `y' `catid' `tvar' `over'

    tempvar vlo vhi
    quietly gen double `vlo' = `y' if `tvar'==`tlo'
    quietly gen double `vhi' = `y' if `tvar'==`thi'

    * one row per category: take the (single) non-missing value of each
    quietly collapse (firstnm) `vlo' `vhi' (firstnm) catname=`over', by(`catid')
    rename `vlo' _v_lo
    rename `vhi' _v_hi

    * ---- sort and assign plotting position ----
    if "`sortby'"=="high" local skey _v_hi
    else                  local skey _v_lo

    if "`ascending'" != "" local dir ""      // ascending -> smallest gets lowest y
    else                   local dir "-"     // descending (default) -> largest at top

    gsort `dir'`skey'
    quietly gen _pos = _N - _n + 1   // so first (largest) is at top

    * y-axis category labels
    local ylab ""
    quietly levelsof _pos, local(poss)
    foreach p of local poss {
        quietly levelsof catname if _pos==`p', local(nm) clean
        local ylab `ylab' `p' `"`nm'"'
    }

    * ---- build the plot ----
    quietly summarize _pos, meanonly
    local ymax = r(max)

    twoway ///
        (rspike _v_lo _v_hi _pos, horizontal lcolor(`lcolor') lwidth(medthin)) ///
        (scatter _pos _v_lo, mcolor("`c1'") msize(`msize') msymbol(O)) ///
        (scatter _pos _v_hi, mcolor("`c2'") msize(`msize') msymbol(O)) ///
        , ///
        ylabel(`ylab', noticks angle(0) labsize(`labsize') nogrid) ///
        ytitle("") ///
        yscale(range(0.5 `=`ymax'+0.5')) ///
        xtitle(`"`xtitle'"') ///
        xlabel(`xlabel') ///
        `=cond(`"`title'"'=="","",`"title(`"`title'"')"')' ///
        `=cond(`"`subtitle'"'=="","",`"subtitle(`"`subtitle'"')"')' ///
        legend(order(2 "`l1'" 3 "`l2'") `=cond("`legend'"=="off","off","")' ///
               position(4) ring(0) cols(1) region(lstyle(none))) ///
        graphregion(color(white)) plotregion(margin(l=2 r=4)) ///
        name(`name', replace)

    if `"`saving'"' != "" {
        quietly graph export `"`saving'"', replace width(2000)
        di as result "saved: `saving'"
    }
    restore
end
