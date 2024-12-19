#Installing packages if necessary
install.packages("tidyverse")
install.packages("corrplot")
install.packages("GGally")
install.packages("e1071")
install.packages("ggplot2")

library(tidyverse)
library(caret)
library(ggplot2)
library(corrplot)
library(MASS)
library(e1071) 
library(reshape2)

#load data
df <- read.csv("D:/Myworks/Raisin_Dataset.csv")
head(df)
dim(df)
str(df)

#checking null value
colSums(is.na(df))

#Descriptive Statistics
summary(df)

#Open new window (optional)
dev.new()

#Bar Plot
par(mfrow = c(4, 2), mar = c(4, 4, 2, 1))
for (col in names(df)[-ncol(df)]) {
  if (is.numeric(df[[col]])) {  #
    hist_data <- hist(df[[col]], breaks = 10, plot = FALSE)
    barplot(hist_data$counts, 
            main = paste("Bar Plot of", col), 
            names.arg = round(hist_data$mids, 2), 
            col = "blue", 
            border = "white",
            xlab = col,
            ylab = "Frequency")
  }
}

dev.new()

if (!require(GGally)) install.packages("GGally")


df$Class <- as.factor(df$Class)

#pair plot
ggpairs(df, 
        columns = 1:(ncol(df)-1),   
        aes(color = Class, alpha = 0.6))


dev.new()

if (!require(corrplot)) install.packages("corrplot")


options(repr.plot.width=10, repr.plot.height=8)

#Correlation
num_cols <- df %>% select_if(is.numeric)
correlation <- cor(num_cols, use = "complete.obs")

#Heatmap
corrplot(correlation, method = "color", 
         type = "upper", 
         tl.cex = 0.8, 
         tl.col = "black", 
         addCoef.col = "black", 
         number.cex = 0.7, 
         col = colorRampPalette(c("blue", "white", "red"))(200))

dev.new()
#Cleaning outliers
replace_outliers_with_bounds <- function(df) {
  for (col in names(df)[-ncol(df)]) {
    q1 <- quantile(df[[col]], 0.25)
    q3 <- quantile(df[[col]], 0.75)
    iqr <- q3 - q1
    lower_bound <- q1 - 1.5 * iqr
    upper_bound <- q3 + 1.5 * iqr
    df[[col]][df[[col]] < lower_bound] <- lower_bound
    df[[col]][df[[col]] > upper_bound] <- upper_bound
  }
  return(df)
}

df <- replace_outliers_with_bounds(df)

#Box plot
par(mfrow=c(4,2))
for(col in names(df)[-ncol(df)]) {
  boxplot(df[[col]], main=paste("Boxplot of", col), col="lightblue")
}

#QDA Classification
df$Class <- as.numeric(factor(df$Class))

# Splitting data
X <- df[, -ncol(df)]
y <- df$Class

set.seed(3)
trainIndex <- createDataPartition(y, p = 0.8, 
                                  list = FALSE, 
                                  times = 1)
X_train <- X[trainIndex,]
X_test <- X[-trainIndex,]
y_train <- y[trainIndex]
y_test <- y[-trainIndex]

# Standardization Data
scaler <- preProcess(X_train, method = c("center", "scale"))
X_train <- predict(scaler, X_train)
X_test <- predict(scaler, X_test)

#Training
qda_model <- qda(y_train ~ ., data = X_train)

#Prediction
qda_predictions <- predict(qda_model, X_test)$class

#Accuracy
confusion_matrix <- confusionMatrix(qda_predictions, as.factor(y_test))
print(confusion_matrix)

print(paste("Accuracy of QDA model:", confusion_matrix$overall['Accuracy']*100,"%"))

#Comparison actual vs prediction
train_table <- data.frame(
  Area = df$Area[trainIndex],
  MajorAxisLenght = df$MajorAxisLength[trainIndex],
  MinorAxisLenght = df$MinorAxisLength[trainIndex],
  Eccentricity = df$Eccentricity[trainIndex],
  ConvexArea = df$ConvexArea[trainIndex],
  Extent = df$Extent[trainIndex],
  Perimeter = df$Perimeter[trainIndex],
  Actual = y_train
)

comparison_table <- data.frame(
  Area = df$Area[-trainIndex],
  MajorAxisLenght = df$MajorAxisLength[-trainIndex],
  MinorAxisLenght = df$MinorAxisLength[-trainIndex],
  Eccentricity = df$Eccentricity[-trainIndex],
  ConvexArea = df$ConvexArea[-trainIndex],
  Extent = df$Extent[-trainIndex],
  Perimeter = df$Perimeter[-trainIndex],
  Actual = y_test,
  Predicted = qda_predictions
)

print(train_table)
print(comparison_table)

correct_predictions <- sum(comparison_table$Actual == comparison_table$Predicted)
incorrect_predictions <- sum(comparison_table$Actual != comparison_table$Predicted)

cat("The number of correct predictions:", correct_predictions, "\n")
cat("The number of incorrect predictions:", incorrect_predictions, "\n")

dev.new()
# Scatter plot Actual vs Predicted
ggplot(comparison_table, aes(x = Actual, y = Predicted)) +
  geom_point(color = "blue", alpha = 0.6) +
  geom_jitter(width = 0.2, height = 0.2, color = "red") +  
  labs(title = "Scatter Plot of Actual vs Predicted",
       x = "Actual Class",
       y = "Predicted Class") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5))


