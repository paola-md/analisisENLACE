
*Análisis
*********************************************
clear all
set more off
gl dir = "E:\Proy_Paola_Salo\Educacion\entregaBM"
gl source="E:\Proy_Paola_Salo\Educacion\hechosNotables\source"
gl basesA= "$dir\basesAuxiliares"
gl basesD = "$basesA\deleteMyFiles"
gl resultados ="$dir\resultados"
gl dofile = "$dir\do files"

*====================================================
// 1) descripcion panel_exacto.dta  y panel_fuzzy.dta
*====================================================
foreach x in panel_fuzzy panel_exacto {
	use  "$basesA\\`x'.dta", clear
	gen num_variables=11
	gen num_obs=_N
	bysort curp: gen aux_prim=(grado==3 | grado==4 | grado==5 | grado==6)
	bysort curp: egen aux2_prim=total(aux_prim)
	bysort curp: gen anyos_obs=_N
	gen d_prim_completa=aux2_prim==4
	bysort curp: gen aux_sec=(grado==7 | grado==8 | grado==9)
	bysort curp: egen aux2_sec=total(aux_sec)
	gen d_sec_completa=aux2_sec==3
	duplicates drop curp, force
	gen num_curps=_N
	egen prom_anyos_obs=mean(anyos_obs)
	egen num_prim_completa=total(d_prim_completa)
	egen num_sec_completa=total(d_sec_completa)
	duplicates drop cct, force
	gen num_cct=_N
	keep num_* prom_*
	gen nombre = "`x'"
	order nombre num_curp num_cct num_obs num_variables ///
	num_prim num_sec prom
	
	export excel using "$resultados\describe_bases.xls", sheet("`x'", replace) firstrow(varlabels)
}


foreach x in panel_fuzzy panel_exacto {
	use  "$basesA\\`x'.dta", clear
	sort curp grado
	bysort curp: gen aux=_n
	gen generacion=.
	
	replace generacion= 13 if grado==3 & anyo==2012 & aux==1
	
	replace generacion= 12 if grado==3 & anyo==2011 & aux==1
	replace generacion= 12 if grado==4 & anyo==2012 & aux==2

	replace generacion= 11 if grado==3 & anyo==2010 & aux==1
	replace generacion= 11 if grado==4 & anyo==2011 & aux==2
	replace generacion= 11 if grado==5 & anyo==2012 & aux==3
	
	
	replace generacion= 10 if grado==3 & anyo==2009 & aux==1
	replace generacion= 10 if grado==4 & anyo==2010 & aux==2
	replace generacion= 10 if grado==5 & anyo==2011 & aux==3
	replace generacion= 10 if grado==6 & anyo==2012 & aux==4
	
	
	replace generacion= 9 if grado==3 & anyo==2008 & aux==1
	replace generacion= 9 if grado==4 & anyo==2009 & aux==2
	replace generacion= 9 if grado==5 & anyo==2010 & aux==3
	replace generacion= 9 if grado==6 & anyo==2011 & aux==4
	replace generacion= 9 if grado==7 & anyo==2012 & aux==5
	
	replace generacion= 8 if grado==3 & anyo==2007 & aux==1
	replace generacion= 8 if grado==4 & anyo==2008 & aux==2
	replace generacion= 8 if grado==5 & anyo==2009 & aux==3
	replace generacion= 8 if grado==6 & anyo==2010 & aux==4
	replace generacion= 8 if grado==8 & anyo==2012 & aux==5
	
	replace generacion= 7 if grado==3 & anyo==2006 & aux==1
	replace generacion= 7 if grado==4 & anyo==2007 & aux==2
	replace generacion= 7 if grado==5 & anyo==2008 & aux==3
	replace generacion= 7 if grado==6 & anyo==2009 & aux==4
	replace generacion= 7 if grado==7 & anyo==2010 & aux==5
	replace generacion= 7 if grado==9 & anyo==2012 & aux==6
	
	
	replace generacion= 6 if grado==4 & anyo==2006 & aux==1
	replace generacion= 6 if grado==5 & anyo==2007 & aux==2
	replace generacion= 6 if grado==6 & anyo==2008 & aux==3
	replace generacion= 6 if grado==7 & anyo==2009 & aux==4
	replace generacion= 6 if grado==8 & anyo==2010 & aux==5
	
	replace generacion= 5 if grado==5 & anyo==2006 & aux==1
	replace generacion= 5 if grado==6 & anyo==2007 & aux==2
	replace generacion= 5 if grado==8 & anyo==2009 & aux==3
	replace generacion= 5 if grado==9 & anyo==2010 & aux==4
	
	replace generacion= 4 if grado==6 & anyo==2006 & aux==1
	replace generacion= 4 if grado==9 & anyo==2009 & aux==2
	
	replace generacion= 3 if grado==9 & anyo==2008 & aux==1
	
	replace generacion= 2 if grado==9 & anyo==2007 & aux==1
	
	replace generacion= 1 if grado==9 & anyo==2007 & aux==1
	
	bysort curp: gen num_anyo_obs=_N
	bysort curp: egen su_generacion=min(generacion)
	duplicates drop curp, force
	bysort generacion: egen media_anyos_obs=mean(num_anyo_obs)
	bysort generacion: gen num_ninyos=_N
	duplicates drop generacion, force 
	keep generacion num_ninyos media_anyos_obs
	gen anyos_obs=.
	replace anyos_obs=1 if generacion<4 | generacion==13
	replace anyos_obs=2 if generacion==4  | generacion==12
	replace anyos_obs=3 if generacion==11
	replace anyos_obs=4 if generacion==5 | generacion==10
	replace anyos_obs=5 if generacion==9 | generacion==6 | generacion==8
	replace anyos_obs=6 if generacion==7
	gen porc_observado= media_anyos_obs/anyos_obs
	gen nombre = "`x'"
	order nombre generacion anyos_obs media_anyos_obs porc_observado num_ninyos
	export excel using "$resultados\describe_bases.xls", sheet("`x' g", replace) firstrow(varlabels)
}


*====================================================
// 2) match bernardo
*====================================================


if 0==0{
		foreach lev in M B{
			foreach anyo1 in  06 07 08 09 10 11 12 13 14 {
				capture confirm file "$basesA\`lev'`anyo1'.dta"
				if _rc==0 {
					use "$basesA\`lev'`anyo1'.dta", clear
					*keep if substr(curp, 1, 1)=="G"
					gen curp16=substr(curp, 1, 16)
					bysort curp: drop if _n>1
					*drop if strlen(curp)<16
					save "$basesD\`lev'`anyo1'_matchable.dta", replace
				}
			}

		}
	}

	cap postclose chances
	postfile chances anyo1 anyo2 count matches purity str3 level1 str3 level2  using "$basesA\matches.dta", replace

	foreach anyo1 in  07 08 09 10 11 12 13 14 {
			foreach lev in B M{
			capture confirm file "$basesD\`lev'`anyo1'_matchable.dta"
			if _rc==0 {
			 
				post chances (`anyo1') (`anyo1') (1) (1) (1) ("`lev'")  ("M")
				post chances (`anyo1') (`anyo1') (1) (1) (2) ("`lev'")  ("M")
				post chances (`anyo1') (`anyo1') (1) (1) (2) ("`lev'")  ("B")
				post chances (`anyo1') (`anyo1') (1) (1) (1) ("`lev'")  ("B")


				foreach anyo2 in 06 07 08 09 10 11 12 13 14 {
					if `anyo2'<`anyo1'{
						use "$basesD\`lev'`anyo1'_matchable.dta", clear
						count
						local count=`r(N)'
						if `count'>0{
						capture confirm file "$basesD\B`anyo2'_matchable.dta"
						 if _rc==0 {
							gen grado2=grado-(`anyo1'-`anyo2')
							rename apellido_nombre apellido_nombre_master
							merge 1:1 curp using "$basesD\B`anyo2'_matchable.dta"
							bysort anyo grado: gen bueno=(_N>15000)
							replace bueno=0 if anyo!=2000+`anyo2'
							replace grado2=grado if missing(grado2)
							bysort grado2: egen bueno2=max(bueno)
							keep if anyo==2000+`anyo2' | bueno2==1
							count if anyo==2000+`anyo1'
							*dsfdsfd
							local count=r(N)
							if r(N)>100{
								count if _m==3
								local matches=`r(N)'
								post chances (`anyo1') (`anyo2') (`count') (`matches') (1) ("`lev'") ("B")
								drop if _m==3
								bysort curp16 anyo: drop if _N>1
								bysort curp16: gen match=_N==2
								count if match==1 & anyo==2000+`anyo1'
								local matches=`r(N)'+`matches'
								post chances (`anyo1') (`anyo2') (`count') (`matches') (2) ("`lev'") ("B")
							}

							}

						}

					}

				}

			}

		}

	}

	postclose chances

*para grafica	
local plotregion plotregion(margin(sides) fcolor(white) lstyle(none) lcolor(white)) 
local graphregion graphregion(fcolor(white) lstyle(none) lcolor(white)) 
	
	use "$basesA\matches.dta", clear
	gen porc = matches/count
	replace anyo1=2000+anyo1
	replace anyo2=2000+anyo2
	levels anyo1, local(levels)
	bysort anyo1 anyo2 level2: gen aux1=_N
	bysort anyo1 anyo2 : gen aux2=_N
	gen aux3=(aux1==aux2)

	foreach puri in 1 2{
		local bosc=0
		local med=0
		local tit="Match for exact curp (18 digits)"
		if `puri'==2{
			local tit="Match for exact curp (16 digits for unfound with 18 digits)"
		}
		 
		local twoway
		local labelsin
		local num=1
		foreach anyo in `levels'{
			foreach niv1 in B M{
				count if purity==`puri' & level1=="`niv1'" & (level2=="B" | aux3==1) & anyo1==`anyo'
					if r(N)>1{
					local r1 =round(uniform()*255)
					local r2 =round(uniform()*255)
					local r3 =round(uniform()*255)
					if "`niv1'"=="B" & `bosc'==0{
						local labelsin `labelsin' `num' "Elementary and middle school"
						local bosc=1
					}
					if "`niv1'"=="M" & `med'==0{
						local labelsin `labelsin' `num' "High school"
						local med=1
					}
					local color="62 150 81"
					if "`niv1'"=="B"{
						local color="218 124 41"
					}
					local twoway `twoway' (line porc anyo2 if purity==`puri' & level1=="`niv1'" & (level2=="B" | aux3==1) & anyo1==`anyo' & porc>0.2, ///
					legend(order(`labelsin')) lcolor("`color'") ytitle("Match (%)") xtitle("Year")  ///
					ylabel(0(0.2)1) ytick(0(0.1)1) lwidth(0.5) `graphregion' `plotregion' )
					local num=`num'+1
				}
			}
		}

		twoway `twoway' 
		graph export  "$resultados\graficas\matches_`puri'.pdf", replace
		graph export  "$resultados\graficas\matches_`puri'.png", replace
	}
	
	

*====================================================	
// 3)por estado num escuelas num alumnos
*====================================================

foreach x in 06 07 08 09 10 11 12 {
	use "$basesA\B`x'.dta", clear
	gen edo=substr(cct,1,2)
	destring edo, replace force
	drop if edo<1 | edo>32
	bysort edo: gen num_ninyos=_N
	duplicates drop edo, force 
	keep edo num_ninyos
	export excel using "$resultados\ninyos_edo.xls", sheet(" curp anyo `x'", replace) firstrow(varlabels)
}

foreach x in 06 07 08 09 10 11 12 {
	use "$basesA\B`x'_r.dta", clear
	gen edo=substr(cct,1,2)
	destring edo, replace force
	drop if edo<1 | edo>32
	bysort edo: gen num_ninyos=_N
	duplicates drop edo, force 
	keep edo num_ninyos
	export excel using "$resultados\ninyos_edo.xls", sheet(" folio anyo `x'", replace) firstrow(varlabels)
}

foreach x in 06 07 08 09 10 11 12 {
	use "$basesA\B`x'.dta", clear
	duplicates drop cct, force
	gen edo=substr(cct,1,2)
	destring edo, replace force
	drop if edo<1 | edo>32
	bysort edo: gen num_escuelas=_N
	duplicates drop edo, force 
	keep edo num_escuelas
	export excel using "$resultados\escuelas_edo.xls", sheet(" anyo `x'", replace) firstrow(varlabels)
}

//FALTA

*====================================================
//4) mapa
*====================================================



*====================================================
// 5)seguimiento escuelas
*====================================================




foreach x  in 06 07 08 09 10 11 12  {
		use "$basesA\B`x'.dta", clear
		drop if grado>6
		*duplicates drop cct,force
		keep cct anyo grado
		replace cct = substr(cct,1,9)
		duplicates drop cct,force
		rename anyo a_`x'
	save "$basesD\Besc`x'.dta", replace
	}
	
local labsize medlarge
			local bigger_labsize large
			local xtitle_options size(`labsize') margin(top)
			local title_options size(`bigger_labsize') margin(bottom) color(black)
			local manual_axis lwidth(thin) lcolor(black) lpattern(solid)
			local plotregion plotregion(margin(sides) fcolor(white) lstyle(none) lcolor(white)) 
			local graphregion graphregion(fcolor(white) lstyle(none) lcolor(white)) 
			local T_line_options lwidth(thin) lcolor(gray) 
			*lpattern(dash)
			local estimate_options_95 mcolor(gs7) msymbol(Oh)  msize(medlarge)
		

use "$basesD\Besc12.dta", clear
foreach x  in 06 07 08 09 10 11  {			
	merge 1:1 cct using "$basesD\Besc`x'.dta"
	drop if _merge==2
	gen aux = _merge==3
	egen porcentaje_asistencia_`x' = mean(aux)
	duplicates drop cct, force
	drop _merge aux
			}
local s=6
foreach x  in 06 07 08 09   {			
	rename porcentaje_asistencia_`x' porcentaje_asistencia_`s'
	local s=`s'+1
			}
gen porcentaje_asistencia_12=1
duplicates drop porcentaje_asistencia_12 , force
keep porcentaje_asistencia_*
export excel using "$resultados\seguimiento_escuelas.xls", sheet("escuelas todas", replace) firstrow(varlabels)
gen grado=1
reshape long porcentaje_asistencia_, i(grado) j(anyo)
replace anyo=anyo+2000


twoway (line porcentaje_asistencia anyo, lwidth(thick)) ///
(scatter porcentaje_asistencia anyo, `estimate_options_95'), ///
xtitle("año", `xtitle_options') ///
ytitle("Porcentaje de alumnos encontrados", `xtitle_options') ///
yline(0, `manual_axis') ///
legend(off) `plotregion' `graphregion'
graph export "$resultados\graficas\seguimiento_escuelas_todas.png", as (png) replace

*sólo primarias
use "$basesD\Besc12.dta", clear
drop if grado>6
drop grado
foreach x  in 06 07 08 09 10 11  {			
	merge 1:1 cct using "$basesD\Besc`x'.dta"
	drop if _merge==2
	gen aux = _merge==3
	egen porcentaje_asistencia_`x' = mean(aux)
	duplicates drop cct, force
	drop _merge aux
			}
local s=6
foreach x  in 06 07 08 09   {			
	rename porcentaje_asistencia_`x' porcentaje_asistencia_`s'
	local s=`s'+1
			}
gen porcentaje_asistencia_12=1
duplicates drop porcentaje_asistencia_12 , force
keep porcentaje_asistencia_*
export excel using "$resultados\seguimiento_escuelas.xls", sheet("escuelas prim", replace) firstrow(varlabels)
gen grado=1
reshape long porcentaje_asistencia_, i(grado) j(anyo)
replace anyo=anyo+2000


twoway (line porcentaje_asistencia anyo, lwidth(thick)) ///
(scatter porcentaje_asistencia anyo, `estimate_options_95'), ///
xtitle("año", `xtitle_options') ///
ytitle("Porcentaje de alumnos encontrados", `xtitle_options') ///
yline(0, `manual_axis') ///
legend(off) `plotregion' `graphregion'
graph export "$resultados\graficas\seguimiento_escuelas_prim.png", as (png) replace


*====================================================
// 6)seguimiento
*====================================================



local labsize medlarge
			local bigger_labsize large
			local xtitle_options size(`labsize') margin(top)
			local title_options size(`bigger_labsize') margin(bottom) color(black)
			local manual_axis lwidth(thin) lcolor(black) lpattern(solid)
			local plotregion plotregion(margin(sides) fcolor(white) lstyle(none) lcolor(white)) 
			local graphregion graphregion(fcolor(white) lstyle(none) lcolor(white)) 
			local T_line_options lwidth(thin) lcolor(gray) 
			*lpattern(dash)
			local estimate_options_95 mcolor(gs7) msymbol(Oh)  msize(medlarge)

******************
*seguimiento el último año en el que aparece la generación hacia atrás
******************

/* Se escojen los años de 2010, 2011 y 2012 para el forvalues de `t' pues
 en esos años el seguimiento retrospectivo
 de las generaciones es casi ininterrumpido*/
			
			
			
forvalues t = 10/12{
	if `t'!=11 {
		if `t'==12 {
			gl begin=5
			gl end=9
		}
		
			/* 'begin' denota la cota inferior para el grado donde empezará la 
			    secuencia que se analizará a partir del año `t', 
				asimismo con 'end' que denota la cota superior*/ 
		if `t'== 10{
			gl begin=8
			gl end=9
		}
		
		/* Este 'forvalues' está pensado para definir el rango de la sucesión de 
		   grados para una generación que se analizará retrospectivamente */
		forvalues x=$begin / $end {
			use "$basesA\B`t'.dta", clear
			if `t'==12 {
				/* Para estos 'if', `x' denota el grado. x toma los valores 5 y 6 que representan
				5to y 6to de primaria, mientras que 7, 8 y 9 representan 1ero, 
				2ndo y 3ro de secundaria, respectivamente. Por ejemplo, 
				si el grado `x' es 9 (i.e 3ero de secundaria), entonces se hará 
				el analisis de seguimiento retrospectivo hasta el último grado 
				donde se tiene información de esa generación, esto es hasta 6to
				de primaria definiendo a first=6. Todo esto para el año `t'*/
				if  `x'==9 {
					gl first = 6
				}
				if `x'==8{
					gl first = 7 
				}
				if `x'==7{
					gl first = 8 
				}
				if `x'==6 {
					gl first = 9 
				}
				if `x'==5 {
					gl first = 10
				}	

				gl last = 11
			}
			if `t'==10 {
				gl first=6
				gl last =9
			
			}

			/* solo nos quedamos con las variables grado y curp*/
			keep if grado==`x' 
			keep curp grado
			rename grado grado_`t'
			duplicates drop curp, force
			forvalues a=$first / $last {
				local nm= "`a'"
				if `a'<10{
					local nm="0`a'"
				}
				
				merge 1:m curp using "$basesA\B`nm'.dta", keepusing(grado)
				drop if _merge==2
				gen aux = _merge==3
				egen porcentaje_asistencia_`a' = mean(aux)
				duplicates drop curp, force
			/* Con este 'forvalue' de 'a' se hará el seguimiento retrospectivo de la 
			siguiente manera: unimos con merge las bases del 2010 con las de 200`a',
			nos deshacemos de las observaciones de la base 200`a' que no hicieron
			match. A la variable 'aux' le asignamos las observaciones que sí 
			son match (_merge==3) y con la media de 'aux' obtenemos el porcentaje
			de asistencias de forma retrospectiva, donde el porcentaje de asist.
			en 2012 es 100*/
				rename grado grado_`a'
				drop _merge aux
			}
			gen porcentaje_asistencia_`t'=1
			duplicates drop porcentaje_asistencia_$last , force
			keep porcentaje_asistencia_*
			export excel using "$resultados\seguimiento.xls", sheet("`x' en 20`t'", replace) firstrow(varlabels)
			gen grado= `x'
			if `t'==12 & `x'>6{
				drop porcentaje_asistencia_11
			}
			if `t'==10 & `x'==9{
				drop porcentaje_asistencia_8
			}
			reshape long porcentaje_asistencia_, i(grado) j(anyo)
			replace anyo=anyo+2000
			
		
			twoway (line porcentaje_asistencia anyo, lwidth(thick)) ///
			(scatter porcentaje_asistencia anyo, `estimate_options_95'), ///
			xtitle("año", `xtitle_options') ///
			ytitle("Porcentaje de alumnos encontrados", `xtitle_options') ///
			yline(0, `manual_axis') ///
			legend(off) `plotregion' `graphregion'
			*twoway line porcentaje_asistencia anyo || scatter porcentaje_asistencia anyo, title("Seguimiento `x' en 20`t'") legend(off) xtitle("año") ytitle("Porcentaje de alumnos encontrados")
			graph export "$resultados\graficas\g_`x' en 20`t'.png", as (png) replace

			}
	}
}

	
****************
*seguimiento de generaciones de las que observamos toda la primaria 
******************


/* Esta parte del código es estructuralemente muy similar a la pasada */

forvalues t = 9/12{
	
	local num = `t'
	if `t'==9 {
		local num = "09"
	}
	
	use "$basesA\B`num'.dta", clear
	if `t'==12 {
		gl first = 9 
	}
	if `t'==11 {
		gl first = 8
	}	
	if `t'==10 {
		gl first = 7
	}	
	if `t'==9 {
		gl first = 6
	}	
	gl last = `t' - 1 
	
	*solo nos quedamos con las generaciones que seguiremos a partir de sexto
	keep if grado==6
	keep curp grado
	rename grado grado_`t'
	duplicates drop curp, force
	forvalues a=$first / $last {
		local nums = `a'
		if `a'<10 {
			local nums = "0`a'"
		}
		merge 1:m curp using "$basesA\B`nums'.dta", keepusing(grado)
		drop if _merge==2
		gen aux = _merge==3
		egen porcentaje_asistencia_`a' = mean(aux)
		duplicates drop curp, force
		rename grado grado_`a'
		drop _merge aux
	}
	gen porcentaje_asistencia_`t'=1
	duplicates drop porcentaje_asistencia_$last , force
	keep porcentaje_asistencia_*
	export excel using "$resultados\seguimiento_pri.xls", sheet("6 en 20`num'", replace) firstrow(varlabels)
	gen grado= 6
	reshape long porcentaje_asistencia_, i(grado) j(anyo)
	replace anyo=anyo+2000
	twoway (line porcentaje_asistencia_ anyo, lwidth(thick)) ///
			(scatter porcentaje_asistencia anyo, `estimate_options_95'), /// 
			xtitle("año", `xtitle_options') ///
			ytitle("Porcentaje de alumnos encontrados", `xtitle_options') ///
			yline(0, `manual_axis') /// 
			legend(off) `plotregion' `graphregion'
			*twoway line porcentaje_asistencia anyo || scatter porcentaje_asistencia anyo, title("Seguimiento `x' en 20`t'") legend(off) xtitle("año") ytitle("Porcentaje de alumnos encontrados")
			*graph export "$resultados\graficas\g_`x' en 20`t'.png", as (png) replace

	*twoway line porcentaje_asistencia anyo || scatter porcentaje_asistencia anyo, title("Seguimiento 6 en 20`num'") legend(off) xtitle("año") ytitle("Porcentaje de alumnos encontrados")
	graph export "$resultados\graficas\primaria_6 en 20`num'.png", as (png) replace

}



*====================================================
// 7) tamaño de las escuelas
*====================================================


use "$basesA\panel_exacto.dta", clear
keep if anyo==2007 | anyo==2012
bysort cct anyo: gen asistencia=_N
duplicates drop cct anyo, force



local smaller_labsize vsmall
local labsize medlarge
local bigger_labsize large
local ylabel_options nogrid notick labsize(`labsize') angle(horizontal)
local xlabel_options nogrid notick labsize(`labsize')
local xtitle_options size(`smaller_labsize') margin(top)
local title_options size(`medsmall') margin(bottom) color(black)
local manual_axis lwidth(thin) lcolor(black) lpattern(solid)
local plotregion plotregion(margin(sides) fcolor(white) lstyle(none) lcolor(white)) 
local graphregion graphregion(fcolor(white) lstyle(none) lcolor(white)) 

#delimit ;
twoway (histogram asistencia if anyo==2007 & inrange(asistencia,0,500) , 
frac width(30) fcolor(eltblue) lcolor(white) ) 
(histogram asistencia if anyo==2012 & inrange(asistencia,0,500) , 
frac width(30) fcolor(eltblue) lcolor(black) ), 
xtitle(Cambio Porcentual)
ytitle("Fracción")
legend (order( 1 "2007" 2 "2012"))
`graphregion' `plotregion'
;
#delimit cr

graph export "$resultados\graficas\tamanyo.pdf", replace


*====================================================
// 8) variacion tamaño de las escuelas
*====================================================


use "$basesA\panel_exacto.dta", clear
bysort cct anyo: gen asistencia=_N
duplicates drop cct anyo, force
egen cct_id = group(cct)
xtset cct_id anyo 
gen p_asistencia= (L.asistencia-asistencia)/L.asistencia


local smaller_labsize vsmall
local labsize medlarge
local bigger_labsize large
local ylabel_options nogrid notick labsize(`labsize') angle(horizontal)
local xlabel_options nogrid notick labsize(`labsize')
local xtitle_options size(`smaller_labsize') margin(top)
local title_options size(`medsmall') margin(bottom) color(black)
local manual_axis lwidth(thin) lcolor(black) lpattern(solid)
local plotregion plotregion(margin(sides) fcolor(white) lstyle(none) lcolor(white)) 
local graphregion graphregion(fcolor(white) lstyle(none) lcolor(white)) 

#delimit ;
histogram p_asistencia if inrange(p_asistencia,-1,1), 
width(0.1) 
frac
fcolor(eltblue)
lcolor(ebblue) 
xtitle(Cambio Porcentual)
ytitle("Fracción")
`graphregion' `plotregion'
;
#delimit cr

graph export "$resultados\graficas\variacionResultados.pdf", replace



*====================================================
// 9) calif 2011
*====================================================



// GRAPH FORMATTING
// For graphs:
local smaller_labsize vsmall
local labsize medlarge
local bigger_labsize large
local ylabel_options nogrid notick labsize(`labsize') angle(horizontal)
local xlabel_options nogrid notick labsize(`labsize')
local xtitle_options size(`smaller_labsize') margin(top)
local title_options size(`medsmall') margin(bottom) color(black)
local manual_axis lwidth(thin) lcolor(black) lpattern(solid)
local plotregion plotregion(margin(sides) fcolor(white) lstyle(none) lcolor(white)) 
local graphregion graphregion(fcolor(white) lstyle(none) lcolor(white)) 


*tomemos 2011

use "$basesA\B11.dta", clear
keep if grado==3

#delimit 
twoway 
(kdensity p_esp) 
(kdensity p_mat),
xtitle("Resultados")
ytitle("Densidad")
legend(order(1 "Español" 2 "Matemáticas"))
`graphregion' `plotregion'

;
#delimit cr

graph export "$resultados\graficas\kdensityTercero2011.pdf", replace

use "$basesA\B11.dta", clear
keep if grado==6

#delimit 
twoway 
(kdensity p_esp) 
(kdensity p_mat),
xtitle("Resultados")
ytitle("Densidad")
legend(order(1 "Español" 2 "Matemáticas"))
`graphregion' `plotregion'
;
#delimit cr

graph export "$resultados\graficas\kdensitySexto2011.pdf", replace


*====================================================
//10) estabilidad percentil escuela
*====================================================
	

	

use "$basesA\panel_exacto.dta", clear
*sample 1
egen cct_aux=group(cct)
tostring cct_aux, replace force
tostring grado, replace force
gen aux="1010101"
egen cct_id= concat(cct_aux aux grado)
destring cct_id, force replace
 bysort cct_id anyo: egen m_p_mat=mean(p_mat)
 bysort cct_id anyo: egen m_p_esp=mean(p_esp)
duplicates drop cct_id anyo, force
gen p_mat_perc=.
gen p_esp_perc=.
foreach grad in 3 4 5 6 {
	foreach vari in p_mat p_esp{
		gen aux1=m_`vari' if grado==`grad'
		xtile aux2=aux1, nq(100)
		replace `vari'_perc=aux2 if grado==`grad'
		drop aux1 aux2
	}
}

xtset cct_id anyo



gen cambio_percentil_mat =L.p_mat_perc - p_mat_perc

gen cambio_percentil_esp = L.p_esp_perc -p_esp_perc 


local smaller_labsize vsmall
local labsize medlarge
local bigger_labsize large
local ylabel_options nogrid notick labsize(`labsize') angle(horizontal)
local xlabel_options nogrid notick labsize(`labsize')
local xtitle_options size(`smaller_labsize') margin(top)
local title_options size(`medsmall') margin(bottom) color(black)
local manual_axis lwidth(thin) lcolor(black) lpattern(solid)
local plotregion plotregion(margin(sides) fcolor(white) lstyle(none) lcolor(white)) 
local graphregion graphregion(fcolor(white) lstyle(none) lcolor(white)) 

foreach x in mat esp {
	#delimit ;
	histogram cambio_percentil_`x' if inrange(cambio_percentil_`x',-20,20), 
	width(2) 
	frac
	fcolor(eltblue)
	lcolor(ebblue) 
	xtitle(Diferencia absoluta)
	ytitle("Fracción")
	`graphregion' `plotregion'
	;
	#delimit cr

	graph export "$resultados\graficas\perc_`x'_esc.pdf", replace

}




	

*====================================================
//11) estabilidad percentil alumnos
*====================================================
	

	

use "$basesA\panel_exacto.dta", clear
*sample 1
gsort curp -anyo
drop if grado >6
gen aux=substr(curp,1,1)
bysort aux: gen aux2 = _n
bysort aux curp: egen auxiliar=max(aux2)
egen letra= group(aux)
gen cero= 101010
egen clave = concat(letra cero auxiliar)
destring clave, replace
xtset clave anyo

gen cambio_percentil_mat =L.p_mat_perc - p_mat_perc

gen cambio_percentil_esp = L.p_esp_perc -p_esp_perc 


local smaller_labsize vsmall
local labsize medlarge
local bigger_labsize large
local ylabel_options nogrid notick labsize(`labsize') angle(horizontal)
local xlabel_options nogrid notick labsize(`labsize')
local xtitle_options size(`smaller_labsize') margin(top)
local title_options size(`medsmall') margin(bottom) color(black)
local manual_axis lwidth(thin) lcolor(black) lpattern(solid)
local plotregion plotregion(margin(sides) fcolor(white) lstyle(none) lcolor(white)) 
local graphregion graphregion(fcolor(white) lstyle(none) lcolor(white)) 

foreach x in mat esp {
	#delimit ;
	histogram cambio_percentil_`x' if inrange(cambio_percentil_`x',-20,20), 
	width(2) 
	frac
	fcolor(eltblue)
	lcolor(ebblue) 
	xtitle(Diferencia absoluta)
	ytitle("Fracción")
	`graphregion' `plotregion'
	;
	#delimit cr

	graph export "$resultados\graficas\percentil_`x'.pdf", replace

}


*====================================================
//12) estabilidad regresion alumnos
*====================================================

use "$basesA\panel_exacto.dta", clear
*sample 1
gsort curp -anyo
keep curp grado  p_mat_std p_esp_std 
drop if grado >6
duplicates drop curp grado, force
gen aux=substr(curp,1,1)
bysort aux: gen aux2 = _n
bysort aux curp: egen auxiliar=max(aux2)
egen letra= group(aux)
gen cero= 101010
egen clave = concat(letra cero auxiliar)
keep curp grado  p_mat_std p_esp_std clave
destring clave, replace
xtset clave grado

	
foreach k in p_mat_std p_esp_std {
	cd "$resultados\regresiones"
	xtreg `k' L.`k' 
	outreg2 using xtar(1)sinfe.xls, text ctitle(`x') bdec(3) sdec(3) paren(se) asterisk(coef)
	}



*====================================================
//13) abren y cierran
*====================================================
*si 1 alumno presento el examen en ese año en esa escuela se queda con la escuela
foreach x  in 06 07 08 09 10 11 12  {
		use "$basesA\B`x'.dta", clear
		drop if grado>6
		duplicates drop cct,force
		keep cct anyo
		replace cct = substr(cct,1,9)
		rename anyo a_`x'
	save "$basesD\Besc`x'.dta", replace
	}
	
use  "$basesD\Besc06.dta", clear
duplicates drop cct, force
foreach x in 07 08 09 10 11 12  {
	merge 1:m cct using "$basesD\Besc`x'.dta"
	drop _merge
	duplicates drop cct, force
}

save "$basesA\todas_las_escuelas_pri.dta", replace

use "$basesA\todas_las_escuelas_pri.dta", clear 
 
drop if a_12!=. & a_06!=. & a_07!=. & a_08!=. & a_09!=. & a_10!=. & a_11!=.
gen tipo=substr(cct, 3, 1)
egen anyoAp=rowfirst( a_06 a_07 a_08 a_09 a_10 a_11 a_12)
egen anyoCierre= rowlast( a_06 a_07 a_08 a_09 a_10 a_11 a_12)
egen cuenta= anycount( a_06 a_07 a_08 a_09 a_10 a_11 a_12 ), values(2006 2007 2008 2009 2010 2011 2012)
gen resta=  anyoCierre - anyoAp
gen raro=0
replace raro= 1 if resta!= cuenta - 1
save "$basesD\apertura_cierre_pri.dta", replace

*busca a los niños de las que cerraron despues de que cerraron

use "$basesD\apertura_cierre_pri.dta", clear
drop if raro==1
keep if anyoCierre<2012
gen abre = anyoAp>2006
save "$basesD\cierran_pri.dta", replace

********************************
*arma base isaac
********************************
set more off

foreach x in  06 07 08 09 10 11{
	use "$basesD\cierran_pri.dta", clear
	*busca a los niños de las que cerraron en otras escuelas
	keep if anyoCierre==20`x'  
	duplicates drop cct, force
	save "$basesD\ayuda.dta", replace
	use  "$basesA\B`x'.dta", clear
	bysort cct: gen alumnos=_N
	replace cct = substr(cct,1,9)
	merge m:1 cct using "$basesD\ayuda.dta"
	drop if _merge!=3
	drop _merge
	*rename latitud latitud_origen
	*rename longitud longitud_origen
	save "$basesD\auxiliar.dta", replace
	clear 
	local m=`x'
	local k= `x'+1
	if `k'>9 {
	use  "$basesA\B`k'.dta", clear
	}
	if `k'<10 {
	use  "$basesA\B0`k'.dta", clear
	}
	gen cct_destino = substr(cct,1,9) 
	drop cct
	duplicates drop curp, force
	merge 1:m curp using  "$basesD\auxiliar.dta"
	drop if _merge!=3
	drop _merge
	bysort cct: gen total=_N
	bysort cct cct_destino: gen ninos = _N
	gen encontramos=total/alumnos
	duplicates drop cct cct_destino, force
	keep cct anyoAp anyoCierre cct_destino alumnos ninos encontramos 
	save "$basesD\destino`x'_pri.dta", replace
	}
	
	
	
	
	
use  "$basesD\destino06_pri.dta", clear
foreach x in 07 08 09 10 11{
	append using "$basesD\destino`x'_pri.dta"
}
drop if cct_destino==""
save "$basesD\destino_pri.dta", replace

************

foreach m in 0 1 { 
	use "$basesA\todas_las_escuelas_pri.dta", clear
	duplicates drop cct, force
	gen tipo=substr(cct, 3, 1)
	gen pop = tipo=="P"
	drop if pop!=`m'
	foreach x in 06 07 08 09 10 11 12{
	bysort a_`x': gen total`x'=_N 
	}

	foreach x in 06 07 08 09 10 11 12{
		drop if a_`x'==. 
	}
	duplicates drop total10,force
	keep total*
	export excel using "$resultados\analisis_pri.xlsx", sheet("total_`m'", replace) firstrow(varlabels)



	use"$basesD\destino_pri.dta", clear
	gen tipo=substr(cct, 3, 1)
	gen pop = tipo=="P"
	drop if pop!=`m'
	preserve
	duplicates drop cct, force
	bysort anyoCierre: gen escuelas_cierran=_N
	keep anyoCierre escuelas_cierran
	duplicates drop anyoCierre escuelas_cierran, force
	export excel using "$resultados\analisis_pri.xlsx", sheet("cierran_`m'", replace) firstrow(varlabels)
	restore


	preserve
	drop if encontramos<.25
	duplicates drop cct, force
	bysort anyoCierre: gen escuelas_cierran_25=_N
	keep anyoCierre escuelas_cierran_25
	duplicates drop anyoCierre escuelas_cierran_25, force
	export excel using "$resultados\analisis_pri.xlsx", sheet("cierran.25_`m'", replace) firstrow(varlabels)
	restore

	preserve
	drop if encontramos<.40
	duplicates drop cct, force
	bysort anyoCierre: gen escuelas_cierran_40=_N
	keep anyoCierre escuelas_cierran_40
	duplicates drop anyoCierre escuelas_cierran_40, force
	export excel using "$resultados\analisis_pri.xlsx", sheet("cierran.40_`m'", replace) firstrow(varlabels)
	restore
}

********************************
*aperturas
********************************
set more off

foreach  x in 07 08 09 10 11 12{
use "$basesD\apertura_cierre_pri.dta", clear
*busca a los niños de las que cerraron en otras escuelas
	keep if anyoAp==20`x'	
	drop if raro==1
	duplicates drop cct, force
	save "$basesD\ayuda.dta", replace
	use  "$basesA\B`x'.dta", clear
	bysort cct: gen alumnos=_N
	replace cct = substr(cct,1,9)
	merge m:1 cct using "$basesD\ayuda.dta"
	drop if _merge!=3
	drop _merge
	*rename latitud latitud_origen
	*rename longitud longitud_origen
	save "$basesD\auxiliar.dta", replace
	local k= `x'-1
	if `k'>9 {
	use  "$basesA\B`k'.dta", clear
	}
	if `k'<10 {
	use  "$basesA\B0`k'.dta", clear
	}
	gen cct_anterior = substr(cct,1,9) 
	drop cct
	duplicates drop curp, force
	merge 1:m curp using  "$basesD\auxiliar.dta"
	drop if _merge!=3
	drop _merge
	bysort cct: gen total=_N
	bysort cct cct_anterior: gen ninos = _N
	gen encontramos=total/alumnos
	duplicates drop cct cct_anterior, force
	keep cct anyoAp anyoCierre cct_anterior alumnos ninos encontramos 
	
	save "$basesD\anterior`x'_pri.dta", replace
}
	
use  "$basesD\anterior12_pri.dta"
foreach x in 07 08 09 10 11{
	append using "$basesD\anterior`x'_pri.dta"
}
drop if cct_anterior==""
save "$basesD\anterior_pri.dta", replace

foreach m in 0 1 {

	use "$basesA\todas_las_escuelas_pri.dta", clear
	gen tipo=substr(cct, 3, 1)
	gen pop = tipo=="P"
	drop if pop!=`m'
	duplicates drop cct, force
	foreach x in 06 07 08 09 10 11 12{
		bysort a_`x': gen total`x'=_N 
	}
	foreach x in 06 07 08 09 10 11 12{
		drop if a_`x'==. 
	}
	drop if a_12==. 
	duplicates drop total10,force
	keep total*
	export excel using "$dir\resultados\analisisAp_pri.xlsx", sheet("total_`m'", replace) firstrow(varlabels)



	use"$basesD\anterior_pri.dta", clear
	gen tipo=substr(cct, 3, 1)
	gen pop = tipo=="P"
	drop if pop!=`m'
	preserve
	duplicates drop cct, force
	bysort anyoAp: gen escuelas_abren=_N
	keep anyoAp escuelas_abren
	duplicates drop escuelas_abren , force
	export excel using "$dir\resultados\analisisAp_pri.xlsx", sheet("abre_`m'", replace) firstrow(varlabels)
	restore


	preserve
	drop if encontramos<.25
	duplicates drop cct, force
	bysort anyoAp: gen escuelas_abren_25=_N
	keep anyoAp escuelas_abren_25
	duplicates drop  escuelas_abren_25, force
	export excel using "$dir\resultados\analisisAp_pri.xlsx", sheet("abren.25_`m'", replace) firstrow(varlabels)
	restore

	
	preserve
	drop if encontramos<.40
	duplicates drop cct, force
	bysort anyoAp: gen escuelas_abren_40=_N
	keep anyoAp escuelas_abren_40
	duplicates drop anyoAp escuelas_abren_40, force
	export excel using "$dir\resultados\analisisAp_pri.xlsx", sheet("abren.40_`m'", replace) firstrow(varlabels)
	restore

}

*====================================================
//14) distancia
*====================================================
clear
import delimited "$source\escuelas_coord.csv"
replace cct= substr(cct,1,9)
duplicates drop cct, force
save "$basesA\coordenadas.dta", replace

use  "$basesD\destino_pri.dta", clear	
merge m:1 cct using "$basesA\coordenadas.dta" , keepusing( longitud latitud)
rename cct cct_origen
rename latitud latitud_origen
rename longitud longitud_origen
drop if _merge!=3
drop _merge
rename cct_destino cct
merge m:1 cct using "$basesA\coordenadas.dta" , keepusing( longitud latitud)
rename cct cct_destino
rename latitud latitud_destino
rename longitud longitud_destino
drop if _merge!=3

drop _merge

foreach x in latitud_destino longitud_destino latitud_origen longitud_origen {
	destring `x', replace force
}
drop if latitud_destino>90 | latitud_destino<0

drop if latitud_origen>90 | latitud_origen<0
 geodist latitud_destino longitud_destino latitud_origen longitud_origen, gen(distancia)
 
 local smaller_labsize vsmall
local labsize medlarge
local bigger_labsize large
local ylabel_options nogrid notick labsize(`labsize') angle(horizontal)
local xlabel_options nogrid notick labsize(`labsize')
local xtitle_options size(`smaller_labsize') margin(top)
local title_options size(`medsmall') margin(bottom) color(black)
local manual_axis lwidth(thin) lcolor(black) lpattern(solid)
local plotregion plotregion(margin(sides) fcolor(white) lstyle(none) lcolor(white)) 
local graphregion graphregion(fcolor(white) lstyle(none) lcolor(white)) 

#delimit ;
histogram distancia if inrange(distancia,0,20), 
width(1) 
frac
fcolor(eltblue)
lcolor(ebblue) 
xtitle(Distancia en km)
ytitle("Fracción")
`graphregion' `plotregion'
;
#delimit cr

graph export "$resultados\graficas\distancia.png", replace

*====================================================
*15)match bernardo por estado
*====================================================
	
	
	
foreach estado in 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32{
	if 0==0{
		foreach lev in M B{
			foreach anyo1 in  06 07 08 09 10 11 12 13 14 {
				capture confirm file "$basesA\`lev'`anyo1'.dta"
				if _rc==0 {
					use "$basesA\`lev'`anyo1'.dta", clear
					*keep if substr(curp, 1, 1)=="G"
					keep if substr(cct, 1, 2)=="`estado'"
					gen curp16=substr(curp, 1, 16)
					bysort curp: drop if _n>1
					*drop if strlen(curp)<16
					save "$basesD\`lev'`anyo1'_matchable_`estado'.dta", replace
				}
			}

		}
	}

	cap postclose chances
	postfile chances anyo1 anyo2 count matches purity str3 level1 str3 level2  using "$basesA\matches_`estado'.dta", replace

	foreach anyo1 in  07 08 09 10 11 12 13 14 {
			foreach lev in B M{
			capture confirm file "$basesD\`lev'`anyo1'_matchable_`estado'.dta"
			if _rc==0 {
			 
				post chances (`anyo1') (`anyo1') (1) (1) (1) ("`lev'")  ("M")
				post chances (`anyo1') (`anyo1') (1) (1) (2) ("`lev'")  ("M")
				post chances (`anyo1') (`anyo1') (1) (1) (2) ("`lev'")  ("B")
				post chances (`anyo1') (`anyo1') (1) (1) (1) ("`lev'")  ("B")


				foreach anyo2 in 06 07 08 09 10 11 12 13 14{
					if `anyo2'<`anyo1'{
						use "$basesD\`lev'`anyo1'_matchable_`estado'.dta", clear
						count
						local count=`r(N)'
						if `count'>0{
						capture confirm file "$basesD\B`anyo2'_matchable_`estado'.dta"
						 if _rc==0 {
							gen grado2=grado-(`anyo1'-`anyo2')
							rename apellido_nombre apellido_nombre_master
							merge 1:1 curp using "$basesD\B`anyo2'_matchable_`estado'.dta"
							bysort anyo grado: gen bueno=(_N>15000)
							replace bueno=0 if anyo!=2000+`anyo2'
							replace grado2=grado if missing(grado2)
							bysort grado2: egen bueno2=max(bueno)
							keep if anyo==2000+`anyo2' | bueno2==1
							count if anyo==2000+`anyo1'
							*dsfdsfd
							local count=r(N)
							if r(N)>100{
								count if _m==3
								local matches=`r(N)'
								post chances (`anyo1') (`anyo2') (`count') (`matches') (1) ("`lev'") ("B")
								drop if _m==3
								bysort curp16 anyo: drop if _N>1
								bysort curp16: gen match=_N==2
								count if match==1 & anyo==2000+`anyo1'
								local matches=`r(N)'+`matches'
								post chances (`anyo1') (`anyo2') (`count') (`matches') (2) ("`lev'") ("B")
							}

							}

						}

					}

				}

			}

		}

	}

	postclose chances

	use "$basesA\matches_`estado'.dta", clear
	gen porc = matches/count
	replace anyo1=2000+anyo1
	replace anyo2=2000+anyo2
	levels anyo1, local(levels)
	bysort anyo1 anyo2 level2: gen aux1=_N
	bysort anyo1 anyo2 : gen aux2=_N
	gen aux3=(aux1==aux2)

	foreach puri in 1 2{
		local bosc=0
		local med=0
		local tit="Match for exact curp (18 digits)"
		if `puri'==2{
			local tit="Match for exact curp (16 digits for unfound with 18 digits)"
		}
		 
		local twoway
		local labelsin
		local num=1
		foreach anyo in `levels'{
			foreach niv1 in B M{
				count if purity==`puri' & level1=="`niv1'" & (level2=="B" | aux3==1) & anyo1==`anyo'
					if r(N)>1{
					local r1 =round(uniform()*255)
					local r2 =round(uniform()*255)
					local r3 =round(uniform()*255)
					if "`niv1'"=="B" & `bosc'==0{
						local labelsin `labelsin' `num' "Elementary and middle school"
						local bosc=1
					}
					if "`niv1'"=="M" & `med'==0{
						local labelsin `labelsin' `num' "High school"
						local med=1
					}
					local color="62 150 81"
					if "`niv1'"=="B"{
						local color="218 124 41"
					}
					*para grafica	
					local plotregion plotregion(margin(sides) fcolor(white) lstyle(none) lcolor(white)) 
					local graphregion graphregion(fcolor(white) lstyle(none) lcolor(white)) 
						
					local twoway `twoway' (line porc anyo2 if purity==`puri' & level1=="`niv1'" & (level2=="B" | aux3==1) & anyo1==`anyo' & porc>0.2,///
					legend(order(`labelsin')) lcolor("`color'") ytitle("Match (%)") xtitle("Year") ///
					ylabel(0(0.2)1) ytick(0(0.1)1) lwidth(0.5) `graphregion' `plotregion' )
					local num=`num'+1
				}
			}
		}

		twoway `twoway' 
		graph export  "$resultados\graficas\matches_`puri'_`estado'.pdf", replace
		graph export  "$resultados\graficas\matches_`puri'_`estado'.png", replace
	}

}




