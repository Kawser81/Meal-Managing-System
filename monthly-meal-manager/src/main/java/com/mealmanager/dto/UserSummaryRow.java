package com.mealmanager.dto;

public class UserSummaryRow {
    private String name;
    private int deposit;
    private int combinedCost;
    private int mealFund;
    private int totalMeals;
    private int perUserMealCost;
    private int due;

    public UserSummaryRow(String name, int deposit, int combinedCost,
                          int totalMeals, int perUserMealCost) {
        this.name           = name;
        this.deposit        = deposit;
        this.combinedCost   = combinedCost;
        this.mealFund       = deposit - combinedCost;
        this.totalMeals     = totalMeals;
        this.perUserMealCost = perUserMealCost;
        this.due            = perUserMealCost - mealFund;
    }

    public String getName()          { return name; }
    public int getDeposit()          { return deposit; }
    public int getCombinedCost()     { return combinedCost; }
    public int getMealFund()         { return mealFund; }
    public int getTotalMeals()       { return totalMeals; }
    public int getPerUserMealCost()  { return perUserMealCost; }
    public int getDue()              { return due; }
}