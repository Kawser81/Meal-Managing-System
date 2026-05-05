package com.mealmanager.service;

import com.mealmanager.model.Month;
import com.mealmanager.model.ProteinStock;
import com.mealmanager.repository.MonthRepository;
import com.mealmanager.repository.ProteinStockRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Service
public class ProteinStockService {

    private final ProteinStockRepository proteinStockRepository;
    private final MonthRepository monthRepository;

    public ProteinStockService(
            ProteinStockRepository proteinStockRepository,
            MonthRepository monthRepository) {
        this.proteinStockRepository = proteinStockRepository;
        this.monthRepository = monthRepository;
    }

    public List<ProteinStock> getStocksByMonth(Month month) {
        return proteinStockRepository.findByMonthOrderByItemNameAscCreatedAtDesc(month);
    }

    public Map<String, ProteinStock> getStockMapByMonth(Month month) {
        List<ProteinStock> stocks = getStocksByMonth(month);
        Map<String, ProteinStock> map = new LinkedHashMap<>();
        for (ProteinStock stock : stocks) {
            map.put(stock.getItemName(), stock);
        }
        return map;
    }

    public ProteinStock addStock(Month month, String itemName, Integer quantity, String unit, String note) {
        ProteinStock stock = new ProteinStock();
        stock.setMonth(month);
        stock.setItemName(itemName.trim());
        stock.setQuantity(quantity);
        stock.setUnit(unit != null && !unit.isBlank() ? unit.trim() : "piece");
        stock.setNote(note);
        return proteinStockRepository.save(stock);
    }

    public ProteinStock updateStock(Long stockId, Integer quantity, String unit, String note) {
        ProteinStock stock = proteinStockRepository.findById(stockId)
                .orElseThrow(() -> new RuntimeException("Stock not found"));
        stock.setQuantity(quantity);
        if (unit != null && !unit.isBlank()) stock.setUnit(unit.trim());
        stock.setNote(note);
        return proteinStockRepository.save(stock);
    }

    public void deleteStock(Long stockId) {
        proteinStockRepository.deleteById(stockId);
    }

    public Optional<ProteinStock> findById(Long id) {
        return proteinStockRepository.findById(id);
    }
}