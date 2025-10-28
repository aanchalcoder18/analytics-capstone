#installing packages
install.packages("tidyverse")
install.packages("skimr")
install.packages("janitor")
library(tidyverse)
library(skimr)
library(janitor)

#import and view in R
bike <- read_csv("/Users/aanchal/desktop/Capstone/cycle_2019.csv")
View(bike)
head(bike)

library(dplyr)

# Convert start and end times
bike <- bike %>%
  mutate(
    start_time = as.POSIXct(start_time, format="%Y-%m-%d %H:%M:%S"),
    end_time = as.POSIXct(end_time, format="%Y-%m-%d %H:%M:%S")
  )

# Calculate ride length in minutes
bike <- bike %>%
  mutate(
    ride_length = as.numeric(difftime(end_time, start_time, units = "mins"))
  )

# Remove negative or missing ride lengths (in case of data errors)
bike <- bike %>%
  filter(!is.na(ride_length), ride_length > 0)

# Summarize rides by user type
summary <- bike %>%
  group_by(usertype) %>%
  summarize(
    rides = n(),
    avg_min = mean(ride_length, na.rm = TRUE),
    med_min = median(ride_length, na.rm = TRUE)
  )

print(summary)


# === Plot 1: Total rides by user type ===
ggplot(summary, aes(x = usertype, y = rides, fill = usertype)) +
  geom_bar(stat = "identity") +
  labs(title = "Total Rides by User Type", x = "User Type", y = "Total Rides") +
  theme_minimal()

# === Plot 2: Average ride length by user type ===
ggplot(summary, aes(x = usertype, y = avg_min, fill = usertype)) +
  geom_col() +
  labs(title = "Average Ride Length (Minutes)", x = "User Type", y = "Average Ride Time") +
  theme_minimal()

# === Plot 3: Ride length distribution ===
ggplot(bike, aes(x = ride_length, fill = usertype)) +
  geom_histogram(bins = 40, alpha = 0.6, position = "identity") +
  xlim(0, 120) +  # trim outliers
  labs(
    title = "Ride Length Distribution", x = "Ride Time (Minutes)", y = "Count") +
  theme_minimal()

# Summarize total rides and average ride time by weekday and user type
weekday_summary <- bike %>%
  group_by(day_of_week, usertype) %>%
  summarise(
    rides = n(),
    avg_min = mean(ride_length, na.rm = TRUE)
  )

print(weekday_summary)


# === Plot 4: Total rides by weekday ===
ggplot(weekday_summary, aes(x = day_of_week, y = rides, fill = usertype)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Total Rides by Weekday and User Type",
       x = "Weekday", y = "Number of Rides") +
  theme_minimal()

# === Plot 5: Average ride length by weekday ===
ggplot(weekday_summary, aes(x = day_of_week, y = avg_min, fill = usertype)) +
  geom_col(position = "dodge") +
  labs(title = "Average Ride Length (Minutes) by Weekday and User Type",
       x = "Weekday", y = "Average Ride Time (mins)") +
  theme_minimal()

