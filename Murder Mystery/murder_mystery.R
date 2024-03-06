#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#                   Intro to the Tidyverse by Colleen O'Briant
#                            Koan #9: murder mystery!
#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

# In this koan, you'll practice using dplyr to solve a murder mystery! You may
# find that left_join() and str_detect() from koan #8 are especially useful.
# There are NO TESTS associated with this koan: I didn't want to give away any
# spoilers. However, there is a google survey at the end that you should NOT
# SKIP in order to check your final answer.

#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

# Make sure you're connected to the internet and run this code to get started:
#+ message = FALSE
library(tidyverse)
people <- read_csv("https://raw.githubusercontent.com/cobriant/dplyrmurdermystery/master/data/person.csv")
drivers_license <- read_csv("https://raw.githubusercontent.com/cobriant/dplyrmurdermystery/master/data/drivers_license.csv")
income <- read_csv("https://raw.githubusercontent.com/cobriant/dplyrmurdermystery/master/data/income.csv")
crime_scene_report <- read_csv("https://raw.githubusercontent.com/cobriant/dplyrmurdermystery/master/data/crime_scene_report.csv")
facebook_event_checkin <- read_csv("https://raw.githubusercontent.com/cobriant/dplyrmurdermystery/master/data/facebook_event_checkin.csv")
get_fit_now_checkin <- read_csv("https://raw.githubusercontent.com/cobriant/dplyrmurdermystery/master/data/get_fit_now_checkin.csv")
get_fit_now_member <- read_csv("https://raw.githubusercontent.com/cobriant/dplyrmurdermystery/master/data/get_fit_now_member.csv")
interview <- read_csv("https://raw.githubusercontent.com/cobriant/dplyrmurdermystery/master/data/interview.csv")
print_all <- function(df, row, col) cat(str_wrap(df[row, col], width = 80))

# A crime has taken place and the detective needs your help! The detective has
# given you special access to police data to help them crack the case. All 8
# datasets should be in your global environment now. Take a look at each of
# them.

crime_scene_report
drivers_license
facebook_event_checkin
get_fit_now_checkin
get_fit_now_member
income
interview
people

#' This diagram will be useful: it shows you how variables in the tables can be
#' linked to connect information from different tables. It's called a database
#' Entity Relationship Diagram: ![](https://mystery.knightlab.com/schema.png)
#'
#' First, we'll get more comfortable with the data:
#' How many people are in this database?

people %>%
  nrow()

#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

# 1. How many crime reports are there?

crime_scene_report %>%
  nrow()

#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

# Did any crimes happen on Christmas of 2017?

crime_scene_report %>%
  filter(date == "2017-12-25")

#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

# 2. How long do the crime scene reports go back? (Hint: use arrange())

crime_scene_report %>%
  arrange(date) %>%
  select(date) %>%
  slice(1)

#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

# 3. The detective asks you to start by reading the crime scene report. They
# tell you it was a *murder* that was files on *January 15th, 2018* in a place
# called *"dplyr City"*.

crime_scene_report %>%
  filter(str_detect(type, 'murder')) %>%
  filter(str_detect(date, '2018-01-15')) %>%
  filter(str_detect(city, 'dplyr City')) %>%
  select(description)


#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

# An aside: are you annoyed by not being able to easiy read these long character
# strings because it truncates them? I made a function for you called `print_all`
# to help. It takes a tibble as the first argument, the (integer) row you want to
# print as the second argument, and the (integer) column you want to print as
# the third argument. For example, this will print the long string in row 10,
# column 3 of `crime_scene_report`:

crime_scene_report %>%
  print_all(10, 3)

#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

# 4. After reading the correct crime scene report in question 3, you should have
# an idea about how to find the witnesses. Write a query that identifies the
# first witness.

crime_scene_report %>%
  filter(str_detect(type, 'murder')) %>%
  filter(str_detect(date, '2018-01-15')) %>%
  filter(str_detect(city, 'dplyr City')) %>%
  print_all(1, 3)

people %>%
  filter(str_detect(address_street_name, 'Northwestern Dr')) %>%
  arrange(desc(address_number)) %>%
  slice(1)


#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

# 5. Write a query that identifies the second witness.

people %>%
  filter(str_detect(name, 'Annabel')) %>%
  filter(str_detect(address_street_name, 'Franklin Ave'))

#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

# 6. Write two queries that show the interview transcripts for our two subjects.

# witness 1's id: 14887
interview %>%
  filter(str_detect(person_id, '14887')) %>%
  print_all(1, 2)

# witness 2's id 16371
interview %>%
  filter(str_detect(person_id, '16371')) %>%
  print_all(1, 2)

#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

# 7. Go get 'em! Now you know enough to solve the mystery! Show the queries you
# wrote to solve it. Make sure to check your final answer by filling out this
# survey: (DON'T SKIP THE SURVEY EVEN IF YOU'RE SURE ABOUT YOUR ANSWER!!)
# https://forms.gle/K7rZ5VykcA7Bb1Qf7

#get their license id by plate number
left_join(drivers_license, people, join_by(id == license_id)) %>%
  filter(str_detect(plate_number, 'H42W'))
# 3 license id: 183779, 423327, 664760

left_join(people, get_fit_now_member, join_by(name)) %>%
  filter(str_detect(id.y, '^48Z')) %>%
  filter(str_detect(membership_status, 'gold')) %>%
  select(name, person_id)
#Only Jeremy Bowers match all the conditions


#Challenge
interview %>%
  filter(str_detect(person_id, '67318')) %>%
  print_all(1, 2)

left_join(people, drivers_license, join_by(license_id == id)) %>%
  filter(str_detect(hair_color, 'red')) %>%
  filter(str_detect(car_make, 'Tesla')) %>%
  filter(str_detect(car_model, 'Model S')) %>%
  #after these conditions, no aged 67 so I tried 65
  filter(str_detect(age, '65')) %>%
  select(name)


#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

# Great work! You're one step closer to tidyverse enlightenment. Make sure to
# return to this topic to meditate on it later.
