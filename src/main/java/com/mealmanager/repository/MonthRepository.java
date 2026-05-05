package com.mealmanager.repository;

import com.mealmanager.model.Month;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface MonthRepository extends JpaRepository<Month, Long> {
    Optional<Month> findByIsActiveTrue();
}