### Introduction

The purpose of this R script is to produce a Risk v. Return scatterplot 
based on supply list of stock tickers symbols. The scatterplot will help 
dtermine the optimal portfolio (allocations) of these symbols across a 
spectrum of risk. You can see the best portfolio at any given level of 
risk.

### How it works

The functions accepts a list of stock ticker symbols and then creates 
numerous portfolios by assigning allocations to each stock. The number 
of portfolios produced is determined by the number of ticker symbols. 

The key steps in the code include, 

1.  Create allocations based on the number of symbols
2.  Create portfolios by assigning allocations across all symbols
3.  Download stock performance data for the last x years 
4.  Calculate the portfolio return for each year
5.  Calculate average and standard deviation for each portfolio 
6.  Produce a scatter plot with standard deviation (risk) on the x-asix and return on the y


### Stock Data

This program leverages Quandl functions to retrieve annualized % change in the adjusted* stock price
for each security. The original data is from finance.yahoo.com and the stock price is adjusted for 
splits and dividens. Performance is inclusize of dividend payouts. 
