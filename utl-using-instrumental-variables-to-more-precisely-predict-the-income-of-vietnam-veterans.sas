%let pgm=utl-using-instrumental-variables-to-more-precisely-predict-the-income-of-vietnam-veterans;

%stop_submission;

Using instrumental variables to more precisely predict the income of vietnam veterans

github
https://tinyurl.com/yj8yejfh
https://github.com/rogerjdeangelis/utl-using-instrumental-variables-to-more-precisely-predict-the-income-of-vietnam-veterans

AI query
https://chat.deepseek.com/a/chat/s/10d5f2dc-e2d5-4774-97bb-0956339aa593
please provide a simple real world example using vietnam draft lottery numbers as an instrumental variable in regression using r AER package with output

SOAPBOX ON

Vietnam draft lottery numbers are a good instrumetal variable.
Because the lottery number is not influenced by factors such as socioeconomic
background, income or motivation, it does not capture any of the unobserved variation in
the earning variable that could be associated with the error term.
This randomness makes it a good instrumental variable for military service, as it affects the
likelihood of serving but (ideally) isn't correlated with other factors affecting earnings.
Note you do not need to draw a new sample of veterans you can use the draft numbers you have.

The known validated model for veteran earnings is:

earnings <- 25000 - 5000*military + 8000*ability + rnorm(n, 0, 5000)

However we do not have the ability variable.
This earnings model above defines the effect of miitary service is -$5,000 earnings per year,

Input variables

draft_number is the instrument (1-365, lower numbers more likely to be drafted)
military     is the endogenous served variable (1 if served, 0 otherwise)
earnings     is the outcome variable yearly income

SOAPBOX OFF


/**************************************************************************************************************************/
/*             INPUT              |             PROCESS                               |   OUTPUT                          */
/*             =====              |             =======                               |   ======                          */
/*  SD1.HAVE total obs=999        | The validated model for vets income is            |                                   */
/*  draft_                        | earnings<-25000-5000*military+8000*ability        | OLS  earnings ~ military          */
/*   Ob number military earnings  |                                                   |               PARAMTR     VALUE   */
/*                                | Vets earn $5,000 less than non-vets               | (Intercept) INTERCEPT 23643.963   */
/*    1  179      1       29021   |                                                   | military        SLOPE -1520.241   */
/*    2   14      1       20244   | But we do not have the ability variable.          |                                   */
/*    3  195      1       16348   |                                                   | Instrumental Regression           */
/*    4  306      0       33281   | Our OLS model (without ability)                   |                                   */
/*    ...                         | earnings ~ military                               |               PARAMTR     VALUE   */
/*  995  293      0       26891   |                                                   | (Intercept) INTERCEPT 25236.724   */
/*  996  310      1       13198   | Predicts                                          | military        SLOPE -4814.583   */
/*  997  214      0       21215   | military  SLOPE -1520.241                         |                                   */
/*  998  238      1       40938   |                                                   | SD1.WANT                          */
/*  999  236      0       31814   | So vets earn $1,520 less than non-vets            | regression PARAMTR      VALUE     */
/*                                |                                                   |                                   */
/*  see below for sas dataset     | Adding instrumental variable draft_number         | ols        INTERCEPT   23643.96   */
/*                                |                                                   | ols        SLOPE       -1520.24   */
/*                                | earnings ~ military | draft_number                |                                   */
/*                                |                                                   | iv         INTERCEPT   25236.72   */
/*                                | Our new prediction is                             | iv         SLOPE       -4814.58   */
/*                                |                                                   |                                   */
/*                                | SLOPE -4814.583                                   | -$4,814 much to validated value   */
/*                                |                                                   |                                   */
/*                                | So vets learn $4,814 less than non-vets           |                                   */
/*                                | MUCH CLOSER TO VALIDATED RESULT                   |                                   */
/*                                |                                                   |                                   */
/*                                |---------------------------------------------------------------------------------------*/
/*                                | INSTRUMENTAL REGRESSION                           |                                   */
/*                                |                                                   |                                   */
/*                                | proc datasets lib=sd1 nolist nodetails;           |                                   */
/*                                |  delete want;                                     |                                   */
/*                                | run;quit;                                         |                                   */
/*                                |                                                   |                                   */
/*                                | %utlfkil(d:/txt/olsreg.txt);                      |                                   */
/*                                | %utlfkil(d:/txt/ivreg.txt);                       |                                   */
/*                                |                                                   |                                   */
/*                                | %utl_rbeginx;                                     |                                   */
/*                                | parmcards4;                                       |                                   */
/*                                | library(haven)                                    |                                   */
/*                                | library(sqldf)                                    |                                   */
/*                                | library(AER)                                      |                                   */
/*                                | source("c:/oto/fn_tosas9x.R")                     |                                   */
/*                                | options(sqldf.dll = "d:/dll/sqlean.dll")          |                                   */
/*                                |                                                   |                                   */
/*                                | df<-read_sas("d:/sd1/have.sas7bdat")              |                                   */
/*                                | head(df)                                          |                                   */
/*                                |                                                   |                                   */
/*                                | # OLS (biased- ability not available)             |                                   */
/*                                | ols <- lm(earnings ~ military, data = df)         |                                   */
/*                                | coefols <-as.data.frame(ols$coefficients)         |                                   */
/*                                | coefols<-cbind(c("INTERCEPT","SLOPE"),coefols)    |                                   */
/*                                | colnames(coefols)<-c("PARAMTR","VALUE")           |                                   */
/*                                | coefols                                           |                                   */
/*                                | sink("d:/txt/olsreg.txt")                         |                                   */
/*                                | coefols                                           |                                   */
/*                                | sink()                                            |                                   */
/*                                |                                                   |                                   */
/*                                | # IV regression draft number as instrument        |                                   */
/*                                | iv <- ivreg(earnings ~ military | draft_number    |                                   */
/*                                |       ,data = df)                                 |                                   */
/*                                | coefiv <-  as.data.frame(iv$coefficients)         |                                   */
/*                                | coefiv <-  cbind(c("INTERCEPT","SLOPE"),coefiv)   |                                   */
/*                                | colnames(coefiv)<-c("PARAMTR","VALUE")            |                                   */
/*                                | coefiv                                            |                                   */
/*                                | sink("d:/txt/ivreg.txt")                          |                                   */
/*                                | coefiv                                            |                                   */
/*                                | sink()                                            |                                   */
/*                                |                                                   |                                   */
/*                                | want<-sqldf('                                     |                                   */
/*                                |   select                                          |                                   */
/*                                |      "ols" as regression                          |                                   */
/*                                |     ,paramtr                                      |                                   */
/*                                |     ,value                                        |                                   */
/*                                |   from                                            |                                   */
/*                                |      coefols                                      |                                   */
/*                                |   union                                           |                                   */
/*                                |      all                                          |                                   */
/*                                |   select                                          |                                   */
/*                                |      "iv" as regression                           |                                   */
/*                                |     ,paramtr                                      |                                   */
/*                                |     ,value                                        |                                   */
/*                                |   from                                            |                                   */
/*                                |      coefiv                                       |                                   */
/*                                |   ')                                              |                                   */
/*                                | want                                              |                                   */
/*                                | fn_tosas9x(                                       |                                   */
/*                                |       inp    = want                               |                                   */
/*                                |      ,outlib ="d:/sd1/"                           |                                   */
/*                                |      ,outdsn ="want"                              |                                   */
/*                                |      )                                            |                                   */
/*                                | ;;;;                                              |                                   */
/*                                | %utl_rendx;                                       |                                   */
/*                                |                                                   |                                   */
/*                                | proc print data=sd1.want;                         |                                   */
/*                                | run;quit;                                         |                                   */
/*                                |                                                   |                                   */
/*                                | data _null_;                                      |                                   */
/*                                |   infile "d:/txt/olsreg.txt";                     |                                   */
/*                                |   input;                                          |                                   */
/*                                |   putlog _infile_;                                |                                   */
/*                                | run;quit;                                         |                                   */
/*                                |                                                   |                                   */
/*                                | data _null_;                                      |                                   */
/*                                |   infile "d:/txt/ivreg.txt";                      |                                   */
/*                                |   input;                                          |                                   */
/*                                |   putlog _infile_;                                |                                   */
/*                                | run;quit;                                         |                                   */
/**************************************************************************************************************************/

/*                   _
(_)_ __  _ __  _   _| |_
| | `_ \| `_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
*/


options validvarname=v7;
libname sd1 "d:/sd1";
data sd1.have;
 input
    draft_number
    military
    earnings @@;
cards4;
179 1 029021 014 1 020244 195 1 016348 306 0 033281 118 1 034858 299 0 032129 229 0 035189 244 0 016629 014 1 022297
153 1 030243 090 1 010722 091 0 015726 256 0 029025 197 0 001275 091 1 015612 348 0 028116 137 0 036744 355 1 018548
328 0 020517 026 1 023067 007 1 028827 137 1 023163 254 0 016296 211 1 035898 078 1 022520 081 1 029777 043 1 022854
359 0 028024 332 0 025446 143 1 022908 032 1 021538 109 1 028172 263 1 040092 330 0 028709 023 1 016677 309 0 003140
135 1 043660 309 0 019662 224 1 041744 166 1 015268 217 0 031041 290 0 023566 069 1 017028 072 1 011797 076 1 022429
063 0 028541 141 0 027953 210 0 022028 353 0 003029 347 0 025015 153 1 024170 294 0 025584 277 0 026061 041 1 001153
090 1 025132 316 0 035598 223 1 032095 016 1 013986 116 1 008494 094 0 039557 262 0 010771 235 0 021308 086 1 028820
342 0 007590 039 1 027957 159 1 032957 240 1 016402 209 1 016744 306 1 025749 034 1 016731 004 1 022005 013 1 025827
069 1 007312 243 1 008044 308 0 016734 278 0 019410 089 0 034821 025 1 006764 291 0 013138 286 0 023050 159 1 014462
121 1 012712 110 0 040244 158 1 020265 064 1 020899 199 1 027268 067 1 025892 151 1 015072 335 0 023607 085 0 030540
165 0 028889 136 1 013809 051 1 026999 074 1 031280 178 1 018329 362 0 031851 236 0 035399 098 1 044677 330 0 024938
214 0 014619 127 0 005208 212 0 016879 174 0 028269 273 0 020502 302 0 021649 310 0 032241 232 0 026577 243 0 039081
350 1 016710 335 1 005493 280 0 008605 113 0 020876 107 1 021861 151 1 030459 154 1 019538 102 1 009969 255 1 024892
160 0 008328 155 0 024538 005 1 011221 326 0 039386 272 1 016874 280 0 030992 288 0 032069 277 1 015673 055 0 027035
331 0 012402 238 0 018285 252 0 024560 339 0 028310 039 0 016303 310 0 043799 137 1 009054 226 1 024745 048 1 025433
077 0 024374 083 1 011147 184 1 027124 039 1 027490 196 0 019516 257 0 019903 168 1 024129 286 0 033761 094 1 005167
272 1 044386 344 1 018295 310 0 017041 020 0 021064 360 0 024059 195 1 032499 349 1 029313 164 1 025139 052 1 016831
364 1 010526 022 0 018616 177 1 040929 042 1 020229 315 0 031905 084 1 021511 011 1 032112 121 0 013494 302 0 022597
085 1 010147 365 1 035437 194 0 038379 107 1 038042 077 1 030574 198 1 045105 249 0 038849 200 0 016809 160 1 018649
250 0 009277 292 0 009276 016 1 036221 033 1 021862 040 0 030634 010 1 017603 200 1 012605 125 1 013208 265 0 029914
263 0 018205 186 1 020625 061 1 014723 252 1 037356 152 1 022242 319 1 008280 054 0 030095 026 1 024318 235 1 029872
289 0 031311 185 0 014471 253 0 016013 115 1 019458 010 1 031054 309 0 037223 054 1 016285 205 1 017326 363 0 015309
267 0 027296 025 1 022833 052 1 029066 282 0 011435 215 0 025945 346 0 018069 160 1 014654 057 0 027496 105 1 026164
357 0 010476 279 0 029956 270 0 036144 134 1 008626 347 0 020150 129 1 016905 218 0 026907 106 0 038436 186 1 027159
337 0 024617 285 0 023043 026 1 033703 027 1 026629 007 1 016257 245 0 027938 154 0 025486 041 1 018531 212 0 024579
222 1 024615 159 0 022825 349 0 017979 145 1 012453 057 0 030751 148 0 029468 163 0 028195 238 0 010568 161 0 014457
066 0 025298 004 1 027555 330 0 016226 225 1 033829 117 0 024548 025 1 010264 136 1 020902 055 1 020528 217 0 025947
085 0 025466 045 1 025272 146 0 011778 170 1 024905 134 1 021364 199 0 015849 361 0 024824 176 1 026343 245 1 035816
309 0 020301 104 0 023309 309 1 022633 319 0 026020 199 1 008680 210 0 016335 349 0 028522 225 0 018729 258 0 018797
177 1 001709 141 0 018859 024 0 015581 130 1 019702 165 0 018669 191 1 015013 076 0 023636 269 1 018285 170 1 028018
198 1 044936 362 0 013722 234 0 022610 064 1 008595 080 1 028460 036 1 023885 291 0 031833 253 0 030151 343 0 013069
323 0 031408 048 1 036036 111 1 011979 279 1 020667 317 0 028684 295 1 017008 222 0 027913 287 0 040768 222 0 013140
073 1 023075 292 0 026214 226 0 013640 278 0 019552 172 0 021334 297 0 021273 348 0 008477 093 1 025946 125 1 021876
299 1 044425 039 1 019454 237 0 029401 165 0 057589 107 1 045730 033 1 012360 083 0 026270 354 0 025765 277 0 023986
209 0 028261 076 1 006472 094 1 026227 291 0 042451 030 0 029902 217 0 033608 175 1 027956 323 0 037018 115 0 004676
338 1 019541 096 0 042956 358 0 032630 170 0 030088 096 1 021268 026 0 013573 230 0 027197 148 1 009303 350 0 011607
202 1 028700 081 1 013279 338 0 027819 232 0 025983 243 0 029940 106 1 039965 011 0 004953 113 1 030472 364 1 010391
141 1 016191 031 1 018167 115 1 008686 278 0 021077 094 1 018717 202 1 036484 016 1 010056 197 0 028633 178 1 021625
177 1 028069 012 0 012520 066 1 033951 050 0 022702 204 0 027242 175 0 021443 134 1 029556 122 1 026051 315 1 026537
259 1 020817 353 1 029096 248 0 037384 289 0 024791 048 0 021535 331 1 011395 100 1 029238 108 1 017670 301 0 041869
010 1 026174 170 0 026244 280 1 008690 348 0 021229 209 1 019842 315 0 025936 137 1 020930 309 0 030986 108 1 023107
008 1 014087 114 1 041271 261 0 027238 029 1 024661 306 1 009106 326 0 032394 074 0 013827 282 0 011614 073 0 023939
267 0 019097 262 0 014427 224 0 037964 204 0 000036 211 0 040365 219 1 031648 184 0 029685 352 1 029619 155 0 025456
119 1 026265 344 0 021669 067 1 021743 110 1 035446 134 1 021803 036 1 006496 055 1 013207 240 0 018700 120 1 027416
350 0 019976 304 0 017097 010 0 016215 153 1 021816 100 0 007659 105 1 027448 281 1 036460 180 0 013236 278 1 029655
241 0 035856 024 1 028073 167 0 008208 047 1 036321 191 0 004195 037 0 025636 174 0 015235 054 1 038387 303 0 016061
207 0 023276 019 0 051948 200 0 029839 159 0 020294 037 1 028119 103 0 010228 244 0 026776 048 1 019358 188 0 023402
139 0 014858 299 0 022366 158 0 027712 189 0 024427 311 0 033268 189 1 034226 057 0 024237 038 0 015833 084 1 018655
319 0 021432 174 1 015472 334 0 030948 326 0 015487 130 1 012505 120 1 024708 200 0 020891 331 0 029886 021 1 022057
199 0 011961 087 0 036019 072 1 028850 315 0 038063 202 0 026727 165 0 022734 081 0 028514 055 1 012397 134 1 013997
244 0 032351 006 0 020656 128 1 025119 156 1 018890 288 1 006017 049 1 003352 227 0 030026 239 0 037243 340 0 014991
193 0 027159 197 1 023105 303 0 029737 148 0 012462 190 0 021206 112 0 020204 191 1 031834 119 1 011235 115 1 017724
010 1 006692 115 1 018231 059 1 017667 305 0 015218 061 1 017058 108 1 010398 292 0 034456 023 1 018438 115 1 010782
088 1 010338 132 0 026734 186 0 007552 251 0 030132 203 1 044691 246 1 034735 246 0 022768 178 0 015400 251 0 029874
048 1 001969 131 0 037861 033 0 016520 162 1 019264 322 0 019928 064 1 012911 168 1 018567 276 0 018940 078 1 020567
153 1 029005 199 0 019397 095 1 026345 342 1 010972 221 1 019296 184 1 018278 161 0 014116 108 0 023242 242 0 014190
181 0 022807 302 0 033254 024 0 014066 316 0 014765 229 0 023083 224 1 004048 273 1 030110 187 1 015024 171 1 003275
023 1 016910 218 0 015686 301 1 031590 136 0 013471 079 1 028110 164 1 019789 237 0 023638 067 0 026690 295 0 045588
218 0 027062 284 0 010769 209 0 027051 087 0 012833 181 1 025534 358 1 020872 138 1 024424 365 0 032002 358 1 011851
041 0 029630 129 1 030211 336 0 024841 232 0 008139 334 0 026697 218 0 025800 328 0 022974 127 1 039333 041 1 021927
264 0 027829 185 1 020525 201 1 027831 052 1 032434 225 1 029709 067 1 012517 168 0 011416 258 0 036319 065 0 027656
029 1 008946 020 1 022704 206 0 029856 124 1 012358 080 0 021134 263 1 014922 228 1 030301 045 1 025086 332 1 035519
281 1 022021 091 1 036976 141 1 025133 138 1 014130 094 0 028446 127 1 021010 268 0 022122 008 0 033840 327 0 030865
271 0 035233 083 1 019474 235 0 021679 167 0 020241 255 0 026239 087 1 024289 122 1 000010 071 1 005440 260 0 036798
081 1 020471 264 0 010875 067 1 008723 364 0 022473 238 0 034362 270 1 034445 134 1 019400 137 0 037399 161 1 022728
116 1 017874 046 0 024322 064 1 012111 019 1 020443 229 1 025681 098 1 015587 129 0 016918 220 0 008663 180 1 032295
222 0 030388 324 1 023202 090 0 013842 122 1 024783 331 0 016396 275 0 025957 291 0 034417 231 0 018465 197 1 028744
317 0 019710 169 0 027681 217 0 022883 049 1 013891 341 0 010331 069 1 024747 320 0 032872 076 0 019794 002 1 002880
274 0 037257 260 1 041596 106 1 026855 111 0 044513 343 0 031428 072 1 013924 229 0 023589 011 1 019728 207 0 007462
335 0 027409 056 0 016660 106 1 017148 271 1 017720 207 0 006442 364 0 040872 089 1 009737 292 0 035299 263 1 020610
068 1 011925 120 1 027912 232 0 021709 053 1 010846 357 0 014614 280 0 022217 230 1 012776 324 0 027591 323 0 014878
011 1 015986 074 1 020533 256 0 018143 349 0 018277 088 1 030849 345 0 043362 011 1 045714 074 1 017497 243 0 015767
188 0 015342 287 0 031717 330 0 039909 173 1 022268 315 0 029828 280 0 037172 291 1 010234 242 1 016401 266 1 030059
064 0 032391 328 0 036895 172 1 018263 298 0 033364 160 0 010578 167 1 031237 166 1 001652 017 1 009217 229 1 028691
365 0 017429 079 1 017638 227 0 013204 322 0 020747 326 0 023206 110 1 022226 315 0 031648 243 0 033645 265 0 028600
023 1 003493 281 0 022995 112 0 026189 093 1 033483 277 0 011867 119 1 014979 048 1 011804 248 0 026767 105 0 030627
171 1 027303 184 0 017356 004 0 034316 327 0 031875 312 0 033613 050 0 016148 139 0 008330 246 0 009948 331 0 036239
316 0 023071 250 0 026169 230 1 028891 085 1 032558 330 0 041923 121 0 006369 114 0 015800 195 1 025947 099 0 032432
098 1 008091 058 1 028432 013 0 017343 008 0 023785 258 0 031243 123 1 018705 262 0 025995 087 1 030262 017 1 024614
206 1 023623 199 0 026413 077 0 034003 328 0 024565 358 0 035000 234 0 020575 017 1 028508 327 0 014619 055 0 018013
019 1 030143 241 0 003804 271 0 022823 218 0 026945 155 0 001927 209 0 019177 033 1 005200 306 0 025171 274 0 020578
148 0 018458 347 0 028428 298 0 035655 074 0 019246 053 0 037739 319 0 029589 329 0 018682 159 0 013446 339 0 011917
055 1 031089 247 1 019437 018 1 036019 364 0 039438 044 1 024147 348 0 042130 021 1 012959 029 1 032631 084 1 023619
023 1 026883 042 1 031283 197 1 028194 194 0 020813 082 0 032202 318 0 030211 064 1 035348 077 1 016226 107 1 013454
179 0 017989 146 1 030303 266 0 025145 201 0 017709 355 1 026595 339 0 011552 200 0 027378 237 1 011796 258 0 017204
254 0 013107 112 1 026878 005 1 014523 100 0 016881 143 1 027616 234 1 022176 103 1 042404 058 1 036421 290 0 031843
287 0 018506 018 1 022520 302 0 019838 265 1 023705 079 1 038233 135 1 028716 321 0 038538 009 1 000114 355 0 016253
281 1 038995 130 0 012338 196 0 032021 040 1 024913 148 0 031004 139 1 034658 018 1 022866 348 0 017681 067 0 020903
220 0 010542 093 1 021530 039 1 041955 151 1 036831 079 1 027496 344 0 017079 168 1 031245 161 1 026974 029 1 024914
121 0 010019 241 0 022545 153 1 033526 042 1 016450 044 1 031607 224 0 023415 008 1 032727 039 0 025813 352 0 020497
321 0 029521 350 0 020437 314 0 028696 217 1 018205 184 0 014785 171 1 019299 056 1 024098 278 0 003244 099 1 018699
142 1 028291 229 1 030289 064 0 021764 242 0 021880 280 0 014787 222 0 031829 008 1 030785 148 0 015553 074 1 018190
086 0 031972 017 0 029994 137 0 033939 163 1 024319 185 0 027525 144 0 042189 308 0 030179 355 1 025735 035 1 017692
026 1 026423 269 0 012086 036 1 008205 175 0 021035 028 1 019006 157 0 017503 300 0 025222 310 0 033393 153 1 008817
285 1 026754 148 0 026632 093 1 004012 269 1 021678 205 0 018818 163 0 022267 005 1 020152 056 1 021323 077 1 026989
348 0 001200 172 1 034759 072 1 026945 126 1 021763 152 1 021288 208 0 032053 075 1 019943 087 1 009576 094 1 018517
304 0 014333 271 0 036938 321 0 023556 182 1 018752 266 0 026164 086 1 017447 042 1 020283 100 1 029242 025 1 009315
094 1 027735 180 0 015941 293 0 032723 027 1 008962 201 0 022504 211 1 025621 035 1 026579 191 0 000001 343 1 019854
076 0 012598 207 1 007709 291 0 022797 157 1 023814 327 1 014461 034 1 031939 201 0 013118 303 0 040052 129 1 023155
266 0 022796 169 0 027751 039 1 009106 242 0 010957 364 1 021997 215 1 038761 103 1 027166 080 1 034031 346 0 034459
002 1 031211 162 1 018591 078 1 022925 158 0 021774 156 0 023690 215 0 010606 186 0 021440 286 0 025357 217 1 024611
326 0 025153 195 0 017443 187 0 054298 115 1 027731 238 1 023321 048 1 018885 138 1 022405 028 1 022282 204 1 033280
242 0 020347 323 0 030362 044 1 001794 161 1 018068 164 0 008540 115 1 025955 335 0 019116 077 1 012522 174 1 029110
094 1 026504 119 1 009316 146 1 022156 364 0 007248 103 1 016750 282 0 041092 292 1 025186 056 1 021807 313 0 031593
003 0 011146 217 0 015860 011 1 026628 051 0 025139 272 1 002885 011 1 015829 230 1 029120 352 0 028425 223 0 016832
101 1 003874 145 1 018758 133 1 020745 115 1 023239 335 1 007437 243 0 034937 096 1 019356 318 0 031563 091 0 007242
089 0 018673 143 0 016418 123 1 022432 291 0 031568 030 1 024321 162 1 028269 069 1 015001 130 1 018948 208 0 022479
023 1 020515 216 1 021630 277 0 030084 275 0 030927 211 0 023598 211 0 027422 197 1 044290 173 0 031827 208 0 034994
360 0 032430 032 1 028584 048 1 012463 271 0 031269 154 0 011362 035 0 003878 055 1 018290 152 1 018215 017 0 029774
327 1 001025 333 0 015709 186 1 037072 269 0 020386 324 0 029119 127 0 025541 025 1 017557 029 0 022891 181 0 024785
016 1 014248 169 0 021751 240 0 003873 009 1 041919 293 0 026891 310 1 013198 214 0 021215 238 1 040938 236 0 031814
;;;;
run;quit;

/**************************************************************************************************************************/
/*  SD1.HAVE total obs=999                                                                                                */
/*  draft_                                                                                                                */
/*  Obsnumber military  earnings                                                                                          */
/*                                                                                                                        */
/*    1  179      1       29021                                                                                           */
/*    2   14      1       20244                                                                                           */
/*    3  195      1       16348                                                                                           */
/*    4  306      0       33281                                                                                           */
/*    ...                                                                                                                 */
/*  995  293      0       26891                                                                                           */
/*  996  310      1       13198                                                                                           */
/*  997  214      0       21215                                                                                           */
/*  998  238      1       40938                                                                                           */
/*  999  236      0       31814                                                                                           */
/**************************************************************************************************************************/

/*
 _ __  _ __ ___   ___ ___  ___ ___
| `_ \| `__/ _ \ / __/ _ \/ __/ __|
| |_) | | | (_) | (_|  __/\__ \__ \
| .__/|_|  \___/ \___\___||___/___/
|_|
*/

proc datasets lib=sd1 nolist nodetails;
 delete want;
run;quit;

%utlfkil(d:/txt/olsreg.txt);
%utlfkil(d:/txt/ivreg.txt);

%utl_rbeginx;
parmcards4;
library(haven)
library(sqldf)
library(AER)
source("c:/oto/fn_tosas9x.R")
options(sqldf.dll = "d:/dll/sqlean.dll")

df<-read_sas("d:/sd1/have.sas7bdat")
head(df)

# OLS (biased- ability not available)
ols <- lm(earnings ~ military, data = df)
coefols <-as.data.frame(ols$coefficients)
coefols<-cbind(c("INTERCEPT","SLOPE"),coefols)
colnames(coefols)<-c("PARAMTR","VALUE")
coefols
sink("d:/txt/olsreg.txt")
coefols
sink()

# IV regression draft number as instrument
iv <- ivreg(earnings ~ military | draft_number
      ,data = df)
coefiv <-  as.data.frame(iv$coefficients)
coefiv <-  cbind(c("INTERCEPT","SLOPE"),coefiv)
colnames(coefiv)<-c("PARAMTR","VALUE")
coefiv
sink("d:/txt/ivreg.txt")
coefiv
sink()

want<-sqldf('
  select
     "ols" as regression
    ,paramtr
    ,value
  from
     coefols
  union
     all
  select
     "iv" as regression
    ,paramtr
    ,value
  from
     coefiv
  ')
want
fn_tosas9x(
      inp    = want
     ,outlib ="d:/sd1/"
     ,outdsn ="want"
     )
;;;;
%utl_rendx;

proc print data=sd1.want;
run;quit;

data _null_;
  infile "d:/txt/olsreg.txt";
  input;
  putlog _infile_;
run;quit;

data _null_;
  infile "d:/txt/ivreg.txt";
  input;
  putlog _infile_;
run;quit;

/**************************************************************************************************************************/
/*OLS  earnings ~ military                                                                                                */
/*              PARAMTR     VALUE                                                                                         */
/*(Intercept) INTERCEPT 23643.963                                                                                         */
/*military        SLOPE -1520.241                                                                                         */
/*                                                                                                                        */
/*Instrumental Regression                                                                                                 */
/*                                                                                                                        */
/*              PARAMTR     VALUE                                                                                         */
/*(Intercept) INTERCEPT 25236.724                                                                                         */
/*military        SLOPE -4814.583                                                                                         */
/*                                                                                                                        */
/*SD1.WANT                                                                                                                */
/*regression PARAMTR      VALUE                                                                                           */
/*                                                                                                                        */
/*ols        INTERCEPT   23643.96                                                                                         */
/*ols        SLOPE       -1520.24                                                                                         */
/*                                                                                                                        */
/*iv         INTERCEPT   25236.72                                                                                         */
/*iv         SLOPE       -4814.58                                                                                         */
/*                                                                                                                        */
/*-$4,814 much to validated value                                                                                         */
/**************************************************************************************************************************/

/*
| | ___   __ _
| |/ _ \ / _` |
| | (_) | (_| |
|_|\___/ \__, |
         |___/
*/

1516  proc datasets lib=sd1 nolist nodetails;
1517   delete want;
1518  run;

NOTE: Deleting SD1.WANT (memtype=DATA).
1518!     quit;

NOTE: PROCEDURE DATASETS used (Total process time):
      real time           0.03 seconds
      user cpu time       0.00 seconds
      system cpu time     0.01 seconds
      memory              315.71k
      OS Memory           24052.00k
      Timestamp           05/20/2025 04:30:07 PM
      Step Count          178  Switch Count  0


1519  %utlfkil(d:/txt/olsreg.txt);
MLOGIC(UTLFKIL):  Beginning execution.
MLOGIC(UTLFKIL):  This macro was compiled from the autocall file c:\oto\utlfkil.sas
MLOGIC(UTLFKIL):  Parameter UTLFKIL has value d:/txt/olsreg.txt
MLOGIC(UTLFKIL):  %LOCAL  URC
MLOGIC(UTLFKIL):  %LET (variable name is URC)
SYMBOLGEN:  Macro variable UTLFKIL resolves to d:/txt/olsreg.txt
SYMBOLGEN:  Macro variable URC resolves to 0
SYMBOLGEN:  Macro variable FNAME resolves to #LN00353
MLOGIC(UTLFKIL):  %IF condition &urc = 0 and %sysfunc(fexist(&fname)) is TRUE
MLOGIC(UTLFKIL):  %LET (variable name is URC)
SYMBOLGEN:  Macro variable FNAME resolves to #LN00353
MLOGIC(UTLFKIL):  %PUT xxxxxx &fname deleted xxxxxx
SYMBOLGEN:  Macro variable FNAME resolves to #LN00353
xxxxxx #LN00353 deleted xxxxxx
MLOGIC(UTLFKIL):  %LET (variable name is URC)
MPRINT(UTLFKIL):   run;
MLOGIC(UTLFKIL):  Ending execution.
1520  %utlfkil(d:/txt/ivreg.txt);
MLOGIC(UTLFKIL):  Beginning execution.
MLOGIC(UTLFKIL):  This macro was compiled from the autocall file c:\oto\utlfkil.sas
MLOGIC(UTLFKIL):  Parameter UTLFKIL has value d:/txt/ivreg.txt
MLOGIC(UTLFKIL):  %LOCAL  URC
MLOGIC(UTLFKIL):  %LET (variable name is URC)
SYMBOLGEN:  Macro variable UTLFKIL resolves to d:/txt/ivreg.txt
SYMBOLGEN:  Macro variable URC resolves to 0
SYMBOLGEN:  Macro variable FNAME resolves to #LN00354
MLOGIC(UTLFKIL):  %IF condition &urc = 0 and %sysfunc(fexist(&fname)) is TRUE
MLOGIC(UTLFKIL):  %LET (variable name is URC)
SYMBOLGEN:  Macro variable FNAME resolves to #LN00354
MLOGIC(UTLFKIL):  %PUT xxxxxx &fname deleted xxxxxx
SYMBOLGEN:  Macro variable FNAME resolves to #LN00354
xxxxxx #LN00354 deleted xxxxxx
MLOGIC(UTLFKIL):  %LET (variable name is URC)
MPRINT(UTLFKIL):   run;
MLOGIC(UTLFKIL):  Ending execution.
1521  %utl_rbeginx;
MLOGIC(UTL_RBEGINX):  Beginning execution.
MLOGIC(UTL_RBEGINX):  This macro was compiled from the autocall file c:\oto\utl_rbeginx.sas
MLOGIC(UTLFKIL):  Beginning execution.
MLOGIC(UTLFKIL):  This macro was compiled from the autocall file c:\oto\utlfkil.sas
MLOGIC(UTLFKIL):  Parameter UTLFKIL has value c:/temp/r_pgmx
MLOGIC(UTLFKIL):  %LOCAL  URC
MLOGIC(UTLFKIL):  %LET (variable name is URC)
SYMBOLGEN:  Macro variable UTLFKIL resolves to c:/temp/r_pgmx
SYMBOLGEN:  Macro variable URC resolves to 0
SYMBOLGEN:  Macro variable FNAME resolves to #LN00355
MLOGIC(UTLFKIL):  %IF condition &urc = 0 and %sysfunc(fexist(&fname)) is TRUE
MLOGIC(UTLFKIL):  %LET (variable name is URC)
SYMBOLGEN:  Macro variable FNAME resolves to #LN00355
MLOGIC(UTLFKIL):  %PUT xxxxxx &fname deleted xxxxxx
SYMBOLGEN:  Macro variable FNAME resolves to #LN00355
xxxxxx #LN00355 deleted xxxxxx
MLOGIC(UTLFKIL):  %LET (variable name is URC)
MPRINT(UTLFKIL):   run;
MLOGIC(UTLFKIL):  Ending execution.
MPRINT(UTL_RBEGINX):  ;
MLOGIC(UTLFKIL):  Beginning execution.
MLOGIC(UTLFKIL):  This macro was compiled from the autocall file c:\oto\utlfkil.sas
MLOGIC(UTLFKIL):  Parameter UTLFKIL has value c:/temp/r_pgm
MLOGIC(UTLFKIL):  %LOCAL  URC
MLOGIC(UTLFKIL):  %LET (variable name is URC)
SYMBOLGEN:  Macro variable UTLFKIL resolves to c:/temp/r_pgm
SYMBOLGEN:  Macro variable URC resolves to 0
SYMBOLGEN:  Macro variable FNAME resolves to #LN00356
MLOGIC(UTLFKIL):  %IF condition &urc = 0 and %sysfunc(fexist(&fname)) is TRUE
MLOGIC(UTLFKIL):  %LET (variable name is URC)
SYMBOLGEN:  Macro variable FNAME resolves to #LN00356
MLOGIC(UTLFKIL):  %PUT xxxxxx &fname deleted xxxxxx
SYMBOLGEN:  Macro variable FNAME resolves to #LN00356
xxxxxx #LN00356 deleted xxxxxx
MLOGIC(UTLFKIL):  %LET (variable name is URC)
MPRINT(UTLFKIL):   run;
MLOGIC(UTLFKIL):  Ending execution.
MPRINT(UTL_RBEGINX):  ;
MPRINT(UTL_RBEGINX):   filename ft15f001 "c:/temp/r_pgm";
MLOGIC(UTL_RBEGINX):  Ending execution.
1522  parmcards4;
1571  ;;;;

1572  %utl_rendx;
MLOGIC(UTL_RENDX):  Beginning execution.
MLOGIC(UTL_RENDX):  This macro was compiled from the autocall file c:\oto\utl_rendx.sas
MLOGIC(UTL_RENDX):  Parameter RETURN has value
MLOGIC(UTL_RENDX):  Parameter RESOLVE has value Y
MPRINT(UTL_RENDX):   run;
MPRINT(UTL_RENDX):  quit;
MPRINT(UTL_RENDX):   * EXECUTE R PROGRAM;
MPRINT(UTL_RENDX):   data _null_;
MPRINT(UTL_RENDX):   infile "c:/temp/r_pgm";
MPRINT(UTL_RENDX):   input;
MPRINT(UTL_RENDX):   file "c:/temp/r_pgmx";
SYMBOLGEN:  Macro variable RESOLVE resolves to Y
MLOGIC(UTL_RENDX):  %IF condition "&resolve"="Y" is TRUE
MPRINT(UTL_RENDX):  _infile_=resolve(_infile_);
MPRINT(UTL_RENDX):   put _infile_;
MPRINT(UTL_RENDX):   run;

NOTE: The infile "c:/temp/r_pgm" is:
      Filename=c:\temp\r_pgm,
      RECFM=V,LRECL=384,File Size (bytes)=1028,
      Last Modified=20May2025:16:30:07,
      Create Time=01May2025:09:15:43

NOTE: The file "c:/temp/r_pgmx" is:
      Filename=c:\temp\r_pgmx,
      RECFM=V,LRECL=384,File Size (bytes)=0,
      Last Modified=20May2025:16:30:07,
      Create Time=19May2025:12:40:45

NOTE: 48 records were read from the infile "c:/temp/r_pgm".
      The minimum record length was 4.
      The maximum record length was 47.
NOTE: 48 records were written to the file "c:/temp/r_pgmx".
      The minimum record length was 4.
      The maximum record length was 47.
NOTE: DATA statement used (Total process time):
      real time           0.02 seconds
      user cpu time       0.00 seconds
      system cpu time     0.01 seconds
      memory              426.18k
      OS Memory           24052.00k
      Timestamp           05/20/2025 04:30:07 PM
      Step Count                        179  Switch Count  0


MPRINT(UTL_RENDX):  quit;
MPRINT(UTL_RENDX):   options noxwait noxsync;
MPRINT(UTL_RENDX):   filename rut pipe "D:\r414\bin\r.exe --vanilla --quiet --no-save < c:/temp/r_pgmx";
MPRINT(UTL_RENDX):   run;
MPRINT(UTL_RENDX):  quit;
MPRINT(UTL_RENDX):   data _null_;
MPRINT(UTL_RENDX):   file print;
MPRINT(UTL_RENDX):   infile rut;
MPRINT(UTL_RENDX):   input;
MPRINT(UTL_RENDX):   put _infile_;
MPRINT(UTL_RENDX):   putlog _infile_;
MPRINT(UTL_RENDX):   run;

NOTE: The infile RUT is:
      Unnamed Pipe Access Device,
      PROCESS=D:\r414\bin\r.exe --vanilla --quiet --no-save < c:/temp/r_pgmx,
      RECFM=V,LRECL=384

> library(haven)
> library(sqldf)
> library(AER)
> source("c:/oto/fn_tosas9x.R")
> options(sqldf.dll = "d:/dll/sqlean.dll")
> df<-read_sas("d:/sd1/have.sas7bdat")
> head(df)
# A tibble: 6 Ã— 3
  draft_number military earnings
         <dbl>    <dbl>    <dbl>
1          179        1    29021
2           14        1    20244
3          195        1    16348
4          306        0    33281
5          118        1    34858
6          299        0    32129
> # OLS (biased- ability not available)
> ols <- lm(earnings ~ military, data = df)
> coefols <-as.data.frame(ols$coefficients)
> coefols<-cbind(c("INTERCEPT","SLOPE"),coefols)
> colnames(coefols)<-c("PARAMTR","VALUE")
> coefols
              PARAMTR     VALUE
(Intercept) INTERCEPT 23643.963
military        SLOPE -1520.241
> sink("d:/txt/olsreg.txt")
> coefols
> sink()
> # IV regression draft number as instrument
> iv <- ivreg(earnings ~ military | draft_number
+       ,data = df)
> coefiv <-  as.data.frame(iv$coefficients)
> coefiv <-  cbind(c("INTERCEPT","SLOPE"),coefiv)
> colnames(coefiv)<-c("PARAMTR","VALUE")
> coefiv
              PARAMTR     VALUE
(Intercept) INTERCEPT 25236.724
military        SLOPE -4814.583
> sink("d:/txt/ivreg.txt")
> coefiv
> sink()
> want<-sqldf('
+   select
+      "ols" as regression
+     ,paramtr
+     ,value
+   from
+      coefols
+   union
+      all
+   select
+      "iv" as regression
+     ,paramtr
+     ,value
+   from
+      coefiv
+   ')
> want
  regression   PARAMTR     VALUE
1        ols INTERCEPT 23643.963
2        ols     SLOPE -1520.241
3         iv INTERCEPT 25236.724
4         iv     SLOPE -4814.583
> fn_tosas9x(
+       inp    = want
+      ,outlib ="d:/sd1/"
+      ,outdsn ="want"
+      )
  [1] 0
>
NOTE: 70 lines were written to file PRINT.
Stderr output:
Loading required package: gsubfn
Loading required package: proto
Loading required package: RSQLite
Warning messages:
1: package 'gsubfn' was built under R version 4.4.2
2: package 'proto' was built under R version 4.4.2
3: package 'RSQLite' was built under R version 4.4.2
Loading required package: car
Loading required package: carData
Loading required package: lmtest
Loading required package: zoo

Attaching package: 'zoo'

The following objects are masked from 'package:base':

    as.Date, as.Date.numeric

Loading required package: sandwich
Loading required package: survival
Warning messages:
1: package 'AER' was built under R version 4.4.3
2: package 'car' was built under R version 4.4.2
3: package 'survival' was built under R version 4.4.3
Stat/Transfer - Command Processor (c) 1986-2024 Circle Systems, Inc.
www.stattransfer.com
Version 17.0.1756.0911 - 64 Bit Windows (10.0.19041)

Transferring from R Single object: C:\Users\Roger\AppData\Local\Temp\RtmpQ1g7mg\file1f807bef7c6c.rds
Input file has 4 variables
The input file contains string variables and although optimization is not required by the output
format, S/T will enable it to make sure that the output strings will not
get truncated.
Optimizing (All records) ...
Transferring to SAS Data File - Version Nine: d:/sd1/want.sas7bdat

4 cases were transferred(0.00 seconds)

NOTE: 70 records were read from the infile RUT.
      The minimum record length was 2.
      The maximum record length was 49.
NOTE: DATA statement used (Total process time):
      real time           4.89 seconds
      user cpu time       0.06 seconds
      system cpu time     0.29 seconds
      memory              315.31k
      OS Memory           24052.00k
      Timestamp           05/20/2025 04:30:12 PM
      Step Count                        180  Switch Count  0


MPRINT(UTL_RENDX):  quit;
MPRINT(UTL_RENDX):   data _null_;
MPRINT(UTL_RENDX):   infile " c:/temp/r_pgm";
MPRINT(UTL_RENDX):   input;
MPRINT(UTL_RENDX):   putlog _infile_;
MPRINT(UTL_RENDX):   run;

NOTE: The infile " c:/temp/r_pgm" is:
      Filename=c:\temp\r_pgm,
      RECFM=V,LRECL=384,File Size (bytes)=1028,
      Last Modified=20May2025:16:30:07,
      Create Time=01May2025:09:15:43

library(haven)
library(sqldf)
library(AER)
source("c:/oto/fn_tosas9x.R")
options(sqldf.dll = "d:/dll/sqlean.dll")
df<-read_sas("d:/sd1/have.sas7bdat")
head(df)
# OLS (biased- ability not available)
ols <- lm(earnings ~ military, data = df)
coefols <-as.data.frame(ols$coefficients)
coefols<-cbind(c("INTERCEPT","SLOPE"),coefols)
colnames(coefols)<-c("PARAMTR","VALUE")
coefols
sink("d:/txt/olsreg.txt")
coefols
sink()
# IV regression draft number as instrument
iv <- ivreg(earnings ~ military | draft_number
      ,data = df)
coefiv <-  as.data.frame(iv$coefficients)
coefiv <-  cbind(c("INTERCEPT","SLOPE"),coefiv)
colnames(coefiv)<-c("PARAMTR","VALUE")
coefiv
sink("d:/txt/ivreg.txt")
coefiv
sink()
want<-sqldf('
  select
     "ols" as regression
    ,paramtr
    ,value
  from
     coefols
  union
     all
  select
     "iv" as regression
    ,paramtr
    ,value
  from
     coefiv
  ')
want
fn_tosas9x(
      inp    = want
     ,outlib ="d:/sd1/"
     ,outdsn ="want"
     )
NOTE: 48 records were read from the infile " c:/temp/r_pgm".
      The minimum record length was 4.
      The maximum record length was 47.
NOTE: DATA statement used (Total process time):
      real time           0.06 seconds
      user cpu time       0.01 seconds
      system cpu time     0.06 seconds
      memory              315.31k
      OS Memory           24052.00k
      Timestamp           05/20/2025 04:30:12 PM
      Step Count                        181  Switch Count  0


MPRINT(UTL_RENDX):  quit;
SYMBOLGEN:  Macro variable RETURN resolves to
MLOGIC(UTL_RENDX):  %IF condition "&return" ne "" is FALSE
MPRINT(UTL_RENDX):   filename ft15f001 clear;
NOTE: Fileref FT15F001 has been deassigned.
MLOGIC(UTL_RENDX):  Ending execution.
1573  proc print data=sd1.want;
1574  run;

NOTE: There were 4 observations read from the data set SD1.WANT.
NOTE: PROCEDURE PRINT used (Total process time):
      real time           0.02 seconds
      user cpu time       0.01 seconds
      system cpu time     0.00 seconds
      memory              285.90k
      OS Memory           24052.00k
      Timestamp           05/20/2025 04:30:12 PM
      Step Count                        182  Switch Count  0


1574!     quit;
1575  data _null_;
1576    infile "d:/txt/olsreg.txt";
1577    input;
1578    putlog _infile_;
1579  run;

NOTE: The infile "d:/txt/olsreg.txt" is:
      Filename=d:\txt\olsreg.txt,
      RECFM=V,LRECL=384,File Size (bytes)=99,
      Last Modified=20May2025:16:30:10,
      Create Time=20May2025:16:10:17

              PARAMTR     VALUE
(Intercept) INTERCEPT 23643.963
military        SLOPE -1520.241
NOTE: 3 records were read from the infile "d:/txt/olsreg.txt".
      The minimum record length was 31.
      The maximum record length was 31.
NOTE: DATA statement used (Total process time):
      real time           0.01 seconds
      user cpu time       0.00 seconds
      system cpu time     0.01 seconds
      memory              315.31k
      OS Memory           24052.00k
      Timestamp           05/20/2025 04:30:12 PM
      Step Count                        183  Switch Count  0


1579!     quit;
1580  data _null_;
1581    infile "d:/txt/ivreg.txt";
1582    input;
1583    putlog _infile_;
1584  run;

NOTE: The infile "d:/txt/ivreg.txt" is:
      Filename=d:\txt\ivreg.txt,
      RECFM=V,LRECL=384,File Size (bytes)=99,
      Last Modified=20May2025:16:30:10,
      Create Time=20May2025:16:10:17

              PARAMTR     VALUE
(Intercept) INTERCEPT 25236.724
military        SLOPE -4814.583
NOTE: 3 records were read from the infile "d:/txt/ivreg.txt".
      The minimum record length was 31.
      The maximum record length was 31.
NOTE: DATA statement used (Total process time):
      real time           0.00 seconds
      user cpu time       0.00 seconds
      system cpu time     0.00 seconds
      memory              315.31k
      OS Memory           24052.00k
      Timestamp           05/20/2025 04:30:12 PM
      Step Count                        184  Switch Count  0

1584!     quit;

/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/
