package com.mealmanager.service;

import com.mealmanager.model.CombinedCost;
import com.mealmanager.model.Month;
import com.mealmanager.model.User;
import com.mealmanager.repository.CombinedCostRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CombinedCostService {

    private final CombinedCostRepository combinedCostRepository;
    private final MonthService monthService;
    private final MonthUserRoleService roleService;

    public CombinedCostService(CombinedCostRepository combinedCostRepository,
                               MonthService monthService,
                               MonthUserRoleService roleService) {
        this.combinedCostRepository = combinedCostRepository;
        this.monthService = monthService;
        this.roleService = roleService;
    }

    public Month getActiveMonth() {
        return monthService.getActiveMonth();
    }

    public boolean isManager(User user, Month month) {
        return roleService.isManager(user, month);
    }

    public List<CombinedCost> getByMonth(Month month) {
        return combinedCostRepository.findByMonth(month);
    }

    public int getTotalByMonth(Month month) {
        return combinedCostRepository.findByMonth(month)
                .stream().mapToInt(CombinedCost::getCost).sum();
    }

    public void add(Month month, String itemName, int cost) {
        CombinedCost combinedCost = new CombinedCost();
        combinedCost.setMonth(month);
        combinedCost.setItemName(itemName);
        combinedCost.setCost(cost);
        combinedCostRepository.save(combinedCost);
    }

    public void update(Long id, String itemName, int cost) {
        CombinedCost combinedCost = combinedCostRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("CombinedCost not found: " + id));
        combinedCost.setItemName(itemName);
        combinedCost.setCost(cost);
        combinedCostRepository.save(combinedCost);
    }

    public void delete(Long id) {
        combinedCostRepository.deleteById(id);
    }

    public CombinedCost getById(Long id) {
        return combinedCostRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("CombinedCost not found: " + id));
    }
}






//package com.mealmanager.service;
//
//import com.mealmanager.model.CombinedCost;
//import com.mealmanager.model.Month;
//import com.mealmanager.repository.CombinedCostRepository;
//import org.springframework.stereotype.Service;
//
//import java.util.List;
//
//@Service
//public class CombinedCostService {
//
//    private final CombinedCostRepository combinedCostRepository;
//
//    public CombinedCostService(CombinedCostRepository combinedCostRepository) {
//        this.combinedCostRepository = combinedCostRepository;
//    }
//
//    public List<CombinedCost> getByMonth(Month month) {
//        return combinedCostRepository.findByMonth(month);
//    }
//
//    public int getTotalByMonth(Month month) {
//        return combinedCostRepository.findByMonth(month)
//                .stream().mapToInt(CombinedCost::getCost).sum();
//    }
//
//    public void add(Month month, String itemName, int cost) {
//        CombinedCost combinedCost = new CombinedCost();
//        combinedCost.setMonth(month);
//        combinedCost.setItemName(itemName);
//        combinedCost.setCost(cost);
//        combinedCostRepository.save(combinedCost);
//    }
//
//    public void update(Long id, String itemName, int cost) {
//        CombinedCost combinedCost = combinedCostRepository.findById(id)
//                .orElseThrow(() -> new RuntimeException("Not found"));
//        combinedCost.setItemName(itemName);
//        combinedCost.setCost(cost);
//        combinedCostRepository.save(combinedCost);
//    }
//
//    public void delete(Long id) {
//        combinedCostRepository.deleteById(id);
//    }
//
//    public CombinedCost getById(Long id) {
//        return combinedCostRepository.findById(id).orElseThrow(() -> new RuntimeException("Not found"));
//    }
//}