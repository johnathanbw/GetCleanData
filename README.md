# GetCleanData

#Part 1
The code works by using read.table() to collect the training and test data before combining using rbind()

#Part 2
Next, it uses the grep() function to search for "Mean", "mean(", "Std", and "std(". Note that there's a double backslash in front of "(" so that grep recognises it. The hits obtained from grep() are used to restrict the data to the mean and std variables only.

#Part 3
To name the activities, I wrote the rename() function to replace y with its names.

#Part 4
To label the dataset, I used a series of gsub functions to replace the original acronyms with proper words that are more informative to the reader. While it is generally preferable to have all the names in small letters, it is not really possible in this dataset due to the multiple characteristics of each variable.

#Part 5
I used for loops to calculate the averages. I admit that this is a fairly inefficient method, but it did manage to get the job done for this dataset.
