package com.mealmanager.dto;

public class MealCostSummary {
    private int totalMealCount;
    private int totalMealCost;
    private double perMealCost;

    public MealCostSummary(int totalMealCount, int totalMealCost) {
        this.totalMealCount = totalMealCount;
        this.totalMealCost  = totalMealCost;
        this.perMealCost    = totalMealCount > 0
                ? (double) totalMealCost / totalMealCount
                : 0.0;
    }

    public int getTotalMealCount()  { return totalMealCount; }
    public int getTotalMealCost()   { return totalMealCost; }
    public double getPerMealCost()  { return perMealCost; }
}