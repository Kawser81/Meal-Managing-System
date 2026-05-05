package com.mealmanager.service;

import com.mealmanager.enumeration.GlobalRole;
import com.mealmanager.enumeration.MonthlyRole;
import com.mealmanager.model.Month;
import com.mealmanager.model.MonthUserRole;
import com.mealmanager.model.User;
import com.mealmanager.repository.MonthUserRoleRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class DashboardService {

    private final MonthUserRoleRepository monthUserRoleRepository;
    private final MonthService monthService;

    public DashboardService(MonthUserRoleRepository monthUserRoleRepository,
                            MonthService monthService) {
        this.monthUserRoleRepository = monthUserRoleRepository;
        this.monthService = monthService;
    }

    public Month getActiveMonth() {
        return monthService.getActiveMonth();
    }

    public boolean isAdmin(User user) {
        return user.getRole() == GlobalRole.ADMIN;
    }

    public boolean isManager(User user, Month month) {
        if (month == null) return false;
        return getUserRolesForMonth(month)
                .stream()
                .anyMatch(r -> r.getUser().getId().equals(user.getId())
                        && r.getRole() == MonthlyRole.MANAGER);
    }

    public List<MonthUserRole> getUserRolesForMonth(Month month) {
        return monthUserRoleRepository.findByMonthWithUsers(month);
    }

    public void updateRole(Long userId, Long monthId, MonthlyRole newRole) {
        List<MonthUserRole> roles = monthUserRoleRepository
                .findByUserIdAndMonthId(userId, monthId);

        if (roles.isEmpty()) {
            throw new RuntimeException("User not found in this month.");
        }

        MonthUserRole role = roles.get(0);
        role.setRole(newRole);
        monthUserRoleRepository.save(role);
    }
}