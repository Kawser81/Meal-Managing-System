package com.mealmanager.controller;

import com.mealmanager.enumeration.MonthlyRole;
import com.mealmanager.model.Month;
import com.mealmanager.model.User;
import com.mealmanager.service.DashboardService;
import com.mealmanager.service.UserService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/dashboard")
public class DashboardController {

    private static final String VIEW_DASHBOARD = "dashboard";
    private static final String VIEW_403 = "error/403";
    private static final String REDIRECT_DASHBOARD = "redirect:/dashboard";

    private final DashboardService dashboardService;
    private final UserService userService;

    public DashboardController(DashboardService dashboardService,
                               UserService userService) {
        this.dashboardService = dashboardService;
        this.userService = userService;
    }

    @GetMapping("")
    public String page(Model model, HttpSession session) {
        User currentUser = resolveUser(session);
        Month month = dashboardService.getActiveMonth();

        boolean isAdmin = dashboardService.isAdmin(currentUser);
        boolean isManager = dashboardService.isManager(currentUser, month);

        model.addAttribute("name",          currentUser.getName());
        model.addAttribute("currentUserId", currentUser.getId());
        model.addAttribute("month",         month);
        model.addAttribute("isAdmin",       isAdmin);
        model.addAttribute("isManager",     isManager);

        if (isAdmin && month != null) {
            model.addAttribute("userRoles", dashboardService.getUserRolesForMonth(month));
        }

        return VIEW_DASHBOARD;
    }

    @PostMapping("/role/update")
    public String updateRole(@RequestParam Long userId,
                             @RequestParam String newRole,
                             HttpSession session,
                             RedirectAttributes ra) {
        User currentUser = resolveUser(session);

        if (!dashboardService.isAdmin(currentUser)) return VIEW_403;

        Month month = dashboardService.getActiveMonth();
        if (month == null) {
            ra.addFlashAttribute("error", "No active month found.");
            return REDIRECT_DASHBOARD;
        }

        try {
            dashboardService.updateRole(userId, month.getId(), MonthlyRole.valueOf(newRole));
        } catch (Exception e) {
            ra.addFlashAttribute("error", e.getMessage());
        }

        return REDIRECT_DASHBOARD;
    }

    private User resolveUser(HttpSession session) {
        String email = (String) session.getAttribute("loggedInUser");
        return userService.findByEmail(email);
    }
}