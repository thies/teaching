# run once, if library hasn't been installed already
install.packages("psych")


# load library
library(psych)

# enter the correlation matrices
# either estimate them in , or enter the estimates from Excel/eviews/Matlab/...
a <- matrix( c(1,0.5,0,0.5,1,0.5,0,0.5,1) , nrow = 3, ncol = 3)
b <- matrix( c(1,0.4,0.1,0.4,1,0.4,0.1,0.4,1) , nrow = 3, ncol = 3)
c <- matrix( c(1,0.1,0.4,0.1,1,0.1,0.4,0.1,1) , nrow = 3, ncol = 3)

# inspect the matrices
print(a)
print(b)

# The Jennrich test
# set the values for n1 and n2 based on sample sizes for the a and b
jenn <- cortest.jennrich(a,b,n1=200,n2=200) 
print(jenn)

# read the probabilities (select a cutoff value of your choice)
if(jenn$prob < 0.05){
  print("corr matrices are different at 5%")
} else {
  print("corr matrices are not different at 5%")
}
