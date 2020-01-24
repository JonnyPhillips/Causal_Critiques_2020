cd "C:\Users\fcslab16\Downloads"
import delimited "C:\Users\fcslab16\Downloads\2000 Mayoral Elections Data.csv", clear
describe
drop if num_turno==2
bysort cod_mun_ibge: egen tot_votes=total(qtde_votos)
egen rank = rank(-qtde_votos), by(cod_mun_ibge)
gen result=qtde_votos/tot_votes
egen first_rank_pct=max(result), by(cod_mun_ibge)
egen second_rank_pct=total(result / [rank ==2]), by(cod_mun_ibge)

gen margin = result - second_rank_pct if rank ==1
replace margin = result - first_rank_pct if rank != 1

gen incumbency = 0
replace incumbency = 1 if rank == 1

drop if sigla_partido == "NA"

save newdata_2000, replace


cd "C:\Users\fcslab16\Downloads"
import delimited "C:\Users\fcslab16\Downloads\2004 Mayoral Elections Data.csv", clear
drop if num_turno==2
bysort cod_mun_ibge: egen tot_votes=total(qtde_votos)
egen rank = rank(-qtde_votos), by(cod_mun_ibge)
gen result=qtde_votos/tot_votes
egen first_rank_pct=max(result), by(cod_mun_ibge)
egen second_rank_pct=total(result / [rank ==2]), by(cod_mun_ibge)

gen margin = result - second_rank_pct if rank ==1
replace margin = result - first_rank_pct if rank != 1

rename ano_eleicao ano_eleicao04
rename num_turno num_turno04
rename uf uf04
rename nome_municipio nome_mun04
rename qtde_votos qtde_votos04
rename tot_votes tot_votes04
rename result result04
rename rank rank04
rename first_rank_pct first_rank_pct04
rename second_rank_pct second_rank_pct04
rename margin margin04

drop if sigla_partido == "NA"

save newdata_2004, replace

use new2000_day3, clear

merge 1:1 cod_mun_ibge sigla_partido using new2004_day3

save merge_data00_04, replace
use merge_data_00_04, clear 

gen sigla_partido2 = 0
replace sigla_partido2 = 1 if sigla_partido == "PAN"
replace sigla_partido2 = 2 if sigla_partido == "PC do B"
replace sigla_partido2 = 3 if sigla_partido == "PCB"
replace sigla_partido2 = 4 if sigla_partido == "PCO"
replace sigla_partido2 = 5 if sigla_partido == "PDT"
replace sigla_partido2 = 6 if sigla_partido == "PFL"
replace sigla_partido2 = 7 if sigla_partido == "PGT"
replace sigla_partido2 = 8 if sigla_partido == "PHS"
replace sigla_partido2 = 9 if sigla_partido == "PL"
replace sigla_partido2 = 10 if sigla_partido == "PMDB"
replace sigla_partido2 = 11 if sigla_partido == "PMN"
replace sigla_partido2 = 12 if sigla_partido == "PP"
replace sigla_partido2 = 13 if sigla_partido == "PPB"
replace sigla_partido2 = 14 if sigla_partido == "PPS"
replace sigla_partido2 = 15 if sigla_partido == "PRN"
replace sigla_partido2 = 16 if sigla_partido == "PRONA"
replace sigla_partido2 = 17 if sigla_partido == "PRP"
replace sigla_partido2 = 18 if sigla_partido == "PRTB"
replace sigla_partido2 = 19 if sigla_partido == "PSB"
replace sigla_partido2 = 20 if sigla_partido == "PSC"
replace sigla_partido2 = 21 if sigla_partido == "PSD"
replace sigla_partido2 = 22 if sigla_partido == "PSDB"
replace sigla_partido2 = 23 if sigla_partido == "PSDC"
replace sigla_partido2 = 24 if sigla_partido == "PSL"
replace sigla_partido2 = 25 if sigla_partido == "PST"
replace sigla_partido2 = 26 if sigla_partido == "PSTU"
replace sigla_partido2 = 27 if sigla_partido == "PT"
replace sigla_partido2 = 28 if sigla_partido == "PT do B"
replace sigla_partido2 = 29 if sigla_partido == "PTB"
replace sigla_partido2 = 30 if sigla_partido == "PTC"
replace sigla_partido2 = 31 if sigla_partido == "PTN"
replace sigla_partido2 = 32 if sigla_partido == "PV"

reg margin04 incumbency sigla_partido2

cd "C:\Users\fcslab16\Downloads"
import delimited C:\Users\fcslab16\Downloads\Mun_data.csv, clear
save dataIBGE, replace
use dataIBGE, clear
rename nome nome_municipio

use merge_data_00_04, clear 
merge m:1 cod_mun_ibge using dataIBGE

save merge_data00_04ibge, replace
use usemerge_data00_04ibg, clear 

reg margin04 incumbency sigla_partido2 pop_201 idhm_10 pib_per
reg margin04 incumbency margin

reg result04 incumbency sigla_partido2, robust
reg result04 incumbency sigla_partido2 pop_201 idhm_10 pib_per, robust
reg result04 incumbency margin, robust

reg result04 incumbency margin if abs(margin) < 5, robust
ttest sigla_partido2 if abs(margin) < 5, by(incumbency)
ttest sigla_partido2 if abs(margin) > 20, by(incumbency)

cd "C:\Users\fcslab16\Downloads"
import delimited "C:\Users\fcslab16\Downloads\2012 Mayoral Elections Data.csv", clear

*do the same steps that were apllied to the 2000 data
rename ano_eleicao ano_eleicao12
rename num_turno num_turno12
rename uf uf12
rename nome_municipio nome_mun12
rename qtde_votos qtde_votos12
rename tot_votes tot_votes12
rename result result12
rename rank rank12
rename first_rank_pct first_rank_pct12
rename second_rank_pct second_rank_pct12
rename margin margin12

save new2012_day4, replace

merge 1:1 cod_mun_ibge sigla_partido using new2012_day4

save merge_data, replace

cd "C:\Users\fcslab16\Downloads"
import delimited "C:\Users\fcslab16\Downloads\2016 Mayoral Elections Data.csv", clear

*do the same steps that were apllied to the 2004 data
rename ano_eleicao ano_eleicao16
rename num_turno num_turno16
rename uf uf16
rename nome_municipio nome_mun16
rename qtde_votos qtde_votos16
rename tot_votes tot_votes16
rename result result16
rename rank rank16
rename first_rank_pct first_rank_pct16
rename second_rank_pct second_rank_pct16
rename margin margin16

save new2016_day5, replace

use merge_data, clear

merge 1:1 cod_mun_ibge sigla_partido using new2016_day5

save merge_data, replace

gen incumbency2 = 0
replace incumbency12 = 1 if rank12 == 1

reg result04 incumbency sigla_partido2, robust
reg result16 incumbency12 sigla_partido2, robust

reg result04 incumbency margin, robust
reg result16 incumbency12 margin12, robust

reg result04 incumbency margin if uf == "PI", robust
reg result04 incumbency margin if uf == "MG", robust
reg result16 incumbency12 margin12 if uf == "PI", robust
reg result16 incumbency12 margin12 if uf == "MG", robust
