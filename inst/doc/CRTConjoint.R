## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(CRTConjoint)

## -----------------------------------------------------------------------------
data("immigrationdata")

## -----------------------------------------------------------------------------
form = formula("Y ~ FeatEd + FeatGender + FeatCountry + FeatReason + FeatJob +
FeatExp + FeatPlans + FeatTrips + FeatLang + ppage + ppeducat + ppethm + ppgender")
left = colnames(immigrationdata)[1:9]
right = colnames(immigrationdata)[10:18]
left; right

## ---- eval = FALSE------------------------------------------------------------
#  education_test = CRT_pval(formula = form, data = immigrationdata, X = "FeatEd",
#   left = left, right = right, non_factor = "ppage", B = 100, analysis = 2)
#  education_test$p_val

## ---- eval = FALSE------------------------------------------------------------
#  constraint_randomization = list() # (Job has dependent randomization scheme)
#  constraint_randomization[["FeatJob"]] = c("Financial analyst","Computer programmer",
#  "Research scientist","Doctor")
#  constraint_randomization[["FeatEd"]] = c("Equivalent to completing two years of
#  college in the US", "Equivalent to completing a graduate degree in the US",
#   "Equivalent to completing a college degree in the US")

## ---- eval = FALSE------------------------------------------------------------
#  job_test = CRT_pval(formula = form, data = immigrationdata, X = "FeatJob",
#  left = left, right = right, design = "Constrained Uniform",
#  constraint_randomization = constraint_randomization, non_factor = "ppage", B = 100)
#  job_test$p_val

## ---- eval = FALSE------------------------------------------------------------
#  profileorder_test = CRT_profileordereffect(formula = form, data = immigrationdata,
#   left = left, right = right, B = 100)
#  profileorder_test$p_val

## ---- eval = FALSE------------------------------------------------------------
#  resample_func_immigration = function(x, seed = sample(c(0, 1000), size = 1), left_idx, right_idx) {
#   set.seed(seed)
#   df = x[, c(left_idx, right_idx)]
#   variable = colnames(x)[c(left_idx, right_idx)]
#   len = length(variable)
#   resampled = list()
#   n = nrow(df)
#   for (i in 1:len) {
#     var = df[, variable[i]]
#     lev = levels(var)
#     resampled[[i]] = factor(sample(lev, size = n, replace = TRUE))
#   }
#  
#   resampled_df = data.frame(resampled[[1]])
#   for (i in 2:len) {
#     resampled_df = cbind(resampled_df, resampled[[i]])
#   }
#   colnames(resampled_df) = colnames(df)
#  
#   #escape persecution was dependently randomized
#   country_1 = resampled_df[, "FeatCountry"]
#   country_2 = resampled_df[, "FeatCountry_2"]
#   i_1 = which((country_1 == "Iraq" | country_1 == "Sudan" | country_1 == "Somalia"))
#   i_2 = which((country_2 == "Iraq" | country_2 == "Sudan" | country_2 == "Somalia"))
#  
#   reason_1 = resampled_df[, "FeatReason"]
#   reason_2 = resampled_df[, "FeatReason_2"]
#   levs = levels(reason_1)
#   r_levs = levs[c(2,3)]
#  
#   reason_1 = sample(r_levs, size = n, replace = TRUE)
#  
#   reason_1[i_1] = sample(levs, size = length(i_1), replace = TRUE)
#  
#   reason_2 = sample(r_levs, size = n, replace = TRUE)
#  
#   reason_2[i_2] = sample(levs, size = length(i_2), replace = TRUE)
#  
#   resampled_df[, "FeatReason"] = reason_1
#   resampled_df[, "FeatReason_2"] = reason_2
#  
#   #profession high skill fix
#   educ_1 = resampled_df[, "FeatEd"]
#   educ_2 = resampled_df[, "FeatEd_2"]
#   i_1 = which((educ_1 == "Equivalent to completing two years of college in the US" |
#    educ_1 == "Equivalent to completing a college degree in the US" |
#    educ_1 == "Equivalent to completing a graduate degree in the US"))
#   i_2 = which((educ_2 == "Equivalent to completing two years of college in the US" |
#   educ_2 == "Equivalent to completing a college degree in the US" |
#   educ_2 == "Equivalent to completing a graduate degree in the US"))
#  
#  
#   job_1 = resampled_df[, "FeatJob"]
#   job_2 = resampled_df[, "FeatJob_2"]
#   levs = levels(job_1)
#   # take out computer programmer, doctor, financial analyst, and research scientist
#   r_levs = levs[-c(2,4,5, 9)]
#  
#   job_1 = sample(r_levs, size = n, replace = TRUE)
#  
#   job_1[i_1] = sample(levs, size = length(i_1), replace = TRUE)
#  
#   job_2 = sample(r_levs, size = n, replace = TRUE)
#  
#   job_2[i_2] = sample(levs, size = length(i_2), replace = TRUE)
#  
#   resampled_df[, "FeatJob"] = job_1
#   resampled_df[, "FeatJob_2"] = job_2
#  
#   resampled_df[colnames(resampled_df)] = lapply(resampled_df[colnames(resampled_df)], factor )
#  
#   return(resampled_df)
#  }

## ---- eval = FALSE------------------------------------------------------------
#  carryover_df = immigrationdata
#  own_resamples = list()
#  B = 100
#  for (i in 1:B) {
#   newdf = resample_func_immigration(carryover_df, left_idx = 1:9, right_idx = 10:18, seed = i)
#   own_resamples[[i]] = newdf
#  }

## ---- eval = FALSE------------------------------------------------------------
#  J = 5
#  carryover_df$task = rep(1:J, nrow(carryover_df)/J)
#  
#  carryover_test = CRT_carryovereffect(formula = form, data = carryover_df, left = left,
#  right = right, task = "task", supplyown_resamples = own_resamples, B = B)
#  carryover_test$p_val

## ---- eval = FALSE------------------------------------------------------------
#  fatigue_df = immigrationdata
#  fatigue_df$task = rep(1:J, nrow(fatigue_df)/J)
#  fatigue_df$respondent = rep(1:(nrow(fatigue_df)/J), each = J)
#  
#  fatigue_test = CRT_fatigueeffect(formula = form, data = fatigue_df, left = left,
#  right = right, task = "task", respondent = "respondent", B = 100)
#  fatigue_test$p_val

