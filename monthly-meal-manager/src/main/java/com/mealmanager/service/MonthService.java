package com.mealmanager.service;

import com.mealmanager.model.Month;
import com.mealmanager.repository.MonthRepository;
import org.springframework.stereotype.Service;

@Service
public class MonthService {

    private final MonthRepository monthRepository;

    public MonthService(MonthRepository monthRepository) {
        this.monthRepository = monthRepository;
    }

    public Month getActiveMonth() {
        return monthRepository.findByIsActiveTrue()
                .orElse(null);
    }

    public Month createMonth(Month month) {
        monthRepository.findByIsActiveTrue().ifPresent(m -> {
            m.setActive(false);
            monthRepository.save(m);
        });

        month.setActive(true);
        return monthRepository.save(month);
    }
}