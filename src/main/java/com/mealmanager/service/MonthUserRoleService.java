package com.mealmanager.service;

import com.mealmanager.enumeration.MonthlyRole;
import com.mealmanager.model.Month;
import com.mealmanager.model.MonthUserRole;
import com.mealmanager.model.User;
import com.mealmanager.repository.MonthUserRoleRepository;
import org.springframework.stereotype.Service;

@Service
public class MonthUserRoleService {

    private final MonthUserRoleRepository monthUserRoleRepository;

    public MonthUserRoleService(MonthUserRoleRepository monthUserRoleRepository) {
        this.monthUserRoleRepository = monthUserRoleRepository;
    }

    public MonthlyRole getUserRole(User user, Month month) {
        return monthUserRoleRepository.findByUserAndMonth(user, month)
                .map(MonthUserRole::getRole)
                .orElse(null);
    }

    public boolean isManager(User user, Month month) {
        return getUserRole(user, month) == MonthlyRole.MANAGER;
    }
}