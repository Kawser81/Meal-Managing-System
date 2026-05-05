package com.mealmanager.repository;

import com.mealmanager.model.*;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface DepositRepository extends JpaRepository<Deposit, Long> {
    List<Deposit> findByMonth(Month month);
    List<Deposit> findByUserAndMonth(User user, Month month);
    void deleteById(Long id);
}