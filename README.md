# Binary Classification using Quadratic Discriminant Analysis (QDA)

This repository provides an end-to-end implementation of **binary classification using Quadratic Discriminant Analysis (QDA)**. The project demonstrates how QDA can be utilized to separate two classes by modeling class-specific covariance structures and deriving non-linear decision boundaries.

---

## ⭐ Overview

Quadratic Discriminant Analysis (QDA) is a generative classification algorithm that assumes each class follows a Gaussian distribution with its own covariance matrix. Unlike LDA—which enforces a shared covariance across classes—QDA offers **greater flexibility** by allowing curved, non-linear decision boundaries.

This project aims to:

- Explain and implement QDA from first principles  
- Perform binary classification on a selected dataset  
- Evaluate the model using standard metrics  
- Visualize the resulting decision boundaries  

---

## 🔧 Features

- Complete Python implementation of QDA  
- Dataset preprocessing and feature normalization  
- Analytical computation of:
  - Class priors  
  - Class means  
  - Covariance matrices  
  - Discriminant score functions  
- Visualization utilities for classification boundaries  
- Evaluation using:
  - Accuracy  
  - Precision  
  - Recall  
  - Confusion matrix  

---

## 🧠 Methodology

### 1. Data Preparation
- Load dataset  
- Standardize feature values  
- Split into training and testing sets  

### 2. Model Training
- Estimate prior probabilities  
- Compute mean vectors per class  
- Compute covariance matrices per class  
- Construct quadratic discriminant functions  

### 3. Prediction
- Evaluate discriminant functions on new samples  
- Select class with maximum posterior probability  

### 4. Evaluation & Visualization
- Compute accuracy, precision, and recall  
- Generate confusion matrix  
- Visualize QDA decision boundary  

---

## 📊 Results

The QDA model effectively classifies two classes using flexible, non-linear boundaries.  
(Insert your accuracy, classification report, and plots here if desired.)

---
