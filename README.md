---
title: "README.md"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## R Markdown

Markdown document for the Coursera Getting and Cleaning Data > Week 4 > Getting and Cleaning Data Course Project

simply source('~/R/GandCDproj/run_analysis.R'), with the data contained under /UCI HAR Dataset

1.  The tidy data set made at the end is "Tidy_Average", 1980 observations of 4 variables
1b.  Tidy average contains columns  "Subject"  "Activity" "Metric" "Average" 
1c.  The instructions for "run_analysis.R" says "Extracts only the measurements on the mean and standard deviation for each measurement.", which is confusing wording.  There are 66 data columns in the original features dataset with mean() or std() in name.  All of these were retained.
1d. Tidy_Average contains so many observations b/c there are so many data features stored under "Variable"
1e. Not every Subject-Activity was performed, which would lead to many NAs in Tidy_Average set.  However the decision was made to only include metrics where an observation was made

2.  Github has it all.  Including the original data unzipped and stored under the folder "UCI HAR Dataset"

3. codebook.txt is the code book

4.  There is a README.md file.  This is it.

5. This is my work, the student who submitted it.

```



Note that the `echo = FALSE` parameter was added to the code chunk to prevent printing of the R code that generated the plot.
