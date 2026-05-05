package com.mealmanager.repository;

import com.mealmanager.model.*;
import org.springframework.data.jpa.repository.JpaRepository;

import java.time.LocalDate;
import java.util.*;

public interface MealRepository extends JpaRepository<MealEntry, Long> {
    List<MealEntry> findByMonth(Month month);
    Optional<MealEntry> findByUserAndMonthAndDate(User user, Month month, LocalDate date);
    List<MealEntry> findByMonthAndDate(Month month, LocalDate date);
}