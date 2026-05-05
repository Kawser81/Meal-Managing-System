package com.mealmanager.service;

import com.mealmanager.model.*;
import com.mealmanager.repository.MealRepository;
import org.springframework.stereotype.Service;
import java.time.LocalDate;
import java.util.*;

@Service
public class MealService {

    private final MealRepository mealRepository;
    private final MonthService monthService;
    private final MonthUserRoleService roleService;

    public MealService(MealRepository mealRepository,
                       MonthService monthService,
                       MonthUserRoleService roleService) {
        this.mealRepository = mealRepository;
        this.monthService = monthService;
        this.roleService = roleService;
    }

    public Month getActiveMonth() {
        return monthService.getActiveMonth();
    }

    public boolean isManager(User user, Month month) {
        return roleService.isManager(user, month);
    }

    public List<LocalDate> getDatesForMonth(Month month) {
        List<LocalDate> dates = new ArrayList<>();
        LocalDate start = month.getStartDate();
        LocalDate end = month.getEndDate();
        while (!start.isAfter(end)) {
            dates.add(start);
            start = start.plusDays(1);
        }
        return dates;
    }

    public List<MealEntry> getMealsByMonth(Month month) {
        return mealRepository.findByMonth(month);
    }

    public int getMealCount(User user, Month month, LocalDate date,
                            Map<String, MealEntry> mealMap) {
        String key = user.getId() + "_" + date.toString();
        MealEntry entry = mealMap.get(key);
        return entry != null ? entry.getMealCount() : 0;
    }

    public Map<String, MealEntry> buildMealMap(Month month) {
        List<MealEntry> meals = mealRepository.findByMonth(month);
        Map<String, MealEntry> map = new HashMap<>();
        for (MealEntry m : meals) {
            String key = m.getUser().getId() + "_" + m.getDate().toString();
            map.put(key, m);
        }
        return map;
    }

    public MealEntry getMealFromMap(Month month, Long userId, String date) {
        Map<String, MealEntry> mealMap = buildMealMap(month);
        String key = userId + "_" + date;
        return mealMap.get(key);
    }

    public void saveMeal(User user, Month month, LocalDate date, int mealCount) {
        Optional<MealEntry> existing =
                mealRepository.findByUserAndMonthAndDate(user, month, date);

        MealEntry mealEntry = existing.orElseGet(MealEntry::new);
        mealEntry.setUser(user);
        mealEntry.setMonth(month);
        mealEntry.setDate(date);
        mealEntry.setMealCount(mealCount);
        mealRepository.save(mealEntry);
    }

    public void updateMeal(Long id, int mealCount) {
        MealEntry mealEntry = mealRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Meal not found"));
        mealEntry.setMealCount(mealCount);
        mealRepository.save(mealEntry);
    }

    public MealEntry getById(Long id) {
        return mealRepository.findById(id).orElse(null);
    }

    public void delete(Long id) {
        mealRepository.deleteById(id);
    }
}