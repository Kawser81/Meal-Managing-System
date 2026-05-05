package com.mealmanager.repository;

import com.mealmanager.model.CombinedCost;
import com.mealmanager.model.Month;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface CombinedCostRepository extends JpaRepository<CombinedCost, Long> {
    List<CombinedCost> findByMonth(Month month);
}