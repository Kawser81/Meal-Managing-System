package com.mealmanager.service;

import com.mealmanager.dto.MealCostSummary;
import com.mealmanager.dto.UserSummaryRow;
import com.mealmanager.model.CombinedCost;
import com.mealmanager.model.Deposit;
import com.mealmanager.model.MealCost;
import com.mealmanager.model.MealEntry;
import com.mealmanager.model.Month;
import com.mealmanager.model.MonthUserRole;
import com.mealmanager.model.User;
import com.mealmanager.repository.CombinedCostRepository;
import com.mealmanager.repository.DepositRepository;
import com.mealmanager.repository.MealCostRepository;
import com.mealmanager.repository.MealRepository;
import com.mealmanager.repository.MonthUserRoleRepository;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class SummaryService {

    private final DepositRepository depositRepository;
    private final CombinedCostRepository combinedCostRepository;
    private final MealCostRepository mealCostRepository;
    private final MealRepository mealRepository;
    private final MonthUserRoleRepository monthUserRoleRepository;

    public SummaryService(DepositRepository depositRepository, CombinedCostRepository combinedCostRepository, MealCostRepository mealCostRepository, MealRepository mealRepository, MonthUserRoleRepository monthUserRoleRepository) {
        this.depositRepository = depositRepository;
        this.combinedCostRepository = combinedCostRepository;
        this.mealCostRepository = mealCostRepository;
        this.mealRepository = mealRepository;
        this.monthUserRoleRepository = monthUserRoleRepository;
    }

    public List<UserSummaryRow> getUserSummaryRows(Month month) {

        List<MonthUserRole> roles = monthUserRoleRepository.findByMonthWithUsers(month);
        int userCount = roles.size();
        if (userCount == 0) return List.of();

        int totalCombinedCost = combinedCostRepository.findByMonth(month)
                .stream().mapToInt(CombinedCost::getCost).sum();
        int perUserCombinedCost = userCount > 0 ? totalCombinedCost / userCount : 0;

        MealCostSummary mcs = getMealCostSummary(month);
        double perMealCost  = mcs.getPerMealCost();

        Map<Long, Integer> depositMap = new HashMap<>();
        for (Deposit d : depositRepository.findByMonth(month)) {
            depositMap.merge(d.getUser().getId(), d.getAmount(), Integer::sum);
        }

        Map<Long, Integer> mealMap = new HashMap<>();
        for (MealEntry e : mealRepository.findByMonth(month)) {
            mealMap.merge(e.getUser().getId(), e.getMealCount(), Integer::sum);
        }

        List<UserSummaryRow> rows = new ArrayList<>();
        for (MonthUserRole role : roles) {
            User user    = role.getUser();
            int deposit  = depositMap.getOrDefault(user.getId(), 0);
            int meals    = mealMap.getOrDefault(user.getId(), 0);
            int mealCost = (int) Math.round(meals * perMealCost);

            rows.add(new UserSummaryRow(
                    user.getName(), deposit, perUserCombinedCost, meals, mealCost
            ));
        }
        return rows;
    }

    public MealCostSummary getMealCostSummary(Month month) {
        int totalMeals    = mealRepository.findByMonth(month)
                .stream().mapToInt(MealEntry::getMealCount).sum();
        int totalMealCost = mealCostRepository.findByMonth(month)
                .stream().mapToInt(MealCost::getCost).sum();
        return new MealCostSummary(totalMeals, totalMealCost);
    }

    public int getTotalCombinedCost(Month month) {
        return combinedCostRepository.findByMonth(month)
                .stream().mapToInt(CombinedCost::getCost).sum();
    }

    public int getMoneyInHand(Month month) {
        int totalDeposit      = depositRepository.findByMonth(month)
                .stream().mapToInt(Deposit::getAmount).sum();
        int totalMealCost     = mealCostRepository.findByMonth(month)
                .stream().mapToInt(MealCost::getCost).sum();
        int totalCombinedCost = combinedCostRepository.findByMonth(month)
                .stream().mapToInt(CombinedCost::getCost).sum();

        return totalDeposit - (totalMealCost + totalCombinedCost);
    }

}