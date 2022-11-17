
library(lubridate)


#load message Data
message_data <- read.csv(file="sent.csv", header = TRUE)
#seperate notifacation column to type language and msg_nmbr
message_data <- message_data %>% separate(notification_label, c('type','language','msg_nmbr'))
#change the message date to simple date
message_data <- message_data %>% 
                mutate(date_comment = as.Date(date_comment)) %>% 
                rename(user_id = sent_to_user_id, msg_date = date_comment) 
                          



#create data frame for extracting the dates of first messages read
first_msg <- message_data %>%
  group_by(user_id) %>%
  arrange(msg_date) %>% 
  slice(1L) %>% 
  select(-msg_nmbr,-type,-language,-msg_nmbr,-acknowledged) %>% 
  rename(first_msg_date = msg_date)

#create data frame for extracting last message read
last_msg <- message_data %>%
  group_by(user_id) %>%
  arrange(desc(msg_date)) %>% 
  slice(1L) %>% 
  select(-msg_nmbr,-acknowledged)%>% 
  rename(last_msg_date = msg_date)

#create a data frame to extract  count of messages read
read_count <- as.data.frame(table(message_data$user_id, message_data$acknowledged))  %>% 
        pivot_wider(names_from = Var2, values_from =  Freq ) %>% 
        rename(user_id = Var1, not_read = f, read = t)
 
#join data frames to include user, 
df_list <- list(first_msg,last_msg,read_count)
Messages <- reduce(df_list, full_join, by='user_id')

#clean now redundant dataframes from environment  
rm(df_list,first_msg,last_msg,read_count)  

         
