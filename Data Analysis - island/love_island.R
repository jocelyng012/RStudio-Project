# Love Island

# So far in lab:
# - We've learned how to represent data in R using vectors and tibbles,
# - We've learned how to answer questions about that data using dplyr,
# - And we've learned how to visualize that data using ggplot.
# In this lab, we'll practice adding a final step: modeling that data using lm
# so that we can do inference: drawing conclusions or making predictions based
# on evidence as long as the model's assumptions hold.

# Why are models necessary? I came across this quote this week and I thought it
# was really beautiful: "Data alone can inform us only so much, and generally,
# it is not possible to do inference without any assumptions, i.e., without a
# model. The partial identification approach to econometrics views economic
# models as sets of assumptions, some of which are plausible--e.g., based on
# economic principles that respect constraints and optimizing behavior--and some
# of which are esoteric and needed only to complete a model."
# - Elie Tamer (Partial Identification in Econometrics, Annual Review of Economics 2010)

# The linear model that you've been studying in class is widely used, but it is
# always a good idea to keep in mind the kinds of assumptions that make it valid.
# This is why we harp on assumptions constantly in EC320 & EC421. And in any
# good econometrics class.

# Anyway, let's jump in with our first full data project!

# The data for this week: a Love Island superfan recorded very detailed data
# on every contestant over the course of three seasons of the show. I had
# never seen Love Island before, but I was still pretty tickled about the idea
# of a data project on the topic. So I started watching the first episode of the
# 2016 series and I would like to make it clear, while this is sort of a fun data
# project, I STRONGLY DO NOT RECOMMEND watching this show. Personally I just
# couldn't find anything redeeming about it. No judgment to those of you who
# might be fans, but what I'm trying to say is please don't be inspired by this
# data project to go watch three seasons of this show.

# Run this code to get started: it attaches the tidyverse, loads the data from
# the internet, and edits some things about it like variable names to make it a
# little easier to use with the tidyverse:
library(tidyverse)
love <- read_csv("https://raw.githubusercontent.com/amynic/love-island-workshop/master/data%20vizualisation/love-island-historical-dataset.csv") %>%
  select(name = `Contestant Name`, outcome = OUTCOME, day_left = `Day left Villa`,
         age = Age, profession = Profession, region_origin_UK = `Area of UK`,
         gender = Gender, first_arrive = `First Group to enter villa`,
         day_joined = `Day Joined Villa`, n_dates = `Number of dates`,
         n_challenges_won = `Number of challenges won`, series = `love-island-series`) %>%
  mutate(profession = tolower(profession),outcome = tolower(outcome),
         outcome = factor(outcome, levels = c(
           "winner", "runner up", "third place", "walked", "re-dumped", "dumped",
           "removed")))

# This data project will have 2 parts:
# Q1. Get curious about the data and answer some questions about it with dplyr.
# Q2. Visualize some trends using ggplot and then model those relationships using
# lm to see what kinds of inferences we might be able to make.

# There are no tests associated with this file because it's sort of a "choose
# your own adventure" type project where there are lots of possibilities. But
# I'll post an answer key next week so you can see how I solved it.

# QUESTION 1: dplyr
# Answer at least three of the following seven questions using dplyr functions:
# select, filter, arrange, slice, mutate, summarize, group_by, and count.
# If the result of your query doesn't make the answer obvious, make sure to
# answer the questions in words.

# 1.1 Out of the three seasons, how many people won?
# 1.2 What is the minimum, maximum, and median age of contestants?
# 1.3 Are male contestants, on average, older than female contestants?
# 1.4 What are the three most common professions among contestants?
# 1.5 Continuing from #4, what are the three most common professions for male
# contestants, and what are the three most common professions for female
# contestants?
# 1.6 What region of the UK are most of the contestants from?
# 1.7 Love Island seems to introduce people in waves, so people enter at
# different times. Show that in 2016, 42.3% of the cast arrived on day 1. Then
# in 2017, 34.4% arrived on day 1, and then in 2018, 28.9% arrived on day 1.

# 1.1
love %>%
  filter(str_detect(outcome, 'winner')) %>%
  nrow()

# 1.2
love %>%
  summarize(max(age), min(age), median(age))

# 1.3
love %>% 
  filter(str_detect(gender, 'male')) %>%
  summarise(mean(age)) #23.7

love %>%
  filter(str_detect(gender, 'female')) %>%
  summarise(mean(age)) #22.8
  
#yes, male contestants older than female contestants, on average

# QUESTION 2: ggplot and lm
# I'll visualize a relationship using geom_jitter and geom_smooth. Then it is
# your turn to use lm() to estimate the model. Give an interpretation of beta_0
# and give both an interpretation and explain the statistical significance of
# beta_1.

# 2a) First, an example: Does age help your chances of winning? Because of the
# limited sample size, let "win" be anyone who got third place, anyone who was a
# runner up, and anyone who won the show.

# PLOT:
love %>%
  mutate(
    win = if_else(outcome %in% c("winner", "runner up", "third place"), 1, 0)
  ) %>%
  ggplot(aes(x = age, y = win)) +
  geom_jitter(height = 0.1) +
  geom_smooth(method = lm, se = FALSE)

# Notes about the plot above:
# 1. Use if_else() instead of case_when() when you only have two alternatives.
# Here, if someone's outcome is third place or above, their value for win is 1,
# and if not, they get 0. So on the y-axis we'll get a cluster of points near
# 1 (winners) and a cluster near 0 (losers). The technical term for a linear
# model where y takes on only 0's and 1's is a "linear probability model"
# because fitted values are the estimated probabilities that someone with such
# X-values wins.
# 2. Use geom_jitter() instead of geom_point() when the data is discrete, but
# you'd rather see the data points instead of something like a boxplot.
# geom_jitter just jitters the data points so you can avoid the overplotting
# that will happen when you try to use geom_point with discrete data.

# MODEL:
love %>%
  mutate(
    win = if_else(outcome %in% c("winner", "runner up", "third place"), 1, 0)
  ) %>%
  lm(win ~ age, data = .) %>%
  broom::tidy()

# INTERPRETATION:
# The estimated probability of getting third place or above if you're zero years
# old is -.493 (one issue with the linear probability model is that it can estimate
# probabilities less than 0 and greater than 1). For every year older, you gain
# .0288 in probability that you'll win, and with a p-value of .0539, that is
# statistically significant at the 10% level but not at the 5% level (it is
# less than .10 but not less than .05).

# 2b) Does having a low "day_joined" help your chances of winning?

# PLOT:
love %>%
  mutate(win = if_else(outcome %in% c("winner", "runner up", "third place"), 1, 0)) %>%
  ggplot(aes(x = day_joined, y = win)) +
  geom_jitter(height = 0.1) +
  geom_smooth(method = lm, se = FALSE)

# YOUR MODEL HERE:
love %>%
  mutate(win = if_else(outcome %in% c("winner", "runner up", "third place"), 1, 0)) %>%
  lm(win ~ day_joined, data = .) %>%
  broom::tidy()

# YOUR INTERPRETATION HERE:
# The estimated probability of getting third place or above if you joined 0 day
# is 0.298. For every day you joined, you gain -0.00722 in probability that
# you will win, and with a p-value of 0.0128, that is statistically significant 
# at the 5% level but not at the 1% level (it is less than 0.05 but not less than
# 0.01)


# 2c) Does being a model hurt your chances of winning?

# PLOT:
love %>%
  mutate(
    win = if_else(outcome %in% c("winner", "runner up", "third place"), 1, 0),
    model = if_else(str_detect(profession, "model"), 1, 0)
  ) %>%
  ggplot(aes(x = model, y = win)) +
  geom_jitter(height = 0.1, width = 0.1) +
  geom_smooth(method = lm, se = FALSE)

# YOUR MODEL HERE:
love %>%
  mutate(
    win = if_else(outcome %in% c("winner", "runner up", "third place"), 1, 0),
    model = if_else(str_detect(profession, "model"), 1, 0)
  ) %>%
  lm(win ~ model, data = .) %>%
  broom::tidy()

# YOUR INTERPRETATION HERE:
# The estimated probability of getting third place or above if you are not the
# model is 0.193. the amount that the probability of winning decreases -0.0389 
# as model goes from 0 to 1, with a p-value of 0.741.

