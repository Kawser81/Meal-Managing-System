package com.mealmanager.repository;

import com.mealmanager.model.MealCost;
import com.mealmanager.model.Month;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface MealCostRepository extends JpaRepository<MealCost, Long> {
    List<MealCost> findByMonth(Month month);
}