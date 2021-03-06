hoh_data <- data %>% select(
  hh_member_sex = hoh_sex,
  hh_member_age = hoh_age
) %>% 
  mutate(
    school_age = case_when(
      hh_member_age >=6 & hh_member_age <= 18 ~ "school age",
      TRUE ~ "not school age"
    ),
    male_0_5 = hh_member_sex == "male" & between(hh_member_age, 0, 5),
    male_6_18 = hh_member_sex == "male" & between(hh_member_age, 6, 18),
    male_19_59 = hh_member_sex == "male" & between(hh_member_age, 19, 59),
    male_60_plus = hh_member_sex == "male" & hh_member_age >= 60,
    female_0_5 = hh_member_sex == "female" & between(hh_member_age, 0, 5),
    female_6_18 = hh_member_sex == "female" & between(hh_member_age, 6, 18),
    female_19_59 = hh_member_sex == "female" & between(hh_member_age, 19, 59),
    female_60_plus = hh_member_sex == "female" & hh_member_age >= 60
  )

# create the variables
overall_hh_roster <- overall_hh_roster %>% 
  mutate(
    school_age = case_when(
      hh_member_age >=6 & hh_member_age <= 18 ~ "school age",
      TRUE ~ "not school age"
    ),
    male_0_5 = hh_member_sex == "male" & between(hh_member_age, 0, 5),
    male_6_18 = hh_member_sex == "male" & between(hh_member_age, 6, 18),
    male_19_59 = hh_member_sex == "male" & between(hh_member_age, 19, 59),
    male_60_plus = hh_member_sex == "male" & hh_member_age >= 60,
    female_0_5 = hh_member_sex == "female" & between(hh_member_age, 0, 5),
    female_6_18 = hh_member_sex == "female" & between(hh_member_age, 6, 18),
    female_19_59 = hh_member_sex == "female" & between(hh_member_age, 19, 59),
    female_60_plus = hh_member_sex == "female" & hh_member_age >= 60
  )
sum1 <- function(x){sum(x, na.rm = TRUE)}

# create data frame for results
results <- data.frame(row.names = 1)

# Make the rooster and hoh data have the same vars and order
d <- overall_hh_roster %>% 
  select(
    hh_member_sex,
    hh_member_age,
    school_age,
    male_0_5,
    male_6_18,
    male_19_59,
    male_60_plus,
    female_0_5,
    female_6_18,
    female_19_59,
    female_60_plus
  )

names(d) == names(hoh_data)
d1 <- rbind(d, hoh_data)
results$tot_child_6_18 <- sum1(d1$school_age == "school age") 
results$perc_females <- sum1(d1$hh_member_sex=="female") /nrow(d1)
results$perc_males <- sum1(d1$hh_member_sex=="male")/nrow(d1)

filt <- d1$hh_member_sex=="male"
results$perc_male_0_5 <- sum1(d1$male_0_5)/nrow(d1[filt,])
results$perc_male_6_18 <- sum1(d1$male_6_18)/nrow(d1[filt,])
results$perc_male_19_59 <- sum1(d1$male_19_59)/nrow(d1[filt,])
results$perc_male_60 <- sum1(d1$male_60_plus)/nrow(d1[filt,])

filt <- d1$hh_member_sex=="female"
results$perc_female_0_5 <- sum1(d1$female_0_5)/nrow(d1[filt,])
results$perc_female_6_18 <- sum1(d1$female_6_18)/nrow(d1[filt,])
results$perc_female_19_59 <- sum1(d1$female_19_59)/nrow(d1[filt,])
results$perc_female_60 <- sum1(d1$female_60_plus)/nrow(d1[filt,])

# School attendance
d <- overall_hh_roster
results$perc_enrolled <- sum1(d$current_year_enrolled == "yes")/sum1(d$school_age == "school age") 
filt <- d$male_6_12>0
results$perc_enrolled_male_6_12 <- sum1(d[filt,]$current_year_enrolled == "yes")/nrow(d[filt,])
results$perc_attending_male_6_12 <- sum1(d[filt,]$current_year_attending == "yes")/nrow(d[filt,])

filt <- d$male_13_18>0
results$perc_enrolled_male_13_18 <- sum1(d[filt,]$current_year_enrolled == "yes")/nrow(d[filt,])
results$perc_attending_male_13_18 <- sum1(d[filt,]$current_year_attending == "yes")/nrow(d[filt,])

filt <- d$female_6_12>0
results$perc_enrolled_female_6_12 <- sum1(d[filt,]$current_year_enrolled == "yes")/nrow(d[filt,])
results$perc_attending_female_6_12 <- sum1(d[filt,]$current_year_attending == "yes")/nrow(d[filt,])
filt <- d$female_13_18>0
results$perc_enrolled_female_13_18 <- sum1(d[filt,]$current_year_enrolled == "yes")/nrow(d[filt,])
results$perc_attending_female_13_18 <- sum1(d[filt,]$current_year_attending == "yes")/nrow(d[filt,])

filt <- d$school_age == "school age"
results$perc_enrolled_previous <- sum1(d[filt,]$previous_year_enrolled== "yes")/nrow(d[filt,])
results$perc_edu_removal <- sum1(d[filt,]$edu_removal_shock.no)/nrow(d[filt,])

denom_ <- sum1(data$number_muac_person)

results$perc_moderate <- sum1(data$number_muac_mod_mal)/denom_
results$perc_severe <- sum1(data$number_muac_sev_mal)/denom_
results$perc_muac125 <- sum1(data$number_muac_above_125)/denom_
results$perc_ruft_recpt <- sum1(data$ruft_reception_num)/denom_

filt <- data$ruft_reception == TRUE
denom_ <- sum1(data$ruft_reception_num)

d1 <- overall_muac_data %>% filter(rutf_reception == "yes")
denom_ <- nrow(d1)

results$perc_ruft_recpt_115 <- sum1(d1$severe_malnutrition)/denom_
results$perc_ruft_recpt_115_125 <- sum1(d1$moderate_malnutrition)/denom_
results$perc_ruft_recpt_125 <- sum1(d1$muac_measurement >= 125)/denom_

fun1 <- function(x){
  round(x*100,0)
}


# Change the format
results <-  results %>% 
  mutate_at(vars(contains("perc")), fun1)
results_long <- data.frame(var = names(results), val = t(results)[1:ncol(results)])

write.csv(results, file = "output/non_hh_results.csv", row.names = FALSE)
write.csv(results_long, file = "output/non_hh_results_long.csv", row.names = FALSE)

