#Extract a vec1tor of all user Id's of those of who participated in the survey (data1 loaded in another Tab)
vec1 <- Survey_data$user_id
#Reduce the Reports1 to only those that have been given by those who have filled the survey
Reports1 <-  Reports_2022[Reports_2022$user_id %in% vec1,]

#percentage of Reports1 coming from those who participated in the survey
count(Reports1)/count(Reports_2022)*100

#add report count data1 and remove report ID
Reports1 <- Reports1 %>% 
  group_by(user_id) %>% 
  mutate(report_count = n()) %>% 
  select(-report_id)

#remove redundent items from data1 frame
rm(vec1)

#create data1 frames to bolster the message data1 frame
#create data1 frame for extracting the dates of first messages read
first_msg <- message_data %>%
  group_by(user_id) %>%
  arrange(msg_date) %>% 
  slice(1L) %>% 
  select(-msg_nmbr,-type,-msg_lang,-msg_nmbr,-acknowledged) %>% 
  rename(first_msg_date = msg_date)

#create data1 frame for extracting last message read
last_msg <- message_data %>%
  group_by(user_id) %>%
  arrange(desc(msg_date)) %>% 
  slice(1L) %>% 
  select(-msg_nmbr,-acknowledged)%>% 
  rename(last_msg_date = msg_date, msg_type = type)

#create a data1 frame to extract  count of messages read
read_count <- as.data.frame(table(message_data$user_id, message_data$acknowledged))  %>% 
  pivot_wider(names_from = Var2, values_from =  Freq ) %>% 
  rename(user_id = Var1, not_read = f, read = t)

#join data1 frames to include user, 
df_list <- list(first_msg,last_msg,read_count)
data1 <- reduce(df_list, full_join, by='user_id')

#clean now redundant data1frames from environment  
rm(df_list,first_msg,last_msg,read_count)  


# add data1frame that shows Reports1 by type (will be added to main data1frame)
Report_Number_Type1 <- Reports1 %>%
  select(-report_date,-report_count) %>% 
  group_by(report_type)


Report_Number_Type1 <- as.data.frame(table(Report_Number_Type1$user_id, Report_Number_Type1$report_type))

Report_Number_Type1 <- Report_Number_Type1 %>% pivot_wider(names_from = Var2, values_from = Freq)%>% 
  rename(user_id = Var1, bite_report = bite, site_report = site, adult_report = adult) %>% 
  mutate(total_Reports1 = (bite_report+ adult_report+ site_report))


#attach report type and number to data1 set
data1 <- full_join(data1,Report_Number_Type1, by = "user_id") %>% 
  mutate(bite_report = coalesce(bite_report, 0), site_report = coalesce(site_report, 0), adult_report = coalesce(adult_report,0), total_Reports1 = coalesce(total_Reports1,0))

# add data1 frame that shows Reports1 by date (final part to be added to messages data1frame)
#Reports1 that are counted for users are those that are 26 days ahead of messaging treatment and 26 days after
Report_date1 <- left_join(Reports1,data1, by = "user_id") %>% 
  select(user_id, report_date, first_msg_date, last_msg_date) %>% 
  mutate(month_before = first_msg_date - 26 ) %>% 
  mutate(month_after = last_msg_date + 26) %>% 
  mutate(report_before_msg = case_when(report_date < month_before ~ 0, report_date < first_msg_date & report_date >= month_before ~ 1, report_date >= first_msg_date ~ 0)) %>% 
  mutate(report_during_msg = case_when(report_date >= first_msg_date & report_date <= last_msg_date ~ 1, report_date < first_msg_date | report_date > last_msg_date ~ 0))%>% 
  mutate(report_after_msg = case_when(report_date <= last_msg_date ~ 0, report_date > last_msg_date & report_date <= month_after ~ 1,report_date > month_after ~ 0 )) %>% 
  group_by(user_id) %>%
  mutate(before = sum(report_before_msg))%>%
  mutate(during = sum(report_during_msg))%>%
  mutate(after = sum(report_after_msg)) %>% 
  select(-report_before_msg,-report_after_msg,-report_during_msg)


#add report counts to data1

data1 <-  Report_date1 %>% 
  select(user_id, before, during,after) %>% 
  group_by(user_id) %>%
  slice(1L) %>% 
  right_join(data1, Report_date1, by = "user_id")


#convert NA to 0 in before after and during
data1 <- data1 %>% 
  mutate(before = coalesce(before, 0),
         during = coalesce(during, 0),
         after  = coalesce(after,  0))


#add promotion prevention

data1 <- Survey %>% 
  select(user_id, promotion, prevention) %>% 
  mutate(orientation_value = promotion - prevention) %>% 
  mutate(orientation = case_when(orientation_value > 0 ~ "promotion", orientation_value < 0 ~ "prevention")) %>% 
  right_join(data1, Survey, by = "user_id")




