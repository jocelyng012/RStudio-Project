# RStudio-Project

RStudio projects (EC 320 at the University of Oregon)

Below is the overview of the projects:

***Tibble***
  - Intro to tidyverse table functions
  - Hold & create data set in Tibbles
  - Form data into a Tibbles

Example:
```shell
tibble(
  sex = c("male", "female", "female"),
  study_time = c(8, 4, 4),
  grade = c(78, 74, 86)
)
```
<table border="1">
 <tr> 
    <th></th>
    <th>sex</th>
    <th>study_time</th>
    <th>grade</th>
  </tr>
  <tr>
    <th>1</th>
    <td>male</td>
    <td>8</td>
    <td>78</td>
  </tr>
  <tr> 
    <th>2</th>
    <td>female</td>
    <td>4</td>
    <td>74</td>
 </tr>
 <tr> 
    <th>3</th>
    <td>female</td>
    <td>4</td>
    <td>86</td>
 </tr>
</table>
<br>
<br>


***lm***

<br>
<br>

***dplyr***
  - dplyr functions such as ```summarize()``` and ```group_by()```
  - Analyze data using ```filter()```, ```arrange()```, and ```mutate()```, etc
  - Combine two or more Tibbles by ```bind_rows()```, ```bind_cols()```, and ```left_join()```, etc


EX: What percentage of A students study for more than 10H per week?
```shell
students %>%
  filter(final_grade >= 90) %>%
  group_by(study_time) %>%
  summarize(n = n()) %>%
  mutate(percent = n / sum(n))
```
Outcome table:
```shell
# A tibble: 4 × 3
  study_time        n percent
  <fct>         <int>   <dbl>
1 less than 2H     10   0.294
2 2 - 5H           13   0.382
3 5 - 10H           7   0.206
4 more than 10H     4   0.118
```
<br>
<br>

***ggplot2***
  - Visualization of data such as Bar plot, Histogram, Box plot, and scatterplot, etc
  - Add a line of best fit in scatterplot

Example charts:
<div class="image-row">
  <img src="z_img/barplot.png" width="250" height="250" >
  <img src="z_img/histogram.png" width="250" height="250" >
</div>

<div class="image-row">
  <img src="z_img/boxplot.png" width="250" height="250" >
  <img src="z_img/scatterplot.png" width="250" height="250" >
</div>
