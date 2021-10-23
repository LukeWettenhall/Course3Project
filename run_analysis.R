
# Download data
if(!dir.exists("./datadownload")) {dir.create("./datadownload")}
download.file(url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
              destfile = "./datadownload/raw_data.zip")

# Unzip the data
unzip("./datadownload/raw_data.zip", exdir = "./datadownload")

# Check the files in the unzipped data
list.files("./datadownload/UCI HAR Dataset", recursive = T)

# Source required data
feature_names <- read.table("./datadownload/UCI HAR Dataset/features.txt")
activity_names <- read.table("./datadownload/UCI HAR Dataset/activity_labels.txt")
subjects_train <- read.table("./datadownload/UCI HAR Dataset/train/subject_train.txt")
subjects_test <- read.table("./datadownload/UCI HAR Dataset/test/subject_test.txt")
x_train <- read.table("./datadownload/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./datadownload/UCI HAR Dataset/train/Y_train.txt")
x_test <- read.table("./datadownload/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./datadownload/UCI HAR Dataset/test/Y_test.txt")

# Get correct column names
names(x_train) <- feature_names[,2]
names(x_test) <- feature_names[,2]
names(y_train) <- "Activity_id"
names(y_test) <- "Activity_id"
names(subjects_train) <- "Subject"
names(subjects_test) <- "Subject"
names(activity_names) <- c("Activity_id", "Activity_label")

# Merge subject numbers onto data
x_train <- cbind(subjects_train, x_train)
x_test <- cbind(subjects_test, x_test)

# Merge labels onto features data
x_train <- cbind(x_train, y_train)
x_test <- cbind(x_test, y_test)

# Merge on correct activity lables
x_train <- merge(x_train, activity_names, by = "Activity_id")
x_test <- merge(x_test, activity_names, by = "Activity_id")

# Create a column to tell if its train or test
x_train$type <- "train"
x_test$type <- "test"

# Append data
all_data <- rbind(x_train, x_test)

# Only get the measurements of interest
key_measurement_data <- all_data[,grep("mean\\(|std\\(|Subject|Activity_label", names(all_data))]
names(key_measurement_data)

# Produce final summary table
summary_table <- sapply(split(key_measurement_data[,-c(1,68)], 
                             interaction(key_measurement_data$Subject, key_measurement_data$Activity_label))
                       , colMeans)
