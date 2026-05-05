package com.mealmanager.model;

import jakarta.persistence.*;

@Entity
@Table(name = "meal_costs")
public class MealCost {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "month_id")
    private Month month;

    private String itemName;
    private int cost;

    public MealCost() {}

    public Long getId() { return id; }
    public Month getMonth() { return month; }
    public void setMonth(Month month) { this.month = month; }
    public String getItemName() { return itemName; }
    public void setItemName(String itemName) { this.itemName = itemName; }
    public int getCost() { return cost; }
    public void setCost(int cost) { this.cost = cost; }
}