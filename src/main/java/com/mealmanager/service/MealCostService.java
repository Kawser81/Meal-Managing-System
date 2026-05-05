package com.mealmanager.service;

import com.mealmanager.model.MealCost;
import com.mealmanager.model.Month;
import com.mealmanager.repository.MealCostRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class MealCostService {

    @Autowired
    private MealCostRepository mealCostRepository;

    public List<MealCost> getByMonth(Month month) {
        return mealCostRepository.findByMonth(month);
    }

    public int getTotalByMonth(Month month) {
        return mealCostRepository.findByMonth(month)
                .stream().mapToInt(MealCost::getCost).sum();
    }

    public void add(Month month, String itemName, int cost) {
        MealCost mealCost = new MealCost();
        mealCost.setMonth(month);
        mealCost.setItemName(itemName);
        mealCost.setCost(cost);
        mealCostRepository.save(mealCost);
    }

    public void update(Long id, String itemName, int cost) {
        MealCost mc = mealCostRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Not found"));
        mc.setItemName(itemName);
        mc.setCost(cost);
        mealCostRepository.save(mc);
    }

    public void delete(Long id) {
        mealCostRepository.deleteById(id);
    }

    public MealCost getById(Long id) {
        return mealCostRepository.findById(id).orElseThrow(() -> new RuntimeException("Not found"));
    }
}