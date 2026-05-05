package com.mealmanager.repository;

import com.mealmanager.model.Month;
import com.mealmanager.model.ProteinStock;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ProteinStockRepository extends JpaRepository<ProteinStock, Long> {

    List<ProteinStock> findByMonthOrderByItemNameAscCreatedAtDesc(Month month);

    List<ProteinStock> findByMonthAndItemNameIgnoreCaseOrderByCreatedAtDesc(Month month, String itemName);

    boolean existsByMonthAndItemNameIgnoreCase(Month month, String itemName);
}