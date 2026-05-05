package com.mealmanager.controller;

import com.mealmanager.model.Month;
import com.mealmanager.model.User;
import com.mealmanager.service.CombinedCostService;
import com.mealmanager.service.UserService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/combined-cost")
public class CombinedCostController {

    private static final String VIEW_COMBINED_COST = "cost/combined-cost";
    private static final String REDIRECT_COMBINED_COST = "redirect:/combined-cost";

    private final CombinedCostService combinedCostService;
    private final UserService userService;

    public CombinedCostController(CombinedCostService combinedCostService,
                                  UserService userService) {
        this.combinedCostService = combinedCostService;
        this.userService = userService;
    }

    @GetMapping("")
    public String page(Model model, HttpSession session) {
        User currentUser = resolveUser(session);
        Month month = combinedCostService.getActiveMonth();

        if (month == null) {
            model.addAttribute("error", "No active month found.");
            return VIEW_COMBINED_COST;
        }

        model.addAttribute("month",     month);
        model.addAttribute("items",     combinedCostService.getByMonth(month));
        model.addAttribute("total",     combinedCostService.getTotalByMonth(month));
        model.addAttribute("isManager", combinedCostService.isManager(currentUser, month));

        return VIEW_COMBINED_COST;
    }

    @PostMapping("/add")
    public String add(@RequestParam String itemName,
                      @RequestParam int cost,
                      HttpSession session) {
        User currentUser = resolveUser(session);
        Month month = combinedCostService.getActiveMonth();

        if (!combinedCostService.isManager(currentUser, month)) return "error/403";

        combinedCostService.add(month, itemName, cost);
        return REDIRECT_COMBINED_COST;
    }

    @PostMapping("/update")
    public String update(@RequestParam Long id,
                         @RequestParam String itemName,
                         @RequestParam int cost,
                         HttpSession session) {
        User currentUser = resolveUser(session);
        Month month = combinedCostService.getActiveMonth();

        if (!combinedCostService.isManager(currentUser, month)) return "error/403";

        combinedCostService.update(id, itemName, cost);
        return REDIRECT_COMBINED_COST;
    }

    @PostMapping("/delete")
    public String delete(@RequestParam Long id, HttpSession session) {
        User currentUser = resolveUser(session);
        Month month = combinedCostService.getActiveMonth();

        if (!combinedCostService.isManager(currentUser, month)) return "error/403";

        combinedCostService.delete(id);
        return REDIRECT_COMBINED_COST;
    }

    private User resolveUser(HttpSession session) {
        String email = (String) session.getAttribute("loggedInUser");
        return userService.findByEmail(email);
    }
}