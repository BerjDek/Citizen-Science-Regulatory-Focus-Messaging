setwd("C:/Users/U176055/OneDrive/R/Mosquito-Alert/MosquitoAlertParticipation (John)/MosquitoAlert-Report Data")
install.packages("rjson")
install.packages("qdapTools")
install.packages("splitstackshape")

library(rjson)
library(tidyr)
library(dplyr)
library(qdapTools)
library(splitstackshape)



#Loading Data


#translation <-  fromJSON(file = "translation_dict.json")
#translation<- stringi::stri_list2matrix(translation, byrow = TRUE, fill = "")
#translation <- as.data.frame(translation)


Reports_2022 <- fromJSON(file = "all_reports2022.json")

Reports_2022<- stringi::stri_list2matrix(Reports_2022, byrow = TRUE, fill = "")
Reports_2022 <- as.data.frame(Reports_2022)
Reports_2022 <- Reports_2022 %>% rename(report_id = V1, report_date = V3, report_type = V8)
summary(Reports_2022)


#loading data set that has both user_Id and Version_id, the data set from Lime survey has the first and data set with the report has the latter
UUID_Conv <- read.csv(file="user_reports_091122.csv", header = TRUE) %>% 
             rename(report_id = version_UUID) 


#adding User Id to the reports data set
Reports_2022 <- inner_join(Reports_2022, UUID_Conv, by = "report_id") 

#Selecting the columns important for 
Reports_2022 <- Reports_2022 %>% 
           select(user_id, report_id, report_date, report_type)
            


#remove big report and user id conversion dataframes
#rm(Reports_2022, UUID_Conv)


#Extract a vector of all user Id's of those of who participated in the survey (data loaded in another Tab)
vec <- data$user_id
#Reduce the reports to only those that have been given by those who have filled the survey
Reports <-  Reports_2022[Reports_2022$user_id %in% vec,]

#percentage of reports coming from those who participated in the survey
count(Reports)/count(Reports_2022)*100

#add report count data and remove report ID
Reports <- Reports %>% 
              group_by(user_id) %>% 
              mutate(report_count = n()) %>% 
              select(-report_id)


#by report type (will be added to messages dataframe)
Report_Number_Type <- Reports %>%
                      select(-report_date,-report_count) %>% 
                      group_by(report_type)


Report_Number_Type <- as.data.frame(table(Report_Number_Type$user_id, Report_Number_Type$report_type))

Report_Number_Type <- Report_Number_Type %>% pivot_wider(names_from = Var2, values_from = Freq)%>% 
                                             rename(user_id = Var1, bite_report = bite, site_report = site, adult_report = adult) %>% 
                                             mutate(total_reports = (bite_report+ adult_report+ site_report))

#by report date

Report_date <- left_join(Reports,Messages, by = "user_id") %>% 
  select(user_id, report_date, first_msg_date, last_msg_date) %>% 
  mutate(month_before = first_msg_date - 26 ) %>% 
  mutate(month_after = last_msg_date + 26) %>% 
  mutate(report_before_msg = case_when(report_date < month_before ~ 0, report_date < first_msg_date & report_date >= month_before ~ 1, report_date >= first_msg_date ~ 0)) %>% 
  mutate(report_during_msg = case_when(report_date >= first_msg_date & report_date <= last_msg_date ~ 1, report_date < first_msg_date | report_date > last_msg_date ~ 0))%>% 
  mutate(report_after_msg = case_when(report_date <= last_msg_date ~ 0, report_date > last_msg_date & report_date <= month_after ~ 1,report_date > month_after ~ 0 )) %>% 
  group_by(user_id) %>%
  mutate(before = sum(report_before_msg))%>%
  mutate(during = sum(report_during_msg))%>%
  mutate(after = sum(report_after_msg))


###o<- left_join(Reports,Messages, by = "user_id") %>% 
  select(user_id, report_date, first_msg_date, last_msg_date) %>% 
  mutate(month_before = first_msg_date - 26 ) %>% 
  mutate(month_after = last_msg_date + 26) %>% 
  mutate(report_before_msg = case_when(report_date < month_before ~ 0, report_date < first_msg_date & report_date >= month_before ~ 1, report_date >= first_msg_date ~ 0)) %>% 
  mutate(report_during_msg = case_when(report_date >= first_msg_date & report_date <= last_msg_date ~ 1, report_date < first_msg_date | report_date > last_msg_date ~ 0))%>% 
  mutate(report_after_msg = case_when(report_date <= last_msg_date ~ 0, report_date > last_msg_date & report_date <= month_after ~ 1,report_date > month_after ~ 0 )) %>% 
  group_by(user_id) %>%
  mutate(before = sum(report_before_msg))%>%
  mutate(during = sum(report_during_msg))%>%
  mutate(after = sum(report_after_msg))

o <- Reports_2022 %>% 
  select(user_id, report_date) 

o <- left_join(o, Messages,"user_id") %>% 
    select(user_id, report_date, first_msg_date, last_msg_date)

o$first_msg_date <- Messages$first_msg_date[match(o$user_id,Messages$user_id)];
o$last_msg_date <- Messages$last_msg_date[match(o$user_id,Messages$user_id)];
  