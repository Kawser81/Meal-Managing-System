package com.mealmanager.controller;

import com.mealmanager.dto.MealCostSummary;
import com.mealmanager.dto.UserSummaryRow;
import com.mealmanager.model.Month;
import com.mealmanager.model.User;
import com.mealmanager.service.MonthService;
import com.mealmanager.service.MonthUserRoleService;
import com.mealmanager.service.SummaryService;
import com.mealmanager.service.UserService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Controller
@RequestMapping("/summary")
public class SummaryController {

    private static final String SUMMARY_VIEW = "summary";
    private final SummaryService summaryService;
    private final MonthService monthService;
    private final UserService userService;
    private final MonthUserRoleService roleService;

    public SummaryController(
            SummaryService summaryService,
            MonthService monthService,
            UserService userService,
            MonthUserRoleService roleService) {
        this.summaryService = summaryService;
        this.monthService = monthService;
        this.userService = userService;
        this.roleService = roleService;
    }

    @GetMapping("")
    public String page(Model model, HttpSession session) {

        String email     = (String) session.getAttribute("loggedInUser");
        User currentUser = userService.findByEmail(email);
        Month month      = monthService.getActiveMonth();

        if (month == null) {
            model.addAttribute("error", "No active month found.");
            return SUMMARY_VIEW;
        }

        List<UserSummaryRow> rows = summaryService.getUserSummaryRows(month);

        for (UserSummaryRow r : rows) {
            System.out.println("  → " + r.getName());
        }

        MealCostSummary mcs = summaryService.getMealCostSummary(month);

        int grandDeposit       = rows.stream().mapToInt(UserSummaryRow::getDeposit).sum();
        int grandCombinedCost  = summaryService.getTotalCombinedCost(month);
        int grandMealFund      = rows.stream().mapToInt(UserSummaryRow::getMealFund).sum();
        int grandMeals         = rows.stream().mapToInt(UserSummaryRow::getTotalMeals).sum();
        int grandMealCost      = rows.stream().mapToInt(UserSummaryRow::getPerUserMealCost).sum();
        int grandDue           = rows.stream().mapToInt(UserSummaryRow::getDue).sum();
        int moneyInHand = summaryService.getMoneyInHand(month);

        model.addAttribute("moneyInHand", moneyInHand);
        model.addAttribute("month",             month);
        model.addAttribute("isManager",         roleService.isManager(currentUser, month));
        model.addAttribute("rows",              rows);
        model.addAttribute("mcs",              mcs);
        model.addAttribute("grandDeposit",      grandDeposit);
        model.addAttribute("grandCombinedCost", grandCombinedCost);
        model.addAttribute("grandMealFund",     grandMealFund);
        model.addAttribute("grandMeals",        grandMeals);
        model.addAttribute("grandMealCost",     grandMealCost);
        model.addAttribute("grandDue",          grandDue);

        return SUMMARY_VIEW;
    }
}