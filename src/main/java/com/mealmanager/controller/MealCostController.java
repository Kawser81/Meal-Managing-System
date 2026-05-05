package com.mealmanager.controller;

import com.mealmanager.model.*;
import com.mealmanager.service.*;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/meal-cost")
public class MealCostController {

    private static final String MEAL_COST = "cost/meal-cost";
    private static final String REDIRECT_MEAL_COST = "redirect:/meal-cost";

    private final MealCostService mealCostService;
    private final MonthService monthService;
    private final UserService userService;
    private final MonthUserRoleService roleService;

    public MealCostController(
            MealCostService mealCostService,
            MonthService monthService,
            UserService userService,
            MonthUserRoleService roleService) {
        this.mealCostService = mealCostService;
        this.monthService = monthService;
        this.userService = userService;
        this.roleService = roleService;
    }

    @GetMapping("")
    public String page(Model model, HttpSession session) {
        String email = (String) session.getAttribute("loggedInUser");
        User currentUser = userService.findByEmail(email);
        Month month = monthService.getActiveMonth();

        if (month == null) {
            model.addAttribute("error", "No active month found.");
            return MEAL_COST;
        }

        List<MealCost> items = mealCostService.getByMonth(month);
        int total = mealCostService.getTotalByMonth(month);

        model.addAttribute("month", month);
        model.addAttribute("items", items);
        model.addAttribute("total", total);
        model.addAttribute("isManager", roleService.isManager(currentUser, month));

        String editId = (String) model.asMap().get("editId");
        model.addAttribute("editId", editId);

        return MEAL_COST;
    }

    @PostMapping("/add")
    public String add(@RequestParam String itemName,
                      @RequestParam int cost,
                      HttpSession session) {

        User currentUser = userService.findByEmail(
                (String) session.getAttribute("loggedInUser"));
        Month month = monthService.getActiveMonth();

        if (!roleService.isManager(currentUser, month)) return "error/403";

        mealCostService.add(month, itemName, cost);
        return REDIRECT_MEAL_COST;
    }

    @PostMapping("/update")
    public String update(@RequestParam Long id,
                         @RequestParam String itemName,
                         @RequestParam int cost,
                         HttpSession session) {

        User currentUser = userService.findByEmail(
                (String) session.getAttribute("loggedInUser"));
        Month month = monthService.getActiveMonth();

        if (!roleService.isManager(currentUser, month)) return "error/403";

        mealCostService.update(id, itemName, cost);
        return REDIRECT_MEAL_COST;
    }

    @PostMapping("/delete")
    public String delete(@RequestParam Long id, HttpSession session) {

        User currentUser = userService.findByEmail(
                (String) session.getAttribute("loggedInUser"));
        Month month = monthService.getActiveMonth();

        if (!roleService.isManager(currentUser, month)) return "error/403";

        mealCostService.delete(id);
        return REDIRECT_MEAL_COST;
    }
}